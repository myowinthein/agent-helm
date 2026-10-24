---
title: Home
nav_order: 1
permalink: /
---

# Agent Helm

Take the helm.

<img src="https://myowinthein.github.io/agent-helm/docs/images/banner.jpg" alt="agent-helm" width="600">

A workflow plugin for developers using Claude and Codex.

Keep project context across sessions, refactor code, write tests, maintain docs, audit configuration, manage Git history, ship releases and archive projects.

[Documentation site](https://myowinthein.github.io/agent-helm)

## Install

See the [setup guides](https://myowinthein.github.io/agent-helm/docs/setup/) for Claude Code, Cowork, Codex desktop, and Codex CLI. Use `/helm:<command>` in Claude or select the same Helm workflow from Codex's skill picker.

Claude Code:

```bash
# Register this repo as a marketplace on your machine. Runs once.
/plugin marketplace add myowinthein/agent-helm

# Install the helm plugin from the registered marketplace.
/plugin install helm@agent-helm

# Pull the latest version from GitHub when a new release ships.
/plugin update helm@agent-helm

# Remove the plugin from your machine.
/plugin uninstall helm@agent-helm

# Apply changes after install, update, or uninstall.
/reload-plugins

# Verify installation: type /helm in the Claude Code prompt.
# Commands should appear in the picker. If not, see Known Traps in AGENTS.md.
```

Codex CLI:

```bash
codex plugin marketplace add myowinthein/agent-helm
codex plugin add helm@agent-helm
```

Start a fresh session in your project, open the `$` picker, and select a Helm workflow. Codex entries require explicit invocation.

Normal recorded refactor/test paths prefer shared read-only Python 3.11+ helpers for ledger validation and bounded retrieval. If Python/execution is unavailable, choose Set up Python / Continue without Python / Stop once per run. Equivalent tools must meet the same complete validation and preservation checks; otherwise ledger-dependent work stays pending. Source-only Audit/Plan needs no Python or ledger access, and copied rules remain self-contained. Helm never installs Python or packages automatically. See [Python ledger helpers](https://myowinthein.github.io/agent-helm/docs/setup/python-helpers.html).

Upgrading from the old marketplace name requires registering and installing `helm@agent-helm` in each client. Disable the old plugin entry to avoid duplicate workflows. Existing rule copies and references remain supported; keep any old marketplace checkout that projects still reference. See [renaming an existing installation](https://myowinthein.github.io/agent-helm/docs/setup/compatibility.html#renaming-an-existing-installation).

## Usage

### Commands

Links below go to detail pages. Workflow logic lives in `workflows/*.md`; both Claude and Codex use the portable entries in `skills/`.

| Command | What it does |
|---|---|
| [`/helm:ship`](https://myowinthein.github.io/agent-helm/docs/commands/ship.html) | Publish current work with optional reviewed targets; explicit release mode handles SemVer, tags and hosted releases. |
| [`/helm:test`](https://myowinthein.github.io/agent-helm/docs/commands/test.html) | Audit, plan, write or maintain useful tests across packages and layers, for recent changes, the project or a selected area. |
| [`/helm:refactor`](https://myowinthein.github.io/agent-helm/docs/commands/refactor.html) | Audit, plan or apply selected behavior-preserving refactors across the project or a targeted area. |
| [`/helm:env`](https://myowinthein.github.io/agent-helm/docs/commands/env.html) | Audit environment loading and Git protection first, then choose fixes or approved template creation. |
| [`/helm:log`](https://myowinthein.github.io/agent-helm/docs/commands/log.html) | Set up shared project instructions, review knowledge, check status, or remember developer-confirmed lessons. The captain's log. |
| [`/helm:manifest`](https://myowinthein.github.io/agent-helm/docs/commands/manifest.html) | Create, review or repair a README, preserving existing content and style. Requires an existing instruction owner. |
| [`/helm:legal`](https://myowinthein.github.io/agent-helm/docs/commands/legal.html) | Create or maintain selected legal documents from confirmed business facts and actual data flows. |
| [`/helm:normalize`](https://myowinthein.github.io/agent-helm/docs/commands/normalize.html) | Audit commit conventions, review fixes and rewrite all affected local branches together after approval. |
| [`/helm:archive`](https://myowinthein.github.io/agent-helm/docs/commands/archive.html) | Audit, plan or preserve an old project's environment, data and recovery docs, with a reviewed local payload; ship separately publishes the private backup. |
| [`/helm:adopt`](https://myowinthein.github.io/agent-helm/docs/commands/adopt.html) | Audit, plan, install or update shared rules with content-aware review. Setup helper: see below. |

Log, manifest, test and refactor use **Full scan / Gap scan** consistently, using only the current request labels. They share [scan-selection guidance](https://myowinthein.github.io/agent-helm/docs/setup/compatibility.html#shared-scan-depth-selection) and a [command-specific investigation contract](https://myowinthein.github.io/agent-helm/docs/setup/investigation.html): exact transient inventories, evidence-based exclusions, sufficient reading/tracing, permitted read-only subagents and parent coverage reconciliation. Full reading, behavior assessment, knowledge tracing and README claim review have different required depths. The other six workflows retain specialized scopes. No issue quota, elapsed time or effort setting certifies coverage, and no new settings, state schema or persistent coverage file is added.

Run `/helm:log` in a project to establish shared `AGENTS.md` instructions and a `CLAUDE.md` importing them. Existing projects receive a reviewed migration proposal; future Claude/Codex sessions then share the same knowledge without rerunning setup when switching agents.

Use `/helm:log status` for a read-only local assessment, or `/helm:log remember: <lesson>` to propose a focused lesson without reviewing the whole project. In Codex, select log and request the same mode in your message. Remember preserves the source-review marker; Status writes nothing. The eight memory topics are a flexible checklist, with concise startup commands, project boundaries, working agreements and known traps.

Use `/helm:manifest` after setup to maintain the human-facing README with a full scan, reader-impact gap scan or targeted repair. Existing files receive a reviewed diff; new custom READMEs can start from your approved outline/reference. Root `README.md` remains the default, with an explicit target choice when other entry points compete. Skip saves no pending style, and incomplete reviews retain their previous source marker. See [manifest](https://myowinthein.github.io/agent-helm/docs/commands/manifest.html) for scope and approval details.

Use `/helm:env` to audit the current checkout without changing files or branches. Its eleven checks account for service boundaries, loader precedence and intentional overrides. Choose coherent fixes from a redacted plan, maintain existing templates or explicitly create a missing service template. Real values stay local, tracked operational env files remain report-only, and selected writes use normal Git preparation. See [env](https://myowinthein.github.io/agent-helm/docs/commands/env.html) for scope, verification and untracking decisions.

Env accepts approved edits on current main/master, an established feature branch or a confirmed environment branch. Test also accepts maintenance branches for approved tests/setup and eligible same-branch checkpoints. Prefer shared fixes alongside their feature/main, targeted checks or intentional configuration work on an environment branch, and base for broad project maintenance; recommendations do not restrict modes. Log/manifest/legal/adopt retain base-only Git writes. Refactor accepts base, established feature or existing refactor/* branches, with confirmed non-base environments Audit/Plan only even with that prefix. Runtime-target checks and project policy remain binding; local fixes never synchronize branches automatically. See the [starting-branch table](https://myowinthein.github.io/agent-helm/docs/setup/git-and-ci.html#local-editing-commands) for recommendations, restrictions and the other commands.

Editing commands finish locally on their permitted current branch, without automatic branch creation/switching, push/PR prompts, integration, environment promotion or cleanup. Base-only writers block elsewhere with a reason. Run ship separately when ready. `ship-method: direct|pr` controls publication independently of team size or branch topology; retired keys have no compatibility mapping. Existing adopted rule copies need a reviewed update too. See [Git and CI behavior](https://myowinthein.github.io/agent-helm/docs/setup/git-and-ci.html).

Use `/helm:legal` to review the actual service, confirm business facts and choose relevant legal documents. Existing policies receive targeted edits by default; new drafts can use an optional owner-supplied trusted template or confirmed facts and applicable sources. Review the basis for important claims, concrete wording issues and decisions needing qualified legal review, with an optional separate drafting critique and mandatory content/commit approval. Source freshness stays separate from legal freshness; store requirements and existing translations receive scoped checks. Unknown material facts block affected public drafts instead of becoming invented promises. See [legal](https://myowinthein.github.io/agent-helm/docs/commands/legal.html) for coverage and integration limits.

Use `/helm:ship` to publish the reviewed current branch first, then optionally send the same source to selected targets: main to envs, feature to main/envs, or env to main/other envs. Direct pushes and selected merges/checks/pushes; pr uses the existing feature or one shared main/env helper and creates/reuses verified PRs without merging/waiting. Review fixes update the same source and its open PRs. None finishes at source publication; stronger project/provider restrictions still apply. Use `/helm:ship release` explicitly on integrated main/master for the existing SemVer/version-file/tag/optional hosted-release workflow. A pending metadata PR resumes the same version after integration; ordinary pushes/target merges never release and release never auto-promotes. Plan/status remain read-only, with `ship plan release` for release planning. GitHub/GitLab retain authenticated provider recipes; other hosts retain manual handoffs. See [ship](https://myowinthein.github.io/agent-helm/docs/commands/ship.html) for source reuse, targets, checks and recovery.

Use `/helm:normalize audit` or `plan` for committed-message review without writes. Approved corrections rewrite all affected existing local branches together with consistent shared IDs, verified graph/recovery and preserved tags/excluded refs. Normalize records eligible checkpoints locally and never pushes or creates a bookkeeping PR. Later `/helm:ship normalize <private-run-evidence>` reviews exact histories/destinations and requires explicit fixed-lease approval when published IDs must be replaced. See [normalize](https://myowinthein.github.io/agent-helm/docs/commands/normalize.html).

Use `/helm:test audit` for static behavior/risk findings or `/helm:test plan` for proposed cases, setup and verification commands without execution or writes. Target a path/package/feature or choose Gap scan/Full scan; the workflow reuses project-native tools and selects layers and techniques from actual needs. Per-gap High/Medium/Low priorities need concrete risk evidence; unknown impact stays explicit. Choose exact cases, groups or tier filters through a reviewed plan, with Recommended / All ready / Choose / None for larger sets. Schema 3 remembers every assessed finding, including unselected ones, through stable IDs and open/resolved/obsolete states. Authorized assessment checkpoints precede implementation; later closures cite actual accepted code/evidence snapshots. Selecting work is not approval, and a recorded assessment is not a passing test result. Tooling discovery resolves each package's command and dependency owner, distinguishes restore/add/repair/upgrade and verifies the intended runner after approved setup; installation success alone is insufficient. Tool inventory stays out of test-log, with no discovery profile/config file. Existing tests default to Keep; approved Improve/Consolidate/Replace/Remove actions require evidence and preserved or explicitly superseded guarantees. Retirement stays pending when verification is deferred. Property/fuzz, visual/accessibility, compatibility, security, migration/recovery, performance and mutation checks are proposed only with relevant evidence, meaningful expected outcomes and appropriate limits. Human review stays separate from automated results. Coverage remains scoped evidence, and assessment checkpoints do not certify passing tests or newly considered techniques. Targeted/partial assessments leave project anchors unchanged. Older test ledgers use an explicit reviewed rebuild/reset rather than automatic case conversion. See [test](https://myowinthein.github.io/agent-helm/docs/commands/test.html) for safe execution, residual gaps and local handoffs.

Use `/helm:refactor audit` for static findings or `/helm:refactor plan` for concrete transformations, invariants and verification without execution or writes. Target a path/package/module/feature or choose Full scan, Gap scan or existing backlog. High/Medium/Low reflects evidenced improvement value, separately from safe/needs-review risk and effort. Grouped findings support Recommended / All listed ready / Choose / None, with explicit IDs, exclusions and no automatic selection expansion. Schema 2 separates stable findings, assessments, human decisions and supported closure proof. Genuine fully assessed findings with unknown priority are recorded with clarification blockers and held outside ready work; a completed scan can still advance its source anchors. Only current native provenance is accepted; unsupported inputs need explicit maintenance outside the command. Six defined perspectives cover architecture, contracts/state consistency, code clarity, performance/resources, test maintainability and dependency boundaries. Review resolves actual versions and relevant guidance per package across tech stacks; principles/paradigms and web architecture are contextual checks, not forced patterns. Test edits preserve mapped guarantees; missing/stronger protection belongs to test, with explicit selected-refactor guards allowed. Unverified test retirement/substitution stays plan-only. Selected work follows one dependency plan, with whole-selected-unit review, focused checks and separate code/history checkpoints on the permitted current branch, without creating/selecting another branch. Targeted/Backlog preserve assessed/full-scan anchors; one JSON retains useful history with bounded working views. See [refactor](https://myowinthein.github.io/agent-helm/docs/commands/refactor.html) for safety, recurrence and publication boundaries.

Use `/helm:archive audit` or `plan` for static recovery review without execution/network/writes or required branch confirmation. Before normal pending phases, archive shows the current branch/commit and excluded work and asks Proceed/Cancel for same-branch changes/local payload, reusing explicit still-applicable approval. It preserves compatible tools/images/data/docs through five reviewed local phases and commits the local payload, then finishes with no backup push. Proven prepared/completed report-only reruns need no new branch question and replace nothing. Later `/helm:ship archive` separately publishes/verifies the private payload and completion receipt; optional cleanup and external portable copying stay explicitly scoped. Existing roots/runs are preserved. Static checks, runtime/cold recovery, offline rebuilds and remote backups remain distinct. See [archive](https://myowinthein.github.io/agent-helm/docs/commands/archive.html).

Archive restores from cross-checked setup evidence, offers a developer check, then selects the useful freeze approach for the actual stack and recovery goal. API materials can be retained, repaired, created or skipped. Its own README introduces recovery, setup holds ordered procedures and Markdown metadata holds artifact identities and verification. Supplementary documents and per-artifact storage are handled only as needed. See [archive outputs and naming](https://myowinthein.github.io/agent-helm/docs/commands/archive.html#output-files-and-their-purpose).

Current project state uses only `.helm/` on both hosts: native refactor schema 2, test schema 3, normalize/legal schema 1 and current archive schema 1 at `.helm/archive/`. Unsupported old paths/versions stop without readers, converters or automatic resets. Historical archives and recovery assets remain protected. See [breaking changes and one-time upgrade](https://myowinthein.github.io/agent-helm/docs/setup/upgrading.html). Native shared rules stay in `.claude/rules/`.

### Rules

| Rule | What it does |
|---|---|
| [`git.md`](https://myowinthein.github.io/agent-helm/docs/rules/git.html) | Local Git work, direct/PR shipping, scoped commits that preserve user work, quality gates, exact publication and confirmed environment promotion. |
| [`safety.md`](https://myowinthein.github.io/agent-helm/docs/rules/safety.html) | Autonomous routine work, scoped authorization reuse, effect/recovery boundaries, safe retries and static secret-safe risk discovery. |
| [`writing.md`](https://myowinthein.github.io/agent-helm/docs/rules/writing.html) | Clear, natural prose for native and non-native readers, with familiar words, restrained punctuation and preserved facts, warnings and project voice. |

The copied Git/safety pair works without a loaded plugin and does not require the writing rule. Loading rules executes nothing: labelled static inspection can report unresolved inputs, while writes/publication retain their required policy, approval and verification gates. Routine requested edits and established safe checks proceed without an extra safety question. Consequential actions need a sufficiently specific request or concrete approved plan, reused across clients while its target/content/effects remain covered; hard prohibitions and changed effects still block dependent work. User work, secrets and partial successes stay protected. Rule instructions, application approvals and OS/sandbox permissions are separate layers; the rule alone does not guarantee enforcement. Required failed, unavailable or deferred checks never become a pass.

The independent writing rule guides newly authored or requested edited prose without scanning or restyling existing content. It favours common words, clear actions and natural tone, defaults to avoiding em dashes, and keeps technical meaning, uncertainty, warnings and required formats. It is not an authorship test or a promise of detector results. Helm workflows read the bundled rule; project-wide use outside workflows requires adoption.

## Using the rules

Installing the plugin does not install project-wide rules. Use [`/helm:adopt`](https://myowinthein.github.io/agent-helm/docs/commands/adopt.html) on either host to install approved shared local copies of `git.md`, `safety.md` and `writing.md` in `.claude/rules/`. AGENTS.md explicitly tells both agents to read the installed rules, and CLAUDE.md imports AGENTS.md. No separate Codex copy or installed Claude client is required for Codex to use these files. Log handles existing-file shared onboarding through reviewed diffs; adopt installs no reverse bridge or external-reference converter.

New adoption proposes all three rules in the reviewed plan, with writing optional. Existing projects receive writing as a separate, initially unselected addition. Updating/reconnecting local Git/safety rules does not install writing implicitly; declining it does not break a healthy pair. Foreign/custom files and every real replacement retain individual review, and no pointer is added to an uninstalled rule.

Local copies are the only new installation method. Adopt uses the verified actual loaded Helm package as its default copy source, with no marketplace/cache/GitHub paths in the generated rule pointers. `adopt audit` and `adopt plan` inspect/propose without writes, execution or state access. Selected writes retain the local-only current-base rules; publication belongs to ship.

Existing external references can be kept unchanged or converted through the same reviewed flow on either host. Readable old targets and existing copies receive actual content/version comparisons; missing targets receive a complete proposed replacement and explicit approval of unknown old content/rollback risk. Copies are verified before old pointer spans change, and custom rules, owner settings and adapters remain protected. Keep or a blocking Skip changes nothing; a failed conversion remains explicitly pending. Old external installations are never deleted or modified.

Plugin upgrades do not silently update project copies. Rerun adopt to review real content changes; equivalent bodies keep their bytes/markers, replacements and downgrades require individual decisions, and connection-only to readable local copies needs no unrelated update source. Final readback proves static inspected-root connectivity; fresh sessions are recommended and native loading remains unverified unless separately observed. See [compatibility](https://myowinthein.github.io/agent-helm/docs/setup/compatibility.html) for scope, source and migration safeguards.

## Contributing

The documentation site uses GitHub Pages Actions with the latest stable Just the Docs theme and a System/Light/Dark switcher. See [documentation site maintenance](https://myowinthein.github.io/agent-helm/docs/setup/documentation-site.html) for deployment, local preview and link behaviour. The Actions workflow builds the site; it does not run the tests listed below.

Run `ruby scripts/test_plugin.rb` for offline package checks, `ruby scripts/check_clients.rb` for native CLI discovery, and `bundle exec rake test` for the package and documentation checks. Native discovery checks do not install Helm or invoke a model. Optional `ruby scripts/smoke_layout.rb codex` and `ruby scripts/smoke_layout.rb claude` checks exercise migration, approvals and shared adoption in disposable projects using signed-in CLI accounts; pass case names to run a subset.

Issues and pull requests are welcome at [github.com/myowinthein/agent-helm/issues](https://github.com/myowinthein/agent-helm/issues). The intent of this pack is opinionated solo workflows, so feature requests that conflict with that scope may be declined politely.

## License

[MIT](https://github.com/myowinthein/agent-helm/blob/main/LICENSE)

<!-- last-reviewed: 2454819f5d375089e8695a96c22b5ad966d0deef -->
