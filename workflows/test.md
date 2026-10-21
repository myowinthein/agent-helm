# test

## Before starting

Read the shared runtime and resolve `{memory_file}` before Git actions, including instruction bridges, overrides, and recognized fenced configuration. Read `git-strategy` (default: GitHub Flow), `git-auto-commit` (default: false), and, under GitHub Flow, `git-merge-strategy` (default: squash) from that owner. This command never creates, migrates, or edits AGENTS.md, CLAUDE.md, or their settings. State the effective Git mode; preserve the resolved commit policy throughout the run.

**Solo Mode** (`git-strategy: solo`):
- Only proceed if on `main` or `master`. If on any other branch, stop: "test must be run on main or master in Solo Mode. Current branch is {branch} — switch and re-run."
- No branch is created — every commit in Steps 4–6 lands directly on main as it happens.

**GitHub Flow** (`git-strategy: github-flow`, or absent):
- Record the current branch as `{original_branch}`. Return only when finalization or genuine no-op cleanup completes safely; pending work stays on its current branch.
- Checkout a fresh branch from main's current tip: update local main (`git pull` if a remote exists), then `git checkout -b test/{YYYYMMDD}` from it.
- Call this branch `{branch}` for the rest of this command. Every commit in Steps 4–6 lands on `{branch}`, mirroring `/helm:refactor`'s single-branch-per-run model — Step 7 handles integration once at the end under the configured merge strategy and project review requirements, rather than pushing each cluster individually.
- A genuine no-op with no writes, commits, or pending work uses Step 7's safe empty-branch cleanup. Drafted or committed work is never an empty branch merely because a later action was cancelled.

## Pending work and commit cancellation

Honor the resolved `git-auto-commit` for every cluster, ledger, and integration commit. Before committing, show the concrete changes when confirmation is required. Declining a commit or a write/read-back/commit failure stops subsequent writes and finalization: preserve the current branch, drafted files, existing commits, and remaining legacy ledger sources; do not merge, rebase, push, promote, delete branches, or switch back. Go directly to Step 8 with the actual pending state, without advancing an uncommitted checkpoint or claiming migration completed. If state was only drafted, report it as pending. This rule takes precedence over all no-op cleanup paths below, even if earlier clusters were committed successfully.

## Scope

Tests must reflect actual proven behavior — not speculative edge cases.
Follow existing test conventions, naming, and file structure.
When 3+ cases share the same input → assertion shape (e.g. a dictionary or lookup table with one expected output per entry), write one parametrized test (`it.each`/table-driven, per the framework's convention) instead of one test block per case — same coverage, less bulk.
Never push with failing tests.

---

## Step 1 — Detect test framework

Scan for test framework configuration files and dependencies.
Also detect the project's coverage tool (coverage.py, nyc, jest --coverage, etc.) — record it for use in Step 5.

If framework detected → proceed to Step 2.

If no framework detected, form the recommendation from the project actually detected — language, package manager (from the lockfile), existing build tooling and module system, monorepo structure if any — reusing what the scan above already found rather than defaulting to generic knowledge.
  AskUserQuestion:
    question: "No test framework detected. Which would you like to set up? (based on detected stack)"
    header:   "Framework"
    multiSelect: false
    options:
      - label: "{recommended framework} (Recommended)"
        description: "{why it fits this stack}"
      - label: "{alternative}"
        description: "{brief reason}"
      - label: "{alternative}"
        description: "{brief reason}"
      - label: "Skip"
        description: "I'll set up testing manually"

If Skip selected → exit and inform user:
  "Configure a test framework and re-run /test."

If framework selected:
- Detect the project's package manager from its lockfile (e.g. `package-lock.json` → npm, `yarn.lock` → yarn, `pnpm-lock.yaml` → pnpm, `composer.lock` → composer, `poetry.lock` → poetry, `requirements.txt` → pip, `Gemfile.lock` → bundler) and run the matching install command for the chosen framework as a dev dependency (e.g. `npm install --save-dev {framework}`).
- If the install fails, stop and inform the user with the error — do not proceed to Step 2 with a framework that isn't actually installed.
- If it succeeds, proceed to Step 2.

---

## Step 2 — Load ledger

Read `{package_root}/prompts/shared/project-state.md` and apply it to `test-log.json`. The canonical path is `.helm/test-log.json`; check both `.claude/helm/test-log.json` and `.claude/test-log.json` too. Validate every candidate, applying only the explicit v1 conversion below in memory before comparing them. Resolve differing histories before using state. Path migration waits for Step 6's successful authorized write and is distinct from schema conversion.

With no candidate file, proceed as if the ledger is empty; do not create state just by loading it.

Schema:
```json
{
  "schema_version": 2,
  "last_run_commit": "abc1234",
  "full_scan_ever_run": true,
  "consecutive_catchup_count": 0,
  "files": [
    {
      "file": "path/to/file.ts",
      "priority": "high" | "medium" | "low",
      "last_judged_commit": "abc1234",
      "user_status": "skipped-by-user" | "ambiguous",
      "note": "short reason, e.g. what was unclear or why user skipped",
      "recorded_commit": "abc1234",
      "recorded_date": "2026-07-09"
    }
  ]
}
```

`schema_version` — bumped only if this ledger's structure changes in a future release. Lets a future version of this command detect an older-shaped file and handle it explicitly instead of misreading it.

If `schema_version` is `1` or absent (a ledger written before this shape existed): convert on load rather than misreading it. The old shape had `last_test_run_commit`, `last_full_scan_commit`, a `findings` array (`status`, `note`, `recorded_commit`, `recorded_date`), and a separate `full_scan_findings` array (`priority`, `last_judged_commit`).

Convert as follows:
- Map `last_test_run_commit` → `last_run_commit` directly.
- `full_scan_ever_run` is `true` only if `last_full_scan_commit` holds an actual commit SHA — **not** merely if the key is present. The old field could legitimately be `null` (a repo where a full scan has never run yet, `findings` and `full_scan_findings` both empty) while still being present in the JSON; treating key-presence alone as "a full scan happened" gets this case wrong.
- Map each `findings[].status` to `files[].user_status`, preserving `skipped-by-user` and `ambiguous` exactly, together with its `note`, `recorded_commit`, and `recorded_date`. Do not leave the decision only under the obsolete `status` key. If a legacy record already has a conflicting `user_status` or an unsupported status, stop for explicit reconciliation rather than dropping or guessing the decision.
- Merge `findings` and `full_scan_findings` into one `files` array keyed by file path. A file present in both old arrays becomes one record carrying both sets of fields — this is common, not an edge case (e.g. a file already flagged `ambiguous` by a human is also a real target for the next Full Scan's priority judgment).
- Set `consecutive_catchup_count` to `0` — the old shape never tracked it, and there's no way to reconstruct a meaningful count retroactively.
- Carry over stored commit IDs without inventing replacements. Validate them using the procedure below before using them for a diff, cache reuse, or suppression; a previous writer's valid commit may be unavailable or outside current history after a rewrite or in another clone. Preserve unrelated fields during conversion; remove only superseded v1 keys after their values have been accounted for in the v2 fields.

Treat the result as `schema_version: 2` for the rest of this run, and it will be persisted in that shape at Step 6.

Each `files` entry represents everything currently known about one file. `priority` and `last_judged_commit` come from sub-agent scan judgment (Full Scan only) and are independent of `user_status`, `note`, `recorded_commit`, and `recorded_date`, which come from an actual human decision (Behavior Clarity Check, or the Catch Up/Full Scan skip option) — a file can have either set of fields, both, or neither, and updating one set must never clobber the other.

`full_scan_ever_run` and `consecutive_catchup_count` exist for Step 3's scenario decision and Full Scan recommendation — see below.

### Validate saved commit references

Require a repository with a usable HEAD before assessment; otherwise stop without creating Git history or migrating state. Capture the inspected HEAD as `{assessment_head}` on the branch being assessed. For every stored commit ID used for a comparison, accept only a commit ID, resolve it to an existing commit object, and verify it is an ancestor of `{assessment_head}` before running the comparison. A syntactically plausible SHA alone is insufficient. Never interpret a saved value as an arbitrary revision expression or shell argument.

- Missing, unavailable, or non-ancestor `last_run_commit`: mark the incremental baseline unusable in memory, explain why, and route Step 3 to Full Scan or Skip. Do not run an invalid diff, silently substitute `HEAD~1`, or declare the project up to date. Leave the stored baseline untouched until a complete successful Full Scan records a new one.
- Missing, unavailable, or non-ancestor `last_judged_commit`: mark that priority judgment stale and include the file in Full Scan's new judgment scope. Keep its human decision fields and other history; never carry the priority forward as a verified cache hit.
- Missing, unavailable, or non-ancestor `recorded_commit`: preserve the human decision and note, but do not suppress a candidate file as an unchanged skip. Reassess it within the selected scope; ambiguous entries remain outstanding regardless of reference validity.
- Even with valid ancestry, a failed comparison is an error, not an empty diff. Stop dependent work and report it without advancing the ledger.

These checks are read-only on both schemas and all three state paths. Revalidate after a branch/history change. Squash, rebase, and normalize can invalidate references; do not remap them to HEAD merely to make them pass, since that would claim an assessment that did not happen.

---

## Step 3 — Assessment

Check recent git activity and existing test coverage:
- If Step 2 validated `last_run_commit`, identify recently changed files using `git diff {last_run_commit}..{assessment_head} --name-only`, checking command success. Otherwise record that incremental scope is unavailable; offer Full Scan or Skip as below.
- Count `files` entries with `user_status: ambiguous`, regardless of whether they appear in the diff above — these are outstanding from a previous run, not just files that happen to have changed again.
- Scan for existing test files
- Estimate coverage gaps in recently changed code
- Estimate overall project test coverage

Based on current state, pick one of four scenarios:

**Scenario 1 — No existing tests found:**
  AskUserQuestion:
    question: "No existing tests found — a full scan is recommended."
    header:   "Test scope"
    multiSelect: false
    options:
      - label: "Full scan (Recommended)"
        description: "Scan entire project for missing tests"
      - label: "Skip"
        description: "No tests needed"

**Scenario 2 — Tests exist, but a full scan was never run (`full_scan_ever_run` is `false` or absent) or the incremental baseline is unusable:**
  AskUserQuestion:
    question: "{Tests exist but a full scan has never been run / The saved incremental baseline is unusable: reason}. A full scan is recommended."
    header:   "Test scope"
    multiSelect: false
    options:
      - label: "Full scan (Recommended)"
        description: "Scan entire project for pre-existing coverage gaps"
      - label: "Skip"
        description: "No tests needed"

**Scenario 3 — Tests exist, full scan done, baseline validated, comparison succeeded with no changes, no outstanding ambiguous findings:**
  Inform the user: "No changes since last run — tests are up to date." Do not present any AskUserQuestion. Proceed to Step 7 (which forwards straight to Step 8, since nothing was committed) to report the outcome — nothing was written, but this is still an outcome worth confirming.

**Scenario 4 — Tests exist, and either recent changes are detected or ambiguous findings are outstanding:**
  Recommend Full Scan if `consecutive_catchup_count >= 5` (many Catch Ups have piled up since the last full look) OR the diff identified above touches 50+ files (this one batch is already big enough to warrant a full check). Otherwise recommend Catch Up. Outstanding ambiguous findings alone (no other changes) still route here — Catch Up will pick them up via Step 4's ambiguous-entry union, giving the user another pass through the Behavior Clarity Check.
  Put recommended option first.

  Catch Up is the recommendation:
  AskUserQuestion:
    question: "{one sentence describing coverage status and recommendation}"
    header:   "Test scope"
    multiSelect: false
    options:
      - label: "Catch Up (Recommended)"
        description: "Write tests for files changed since the last /test run. {reason, e.g. 'Only 6 files changed and 2 catch-ups since the last full scan — a targeted check should cover it.'}"
      - label: "Full scan"
        description: "Scan entire project for missing tests"
      - label: "Skip"
        description: "No tests needed"

  Full is the recommendation:
  AskUserQuestion:
    question: "{one sentence describing coverage status and recommendation}"
    header:   "Test scope"
    multiSelect: false
    options:
      - label: "Full scan (Recommended)"
        description: "Scan entire project for missing tests. {reason, e.g. '58 files changed since the last run — too broad for a focused check.' or '5 catch-ups in a row since the last full scan — due for a full look.'}"
      - label: "Catch Up"
        description: "Write tests for files changed since the last /test run"
      - label: "Skip"
        description: "No tests needed"

If Skip selected in any of Scenarios 1, 2, or 4 → nothing to write. Proceed to Step 7 (which forwards straight to Step 8, since nothing was committed) to report the outcome.

---

## Step 4 — Catch Up

Use only Step 2's validated `last_run_commit`: run `git diff {last_run_commit}..{assessment_head}` and check success to get all files changed since the last run. With an unusable baseline, do not enter Catch Up; return to the Full Scan/Skip choice in Step 3. Never replace a failed comparison with an empty change list.

Focus only on files that were added or modified.

Union in any `files` entries with `user_status: ambiguous`, even if they don't appear in the diff above — they're outstanding from a previous run and get another pass through the Behavior Clarity Check below, rather than sitting unresolved indefinitely until the file happens to change again.

Cross-check the resulting file list against `files` entries with `user_status: skipped-by-user`. Drop a file only when its `recorded_commit` passed Step 2's validation and a successful comparison proves it unchanged since that decision. If the file changed or that decision reference is unusable, keep it in the plan for reassessment. This does not apply to `ambiguous` entries, which are always re-included regardless of whether they changed.

Group the remaining files into clusters by module/domain — same folder, or a direct dependency (e.g. a controller and its service) — mirroring `/helm:refactor`'s clustering. Files in unrelated areas never share a cluster: git.md requires one commit per logical unit, and a single commit covering tests for two unrelated features would violate that.

Apply the **Behavior Clarity Check** (see below) before writing any test.

Before writing, present test plan:

  AskUserQuestion:
    question: "I will write tests for:\n- {file}: {what will be tested}\n- {file}: {what will be tested}\n\nProceed?"
    header:   "Confirm"
    multiSelect: false
    options:
      - label: "Write tests (Recommended)"
        description: "Proceed with the test plan above"
      - label: "Cancel"
        description: "Exit without writing tests"

If Cancel selected → nothing to write. Proceed to Step 7 (which forwards straight to Step 8, since nothing was committed) to report the outcome.

Wait for response before proceeding.

Write tests that reflect actual proven behavior — not speculative edge cases.
Follow existing test conventions and file structure in the project.
Place test files according to project's existing test organization.

Write cluster by cluster. For each cluster:
- Run tests after writing — fix if failing before committing.
- Commit, with scope inferred from this cluster's files per git.md's Scope inference convention:
  test({scope}): add tests for {feature}

---

## Behavior Clarity Check

Applied in Step 4 and Step 5 before writing a test for any piece of code.

Assess whether the expected behavior is clear from the code, docs, or existing tests:

- **Clear**: write the test directly. No extra prompt.
- **Ambiguous** (undocumented edge case, unclear intended behavior, behavior contradicts docs):
  stop and confirm with the user:
  AskUserQuestion:
    question: "Behavior is unclear for {file} — {what is ambiguous}. How should this be handled?"
    header:   "Ambiguous behavior"
    multiSelect: false
    options:
      - label: "Clarify and proceed"
        description: "Provide clarification, then write the test"
      - label: "Skip this case"
        description: "Record as ambiguous in the ledger and move on"

  If the user clarifies → write the test using the clarified behavior.
  If the user skips → set `user_status: "ambiguous"` and a short note on that file's `files` entry (creating one if it doesn't exist yet, without touching any `priority` fields already there). Do not guess and encode a guess as a test.

---

## Step 5 — Full Scan

### Coverage check

Run the project's coverage tool (detected in Step 1) across the full project. This is always full and current — never partial, never skipped, regardless of ledger state.

### Priority judgment

Determine which untested areas are high, medium, or low priority.

Split the project into folder/module chunks (keeping related files together), capped at 8 chunks as in Deep Mode in `/helm:refactor`. Use available read-only workers within the host's actual concurrency limit; queue chunks or perform the same complete scan sequentially when delegation is unavailable, as the shared runtime requires. Each worker returns priority judgments only. On Codex, the parent remains the only code, Git, and ledger writer; writing tests stays sequential on both hosts.

Before priority judgment, cross-check each file against `files` in the ledger:
- File has a `files` entry with `priority` set, a validated `last_judged_commit`, and a successful comparison proving it unchanged since that commit: carry the stored priority forward — do not re-run sub-agent judgment for this file.
- File has no `priority` set yet, its judgment reference is unusable, or it's changed since `last_judged_commit`: include it in the sub-agent run; set its `priority` and `last_judged_commit` to the new judgment and current HEAD — creating a new `files` entry if none exists, or adding these fields to an existing entry without touching any `user_status`/`note`/`recorded_commit`/`recorded_date` fields already on it.
- File has a `files` entry (with `priority`, `user_status`, or both) but no longer exists in the repo: remove the entry entirely — neither the priority judgment nor any lingering user decision applies to a file that's gone.

Present findings before writing:

─────────────────────────────────
TEST COVERAGE REPORT
─────────────────────────────────

HIGH PRIORITY        {X untested}
─────────────────────────────────
{file}: {what is untested and why it matters}

MEDIUM PRIORITY      {X untested}
─────────────────────────────────
...

LOW PRIORITY         {X untested}
─────────────────────────────────
...

─────────────────────────────────
TOTAL: {N} untested areas found
─────────────────────────────────

Then use AskUserQuestion for priority selection:
  AskUserQuestion:
    question: "Which priorities to cover?"
    header:   "Priorities"
    multiSelect: true
    options:
      - label: "High Priority"
        description: "{N} areas — payment, auth, core business logic"
      - label: "Medium Priority"
        description: "{N} areas — API endpoints, data transformation"
      - label: "Low Priority"
        description: "{N} areas — everything else"

  Selecting none = skip the Writing tests section below — no tests get written, but the scan itself already ran and still needs to be recorded: proceed to Step 6 to update the ledger (the coverage check and priority judgment happened regardless of what's selected here), then Step 7. Do not add an explicit All or Skip option.

Wait for response before proceeding.

### Writing tests

Apply the **Behavior Clarity Check** (see above) before writing each test.

Write tests priority by priority, single-agent and sequential. Do not parallelize writing across sub-agents.

Within each priority, group files into clusters by module/domain — same folder, or a direct dependency — same reasoning as Step 4's Catch Up clustering. A priority tier commonly spans multiple unrelated areas (e.g. "high priority" including both `payment.ts` and `core-engine.ts`); a single commit must never bundle them together just because they share a priority label.

For each priority, cluster by cluster:
- Write tests reflecting actual proven behavior
- If a cluster is large enough to strain one agent's context, batch it sequentially (write a chunk, commit, continue) — no planning or dependency system needed
- Run tests — stop and inform if failing
- Fix before proceeding to the next cluster
- Commit, with scope inferred from this cluster's files per git.md's Scope inference convention (not the priority label itself):
  test({scope}): add missing {priority}-priority tests for {brief summary of this cluster}

---

## Step 6 — Update ledger

Only after the selected work completes successfully and every required test/framework commit is accepted and verified, or a complete Full Scan finished with no priorities selected for writing. A declined or failed commit follows Pending work and commit cancellation above; do not advance state for incomplete work:

- Set `schema_version` to `2` if not already present — including when converting an old-shaped ledger per Step 2's migration note.
- **Catch Up run**: set `last_run_commit` to current HEAD. Increment `consecutive_catchup_count` by 1.
- **Full Scan run**: set `last_run_commit` to current HEAD, set `full_scan_ever_run` to `true`, reset `consecutive_catchup_count` to `0`. Persist all `priority`/`last_judged_commit` changes from Step 5 into `files` (new entries, updated priorities, entries removed for files that no longer exist).
- For files recorded during the Behavior Clarity Check as ambiguous: set `user_status: "ambiguous"` (plus `note`, `recorded_commit`, `recorded_date`) on that file's `files` entry — creating one if it doesn't exist, without touching any `priority`/`last_judged_commit` fields already there. `skipped-by-user` has no writer in the current flow — Step 4's plan confirmation and Step 5's priority selection are both all-or-nothing/tier-level, not per-file — but Step 4 still checks for and honors any pre-existing `skipped-by-user` entries (e.g. from a schema migration or manual edit).
- For files resolved this run (test written successfully, or ambiguity clarified): clear `user_status`/`note`/`recorded_commit`/`recorded_date` from that file's entry. Remove the entry entirely only if it has no `priority` left either — otherwise keep it for the scan-cache data.

Write and read back `.helm/test-log.json` using the shared project-state procedure. Under the existing commit policy, retire only verified same-file legacy sources after commit authorization and stage the canonical file and tracked legacy removals together using explicit paths. Commit: `test(log): update test ledger after {catch-up / full-scan}`. If this ledger commit is declined or fails, preserve any canonical draft and remaining legacy sources, report any staged legacy removals, stay on the current branch, and go directly to Step 8 with the migration/checkpoint pending. Declining approval leaves legacy sources intact under the shared procedure. Do not enter Step 7, even if test commits were made earlier.

---

## Step 7 — Merge and cleanup

Before any finalization, check for declined/failed commits, incomplete state writes, pending drafts, and a clean index/working tree. Pending work goes directly to Step 8 on the current branch: no merge, rebase, push, promotion, deletion, or checkout. Never reset, stash, or silently commit drafts to pass this gate.

Only a genuine no-op with no writes, no commits, and no pending work uses empty-branch cleanup: under GitHub Flow, switch safely to `{original_branch}` and delete this run's empty `{branch}` with `git branch -d`; under Solo, no cleanup is needed. Then report in Step 8. Solo otherwise has no integration merge, since its commits already landed on main/master.

**Solo Mode:** before pushing, confirm — push always requires its own confirmation regardless of `git-auto-commit`, per git.md's Auto-Commit rule and rules/safety.md's unconditional push-confirmation requirement:

  AskUserQuestion:
    question: "Push main now? This publishes {N} commit(s) made this run to origin."
    header:   "Push"
    multiSelect: false
    options:
      - label: "Push (Recommended)"
        description: "git push origin main"
      - label: "Cancel"
        description: "Leave main committed locally but unpushed — push manually when ready"

If Cancel selected → stop here. Do not push or promote. Proceed to Step 8 to report the outcome, noting main is committed locally but unpushed.

If Push selected: `git push origin main`, then run Environment promotion below.

**GitHub Flow:**
1. Before integration, re-read the effective merge strategy and project review requirements on the destination. Resolve any configuration change before mutation. State "Squash merge", "Rebase merge", or "Merge commit". Honor required PR review and CI; if those requirements are unmet or unavailable, leave the committed branch for that review, report the exact handoff, and go to Step 8 without integrating, pushing, promoting, or deleting it. Do not treat command invocation or auto-commit as an exemption from project review rules.
2. When the project's requirements permit local integration, preview the full branch diff and obtain any required integration-commit approval under `git-auto-commit` before mutation. A decline follows the pending-work rule above. Use the resolved strategy, stopping on any conflict or failed command without continuing publication:
   - `merge`: `git checkout main`, then `git merge {branch} --no-ff -m "test(project): write tests {catch-up / full-scan}"`.
   - `squash` (default): `git checkout main`, then `git merge --squash {branch}`, and commit the reviewed result as `test(project): write tests {catch-up / full-scan}`. A failed commit leaves the actual index/branch pending for review.
   - `rebase`: only rebase this run's private, unpushed branch onto main, then integrate with `git checkout main` and `git merge --ff-only {branch}`. A shared/already-pushed branch requires an explicit reviewed plan instead of an implicit history rewrite; stop and report the handoff. Never force-push as cleanup.
   Verify integration succeeded and includes the committed test changes, canonical ledger, and any tracked legacy removals. Stored ledger IDs from before squash/rebase may cease to be ancestors; preserve their provenance and let Step 2 reassess invalidated comparisons on the next run instead of assigning uninspected SHAs. Before pushing, confirm:

   AskUserQuestion:
     question: "Push main now? This publishes the merged commit to origin."
     header:   "Push"
     multiSelect: false
     options:
       - label: "Push (Recommended)"
         description: "git push origin main"
       - label: "Cancel"
         description: "Leave main merged locally but unpushed — push manually when ready"

   If Cancel selected → stop here. Do not push, promote, or clean up. Proceed to Step 8 to report the outcome, noting main is merged locally but unpushed.

   If Push selected: `git push origin main`.
3. Run Environment promotion below.
4. Delete `{branch}` locally only after verifying its tip is an ancestor of main and `git branch -d {branch}` succeeds. Squash can leave its commits outside main's ancestry; in that case retain the branch and report it, never substitute `-D` without explicit deletion approval. Any remote branch deletion requires its own push confirmation.
5. Return to `{original_branch}` only when safe and no work is pending; otherwise report the actual branch and retained work.

**Environment promotion** — shared by both modes. If environment branches exist (discover via `git branch -r`, filter for known environment names, same detection as ship.md), ask which should also receive these tests. (This block is intentionally duplicated across every content-sync command — see rules/git.md's Environment Branches section for the canonical shape; keep all copies in sync if it changes.)

  AskUserQuestion:
    question: "main has been updated. Which environment branches should also receive these tests?"
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
      question: "main has been updated. Promote to {branch} as well?"
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
  - git merge main --no-ff -m "chore(deploy): promote main to {environment} for test updates"
  - git push origin {environment}
  - git checkout main

  If no environment branches exist, or the user selects none, skip silently.

---

## Step 8 — Confirm completion

Report:

- Outcome: {up to date / catch up written / full scan written / skipped / pending / blocked}
- Mode: {Catch Up / Full Scan / N/A}
- Tests written: {N} test cases ({M} files), covering {list of files or clusters} — {N} counts individual test blocks (`it`/`test`, or the framework's equivalent), not files or clusters, so real volume is visible without needing to grep for it
- Commits made: {N}
- Tests passing: {yes/no, or N/A if nothing was run}
- Ledger: {N} skipped-by-user, {N} ambiguous, {N} resolved this run; loaded path(s), canonical destination, checkpoint/commit status, and migration status
- Comparison validity: {validated baseline / Full Scan required and why}; any stale judgments or skip decisions reassessed without erasing user history
- Pending work: {files and remaining action, or none}; distinguish verified commits from drafts and an uncommitted checkpoint
- Pushed: {yes / no — push manually when ready / N/A, nothing committed}
- Environments promoted: {list or none}
- If GitHub Flow: effective merge strategy and temporary branch's fate ({merged and deleted / retained after squash / awaiting review / pending work}) and which branch you were returned to.
