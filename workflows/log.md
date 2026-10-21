# log

## Memory ownership and preserved instructions

Read `{package_root}/prompts/shared/project-layout.md` and perform its read-only preflight before the branch checks. It defines the migration to root AGENTS.md plus a real CLAUDE.md adapter for both hosts. Resolve existing effective configuration first; compare independent roots and ask about conflicts before Git actions. Never assess a pointer-only entry as an incomplete eight-section document. Report the old owner and the proposed target. Existing instructions remain protected; only the approved layout diff may move them. Do not move settings from a recognized fenced configuration block into a new Project Config section.

If an active root override does not explicitly read AGENTS.md, stop before branching as the layout procedure requires. Do not overwrite or bypass overrides, personal files, nested instructions, or external memory targets to claim shared setup.

The eight-section schema below is the generation format for a fresh file or a file already using that format. For a customized owner (including Compass's AGENTS.md), preserve its section structure and configuration block. Investigate the same topics, but propose targeted changes in the existing sections and wait for approval before applying them. Do not recommend replacing the file merely because its headings differ. In either format, use existing knowledge as the baseline: failure to rediscover a fact is not evidence that it is obsolete. Preserve durable knowledge, instructions, confirmed configuration, imports, Rules, and host-specific content. Any removal, contradiction, or restructuring needs supporting evidence and a concrete diff approved by the user. Uncertain entries remain unchanged and are reported for follow-up.

## Before starting

`/helm:log` updates {memory_file} from the project's state, so it needs the full merged, stable state — never an in-progress feature branch. Record `{run_git_strategy}` and `{run_auto_commit}` from the resolved existing configuration (defaults per git.md) and use those values through this invocation's Git finalization. Project Config Check can save new policy for later runs; it cannot change the current run's branch/commit path.

**No repository or no HEAD:** skip branch setup, Solo branch restrictions, commit, merge, push and promotion. Do not initialize Git. Run the same layout approvals and knowledge assessment on the actual workspace; generate no review marker. A marker retained by layout-only or partial work is provenance, not evidence of currency. Report generated files as uncommitted. The next Git-backed run can perform a full review.

**Solo Mode** (`git-strategy: solo`):
- Only proceed if on `main` or `master`. If on any other branch, stop: "log must be run on main or master in Solo Mode. Current branch is {branch} — switch and re-run."

**GitHub Flow** (`git-strategy: github-flow`, or absent):
- Record the current branch as `{original_branch}` — the workflow returns here at the end, whatever it was.
- Checkout a fresh branch from main's current tip: update local main (`git pull` if a remote exists), then `git checkout -b docs/log-{YYYYMMDD}` from it. This happens unconditionally — {memory_file} is always scanned from main's own state, never from a feature branch's unmerged work. If a feature branch changes something {memory_file} should reflect, re-run `/helm:log` after that branch merges to main.
- Call this branch `{branch}` for the rest of this command.
- If no layout, knowledge, configuration, or marker change was written or committed, delete the empty `{branch}` and return to `{original_branch}` before exiting. A scan Skip or current knowledge does not qualify when Step 0 changed layout. Never strand the user on an empty temporary branch, or delete one carrying a layout commit. A verified Outcome A marker update also needs normal finalization.

After branch setup and before Step 0, record `{review_head}` as the exact current HEAD when available. This is the source snapshot to investigate, not the later layout, knowledge, or merge commit. Apply the snapshot and acceptance rules below to every knowledge path.

## Step 0 — Shared layout

After branch setup, follow the layout procedure's planning, approval, application and read-back steps on the actual branch files. Run this before checking whether knowledge is current. After successful setup, `{memory_file}` is root AGENTS.md. A fresh project defers both files until a full scan is selected; selecting Skip then writes neither.

Capture the post-layout instruction contents as the knowledge-update baseline. Compare proposals and preservation checks against this baseline, not the pre-migration placement of the files.

Record layout writes/commits independently from scan writes. Adapter creation and approved moves count as real changes even if the later assessment says up to date or the user skips the scan. Cancel at layout approval exits with no scan and the empty-branch cleanup; it does not approve a legacy fallback. Commit a completed layout migration separately from any knowledge update under the run's recorded commit policy. Retain its original review marker; do not advance it for layout work.

## Scope

{memory_file} = descriptive project knowledge (orientation layer).
.claude/rules/ = prescriptive rules (architecture, safety, git, testing).
Keep them consistent. Project-specific safety rules live in {memory_file}'s `## Hard Safety Rules` section (written here, loaded with {memory_file}) — proposed, not auto-written. Never auto-edit the adopt-managed `.claude/rules` files (`git.md`, `safety.md`); they are overwritten by `/helm:adopt`, so propose any needed change to those instead.
Whenever writing to {memory_file}, in any step: use em-dashes sparingly — only when no other punctuation (comma, semicolon, colon, or a new sentence) works as well. When in doubt, restructure the sentence instead.

## {memory_file} Schema

For a fresh or standard-format owner, use these eight sections in order. Standard-format updates stay within them. For a customized owner, use its existing sections instead, preserving their names and order; do not install this schema over it.

1. **Project Identity** — name, stack, purpose, blast radius.
2. **Project Config** — flag-style declarations read by `.claude/rules` (e.g. `git-strategy: solo`, `git-auto-commit: true`); keep the heading even if empty.
3. **Dev Commands** — install, run, test a single file, migrate, logs.
4. **Architecture Pointers** — key files and modules with a one-line why, not summaries.
5. **Domain Rules** — non-obvious business, lifecycle, and permission constraints a change could violate; one line each; write "None" if there are none.
6. **Behavior Rules** — development conventions, autonomy model, confirmation gates, test requirements.
7. **Hard Safety Rules** — this project's concrete never-do list: the real operational risks it carries (what `git push` deploys, which scripts are destructive, which environment is shared). Keep it concise; write "None" if there are no project-specific hazards.
8. **Known Traps** — gotchas; initially empty or inferred from README warnings.

A `## Rules` section, if present, is **not** part of this schema — it is written and managed by `/helm:adopt` and points at the adopted rule files (`.claude/rules/git.md`, `safety.md`), distinct from the inline Domain / Behavior / Hard Safety Rules above. Preserve it exactly as-is: a full scan or gap update must never write, move, or remove it.

## Change significance

Commit type, subject, and labels are navigation aids, not exclusion rules. A fix may expose a domain constraint or trap; dependency updates can change runtime requirements; styling can encode accessibility conventions; CRUD and refactors can alter permissions, data lifecycle, or architecture. Inspect changed paths and relevant patches for every commit in the review range, including merge results against relevant parents, before deciding it carries no durable knowledge. Follow affected references, tests, configuration, and docs when needed to understand the effect. Never skip a category wholesale.

A change is noise only after inspection shows that it adds, changes, or invalidates no durable project knowledge. Report the range inspected and the reasons for dismissing changes; do not persist a commit-by-commit changelog in memory. Exclude this run's separately recorded layout commit from the source range, and treat other pure layout moves as noise only after verifying that they changed no settings or instruction meaning. If later commits only maintain the shared instruction outputs and introduce no durable knowledge missing from current memory, retain the marker rather than generating an endless series of marker-only commits. Verify their actual changes; a log-like commit subject is not sufficient.

## Review snapshot, coverage, and acceptance

- With HEAD, review the range from the validated saved marker through `{review_head}`, or the whole project at `{review_head}` for a full investigation. This invocation's generated outputs are not new source changes. Do not stamp whatever HEAD happens to be after layout or finalization.
- Before investigation, inventory relevant source, config, scripts, tests, and docs, including visible untracked project inputs. With HEAD, if such inputs differ from the committed snapshot, stop the knowledge scan and report the paths; ask the developer to commit or resolve them and re-run. Do not fold their changes into a review of an older commit, automatically commit them, stash, or discard them. Step 0's approved instruction edits are expected outputs, not unreviewed source inputs.
- Keep a working coverage summary of the packages/topics investigated, evidence paths, and any absent, excluded, inaccessible, or unfinished areas. For gap review, account for every commit and changed path in the range; for full review, meet Step 3's coverage requirements. Inaccessible or unfinished relevant inputs make the review incomplete, not evidence of no changes. Without HEAD, use the actual workspace, track inspected input contents, and omit the review marker.
- Before applying a proposal, recheck its original instruction-file contents and relevant source inputs. When HEAD exists, it must still be `{review_head}` or this run's recorded layout commit, with no unrelated source changes; without HEAD, compare the inspected workspace inputs directly. If inputs changed, do not apply a stale proposal: stop, report the changed paths/HEAD, and require a refreshed investigation and diff. Approval of an older diff does not approve a changed one.
- Advance `last-reviewed` to `{review_head}` only after the required investigation is complete and every substantive knowledge change in the proposal has been accepted and successfully written. A rejected, cancelled, partially accepted, skipped, or incomplete review leaves the previous marker unchanged. Partially accepted edits or confirmed configuration choices may be applied, but report the outstanding findings and that the review point did not advance. Removing an invalid or ambiguous marker still needs reviewed approval.
- A completed review finding no durable change may advance only the marker (Outcome A), with no extra knowledge-write question. No source commits since the saved marker, or only verified instruction maintenance as described above, means no marker write. Layout-only work never advances the marker. Put an eligible marker change in the same write as accepted knowledge changes, verify them together before committing, and retain the inspected snapshot hash after later commits or merges.

If knowledge investigation stops or is incomplete, preserve its prior marker and proceed to Step 5 only to finalize already-approved layout/configuration changes and clean up an empty branch. Never merge or delete a branch carrying unapproved knowledge drafts. If local changes block returning to the original branch, stop that operation without resetting or stashing them and report the actual branch and files left behind.

---

## Step 1 — Assessment

Without HEAD, no saved hash can establish currency. Offer full scan/investigation or Skip without running Git history commands, even if a moved file retains an old marker as provenance. A layout-only move/Skip preserves it; a completed, accepted full scan without HEAD omits it. A partial or declined scan retains the prior marker only as provenance and reports the review as incomplete. Do not claim up-to-date knowledge from unavailable history.

First classify the resolved owner as standard-format or customized. A file with custom sections or the recognized Compass-style configuration layout is customized, not a broken standard schema. For a customized owner, skip the standard schema-completeness check and replacement descriptions below. Assess its review hash and meaningful changes normally: no hash offers `Full investigation` or `Skip`; a meaningful gap offers `Gap update`, `Full investigation`, or `Skip`; an unchanged current file reports no update. Explain that both custom update modes investigate and propose targeted edits in the existing structure, then wait for approval before writing. Full investigation covers all topics in Step 3, not a full-file replacement. Continue with Step 2's missing-settings-only rule and the matching investigation path.

An otherwise empty Rules-only bootstrap from adopt is fresh, not a customized knowledge document. Offer full scan or Skip and preserve its Rules section when generating the standard sections.

Check {memory_file}:
- Does it exist?
- Does it have content?
- Is there a saved commit hash? (look for `<!-- last-reviewed: {hash} -->`)
- If hash exists and HEAD is available, verify it resolves to a commit and is an ancestor of `{review_head}` (`git merge-base --is-ancestor {hash} {review_head}`), then inspect `git log {hash}..{review_head} --oneline`, changed paths, and relevant patches per Change significance. An invalid or unrelated marker is reported and offers full investigation; do not run an invalid range or silently treat it as current.
- How significant is the gap, based on inspected effects rather than commit categories?
- If the file exists and has content, check whether all eight sections from the {memory_file} Schema (above) are present.

Schema is intact if all eight headings are found. Schema is broken if any are missing.

Based on current state, use AskUserQuestion (single-select) to present options:

If {memory_file} is absent, empty, or has no saved commit hash:
  AskUserQuestion:
    question: "{one sentence status, e.g. '{memory_file} not found — a full scan is required.'}"
    header:   "Update mode"
    multiSelect: false
    options:
      - label: "Full scan (Recommended)"
        description: "Investigate the whole project; preserve existing knowledge and propose evidence-backed updates, reviewing any existing-file changes before writing"
      - label: "Skip"
        description: "No update needed"

If {memory_file} exists with a valid saved commit hash and schema is intact, and there are no source commits through `{review_head}` (apart from verified instruction maintenance as described above):
  {memory_file} is already current. Inform the user: "{memory_file} is up to date — no source changes since last review." Do not present a scan prompt or advance the review marker. Proceed to Step 5, retaining any Step 0 layout changes/commits; only the knowledge update is a no-op.

If the schema is intact and new source commits exist but complete inspection finds no durable knowledge change, use Step 4's Outcome A after the snapshot/coverage checks rather than dismissing them by label. Run Project Config Check once if applicable settings are missing.

If {memory_file} exists with a saved commit hash, and either schema is broken or there are meaningful commits since the hash:
  Determine recommendation:
  - If schema is broken (any required section missing): recommend Full scan regardless of gap size — state which sections are missing.
  - Otherwise (schema intact, meaningful commits exist): recommend Gap update for a small or moderate gap, or Full scan for a large or significant gap.
  List the recommended option first and append "(Recommended)" to it.

  AskUserQuestion:
    question: "{one sentence status and recommendation}"
    header:   "Update mode"
    multiSelect: false
    options:
      - label: "Gap update"
        description: "Edit only sections affected by commits since last review, leaving the rest of the file untouched{ — missing sections will not be added, if schema is broken}"
      - label: "Full scan"
        description: "Investigate the whole project{ and restore missing standard sections, if schema is broken}; preserve existing knowledge and review the proposed updates before writing"
      - label: "Skip"
        description: "No update needed"

---

## Step 2 — Project Config Check

**Every owner and update mode:** ask only about applicable settings absent from its recognized configuration block. Preserve all valid existing values, including explicit `false`, and the block's layout. Do not repeat confirmed questions because a full scan was chosen, a heading differs, or the host changed. Invalid/conflicting existing values must already have been resolved in preflight; an explicit request to change a setting is honored without reasking unrelated settings.

Run this check at most once per invocation. Collect missing choices in `{pending_config}` and reuse them during writing; the scan steps below must not repeat the questions. If all applicable flags are already present, skip silently. Never replace the entire config block with only the keys asked below: retain other settings such as `readme-style` and `environment-promotion`. Include pending choices in the proposed write to the existing owner/block. If the proposal is cancelled, do not apply pending choices; if the developer explicitly accepts settings only, apply only those choices. Saving settings alone does not advance the marker; a separately completed Outcome A review may still qualify for its marker update. A fresh owner may receive a Project Config section when its selected scan writes it. Do not create files after Skip.

If an existing owner lacks a recognized configuration block, show the minimal proposed section addition with the chosen settings before inserting it in that same owner. Preserve customized headings elsewhere and never create a second owner or put settings in CLAUDE.md's adapter. Do not add an alternate section when a recognized fenced block already exists.

The write instructions below describe the pending values, not immediate file writes before a proposal is accepted. All Git finalization still uses `{run_git_strategy}` and `{run_auto_commit}` from invocation start.

**Question 1 — Branching strategy** (ask only if `git-strategy` is absent):

  AskUserQuestion:
    question: "Which git branching strategy should this project use?"
    header:   "Branching strategy"
    multiSelect: false
    options:
      - label: "Solo Mode"
        description: "Commit directly to main — no feature branches, no PRs. Intended for solo work with no collaborators."
      - label: "GitHub Flow"
        description: "Branch off main for every change, open a PR to merge back. Intended for teams or projects with peer review."

  Solo Mode selected → write `git-strategy: solo` under Project Config.
  GitHub Flow selected → write `git-strategy: github-flow` under Project Config.

**Question 2 — Auto-commit** (ask only if `git-auto-commit` is absent):

  AskUserQuestion:
    question: "Should the agent commit automatically after completing each task?"
    header:   "Auto-commit"
    multiSelect: false
    options:
      - label: "Yes — commit automatically"
        description: "The agent commits after each task without prompting. Push still requires confirmation."
      - label: "No — ask before committing"
        description: "The agent asks for confirmation before every commit."

  Yes selected → write `git-auto-commit: true` under Project Config.
  No selected → write `git-auto-commit: false` under Project Config. This explicit choice is confirmed configuration, not a missing flag next time.

**Question 3 — Merge strategy** (ask only if the existing or pending future `git-strategy` is GitHub Flow and `git-merge-strategy` is absent):

  AskUserQuestion:
    question: "Which merge strategy should be used when merging pull requests into main?"
    header:   "Merge strategy"
    multiSelect: false
    options:
      - label: "Squash (Recommended)"
        description: "Squash all commits into one with a Conventional Commit message. Keeps main history clean and linear."
      - label: "Rebase"
        description: "Replay branch commits onto main without a merge commit. Linear history, preserves individual commits."
      - label: "Merge commit"
        description: "Create a merge commit. Preserves full branch topology and commit authorship."

  Squash selected → write `git-merge-strategy: squash` under Project Config.
  Rebase selected → write `git-merge-strategy: rebase` under Project Config.
  Merge commit selected → write `git-merge-strategy: merge` under Project Config.

---

## Step 3 — Full Project Scan

Before writing anything, build a file/package inventory and investigate every applicable topic below across all first-party packages, services, and entry points. Folder names alone are not implementation evidence.

| Topic | Minimum evidence to inspect when present |
|---|---|
| Purpose and scope | README and project docs, package metadata, exposed routes/commands/UI, existing memory and linked shared instructions |
| Stack and setup | Dependency manifests and relevant lock/config files, supported runtime/tool versions, example env key names, install/run/build scripts |
| Architecture and workflows | Each major module's entry points and representative implementations; trace primary requests/jobs/commands through business logic, persistence, and integrations |
| Domain constraints | Models/schema/migrations, validation, auth/permission checks, state transitions, business services, and tests that establish lifecycle and data invariants |
| Development conventions | Contributor docs, lint/format/type settings, test setup and representative tests, fixtures, hooks, CI; distinguish documented preferences from enforced checks |
| Operations and safety | Deployment/CI config, containers, task runners, destructive scripts, background jobs, environment ownership and external integrations; inspect commands, never execute operational actions during a scan |
| Traps and prior knowledge | Existing memory entries, linked docs/rules, warnings, failure-path tests, and relevant history needed to reconcile contradictions |

Keep the coverage summary by package/topic with the evidence paths actually inspected. Mark a topic absent only after checking the relevant locations; record access failures and unfinished paths explicitly. Exclude dependency/vendor directories, build artifacts, caches, and unrelated data with reasons. Respect project restrictions on operational ledgers and credentials; do not read secret values to document configuration. If a relevant area cannot be investigated under those restrictions, disclose the coverage limit and leave the review point unchanged. Do not claim a full review from a README-only scan or a sample of one package in a multi-package project.

For each existing durable entry, decide whether to retain it unchanged, propose an evidence-backed update/removal, or retain it pending clarification. Preserve entries not rediscovered, including historical rationale and operational knowledge that source code cannot prove. Show the evidence and exact diff for proposed removals or contradictions; no deletion by omission. Do not duplicate inherited rules or inline imported files.

For a customized owner, use the targeted, reviewed path above: propose edits in its existing sections and wait for approval before writing.

For a standard-format owner, assemble a complete candidate using the eight schema sections in order, preserving the baseline knowledge and protected content above. A full replacement is a file-writing technique, not permission to discard old knowledge. Show the proposed diff for an existing knowledge document and wait for approval; approved partial changes retain the old review marker and unresolved entries. Use Write once only for the accepted complete replacement. Keep adopted Rules and protected imports verbatim and in their existing placement.

Use the once-per-run Project Config Check and merge `{pending_config}` with every preserved existing setting. Do not run its questions a second time before writing.

{memory_file} is not: a README, a file listing, a code walkthrough,
a technical spec, or a changelog. Only include information a future
session would struggle to discover quickly from the codebase alone.

Do not create or modify .claude/rules during full scan unless explicitly
requested. Safety findings should be proposed, not auto-written.

When the snapshot, coverage, and acceptance conditions are met, append `<!-- last-reviewed: {review_head} -->` at the end of the file in the same write as the accepted knowledge. Otherwise retain the existing marker unchanged; a fresh incomplete review has no marker. Without HEAD, omit the marker rather than fabricating one on a completed scan. On a genuinely fresh setup, also create CLAUDE.md containing only a standalone `@AGENTS.md` import; verify both together before claiming setup complete.

Be concise. Target under 150 lines without padding, but never meet the target by dropping protected or durable content. For a genuinely fresh file or Rules-only bootstrap, choosing Full scan authorizes ordinary descriptive content and the fresh adapter; proposed new safety rules still require explicit approval. Existing knowledge documents, standard or customized, require the proposed-diff approval above. Apply only accepted changes; if any proposed substantive finding remains unaccepted or investigation is incomplete, report that state without advancing the marker.

---

## Step 4 — Gap Update

Run Project Config Check (Step 2) once if it has not already run; reuse pending answers and skip silently when all applicable flags are present.

Read commit messages to navigate the range, then inspect every commit's changed paths and relevant patches through `{review_head}` per Change significance. Include merges, renames, deletions, changed tests/config/docs, and affected callers as needed. Record evidence for dismissals and follow durable effects even when the subject says fix, style, dependency update, CRUD, or refactor. An assessment inspection may be reused; do not repeat it unless inputs changed.

Focus on: architectural changes, new modules, new conventions, domain
rule changes, new operational knowledge, newly discovered traps.

**Stay within the owner's existing structure.** For a standard-format owner, every change must land in one of the eight schema sections. For a customized owner, use its existing sections and configuration block. Never add, rename, or remove a custom heading without a reviewed, approved diff.

Unlike Full scan, this is a targeted patch: use `Edit`, not `Write` — touch only the sections a significant commit actually affects, and leave every other section's existing content exactly as it is.

Before adding anything, apply the three-question filter:
1. Will a future session struggle to find this from the codebase?
2. Would knowing it improve future development decisions?
3. Will it stay true for weeks or months?

Only update if all three are yes. Durable knowledge includes:
architecture decisions, development conventions, domain knowledge
(business rules, lifecycle rules, permissions), operational knowledge,
and project traps. Completed tasks and temporary workarounds are not useful memory by themselves; record any durable constraint or rationale they reveal. Refactors and other commit categories are not automatically excluded.

Only record what is supported by evidence — code, config, docs, or
repository structure. No assumptions, preferences, or speculation.

Prefer improving existing content over adding new content.
Merge overlapping entries and improve clarity while preserving meaning. Remove or contradict an existing entry only with concrete evidence and approval of that specific diff; failure to rediscover it is not evidence of obsolescence.

If a `.claude/rules` file looks out of date, **propose** the change — do not edit it directly (see Scope for why, and where safety findings go).

Then provide one of two outcomes:

Outcome A — no update required
Briefly explain why the fully inspected range introduced or invalidated no durable knowledge, with the inspected snapshot and coverage. If the review is complete, apply any confirmed missing configuration and advance only the eligible review marker to `{review_head}`; skip the extra knowledge-diff question. With no new source commits, layout-only work, or incomplete coverage, do not advance the marker. Report incomplete coverage as incomplete review, not Outcome A or up to date.

Outcome B — update required
Describe what was learned, why it belongs in project memory,
and the exact changes to make. Propose as a diff per section.
Ask for confirmation before writing. After acceptance, recheck the snapshot and original file, then apply only the accepted edits, pending confirmed configuration, and an eligible marker together. If the user declines or accepts only part, preserve the prior marker, retain unaccepted existing content, and report outstanding findings. Do not stamp a hash before asking or claim the whole range is current after partial acceptance.

---

## Step 5 — Commit and finalize

With no repository or no HEAD, skip all Git finalization and report the actual file changes as uncommitted.

If no layout, knowledge, configuration, or marker change was written or committed: skip commit, merge, and environment promotion below. Under GitHub Flow, delete the empty `{branch}` and return to `{original_branch}`. An up-to-date assessment or scan Skip does not erase Step 0 changes: if layout changed, finalize it normally and report knowledge as unchanged/skipped. Do not delete a branch carrying a layout commit as though it were empty. Confirmed configuration and eligible marker-only writes count as workflow changes too.

Use `{run_git_strategy}` and `{run_auto_commit}` throughout the existing finalization below. Commit only remaining uncommitted workflow changes; do not recommit the separate layout commit. If commit approval is declined, leave the actual files and branch for review and stop before merge/push.

Before any knowledge/configuration commit, read the output back and verify retained baseline entries, approved changes, all confirmed settings (including `false`), Rules/imports, and the marker's eligibility and exact `{review_head}` value when eligible. A partial write or settings-only change without a completed review retains the previous marker. Recheck relevant source inputs; an unexpected change stops finalization and is reported rather than folded into a clean review. Stage only this run's approved instruction changes. The completion check below repeats the essential ownership/output checks after finalization; neither step rewrites the marker to the resulting commit or merge hash.

If only a separately committed layout change remains under GitHub Flow and `{run_auto_commit}` is off, confirm its merge unless that action was already explicitly approved. Approval to commit the layout alone is not approval to merge or push it. Push always retains its own confirmation.

Otherwise, commit per git.md's Auto-Commit rule: silent if `git-auto-commit: true`, otherwise ask for confirmation before committing, merging, and pushing together. Either way, push itself always requires its own confirmation regardless of `git-auto-commit` — git.md's Auto-Commit rule states this as an explicit exception, and rules/safety.md lists `git push` as always requiring confirmation with no exceptions. Environment promotion's branch-selection prompt below already serves as that confirmation for environment-branch pushes; under GitHub Flow, confirm separately before step 2's `git push origin main`, even when the commit above was silent.

**Environment promotion** — shared by both modes below. If environment branches exist (discover via `git branch -r`, filter for known environment names, same detection as ship.md), ask which should also receive this update. (This block is intentionally duplicated across every content-sync command — see rules/git.md's Environment Branches section for the canonical shape; keep all copies in sync if it changes.)

  AskUserQuestion:
    question: "main will be updated. Which environment branches should also receive this {memory_file} update?"
    header:   "Promote to environments"
    multiSelect: true
    options: one entry per discovered environment branch, e.g.:
      - label: "staging"
        description: "Merge main into staging"
      - label: "production"
        description: "Merge main into production"

  AskUserQuestion caps at 4 options. If more than 4 branches qualify, offer only the first 4 (recognized tier names first — staging/stage/uat/preprod, then production/prod, then any others alphabetically) and note in the question that remaining branches need a follow-up run.

  If exactly one environment branch qualifies, a multi-select with one option isn't valid — AskUserQuestion requires at least 2. Ask a direct yes/no confirmation instead:

    AskUserQuestion:
      question: "main will be updated. Promote to {branch} as well?"
      header:   "Promote to environment"
      multiSelect: false
      options:
        - label: "Yes — promote to {branch} (Recommended)"
          description: "Merge main into {branch}"
        - label: "Skip"
          description: "Leave {branch} as-is for now"

    "Yes" is equivalent to selecting {branch} in the multi-select above — proceed the same way.

  For each selected environment:
  - git checkout {environment}
  - git merge main --no-ff -m "chore(deploy): promote main to {environment} for {memory_file} update"
  - git push origin {environment}
  - git checkout main

  If no environment branches exist, or the user selects none, skip silently.

**Solo Mode:** commit directly to main. Before pushing, confirm:

  AskUserQuestion:
    question: "Push main now? This publishes the commit to origin."
    header:   "Push"
    multiSelect: false
    options:
      - label: "Push (Recommended)"
        description: "git push origin main"
      - label: "Cancel"
        description: "Leave main committed locally but unpushed — push manually when ready"

If Cancel selected → stop here. Do not push or promote. Proceed to Step 6 to report the outcome, noting main is committed locally but unpushed.

If Push selected: `git push origin main`, then run Environment promotion above.

**GitHub Flow:**
1. Commit on `{branch}`.
2. Merge into main: `git checkout main`, `git merge {branch} --no-ff -m "{same message as the commit above}"`. If only Step 0 produced a commit, use that layout commit's message; do not assume a knowledge commit exists. Before pushing, confirm:

   AskUserQuestion:
     question: "Push main now? This publishes the merged commit to origin."
     header:   "Push"
     multiSelect: false
     options:
       - label: "Push (Recommended)"
         description: "git push origin main"
       - label: "Cancel"
         description: "Leave main merged locally but unpushed — push manually when ready"

   If Cancel selected → stop here. Do not push, promote, or clean up. Proceed to Step 6 to report the outcome, noting main is merged locally but unpushed.

   If Push selected: `git push origin main`.
3. Run Environment promotion above.
4. Delete `{branch}`: `git branch -d {branch}` locally, and `git push origin --delete {branch}` if it was ever pushed.
5. Return to where you started: `git checkout {original_branch}`.

---

## Step 6 — Confirm completion

If knowledge, configuration, or a marker was written this run, verify it before reporting: read {memory_file} back and confirm the accepted changes, retained entries/settings, and the eligible `{review_head}` marker, unchanged previous marker, or intentional absence as appropriate. Verify the CLAUDE.md import and preserved Claude-specific additions too. If layout alone changed, verify against its approved diff and unchanged review point. Verify both host paths resolve the same shared owner/settings and report active override/nested limitations. If any check fails, report it and the actual files/commits left behind instead of a clean completion. A partial or incomplete review takes precedence over a generic full-scan/gap-update success label.

Report:

- Outcome: {up to date / full scan written / gap update written / configuration only / partial review / incomplete review / skipped}
- Shared setup: {already connected / adapter created / migrated / reconciled / cancelled / incomplete}, with actual owner and adapter paths
- Layout and knowledge/configuration commits: {separate hashes, or uncommitted/no changes}; Pushed: {yes / no / N/A}
- Reviewed snapshot and range: {pinned review_head and validated range, or workspace without HEAD}
- Coverage: {packages/topics and evidence paths; exclusions and unresolved areas}
- Last-reviewed commit: {accepted snapshot hash / unchanged with reason / absent without HEAD}
- Unaccepted or unresolved findings: {list or none}; retained uncertain knowledge: {list or none}
- Sections updated: {list, or none}
- Environments promoted: {list or none}
- Rule files worth revisiting: {list any `.claude/rules` files whose content looks stale relative to what this scan found, or none}
- If GitHub Flow: temporary branch's fate ({merged and deleted / left as-is}) and which branch you were returned to.
