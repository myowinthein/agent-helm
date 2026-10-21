# refactor

Full project scan to identify and apply refactoring opportunities.
Run periodically on mature codebases to maintain code quality.

---

## Before starting

Apply the shared runtime and resolve `{memory_file}` before Git actions. Read `git-strategy` (default: GitHub Flow), `git-auto-commit` (default: false), and GitHub Flow's `git-merge-strategy` (default: squash) from the effective owner, following bridges, overrides, and recognized fenced configuration. State the effective Git mode. Refactor always uses a `refactor/*` branch and offers PR/Leave choices even under Solo Mode, per git.md's documented exception; this does not waive review, commit, push, or deployment requirements. This workflow does not create, move, or edit Helm configuration or instruction-entry ownership in AGENTS.md or CLAUDE.md.

Require a repository with HEAD and available Git/filesystem capabilities. Record the invocation branch. Before switching branches, require a clean index/working tree; pending drafts require explicit reconciliation on their current branch first. Never reset, stash, or commit user work to make the workflow proceed. Resolve `{base_branch}` to the project's main/master branch before creating a new refactor branch or planning integration; stop if its identity is ambiguous.

Proceed if on main, master, or an existing refactor/* branch — resuming a session left via Step 7's "Leave branch" option happens directly from that branch, not via a manual switch back to main first.

If on any other branch, stop and inform user:

"refactor must be run on main, master, or an existing refactor branch.
Current branch is {branch}. Please switch and re-run."

---

## Step 1 — Select the refactor branch before loading history

Run `git branch --list 'refactor/*'` and choose the working branch before loading any ledger, recommending a mode, or computing a diff. Use the exact existing branch name as `{branch}` throughout this run, including resuming a branch whose timestamp differs from today. Use a run timestamp only for messages/reporting, never to reconstruct an existing branch name.

- One existing branch: ask whether to continue on it or create a new branch, with those two choices.
- Multiple existing branches: ask which exact branch to continue on or whether to create a new one. Never silently choose the first match. A picker may offer up to three existing branches plus Create new; show remaining names for a free-text selection, respecting the shared runtime's option limits.
- No existing branch: create a new branch from `{base_branch}`.

For a new branch, switch to `{base_branch}` first and create `refactor/{YYYYMMDD-HHMMSS}` from there, never from an old refactor branch. Verify the new name is unused. For continuation, switch to the selected existing branch, or stay if already on it. Record whether this invocation created the branch, and verify the actual branch and HEAD after each switch.

On the selected branch, re-read active instructions and resolve `{memory_file}` and effective configuration again. Resolve conflicting policy before continuing; do not carry settings from another branch or silently rewrite them. Only then run Steps 2 and 3, loading that branch's canonical and legacy state. An unexpected branch/history change invalidates the loaded ledger, changed-file list, and mode recommendation: repeat resolution and assessment before dependent work, including on a fresh host/session. Never transplant an old branch's findings into a fresh branch.

---

## Step 2 — Scan boundaries

Scan all project files except:
- vendor/
- node_modules/
- public/
- storage/
- __pycache__/, .venv/, dist/, build/  (Python)
- tmp/, log/                            (Ruby)
- bin/                                  (Go)
- migration files
- .env files
- generated or compiled files
- .helm/ and .claude/helm/ (operational state, never source code)
- .claude/refactor-log.json, .claude/test-log.json, .claude/normalize-log.json, .claude/legal-manifest.json (flat legacy state)

Include test files — test quality degrades fastest and matters most.

---

## Step 3 — Load history and choose mode

### 3.1 Load the ledger

Verify the selected `{branch}` and capture its HEAD as `{scan_head}` before loading state, including first runs. Before recording Deep/Quick results, require that branch, HEAD, effective configuration, ledger inputs, and inspected source files still match the scan. Unexpected changes invalidate the result and require reassessment before any write; this does not invalidate verified commits/checkpoints made by this workflow later in Step 6.

Read `{package_root}/prompts/shared/project-state.md` and apply it to `refactor-log.json` for every load and write in this workflow. The canonical path is `.helm/refactor-log.json`; check both `.claude/helm/refactor-log.json` and `.claude/refactor-log.json` too. Validate and compare all existing candidates, resolving differing histories explicitly before using them. A legacy-only file is loaded without moving it during inspection; migration waits for the next successful authorized ledger write (Step 4A.8, 4B.5, or a later checkpoint). No candidate means first run.

Schema:
```json
{
  "schema_version": 1,
  "last_scanned_commit": "abc1234",
  "last_mode": "deep",
  "last_scan_date": "2026-06-01",
  "consecutive_quick_count": 0,
  "findings": [
    {
      "id": "f-0012",
      "category": "architecture",
      "priority": "high",
      "risk": "needs-review",
      "cluster_id": "c-004",
      "depends_on": [],
      "file": "app/Http/Controllers/OrderController.php",
      "line": 42,
      "related_files": [],
      "description": "Business logic embedded in controller action",
      "status": "open",
      "first_found_commit": "9f1a2bc",
      "first_found_date": "2026-05-01",
      "resolved_commit": null,
      "resolved_date": null
    }
  ]
}
```

`schema_version` — bumped only if this ledger's structure changes in a future release. Lets a future version of this command detect an older-shaped file and handle it explicitly instead of misreading it. Treat a missing `schema_version` as `1` (every ledger written before this field existed). Always write it going forward.

`status` values: `open`, `fixed`, `skipped-by-user`, `auto-resolved`.

`risk` values:
- `safe` — mechanical, low-ambiguity fix (rename, dead code removal, add missing index, deduplicate identical blocks). Safe to auto-apply.
- `needs-review` — requires judgment about business intent (e.g. an N+1 fix that depends on what the query is actually for). Must be confirmed with the user before touching code. Every `consistency` finding (Step 4A.5) is always `needs-review`, never `safe` — deciding whether a missing connection is intentional or a real gap requires product judgment.

`related_files` — other files implicated by this finding beyond the primary `file`/`line` anchor. Empty for the five per-file categories, which are single-file by construction. A `consistency` finding is inherently multi-file, so it always sets this: `file`/`line` anchors the primary site (e.g. where the state change happens), `related_files` lists the other implicated file(s) (e.g. the missing consumer, or the asymmetrically-handled counterpart) as plain path strings — no per-entry line, since only the primary anchor's line drifts and needs re-verification (see Quick Mode 4B.2). Treat a missing `related_files` as `[]` (every finding written before this field existed).

`cluster_id` — findings that touch the same file, or files with a direct dependency (e.g. controller + its service), share a cluster id. All findings in a cluster are applied together by a single agent — never split across parallel sub-agents, to avoid conflicting edits.

`depends_on` — list of finding ids that must be applied before this one (e.g. "extract shared helper" must land before "deduplicate the 3 call sites that use it").

`consecutive_quick_count` — number of consecutive Quick Mode scans since the last Deep Mode scan. Increment by 1 each time Quick Mode runs; reset to 0 when Deep Mode runs.

### 3.2 First run — no ledger found

If no candidate ledger path from 3.1 has a file, this is the first run. Do not ask which mode to use.
Inform user:

"No refactor history found — running Deep Mode to build a baseline."

Proceed to Step 4, Deep Mode, on the branch selected in Step 1.

### 3.3 Later runs — ledger found

Count `open_count` from the selected branch's `status: open` findings. Use the inspected `{scan_head}` recorded in Step 3.1. Before comparisons, validate `last_scanned_commit`: accept a commit ID only, resolve it to an existing commit object, and verify it is an ancestor of `{scan_head}`. Never interpret a saved value as a shell argument or arbitrary revision expression. A syntactically plausible SHA alone is insufficient.

If the baseline is missing, unavailable, or outside this branch's ancestry, explain why incremental scope is unavailable. Offer **Deep Mode**, **Fix Backlog** only if open findings exist, and **Cancel**; do not offer Quick Mode or substitute `HEAD~1`. Fix Backlog still requires Step 6.2's targeted checks. Cancel writes/migrates nothing; clean up only an empty branch created by this invocation when safe, never an existing session branch. Keep prior findings and watermark intact until a successful new scan replaces scan metadata. After a mode choice go directly to Step 4, or Step 8 on Cancel; skip the valid-baseline comparisons/recommendation below.

With a valid baseline, compute:
- number of commits since `last_scanned_commit` on this branch
- number of days since `last_scan_date`
- `open_count`: findings with `status: open`
- changed files: `git diff --name-only {last_scanned_commit}..{scan_head}`, respecting Step 2 exclusions; retain this list for Quick Mode

Check every comparison's exit status. A failed command is not zero changes or a reason to recommend Fix Backlog; stop dependent work and report it without advancing state. If HEAD changes unexpectedly before the scan completes, discard the stale scope and reassess. Historical `first_found_commit`/`resolved_commit` values remain provenance even when no longer reachable; do not replace them with current HEAD to make validation pass.

Decide which mode to recommend using this logic:
- If `open_count > 0` AND zero commits since `last_scanned_commit`: recommend **Fix Backlog** — there's nothing new to scan for.
- Otherwise recommend **Deep Mode** if: 40+ commits since last scan, OR 60+ days since last scan, OR `consecutive_quick_count` is 2 or more, OR more than 50 files changed. Commit count is a weak proxy for diff size — a handful of commits can still touch hundreds of files (a dependency bump, a mass rename) — so the real changed-file count overrides it here.
- Otherwise recommend **Quick Mode**.

Ask with AskUserQuestion, filling in the reason in the description.
Only include the Fix Backlog option if `open_count > 0`:

  AskUserQuestion:
    question: "Which scan mode would you like to run?"
    header:   "Scan mode"
    multiSelect: false
    options:
      - label: "Deep Mode{recommended tag if applicable}"
        description: "Full codebase re-scan using multiple agents. {reason, e.g. '158 files changed since last scan — too broad for a focused check.'}"
      - label: "Quick Mode{recommended tag if applicable}"
        description: "Only checks files changed since the last scan, plus re-validates past findings. {reason, e.g. 'Only 8 commits and 12 files changed since last scan — a quick check should cover it.'}"
      - label: "Fix Backlog{recommended tag if applicable}"  (only include if open_count > 0)
        description: "Skip scanning — {open_count} known issues waiting to be fixed. {reason if recommended, e.g. 'No new commits since last scan.'}"

With a valid baseline and unchanged branch inputs, the recommendation is a suggestion: Quick Mode remains available even when Deep Mode is recommended for size or age. Baseline validity is a prerequisite, not an optional recommendation.

After the user confirms a mode, proceed to Step 4 on the already-selected branch.

---

## Step 4 — Scan

### 4A. Deep Mode

1. List all project files within scan boundaries (Step 2). Group them by folder/module rather than raw line count, so related code (e.g. a controller and its service layer) stays in the same chunk — this avoids missing issues that span two files in different chunks.
2. Estimate a comfortable read budget per sub-agent, and compute how many chunks/sub-agents are needed based on total project size. Cap at 8 sub-agents maximum — if more chunks are needed, merge the smallest adjacent folders until within the cap.
3. Use available read-only workers per chunk within the host's actual concurrency limit, queueing chunks or scanning sequentially with the same complete coverage when delegation is unavailable; report that fallback. On Codex the parent owns all code, Git, and ledger writes. Each sub-agent reads its full chunk once and checks the five per-file categories in that single pass (architecture, code quality, performance, tests, dependencies) — do not run a second category-only pass over the same files; that doubles cost for no real benefit. Consistency is not part of this per-chunk pass — see step 5 below (Step 4A.5).
   - **Tests** findings are about existing test *code quality*, never about missing coverage — detecting and writing tests for untested code is `/helm:test`'s job exclusively; never create a finding here just because a file lacks tests. Flag 3+ test cases in a file that share the same input → assertion shape (e.g. one expected output per entry in a dictionary or lookup table) and could collapse into a single parametrized test (`it.each`/table-driven, per the framework's convention) with zero coverage loss.
4. Each sub-agent returns structured findings: category, priority, file, line, description.
5. Consistency pass — run once, separately from the per-chunk scans above. This category looks for gaps *between* features rather than problems *within* one file, so a single chunk-scoped sub-agent can't see it by design — it only has visibility into its own folder.
   - Build a short list of the codebase's key persisted or externally-synced state (anywhere data is written to local storage, a database, or pushed to an external service) and the features that conceptually depend on or should react to each — sync, cache invalidation, notifications, derived-data recomputation, audit logging.
   - For each, trace every site that writes or changes that state, and check whether the reactions it should trigger are wired up consistently at *all* of them, not just the primary/obvious code path. A missing connection — state changes but nothing downstream reacts — is a finding.
   - Separately, look for asymmetric treatment: two structurally similar or clearly-related pieces of data or features handled with meaningfully different rigor within the same flow (e.g. one gets conflict review before being overwritten, a directly related one is silently replaced wholesale).
   - Record each finding with `file`/`line` anchored to the primary site (the state change, or the more-rigorously-handled counterpart in an asymmetry finding) and `related_files` listing the other implicated file(s) (the missing consumer, or the less-rigorously-handled counterpart) — see the `related_files` field note in Step 3.1.
   - This needs codebase-wide visibility, not folder-chunk visibility. Scope any sub-agents used for this pass by feature or data flow instead ("everything that touches the user's saved profile"), sized within the same capacity budget as step 2 above. On a small-to-medium codebase the main agent can often do this pass itself instead of spawning sub-agents for it.
   - Every finding from this pass is `category: consistency` and always `risk: needs-review` (see the risk values note in Step 3.1) — never auto-applied.
6. Main agent consolidation:
   - Merge all sub-agent reports, including the consistency pass's findings.
   - Look across chunk boundaries for cross-cutting issues (e.g. the same duplicated pattern appearing in two different chunks) that individual sub-agents couldn't see on their own.
   - Cross-check against the ledger's existing `open` findings — do not duplicate an entry that already exists; keep it as-is.
   - Any `open` ledger entry whose file no longer exists, or has been rewritten enough that the finding no longer applies, gets marked `auto-resolved`.
   - Any genuinely new issue gets added as a new `open` entry.
   - Assign `risk` (`safe` or `needs-review`) to every new finding.
   - Group findings that touch the same or directly-related files into a shared `cluster_id`.
   - Where one finding's fix is a precondition for another (e.g. extract-before-dedupe), record it in `depends_on`.
7. Update the ledger: set `schema_version` to `1` if not already present, set `last_scanned_commit` to the verified `{scan_head}`, `last_mode` to `deep`, `last_scan_date` to today, reset `consecutive_quick_count` to 0, and save the merged findings list.
8. Write and read back `.helm/refactor-log.json` using the shared project-state procedure. Honor the existing commit policy, retire only verified same-file legacy sources after commit authorization, and stage the canonical file plus tracked legacy removals together with explicit paths. Commit: `chore(refactor): update ledger after deep scan`. If approval is declined or the write/commit fails, follow the Checkpoint and pending-work rules: stay on this branch and report pending state in Step 8, without applying findings or entering Step 7.

### 4B. Quick Mode

1. Reuse Step 3.3's changed-file list only while `{branch}`, `{scan_head}`, configuration, and loaded ledger inputs still match the assessment. A branch/history/input change requires fresh resolution and scope calculation. An invalid baseline cannot enter Quick Mode; offer Deep Mode or a validated backlog instead. No additional size restriction is introduced.
2. Re-validate every `open` ledger entry, `consistency` findings included. This step only ever looks at the primary `file`/`line` anchor and, for findings that have them, `related_files` — never at the fix content itself:
   - Primary `file` deleted or heavily rewritten → mark `auto-resolved` (the finding's anchor is gone, regardless of what `related_files` says).
   - Primary `file` untouched and, if present, every path in `related_files` also untouched (none in the changed-file list) → carry forward unchanged, still `open`.
   - Primary `file` touched but not heavily rewritten (the common case — a few unrelated lines added or removed elsewhere in the file): re-verify the finding's pattern still exists near its recorded `line`, and update `line` to its current position before carrying the finding forward as `open`. A stale line number left unchecked here is a real risk, not just noise — `risk: safe` findings get auto-applied with no human review in Step 6.2, so an unverified line pointing at the wrong code could silently apply a fix to unrelated lines. (This does not apply to `consistency` findings, which are always `needs-review`, never `safe` — see Step 3.1 — so there is no auto-apply risk from a stale line on those, but still refresh it for report accuracy.)
   - Primary `file` untouched but one or more `related_files` entries were touched: re-check that entry specifically — if that related file was deleted, drop it from `related_files` (auto-resolve the whole finding only if that was the last remaining related file); if it still exists, carry the finding forward unchanged. `related_files` entries don't carry a `line`, so there is nothing to refresh on them beyond existence.
3. Scan only the changed files (single thread, no sub-agents needed) across the five per-chunk categories for new issues (architecture, code quality, performance, tests, dependencies). Before adding any finding, cross-check it against the ledger's existing `open` findings for that same file — if it matches one already there, do not create a duplicate, just leave the existing entry as-is. Only genuinely new issues get added. Assign `risk`, `cluster_id`, and `depends_on` to any new findings the same way Deep Mode does. Do not scan for *new* consistency findings here — that requires the whole-codebase, cross-feature visibility only Deep Mode's dedicated pass (Step 4A.5) provides; a changed-files-only scan structurally can't see a missing connection to a file that didn't change.
4. Update the ledger: set `schema_version` to `1` if not already present. Add new findings as `open`, keep carried-forward entries as-is, mark auto-resolved ones. Set `last_scanned_commit` to the verified `{scan_head}`, `last_mode` to `quick`, `last_scan_date` to today, increment `consecutive_quick_count` by 1.
5. Write and read back `.helm/refactor-log.json` using the shared project-state procedure. Honor the existing commit policy, retire only verified same-file legacy sources after commit authorization, and stage the canonical file plus tracked legacy removals together with explicit paths. Commit: `chore(refactor): update ledger after quick scan`. If approval is declined or the write/commit fails, follow the Checkpoint and pending-work rules: stay on this branch and report pending state in Step 8, without applying findings or entering Step 7.

### 4C. Fix Backlog

1. Skip discovery of new findings: no project-wide scan or changed-file discovery. Targeted reads of selected findings and their dependencies are still required by Step 6.2 before any edit; skipping a scan never authorizes applying stale anchors.
2. Load every finding from the ledger with `status: open`. These are the only items in scope this run.
3. Do not modify `last_scanned_commit`, `last_mode`, `last_scan_date`, or `consecutive_quick_count` — no scan happened, so this run leaves scan metadata untouched.
4. Proceed directly to Step 5 using only this open-findings list.

---

## Step 5 — Present findings

If this run used Fix Backlog mode, no scan occurred, so the report only ever shows the Still Open section — omit New and Auto-Resolved from the summary counts and category breakdowns entirely, and label the report header `REFACTORING REPORT (mode: Fix Backlog — no scan performed)`.

Otherwise, group by category, prioritize within each. Split into three sections so the user can see real progress instead of a flat repeated list:

- **New** — found for the first time this run
- **Still Open** — found in a previous run, not yet fixed, still valid
- **Auto-Resolved** — found in a previous run, file since deleted/rewritten, no longer applicable

Priority levels:
- High   — architectural issues, security concerns, major code smells
- Medium — redundant code, missing abstractions, inconsistent patterns
- Low    — minor improvements, style inconsistencies, small optimizations

Present in this format:

─────────────────────────────────
REFACTORING REPORT   (mode: {Deep/Quick})
─────────────────────────────────
NEW                    {X issues}
STILL OPEN             {X issues carried over}
AUTO-RESOLVED          {X issues closed automatically}
─────────────────────────────────

ARCHITECTURE          {X issues — High: N, Medium: N, Low: N}
─────────────────────────────────
[New][High][Safe] Brief description
      File: path/to/file.php
      Why: one sentence explanation

[Still Open][Medium][Needs Review] ...

CONSISTENCY           {X issues — High: N, Medium: N, Low: N}
─────────────────────────────────
[New][High][Needs Review] Brief description of the missing connection or asymmetry
      Files: path/to/writer.php, path/to/expected-consumer.php
      Why: one sentence explanation of what should happen and doesn't

CODE QUALITY          {X issues — High: N, Medium: N, Low: N}
─────────────────────────────────
...

PERFORMANCE           {X issues}
─────────────────────────────────
...

TESTS                 {X issues}
─────────────────────────────────
...

DEPENDENCIES          {X issues}
─────────────────────────────────
...

─────────────────────────────────
TOTAL: {N} issues found ({N} new, {N} still open)
─────────────────────────────────

Then present category selection. First determine how many of the 6 categories (Architecture, Consistency, Code Quality, Performance, Tests, Dependencies) have at least one `new` or `still open` finding:

If zero categories qualify (TOTAL is 0): nothing to apply. Inform the user "No refactoring findings this run." and proceed directly to Step 7 (Merge and cleanup) — there is nothing to select or apply.

If exactly one category qualifies, a multi-select with a single option isn't valid — AskUserQuestion requires at least 2. Ask directly instead:

  AskUserQuestion:
    question: "Apply the {N} {category} finding(s)?"
    header:   "Apply category"
    multiSelect: false
    options:
      - label: "Yes (Recommended)"
        description: "{N} issues: {one-line summary}"
      - label: "Skip"
        description: "Leave these findings open, don't change this code"

  "Yes" is equivalent to selecting that category in the multi-select below — proceed the same way.

Otherwise (2 or more categories qualify), present multi-select category selection using the AskUserQuestion tool:

  Question:    "Which categories to apply?"
  multiSelect: true
  Options: one entry per qualifying category — "{N} issues: {one-line summary}"

  AskUserQuestion caps at 4 options. If more than 4 categories qualify, merge the smallest two into one option (e.g. "Tests & Dependencies") — repeat until at or under 4.

  Selecting no options = skip. Do not add an explicit All or Skip option.

Wait for response before proceeding.

---

## Checkpoint and pending-work rules

Apply these rules to every scan, cluster, verification, and integration commit, including when `git-auto-commit` is off. The shared project-state procedure governs every ledger write, read-back, migration, and commit. Preserve append-only findings history, IDs, and unknown fields; update statuses without rebuilding the array from only open findings.

A declined commit, failed commit/write/read-back, or incomplete checkpoint stops subsequent edits, wave handoffs, and finalization. Preserve the current branch, drafted files, existing verified commits, verified canonical state, and remaining legacy sources; report any staged removals. Go directly to Step 8 with pending/blocked status. Do not merge, rebase, push, promote, delete branches, or switch back, even if earlier clusters were committed. Declining migration commit approval leaves legacy sources intact. Never silently commit, reset, or stash drafts to pass a gate.

After each successful ledger checkpoint, verify its commit and refresh the recorded state snapshots before another write. Only a durable checkpoint may be described as complete or handed to another session. If code committed but its ledger commit failed, report those two states separately and reconcile them before resuming; do not apply the same fix again from an old open status.

## Step 6 — Apply refactoring

Apply selected categories one at a time. Complete steps 6.1–6.4 fully for each category before starting the next. Do not batch changes from multiple categories into a single commit.

### 6.1 Plan waves within capacity

- Take all findings in this category, grouped into their clusters.
- Estimate how many clusters one agent session can safely handle without running low on context (rough budget based on total diff size expected, similar to the capacity math used for Deep Mode chunking).
- If the category's clusters fit within that budget, it's a single wave. If not, split into sequential waves — each wave a bounded batch of clusters, still processed one at a time, never in parallel.
- Sort clusters by `depends_on` across the whole category first, then assign to waves in that order, so a cluster never lands in an earlier wave than something it depends on.

### 6.2 Apply one cluster at a time

Work through the current wave's clusters one at a time, in order. For each cluster:

- Verify the expected branch and checkpoint before reading its selected findings. Re-read their current primary files and relevant `related_files`, locate each actual issue by its pattern/context rather than its saved line alone, refresh anchors, and confirm dependencies and the proposed edit still apply. Do this in all modes, including Fix Backlog and fresh-session resumes; earlier clusters can move lines too. Respect Step 2 exclusions and project containment.
- If a finding's file/issue is verified gone, mark it `auto-resolved` without applying a fix. An issue whose current identity/location is unclear stays open pending clarification; never guess a replacement site. Reassess risk on current code; missing or obsolete legacy risk labels do not imply `safe`. Keep every consistency finding `needs-review`. These targeted checks are not a new scan and do not advance scan metadata in Fix Backlog.
- Apply every finding tagged `risk: safe` in the cluster, in dependency order. No need to pause for user input on these.
- For any `risk: needs-review` finding in the cluster, confirm with the user before touching code:

  AskUserQuestion:
    question: "This fix needs a judgment call: {finding description}. Apply it or skip it?"
    header:   "Needs review"
    multiSelect: false
    options:
      - label: "Apply as suggested"
        description: "{brief description of the fix}"
      - label: "Skip"
        description: "Leave this finding open, don't change this code"

  If skipped, this finding's ledger `status` becomes `skipped-by-user` (not `open`), so it stops resurfacing every run. Only re-surface it later if the surrounding code changes enough that the original suggestion may no longer apply.

- Once the cluster's edits are complete: run tests — stop and inform if tests fail, do not move to the next cluster until resolved. Run lint and formatter.
- Infer the commit scope from this cluster's files per git.md's Scope inference convention — not this command's six-category taxonomy (architecture/consistency/quality/performance/tests/dependencies), which is a report and selection grouping, not a commit scope.
- Commit actual tested code changes under the resolved commit policy:
  refactor({scope}): {brief summary of this cluster's changes}
  A declined or failed commit follows the pending-work rule; do not mark those changes fixed or continue to the next cluster.
- Update the ledger for this cluster: actual fixes become `fixed` with the verified code commit in `resolved_commit`; skips become `skipped-by-user` with their decision-context commit/date; confirmed absent issues become `auto-resolved`. A cluster containing only skips/auto-resolutions needs no empty code commit and must not claim a code fix.
- Persist and read back `.helm/refactor-log.json` using the shared state procedure, preserving all earlier records. Commit the checkpoint under `git-auto-commit` as `chore(refactor): checkpoint cluster {cluster_id}`, including any verified tracked legacy removals in that ledger commit. Verify it before continuing. A declined/failed ledger commit stops here with the exact pending state.

This is the checkpoint: each cluster is fully tested, committed, and recorded in the ledger before moving to the next one. If the agent stops for any reason after this point, nothing already committed is lost or ambiguous.

### 6.3 Wave handoff

- When the current wave's clusters are all done, check whether clusters remain in this category.
- If none remain, the category is complete — proceed to 6.4.
- If clusters remain, report progress plainly: "Wave {N} complete: clusters {list} fixed. {N} clusters remaining in this category." In Claude, continue with a fresh agent session when the host supports it; that session reloads the runtime, current instructions/configuration, exact `{branch}`, and the verified ledger checkpoint before picking up remaining work. Supply selected finding/cluster IDs, dependency order, approvals already given, and the remaining scope in the handoff; do not infer approval to apply every open finding from the ledger alone. In Codex, the parent continues the next wave sequentially and remains the only code/Git/ledger writer. If a fresh session is unavailable, continue from the ledger in the current session or report the exact resume point; never claim a handoff that did not happen.
- If capacity runs out mid-wave, stop only at the nearest completed cluster boundary — never leave a cluster half-edited. Report the same way as above and hand the remainder to the next wave.

This replaces "silently completes a few and reports the rest at the end" with "always commits what's done, always states clearly what's left, and always continues from an accurate ledger."

For any finding in this category the user did not select at the category level (Step 5), leave its ledger `status` as `open`.

Example commits:
  refactor(orders): extract business logic from controller
  refactor(auth): remove duplicate helper methods
  refactor(checkout): update outdated assertions

### 6.4 Scoped verification pass

After the current category's clusters and checkpoints have been verified, run one lightweight check — reusing the Quick Mode mechanics (Step 4B), but scoped only to the files touched during this Step 6, not the whole repo:

- Re-check each `fixed` finding's file to confirm the issue is actually gone, not just that an edit was made.
- Scan the same touched files once more for anything new the fixes themselves may have introduced.
- Update the ledger accordingly: confirmed fixes stay `fixed`; anything not actually resolved reverts to `open` with a note; any newly introduced issue is appended as a new `open` finding. Persist, read back, and commit any changed verification state through the shared procedure as `chore(refactor): record scoped verification`, under the existing commit policy. No changed data means no extra write. A declined/failed checkpoint goes directly to Step 8, never finalization.

This step is cheap — it only covers files already touched this session, not a fresh full scan — and it's what tells the user honestly whether this run's fixes fully landed or quietly created new small issues.

---

## Step 7 — Merge and cleanup

Before offering finalization, require all code and ledger checkpoints committed/verified, no pending drafts or staged changes, passing applicable local checks, and the expected branch. Incomplete work follows the pending-work rules and goes directly to Step 8. A completed scan may have committed its ledger even when no categories were selected; report that accurately. A genuine no-op writes/migrates nothing and may remove only an empty branch created by this invocation, after a safe switch back; never delete a resumed session branch as cleanup.

Offer the same three choices in both Git modes:

  AskUserQuestion:
    question: "{Refactoring/checkpoint outcome}. What would you like to do next?"
    header:   "Next step"
    multiSelect: false
    options:
      - label: "Merge to {base_branch}"
        description: "Integrate only when configured review and CI requirements are satisfied; push is confirmed separately"
      - label: "Open PR"
        description: "Publish this committed branch with push confirmation, then attempt a PR or provide manual instructions"
      - label: "Leave branch"
        description: "Keep the committed refactor branch locally for review or continuation"

Wait for the user's choice. Resolve required CI access and project review policy before attempting integration. Native CLI/tool approvals do not bypass the workflow gates.

### Required CI gate

Read `{package_root}/prompts/shared/ci.md` and apply its **integration** gate to the exact reviewed tip and **promotion** gate to the exact published source SHA. GitHub Flow retains its PR and configured pre-merge CI policy. In Solo, CI merely existing does not make unpublished-branch remote results mandatory: when no project/provider policy requires pre-integration remote CI, passing applicable local checks permits local integration. The published-base CI gate before promotion remains mandatory when CI applies.

If remote CI is explicitly required for this integration but the branch is unpublished, offer `Publish branch for required checks` or `Leave integration pending`, describing the exact push and preserving its own confirmation. Publishing solely for checks does not require creating a PR in Solo. Verify remote SHA and applicable results; pipeline trigger filters may still leave the gate unavailable. Required remote checks never become optional or satisfied by local tests. An unavailable/failed/pending gate leaves this branch intact for wait/recheck or manual review, without integration, promotion or cleanup.

### Option 1 — Integrate

1. Read the destination's effective configuration and compare it with the invocation policy before mutation. Resolve any conflict; preserve AGENTS.md/CLAUDE.md ownership and settings. Under GitHub Flow, require its PR/review requirements and the pre-integration CI gate to be satisfied. If they are unmet or cannot be checked, retain `{branch}`, report the review/CI handoff, and go to Step 8; never treat this menu choice or auto-commit as a review exemption. Solo retains its documented refactor branch exception and does not acquire a mandatory PR.
2. Under GitHub Flow, state and use `git-merge-strategy` from the resolved owner (default: squash). Under Solo, use the existing merge-commit behavior unless an explicit project integration instruction says otherwise. Preview the full branch diff and obtain any required integration-commit approval under `git-auto-commit` before mutation. Apply the required CI gate in either mode when applicable. Use the actual selected `{branch}`, not a reconstructed timestamp:
   - `merge`: switch to `{base_branch}`, then `git merge {branch} --no-ff -m "refactor(project): apply refactoring {timestamp}"`.
   - `squash`: switch to `{base_branch}`, run `git merge --squash {branch}`, then commit the approved result as `refactor(project): apply refactoring {timestamp}`.
   - `rebase`: rebase only a private, unpushed branch belonging to this session onto `{base_branch}`, then switch to `{base_branch}` and integrate with `git merge --ff-only {branch}`. A shared/already-pushed branch requires an explicit reviewed rewrite plan instead; leave it intact and report that handoff. Never force-push implicitly.
3. Stop on any conflict or failed command/commit with the actual current branch/index preserved. Verify successful integration includes the code changes, canonical ledger checkpoints, and tracked legacy removals. Preserve saved SHA provenance after squash/rebase; Step 3 validates it next time instead of assigning an uninspected SHA.
4. Ask separately before `git push origin {base_branch}`, regardless of auto-commit. Explain the exact branch/commits being published. A decline or push failure ends finalization: no promotion/deletion, report local integration and retained branch in Step 8. If the push succeeds, freeze its exact SHA for the post-push CI gate.
5. If environments qualify, apply the required CI gate to that published SHA **before** asking which environments to promote. Only a passed/not-applicable gate reaches the picker below. No qualifying environments means no promotion action to gate. Keep this refactor content sync's existing fan-out behavior.

   AskUserQuestion:
     question: "{base_branch} has been updated. Which environments should receive this refactor? CI: {passed for exact SHA / not applicable}"
     header:   "Promote to environments"
     multiSelect: true
     options: one per qualifying environment, for example:
       - label: "staging"
         description: "Merge {base_branch} into staging and push"
       - label: "production"
         description: "Merge {base_branch} into production and push"

   Cap at four options, with staging/stage/uat/preprod first, then production/prod, then other names alphabetically. Disclose any remainder for a follow-up selection. For exactly one environment, use a two-option Yes/Skip question that explicitly describes merging and pushing. No selection means no environment changes. The selection authorizes only the described promotion/push targets; keep any separate project-required deployment gates.

   For each selected environment, recheck the base SHA and CI gate, switch safely, merge `{base_branch}` with `--no-ff` and `chore(deploy): promote {base_branch} to {environment} for refactor {timestamp}`, push only after successful merge, and return to `{base_branch}`. Stop on any failure; report completed and pending targets separately and do not continue cleanup on a failed promotion.
6. Delete the local `{branch}` only if its tip is an ancestor of `{base_branch}` and `git branch -d {branch}` succeeds. Squash may leave its commits outside the base ancestry; retain and report the branch rather than silently substituting `-D`. A remote branch is deleted only if it was pushed and its deletion receives its own push confirmation. Never delete an existing ref with pending or unverified work.

### Option 2 — PR

- Confirm the exact `git push origin {branch}` separately before publishing; selecting PR does not waive the push gate. A decline or failure leaves the local committed branch intact and reports its actual publication status in Step 8. Do not attempt PR creation on a failed push.
- After a successful push, identify the remote host. On GitHub, use an available authenticated PR interface or check `gh` availability/authentication/repository access before creating a PR against `{base_branch}`. On unsupported hosts or unavailable interfaces, give manual review instructions without claiming a PR exists. Do not change credentials or client settings automatically.
- The PR title is `refactor(project): apply refactoring {timestamp}`. Its body describes applied categories and points to `.helm/refactor-log.json`. Pass multiline content through a structured argument or a temporary `--body-file`; preserve literal content and newlines. If creation fails, report the actual failure and leave the published branch for manual review. If successful, report the returned URL and attach it to the current task when the host provides a PR attachment tool.
- PR creation does not merge, promote, or delete the branch. It preserves the configured integration/review policy for later review.

### Option 3 — Leave as-is

Report the exact `{branch}` and verified checkpoint left locally, with remaining finding/cluster IDs and pending review requirements. Do not claim an uncommitted checkpoint is durable.

---

## Step 8 — Confirm completion

Report:

─────────────────────────────────
REFACTORING RESULT
─────────────────────────────────
Branch:   {branch} (actual current branch: {current_branch})
Mode:     {Deep/Quick/Fix Backlog}
Scanned:  {new_count} new findings, {still_open_count} carried over, {auto_resolved_count} auto-resolved this run
Applied:
- Architecture: {N} changes
- Consistency:  {N} changes
- Code Quality: {N} changes
- Performance:  {N} changes
- Tests:        {N} changes
- Dependencies: {N} changes

Ledger:         {N} still open, {N} auto-resolved, {N} newly fixed, {N} skipped by user
Verification:   {N} fixes confirmed resolved, {N} newly introduced issues found
Commits made:   {N}
Tests passing:  yes/no/not run
Configuration:  {memory_file}; effective Git mode and integration strategy
State:          loaded paths; .helm/refactor-log.json; checkpoint commit and migration status
Baseline:       {validated / unusable and reason}; targeted backlog validation results
Pending:        {files, checkpoints, finding/cluster IDs, and required next action, or none}
CI:             {verified SHA/results / not applicable / blocked and reason}
Outcome:        {integrated and pushed / integrated locally but unpushed / PR pending / branch left intact / pending / blocked}; distinguish existing commits from drafts and report any partial promotion
─────────────────────────────────

Sample of fixes applied:
- {description} — {file}
- {description} — {file}
- ... (up to 5 examples, drawn from findings marked `fixed` this run)

For Fix Backlog mode, omit the Scanned line entirely — no scan occurred this run.
