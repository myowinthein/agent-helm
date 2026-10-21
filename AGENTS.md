# agent-helm

## Project Identity

**Name:** agent-helm (plugin name: `helm`)
**Stack:** Plugin is pure markdown (no runtime, no framework, no dependencies); a Jekyll + just-the-docs GitHub Pages site lives alongside it in the same repo
**Purpose:** A Claude and Codex workflow plugin for solo developers. Ten shared workflows and two rule files covering shipping, refactoring, testing, documenting, legal-document generation, env auditing, commit-history normalization, rule adoption, and long-term archiving of your own work.
**Blast radius:** Changes to `workflows/*.md` affect every user who has the plugin installed. Changes to `rules/` affect every project that adopted them via `/helm:adopt`.

## Project Config

git-strategy: solo
git-auto-commit: true
readme-style: custom

## Dev Commands

No install/build step for the plugin itself: its skills and workflows are Markdown files. Run `ruby scripts/test_plugin.rb` for offline package checks and `ruby scripts/check_clients.rb` for native CLI discovery. The Jekyll docs site does have a local test step: `bundle install`, then `bundle exec rake test` to catch broken links, missing images, and malformed HTML before shipping (see Known Traps for why this isn't automated).

Release: the Helm ship workflow (`/helm:ship` in Claude, or select ship from Codex's skill picker) handles version bump, tag, push, and GitHub Release creation.

## Architecture Pointers

- `skills/*/SKILL.md`: ten portable entry points, loaded by Claude and Codex. The manifest sets `commands: []` to avoid duplicate entries; `commands/*.md` remain legacy/manual adapters with the original names and descriptions, outside current skill discovery. Their behavior in older clients is not established by source review.
- `workflows/*.md`: canonical workflow bodies; `prompts/shared/runtime.md` resolves package/workspace paths and host capabilities. `prompts/shared/content-sync.md` and `ci.md` define shared content-sync Git phases and provider-aware integration/promotion gates.
- `AGENTS.md`: shared contributor instructions and the single owner of project knowledge and Helm configuration; `CLAUDE.md` imports it and adds Claude-specific instructions.
- `scripts/validate_plugin.rb`, `scripts/test_plugin.rb`: offline packaging checks; `scripts/check_clients.rb` optionally verifies native CLI discovery.
- `rules/git.md`, `rules/safety.md`: shipped rule files, installed into adopting projects via `/helm:adopt`
- `prompts/archive/step{1-5}-*.md`: sub-step files for `/helm:archive`; `workflows/archive.md` is the orchestrator that reads and sequences them
- `docs/commands/*.md` (+ `docs/commands/archive/`): human-readable detail pages per command, published as Jekyll site content; not command source
- `docs/rules/`: detail pages for the two rule files
- `.helm/*.json`: canonical project state for `refactor-log.json`, `test-log.json`, `normalize-log.json`, and `legal-manifest.json` when used. `prompts/shared/project-state.md` defines validation, conflict resolution, and per-command migration from `.claude/helm/{filename}` or `.claude/{filename}` at the next eligible authorized write. This repository's existing live ledgers remain at their legacy paths until their owning workflows run; feature work must not move them.
- `.claude-plugin/plugin.json`: the version file; bump this on every release
- `.claude-plugin/marketplace.json`: marketplace registration metadata; `/helm:ship` keeps its `plugins[].version` in sync with `plugin.json` automatically
- `_config.yml` + `Gemfile`: Jekyll/GitHub Pages site config; `docs/` files serve as site pages

## Domain Rules

- `docs/commands/*.md` are detail pages, not command source: editing them never changes command behavior; the real definitions live in `workflows/*.md`.
- `prompts/archive/*.md` must never move into `commands/`: that would make each step appear as its own standalone slash command, breaking `/helm:archive`'s single-entry orchestration.
- Ledger files (`.helm/refactor-log.json`, and `.helm/test-log.json` if a project runs `/helm:test`, including their legacy copies) are append-only audit trails: a scan appends new findings, it never overwrites the array. `normalize-log.json` is a different shape (one entry per branch, replaced/dropped as branches come and go), not append-only in the same sense.
- Docs pages (`docs/commands/`, `docs/rules/`) must stay behaviorally consistent with the command/rule files they describe, but nothing enforces this automatically; drift is caught only by manual review or a `/helm:refactor` pass.
- AskUserQuestion caps at 4 options: any command building a picker from a dynamic list (environment branches, refactor categories, legal documents) must merge or truncate down to 4, never assume the list stays small.
- `README.md` ships in three real contexts (Jekyll site homepage, GitHub.com's own renderer, the distributed plugin package via `marketplace.json`), only one of which resolves relative links to `docs/`. Its doc-page links and banner image use absolute `https://myowinthein.github.io/agent-helm/...` URLs for this reason: don't "simplify" them back to relative paths.
- `/helm:refactor` uses a `refactor/*` branch and offers a PR option regardless of `git-strategy`, including under Solo Mode (a formally documented exception in `rules/git.md`, same reasoning as `/helm:ship`'s release-commit exception): refactor sessions are multi-wave and resumable by design, and a branch is what makes leaving work between runs possible.
- `/helm:legal` skips its document picker entirely in two cases: nothing about the project needs legal docs (asks to exit first, since a scan miss shouldn't silently skip a project that does need them), or every applicable document already exists and is unchanged since it was last generated. Neither case writes anything.

## Behavior Rules

When consulting Claude for a review or discussion, use `claude --model claude-opus-5-5 --effort high`, verify the returned model metadata, and do not substitute a model or effort without the user's approval.

- Run `/helm:ship` for all releases: it handles versioning, tagging, and pushing
- Conventional Commits required on every commit (scope is mandatory)
- No PRs, no feature branches: commit directly to main
- `git push` always requires its own confirmation, even with `git-auto-commit: true`; the commit itself may be silent, but push is not
- Prose in `docs/` avoids em dashes; use a comma, semicolon, colon, or restructure the sentence instead. Does not apply to `prompts/` or other files outside `docs/`.

## Hard Safety Rules

- Do not inspect, edit, or migrate operational Helm state during feature work: `.helm/*.json`, `.claude/helm/*.json`, and the known flat legacy `.claude/{refactor-log,test-log,normalize-log,legal-manifest}.json` files. These are operational records, not source. The Helm workflows that own these ledgers may read and update them when explicitly invoked.
- Never delete or rewrite published tags: users pin to specific versions
- Never commit secrets, credentials, or real user data (none expected in this repo)

## Known Traps

- **Refresh the whole plugin after an update.** Use the client's plugin update and start a fresh session. If a Claude cache remains stale, inspect the exact loaded path in `/plugin` and refresh the complete package from the matching marketplace checkout (`.claude-plugin/`, `commands/`, `skills/`, `workflows/`, `prompts/`, `rules/`, README and LICENSE), then reload. Never copy only `commands/`: adapters require the packaged skills and workflows. Never select a cache version by lexicographic `tail -1` or mix versions.
- **Don't "fix" `prompts/` or `docs/commands/` by moving or redefining them.** See Domain Rules above: `prompts/archive/*.md` staying out of `commands/`, and `docs/commands/*.md` not being command source, are both easy mistakes to reach for when something there looks structurally odd.
- **No CI to gate on.** `/helm:ship` and `/helm:refactor`'s environment-promotion CI-status checks both no-op silently here; there's no `.github/workflows/`. `bundle exec rake test` (see Dev Commands) verifies the site locally, but nothing runs it automatically before or after a release.
- **`git filter-repo` removes `origin` and rewrites more refs in its default full-rewrite mode.** `/helm:normalize` uses explicit `--refs` partial mode instead: it preserves remote configuration, all existing tags, and excluded refs. Do not restore unbounded filtering or reconstruct a remote from only its URL; verify it stayed unchanged.

## Rules

This project follows the rules shipped in agent-helm:
- rules/git.md
- rules/safety.md

Read and follow both rule files before project work.

<!-- last-reviewed: 2454819f5d375089e8695a96c22b5ad966d0deef -->
