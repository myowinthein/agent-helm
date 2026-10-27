# agent-helm

## Project Identity

Agent Helm is a workflow plugin for Claude and Codex. Its ten portable skills load Markdown workflows; Python provides read-only ledger/normalize checks and private recovery-locator I/O, Ruby scripts check packaging and client discovery, and Jekyll publishes the documentation site.

Plugin name: `agent-helm`. Marketplace: `agent-helm-marketplace`. Workflow changes affect installed consumers; changes to copied rules also affect projects that adopt those updates.

## Project Config

- ship-method: direct
- git-auto-commit: true
- git-merge-strategy: squash
- readme-style: custom

## Dev Commands

The Markdown plugin needs no install/build step. Run commands from the repository root when execution is authorized:

- `ruby scripts/test_plugin.rb`: offline package, relocation and Git-export checks in temporary repositories; does not execute Python helpers or call models.
- `ruby scripts/check_clients.rb`: native discovery through installed Claude/Codex CLIs, including Codex's actual `skills/list`; uses temporary installations and calls no models.
- `python3 -I -B scripts/test_normalize.py`: offline normalize mechanics tests with synthetic messages, graphs and schema-2 records; no real history or live state access.
- `python3 -I -B scripts/test_normalize_handoff.py`: private locator safety, independent-process discovery and worktree/clone checks in disposable repositories.
- `bundle install`: install the docs dependencies from `Gemfile` and `Gemfile.lock`.
- `bundle exec jekyll serve`: preview the docs site.
- `bundle exec rake test`: package and normalize mechanics checks plus a Jekyll build and HTMLProofer checks for internal links, HTML, images and scripts. Remote-theme resolution may need network access.
- `ruby scripts/smoke_layout.rb [codex|claude] [case ...]` and `ruby scripts/smoke_workflows.rb [codex|claude] [case]`: optional behavioral checks that call signed-in models in disposable projects. Review their model, usage and execution effects separately from offline checks.

## Architecture Pointers

- `skills/*/SKILL.md` are the only ten discoverable entry points. They resolve the loaded package's `prompts/shared/runtime.md` and canonical `workflows/*.md`; each `agents/openai.yaml` disables implicit invocation.
- `prompts/shared/runtime.md` owns package/workspace resolution and host boundaries. `content-sync.md` owns shared local-edit Git steps; `project-layout.md` owns log's shared instruction setup.
- `prompts/shared/question-mechanism.md` owns native question routing and one common fallback. All ten workflows map their question points to Single, Multi, Input or Review; keep client-specific fields out of workflow bodies.
- `rules/safety.md` owns output maintenance for all ten workflows: targeted development edits, stronger commitment/protection review, actual generator ownership and protected assessment/recovery evidence. The runtime applies its output map without widening a selected command's write scope.
- `prompts/shared/scan-scope.md` recommends Full scan / Gap scan only at an existing choice. `investigation-evidence.md` defines transient source/commit inventories and coverage; neither is runtime-autoloaded or grants state access.
- `helpers/helm.py`, `helpers/helm_lib/` and `helpers/ledger-contract.json` implement read-only validation and digest-bound retrieval. Python 3.11+ and standard library only; no writer, project-code execution or network. `prompts/shared/ledger-helper.md` owns invocation and the checked fallback when Python is unavailable.
- `prompts/refactor-ledger.md` defines refactor's native provenance and checkpoint semantics. `prompts/shared/project-state.md` defines owning-workflow access and preservation.
- `workflows/archive.md` sequences the five supporting `prompts/archive/step*.md` files. These steps are not independently discoverable skills.
- `workflows/ship.md` holds routing and ordinary source publication together. `prompts/ship/{targets,release}.md` load only for their selected procedures; they are supporting prompts, never skills. History/archive protocols remain in `prompts/shared/`; `ci.md` and relevant provider sections define exact-source checks and handoffs.
- `prompts/shared/normalize-handoff.md` owns normalize-to-ship discovery across sessions. `helpers/normalize_handoff.py` only registers/reads immutable private locators in the actual Git common directory; it executes no Git, reads no recovery bodies/ledgers and grants no publication authority. Source work leaves real locators untouched.
- `docs/commands/` and `docs/rules/` are concise guides for people deciding whether and how to use Helm. Explain purpose, choices, outcomes and constraints that affect use. Workflows and rules hold the complete behavior. Update what readers need to know at the guide's intended depth; consistency does not require matching source detail. Link authoritative standards instead of reproducing them.
- `.claude-plugin/plugin.json` owns the release version; ship synchronizes `.claude-plugin/marketplace.json`. Keep their plugin identity, version and description aligned, preserving `commands: []` and avoiding legacy command adapters.
- `_config.yml`, `Gemfile`, `Rakefile` and `.github/workflows/docs.yml` own the docs build. Main pushes, PRs and manual dispatch build; only main publishes Pages. CI resolves the latest stable Just the Docs release and does not run package, helper, native-client or model checks.
- `docs/setup/{claude,codex}.md` use `_includes/setup-tabs.html` and four `_includes/setup/` instruction bodies. The four older setup URLs use `_layouts/setup-redirect.html`; preserve panel/heading anchors and redirect fragments together with `assets/js/setup-tabs.js`.
- `_includes/head_custom.html` loads `assets/js/theme-switcher.js` before content. Header markup and `_sass/custom/custom.scss` provide System/Light/Dark selection with a site-specific saved preference.

## Domain Rules

- Use bare Helm command names in general prose and examples. Keep literal platform invocation syntax in platform setup instructions and `docs/setup/index.md`.
- Operational records live under `.helm/`: refactor/normalize schema 2, test schema 3, legal schema 1. Only the invoked owning workflow accesses its record. Source maintenance leaves live records and protected legacy paths opaque; unsupported state has no automatic migration/reset.
- Refactor/test helpers load lazily at their eligible owning-state steps. Source-only previews require no helper or Python setup. Maintaining this repo uses a separate installed package rather than treating the checkout as both package and consumer.
- A source assessment, human selection, edit approval, verified fix and publication are separate results. Preserve stable identities, unknown fields, human decisions and useful closed history; skip/defer/accepted risk does not mean resolved. Follow the owning workflow rather than inventing schema fields or shared cross-ledger access.
- Full scan / Gap scan applies only to log, manifest, test and refactor, with different coverage/checkpoint contracts. Refactor Full scan reads eligible implementation/tests in full; log traces representative flows across all packages/topics. Incomplete review never becomes a complete checkpoint.
- Refactor preserves behavior and existing test guarantees; test owns missing/stronger protection and independent tooling/strategy work. Neither invokes the other automatically. Required deferred checks remain unverified.
- Local editing workflows finish on their permitted current branch. Ship alone publishes reviewed work and optional independently selected targets, then separately offers a release on ready integrated main/master. Source publication or a PR handoff does not prove integration, release or deployment.
- Normalize displays its full coordination notice and waits for readiness before any history review, helper/state access or delegation. Team ready permits fresh agreed-branch discovery; exact fetch/local-branch preparation needs its own concrete approval and continues in the same run before inventory freeze. Readiness is not teammate/device enforcement or rewrite/push consent; Review only writes nothing. Reuse applicable answers and keep one final exact message/impact approval. All affected existing/prepared local branches rewrite together, preserving tags/excluded refs and private recovery proof. Ship retains fixed leases, separate publication approval and owner-sync guidance without live normalize-ledger access.
- Normalize uses the pure stdin/stdout `helpers/normalize_check.py` for mechanical checks and graph selection, separately from the refactor/test helper. Its policy fingerprint canonicalizes unordered type/scope membership only; semantic/unknown fields remain exact, using applicable normative source text rather than regenerated paraphrases. `prompts/normalize-review.md` retains schema-2 baseline/contract validation, strict paging identity and mismatch fallback without old-record rehashing. Syntax pass grants no semantic coverage. The helper has no Git/file/network access or writer. Test with `python3 -I -B scripts/test_normalize.py`; unsupported schema 1 has no reader/migration.
- Archive prepares a reviewed local payload in the current canonical `.helm/archive/` bundle. Ship separately publishes/verifies the private payload and receipt. Historical `.archive/` bundles remain protected; no automatic relocation or replay.
- Adopt installs reviewed local rule copies; it does not convert external pointers or merge rule bodies. Legal writes complete uncommitted source-based drafts for editor/Markdown review, keeps chat to file links and important changes/gaps, and asks once for Commit / Revise / Leave uncommitted. Preserve existing clauses and distinguish concrete omissions from unassessed legal sufficiency; never require home-address intake or a second model. Exact legal content/commit approval remains independent of auto-commit; only approved commits advance its manifest.
- Adopt must stop without writes in this Helm source checkout, its nested directories or a Helm package installation. This project reads the maintained `rules/` sources directly; do not create adopted copies or repoint its instructions to them. Test adoption in a separate consumer fixture outside those roots. This restriction also applies when the invoked installed workflow is older than this checkout.

## Instruction authoring

This covers Helm's agent-facing instructions. Generic prose stays in `rules/writing.md`.

- Keep non-obvious, decision-changing guidance. Rewrite affected passages instead of accumulating exceptions or generic tutorials.
- Define rules once per loaded context; brief action-boundary reminders may repeat. Copied rules retain declared dependencies, including the Git/safety pair, without requiring an installed plugin.
- Keep routine paths concise; load specialized detail when needed and avoid needless reference layers. Moving text alone is not trimming.
- Preserve behavior, essential standards, QM capabilities, approvals, state/recovery protections and coverage semantics. Keep text readable; word or line quotas do not establish quality.
- Batch independent permitted reads; reuse unchanged instructions and pinned-object evidence within an invocation. Refresh mutable source, policy, destination, remote and required checks before mutations; read back outcomes. Never reduce requested coverage, approval or safety.
- Verify proportionately with focused existing checks; reuse passed results while inputs and policy match, rather than per file/phase. Assess source size, loaded context/tool calls and latency separately; speed claims need comparable measurements.

## Behavior Rules

- Commit directly on `main`; do not create feature branches or PRs for this project's work. Use scoped Conventional Commits: `type(scope): description`.
- Use ship for publication. Every push requires its own concrete confirmation; automatic local commits do not approve it.
- When consulting Claude for a review or discussion, use `claude --model claude-sonnet-5-5 --effort high`, verify returned model metadata, and obtain approval before substituting model or effort.

## Known Traps

- Refresh the complete plugin and start a fresh session after updates. If a cache is stale, inspect the exact loaded path; never mix package versions, choose a cache lexicographically, or copy only `skills/` without its runtime/resources.
- `README.md` is the Jekyll homepage, a GitHub-rendered document and packaged plugin content. Keep its published documentation links and banner image as absolute `https://myowinthein.github.io/agent-helm/...` URLs.
- Add new top-level source directories to `_config.yml`'s exclusions when they should not ship as site content.
- Docs CI is build-only. A green Pages build does not establish that package/helper/client/model checks ran or passed.
- Normalize uses explicit `git filter-repo --refs` partial mode to preserve remotes and excluded refs. Default full-rewrite mode removes `origin` and affects more refs; never substitute it or reconstruct a remote from its URL alone.

## Rules

Read and follow all three shipped rules before project work:

- `rules/git.md`
- `rules/safety.md`
- `rules/writing.md`

<!-- last-reviewed: 338818cbfe7421265b2eefe64c7a45c271e23921 -->
