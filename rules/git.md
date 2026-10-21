# Git Rules

---

## Project memory and configuration

These instructions also apply to copied rules in a fresh session without the Helm plugin loaded. Resolve the configuration before any Git action. Preserve existing instruction ownership except during an explicitly approved `/helm:log` shared-layout migration. That approval covers only its reviewed diff, not arbitrary restructuring or configuration changes.

- Start from the current host's project entry: `CLAUDE.md` in Claude, `AGENTS.md` in Codex. Respect active nested instructions and Codex's `AGENTS.override.md` precedence; do not bypass an override by reading only the root file.
- Follow explicit project-memory bridges, such as `@AGENTS.md` or a directive to read `CLAUDE.md`. Resolve relative paths from the referring file. Track visited files and stop on a cycle or missing target before branching or writing. The sole cycle exception is log's read-only reconciliation of a readable root CLAUDE.md/AGENTS.md pair: read each once, resolve configuration conflicts before Git actions, then propose a reviewed diff that removes the reverse bridge. This does not permit other workflows to bypass a cycle, or log to traverse an external/missing chain. Never infer a bridge from a filename mentioned as an example, and never edit an imported file outside the consumer project.
- If the host's entry is absent, read the other host's existing entry. The file that owns the actual Helm declarations and project knowledge is `{memory_file}`. A wrapper remains a wrapper. With no files, the proposed shared owner is root AGENTS.md on either host; do not create it just to resolve configuration. Shared setup uses AGENTS.md plus a CLAUDE.md containing a real `@AGENTS.md` import and any Claude-only additions. Shared declarations and Rules belong only in AGENTS.md in that layout; do not place competing Helm settings in the adapter.
- If both applicable root entries exist independently but only one contains recognized Helm declarations, that file is the configuration/memory owner; the setting-free entry is not a conflict. Read its instructions too and preserve it. If both declare identical settings, use their agreed values; before a memory write, resolve any remaining ambiguity about which file owns project knowledge rather than duplicating configuration. If neither declares settings, keep the current host's existing knowledge file unless a bridge selects another owner. Defaults concern missing settings, not a permission to ignore another file's explicit configuration.
- Recognize standalone declarations under `## Project Config` and the existing Compass-style fenced `text` configuration block introduced as project configuration. Supported keys are `git-strategy` (`solo` or `github-flow`), `git-auto-commit` (`true` or `false`), `git-merge-strategy` (`squash`, `rebase`, or `merge`), `environment-promotion` (`fan-out` or `chain`), and `readme-style` (`standard` or `custom`). A declaration in a recognized block counts regardless of the file's heading scheme. Ignore quoted examples and narrative mentions, not actual declarations.
- Apply the host's instruction precedence first. An explicit active override supersedes lower-priority guidance; an AGENTS.md replaced by AGENTS.override.md in the same directory is not an active competing owner. Then compare the applicable root entries and their explicit memory targets for conflicting independent declarations. If independent owners disagree, a declared value is invalid, or ownership remains ambiguous, show the conflict and resolve it before Git changes. Never silently choose a different strategy because a heading or host differs. Preserve override files and do not treat their host-specific settings as generated project knowledge.
- Use the defaults below only for genuinely absent settings. Save an authorized setting change in the owner's existing configuration block, preserving its layout; never duplicate it in a bridge. Resolving ownership does not authorize a full-file rewrite.
- Only `log` offers reviewed migration/reconciliation of existing root layouts. Its read-only comparison may help resolve ambiguity before Git actions; all other workflows preserve legacy owners and recommend log when a layout change is needed. A layout migration preserves confirmed values. Log finishes Git operations under the strategy and auto-commit policy resolved at the start of that invocation; newly saved policy values apply next time.

## Host capabilities and operational state

These boundaries apply on Claude, Codex, and other hosts even when only copied rules are loaded. Before Git actions, verify the shell is operating on the selected consumer working tree. Folder access alone does not establish access to its Git checkout, remote credentials, local tools, Docker daemon, or required test environment. Check the capabilities needed for the planned action without exposing credentials or changing client settings.

An unavailable required tool, permission, credential, quality check, or CI result blocks the affected action; it is not a passing check or an unconfigured project. Report what ran, what could not run, and the exact pending work. Never claim a commit, merge, push, promotion, or checkpoint succeeded without verifying its result, and do not continue dependent publication or cleanup after failure. Preserve existing work instead of resetting or stashing it to make a gate pass. Host/tool permission is separate from workflow approval and never bypasses the confirmation requirements below.

Operational Helm records in `.helm/`, legacy `.claude/helm/`, and the known flat legacy ledger paths are not source code or configuration owners. Exclude them from ordinary source discovery, edits, and unrelated staging. Only an explicitly invoked owning Helm workflow may load/update its own state or perform its validated per-file migration; follow safety.md's operational-state boundary. Loading these rules or switching agents triggers no migration.

## Git Strategy

Set the strategy with `git-strategy` in {memory_file} (Project Config section or the recognized fenced configuration block):
  git-strategy: solo         → Solo Mode
  git-strategy: github-flow  → GitHub Flow

Absence defaults to GitHub Flow. Exactly one strategy is active at a time.

After resolving {memory_file}, confirm which mode is active before taking any git action. State it explicitly: "Solo Mode active" or "GitHub Flow active."

Before branch creation, commits, integration, publication, or promotion, resolve `{base_branch}` to the project's actual `main` or `master`, using project instructions, its default branch and existing refs. Stop if the identity is ambiguous or unavailable; do not guess, create, or rename a branch to make an instruction work. Without a repository or HEAD, follow only an explicitly authorized bootstrap plan rather than inventing a base. Missing memory files do not bypass the Git strategy in an existing repository. Use the resolved name consistently below, and recheck effective instructions/configuration after branch changes before continuing under the invocation's policy.

### Solo Mode

When active:
- Commit directly to `{base_branch}` — no feature branches required
- No PR required
- Skip the GitHub Flow and Branch Naming subsections entirely
- Environment Branches rules still apply if such branches exist
- All Universal Rules still apply
- Conventional Commits still apply
- Code quality checks still apply before pushing

Use this mode for solo work where peer review and branch protection have no audience. Switch to GitHub Flow the moment you have collaborators.

Exception: /helm:refactor's refactor/* branch and its "Open PR" option in Step 7 are used regardless of git-strategy, including under Solo Mode — this is the sanctioned path for multi-wave, resumable refactor sessions (a session can span multiple runs, and leaving work on a branch between them is the point), not an ad-hoc feature branch. Same reasoning as /helm:ship's exception below, applied to a different command.

### GitHub Flow (default)

Active when `git-strategy: github-flow` is declared, or when `git-strategy` is absent.

**Branch structure:**
  {base_branch} (main or master)
  feature/*  (or feat/*)
  fix/*
  chore/*
  refactor/*
  docs/*
  test/*
  perf/*
  ci/*
  build/*

**Rules:**
- All branches base from `{base_branch}`
- `{base_branch}` is always deployable
- Open a PR before merging to `{base_branch}`
- Merge using the strategy declared as `git-merge-strategy` in {memory_file} (default: squash). Before merging, confirm which is active — same self-check as git-strategy above. State it explicitly: "Squash merge", "Rebase merge", or "Merge commit."
  - `squash` — squash all commits into one with a Conventional Commit message
  - `rebase` — replay branch commits onto `{base_branch}` without a merge commit
  - `merge` — create a merge commit preserving full branch topology
- If CI is configured, it must pass before merge

#### Branch Naming

Only applies when GitHub Flow is active.

Format: type/short-description
Include ticket number if provided: type/123-short-description

Examples:
  feature/user-authentication
  feature/123-user-authentication
  fix/payment-timeout
  fix/456-payment-timeout
  chore/bump-dependencies
  refactor/extract-payment-service

Types mirror Conventional Commits types.
Use lowercase, hyphens only, no spaces.

---

## Auto-Commit

Governs every commit made by any command in this plugin, by default — a
command's own commit step never needs to restate this, only follow it. State
an explicit exception only where one exists (see below).

Set with `git-auto-commit` in {memory_file} (Project Config section or the recognized fenced configuration block):
  git-auto-commit: true   → commit automatically after each task

Absence defaults to off — ask for confirmation before committing.

When active:
- After completing a task, commit without asking for confirmation
- Stage only the files changed for the task. Never use `git add -A` blindly
- Derive the commit message from the work done; follow Conventional Commits
- Push still requires confirmation — same rule as Universal Rules → Safety below, restated here since it's the exception auto-commit doesn't override
- If the task spans multiple logical units, commit each unit separately before moving to the next

**Exception:** commits covered by safety.md's Agent Execution Boundaries — e.g.
committing generated legal documents (`/helm:legal`) — always ask for
confirmation regardless of this setting. Those are public or otherwise
high-stakes content where autonomy level should never skip review.

---

## Universal Rules

These apply regardless of mode.

**Branches**
- Never commit directly to main or master unless solo mode is active
- Never force push without explicit confirmation
- Never delete unmerged branches without explicit confirmation
- Never delete main, master, or any environment branch
- Never delete a published tag from a public repository
- After verified integration and any required publication, safely leave the feature branch before cleanup. Delete locally only when its tip is an ancestor of `{base_branch}`, no work is pending, and `git branch -d` succeeds. Squash/rebase may leave the original tip outside ancestry: retain and report it rather than substituting `-D`. A separately reviewed destructive cleanup still requires explicit confirmation. Deleting a published remote branch is a push and needs its own confirmation. Failed/pending integration or publication never triggers cleanup.

Exception: release commits made by /helm:ship (version bump + tag) may land directly on `{base_branch}` in any mode — this is the sanctioned release path, not an ad-hoc direct commit.

**Commits**
- Every commit on `{base_branch}` must leave the codebase in a working state
- One commit per logical unit — if you need "and" to describe it, split it

**Safety**
- Never push to any branch without confirmation (covered in safety.md)

---

## Conventional Commits

All commits must follow this format:
  type(scope): description

  [optional body]

  [optional footer]

**Types:**
- feat — new feature
- fix — bug fix
- refactor — code change, no feature or fix
- revert — reverts a previous commit
- test — adding or updating tests
- docs — documentation only
- chore — maintenance, dependencies, tooling
- style — formatting, no logic change
- perf — performance improvement
- ci — CI/CD configuration
- build — build system changes

**Scope:** Required. Use the module, feature, or domain area.
  feat(auth): add OAuth login
  fix(payment): resolve stripe timeout
  refactor(orders): extract service layer

**Multi-scope:** When a change is inseparably about two or more named areas — not just adjacent to them — use a comma-separated scope rather than picking one arbitrarily: `refactor(log,manifest): merge broken-structure and gap-based recommendation blocks`. Prefer a single scope whenever one area is clearly dominant; reach for comma-separated scope only when the areas are genuinely equal parts of the same change. Keep it to a handful of names — if the list is growing long, the change is probably `project`/`core`, not multi-scope.

**Scope inference** (for commands that infer it from a diff or cluster of changed files, e.g. `/helm:refactor`, `/helm:test`): use the primary module, folder, or domain area actually touched — never a command's own internal category/priority taxonomy (e.g. "architecture", "high-priority"), which is a report/selection grouping, not a commit scope. If the change spans multiple areas, use the dominant one, or a comma-separated multi-scope (above) if none is dominant; if truly cross-cutting with no specific areas to name, use `project` or `core`. Keep it lowercase, one word or hyphenated per scope.

**Breaking changes:**
  feat(auth)!: replace session with JWT

  BREAKING CHANGE: all existing sessions invalidated

The /helm:ship command reads these types to calculate the next version: feat! or BREAKING CHANGE triggers a major bump, feat minor, fix and perf patch (perf is a real improvement to shipped behavior, not a no-op), anything else is ignored for versioning.

---

## Code Quality

Run before pushing, regardless of mode:

**Lint and Formatting**
- Scan for lint and formatter config files and detect tool
- Run lint and formatter — fix all errors before pushing
- Include formatting changes in last logical commit
- Skip the lint step if no linter is configured — but if a linter is configured, never push with lint errors

**Tests**
- Detect test framework from project files
- Run tests covering changed files — full suite if touching shared/core code
- Skip silently if not configured — never push with failing tests

Only skip a check as unconfigured when repository evidence establishes it is absent. Configured checks that cannot run remain blocked, not passed. Required CI must succeed for the exact intended commit before integration/promotion; unavailable, missing, pending, failed, or unknown results do not satisfy the gate. Recheck after a tip changes and report capability failures under Host capabilities above.

---

## Deployment

Independent of strategy. Applies under both Solo mode and GitHub Flow.

Determine deployment triggers and targets from repository configuration and applicable provider settings. Do not assume a pipeline or deployment exists because a branch/tag exists or these rules are loaded. Unavailable evidence leaves deployment behavior unknown, not absent or safe.

- A configured push trigger may deploy updates to `{base_branch}` or other explicitly configured branches.
- A configured tag trigger may deploy a matching SemVer tag, including one created through /helm:ship.
- Both may be configured (for example, push → staging and tag → production), or neither. Report only verified behavior and preserve project-specific deployment approvals.

---

## Environment Branches (optional)

Independent of strategy. Works with both Solo mode and GitHub Flow.
Detected automatically from remote branch names.

Environment branches are any long-lived branches that are not main,
master, or feature branches — e.g. staging, stage, uat, preprod,
production, prod, or similar.

If no environment branches detected → no additional rules apply.

If environment branches detected, these additional rules apply:

**Rules:**
- Environment branches are permanent — never delete
- Feature work never merges directly to environment branches; use the approved promotion path
- All changes flow through `{base_branch}` first (upstream-first rule); only the approved promotion path then merges into environments
- Hotfixes follow the same rule — `{base_branch}` first, then promote
- If CI is configured, it must pass before promoting

**Promotion model**

Governs `/helm:ship`'s release promotion specifically. `/helm:legal`, `/helm:log`, `/helm:manifest`, `/helm:adopt`, `/helm:env`, and `/helm:test` always use fan-out for their own promotion of generated content or fixes ({memory_file}, README.md, legal documents, rule files, env/gitignore fixes, tests) regardless of this setting — those are content syncs, not a release pipeline, so there's no meaningful "tier" for the change to pass through.

Set with `environment-promotion` in {memory_file} (Project Config section or the recognized fenced configuration block):
  environment-promotion: fan-out  → {base_branch} merges directly into every selected environment, independently
  environment-promotion: chain    → environments form an ordered pipeline; only the first tier is reached directly from {base_branch}

Absence defaults to fan-out.

Before promoting anything, confirm which model is active — same as the git-strategy self-check above. State it explicitly: "Fan-out promotion" or "Chain promotion."

**Fan-out**: `{base_branch}` promotes directly to any combination of environment branches — no ordering, no dependency between them. Simple parallel deploy targets (e.g. staging and production both receive the same release independently).

**Chain**: environments form an ordered pipeline (e.g. `{base_branch}` → staging → production). Only the first tier (staging, stage, uat, preprod) is ever merged into directly from `{base_branch}`. A later tier (production, prod) is never selected as a direct deploy target — it's only reached by later merging the previous tier's branch forward into it (upstream-first rule, one tier at a time).
