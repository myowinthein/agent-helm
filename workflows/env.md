# env

Scan `.env` files, `.gitignore`, and source code to find and fix environment configuration issues.

## Before starting

Check `git-strategy` in {memory_file}'s Project Config (absence defaults to GitHub Flow, per git.md).

Before switching branches or writing files, check for pre-existing staged changes. If any exist, stop and ask the developer to commit or unstage them before re-running env. Do not commit, unstage, or overwrite their staged work as part of this workflow.

Read `{package_root}/prompts/shared/content-sync.md` and apply **Prepare the working branch** with `{branch_template} = chore/env-{YYYYMMDD}`. Use the recorded invocation policy, actual `{base_branch}` and unique `{branch}` throughout this run. Scan only after destination ownership/configuration has been revalidated. A no-write exit uses the shared safe empty-branch cleanup; pending drafts or commits retain their branch.

---

## Step 1 — Scan

Read-only. Do not modify anything in this step.

Scan all env files and source files completely before proceeding. Never stop early — a partial scan produces an incomplete report and missed findings will silently persist.

### 1.1 — Detect env files

Find all `.env*` files in the project. For each file found, infer its purpose from the filename and context. If purpose cannot be determined, label as unknown.

### 1.2 — Compare entries across env files

For each env file, extract all key names (ignore values).

Build a matrix of all keys across all files. Find mismatches:
- Keys present in one file but missing from others
- For each mismatch, note which files have the key and which don't

### 1.3 — Scan source code for env var references

Detect the project's language and framework, then scan source files for env var access patterns appropriate for the detected stack. Collect every unique key referenced in source code.

### 1.4 — Cross-reference code vs env files

Using findings from 1.2 and 1.3:

**Missing from env files:** Keys referenced in source code that do not appear in any env file (completely missing, not just missing from some). Keys missing from some but not all env files are covered by the Env sync check. These would silently fail or use undefined values at runtime.

**Never referenced in code:** Keys present in env files that do not appear anywhere in source code. These may be stale or only used at the infrastructure level — flag but do not auto-remove.

### 1.5 — Check secret vs placeholder correctness

Two complementary checks:

**`.env.example` — no real secrets allowed**
If no `.env.example` exists, skip this check silently.
Flag suspected real credentials, but report only file path, key name and credential type, with values omitted entirely. Never emit prefixes, suffixes, hashes, raw secret-bearing snippets/diffs, or token-bearing URLs. Inspect/filter locally before tool output reaches the conversation; if the host cannot do that safely, mark the affected inspection blocked rather than exposing values. This applies to every scan, preview, replacement plan and completion report below.

**All other env files — no placeholders allowed**
Flag any key whose value looks like an unfilled placeholder. These would cause silent failures at runtime.

### 1.6 — Scan for hardcoded values in source code

Scan source files for values that should be env vars. For each finding, suggest a descriptive env var name.

Exclude test fixtures, mock data, and constants that are genuinely environment-agnostic.

### 1.7 — Check env file formatting

Check each env file for formatting issues. Also check whether comment-based category groupings exist and whether all keys belong to the right group.

### 1.8 — Check for missing .gitignore entries

Detect the project's stack and check `.gitignore` for missing stack-appropriate entries.

### 1.9 — Check for tracked files matching .gitignore

Run `git ls-files` and cross-check against `.gitignore` patterns — flag any tracked file that matches, since gitignore will not protect already-tracked files.

### 1.10 — Check for entries that should not be ignored

Flag overly broad or harmful `.gitignore` entries (e.g. patterns that would exclude source files or committed application code).

### 1.11 — Check .gitignore formatting

Check `.gitignore` for formatting issues and whether comment-based category groupings exist.

---

## Step 2 — Report

Present all findings grouped by category. Use this format:

```
─────────────────────────────────
ENV AUDIT REPORT
─────────────────────────────────
ENV FILES FOUND
─────────────────────────────────
.env              local development
.env.example      onboarding template
.env.staging      staging deployment
.env.production   production deployment

─────────────────────────────────
ENV SYNC          {X issues}
─────────────────────────────────
KEY_NAME          missing from: .env.staging, .env.production
KEY_NAME          missing from: .env.production

─────────────────────────────────
MISSING FROM ENV  {X issues}
─────────────────────────────────
Keys referenced in code but not in any env file:
- KEY_NAME        src/config.js:14
- KEY_NAME        src/api/client.ts:8

─────────────────────────────────
NEVER REFERENCED  {X issues}
─────────────────────────────────
Keys in env files with no code reference (may be infrastructure-only):
- KEY_NAME        .env, .env.staging

─────────────────────────────────
SECRET/PLACEHOLDER ISSUES        {X found}
─────────────────────────────────
.env.example — real secrets found (should be placeholders):
- KEY_NAME        .env.example    API credential (value omitted)
- GITHUB_TOKEN    .env.example    access token (value omitted)

.env, .env.staging — placeholders found (should be real values):
- KEY_NAME        .env            your-key-here
- KEY_NAME        .env.staging    REPLACE_ME

─────────────────────────────────
HARDCODED VALUES  {X issues}
─────────────────────────────────
[High] API key hardcoded as string literal
      File: src/api/stripe.js:23
      Type: API credential (value omitted)
      Suggested env var: STRIPE_PUBLISHABLE_KEY

[Medium] Environment-specific URL hardcoded
      File: src/config.js:5
      Type: environment-specific URL (value omitted)
      Suggested env var: API_BASE_URL

─────────────────────────────────
ENV FORMATTING    {X issues}
─────────────────────────────────
.env:
- 2 duplicate keys
- Inconsistent spacing around = on 3 lines
.env.staging:
- Trailing whitespace on 1 line

─────────────────────────────────
GITIGNORE MISSING ENTRIES   {X issues}
─────────────────────────────────
node_modules/     (stack: Node.js)
.env.local
dist/

─────────────────────────────────
GITIGNORE TRACKED FILES     {X issues}
─────────────────────────────────
.env.local        already tracked by git — run git rm --cached .env.local to untrack

─────────────────────────────────
GITIGNORE ENTRIES TO REMOVE {X issues}
─────────────────────────────────
*.js              overly broad — would exclude source files
config/           matches committed application code — likely added by mistake

─────────────────────────────────
GITIGNORE FORMATTING        {X issues}
─────────────────────────────────
3 duplicate entries found
Missing category groupings

─────────────────────────────────
TOTAL: {N} issues across {N} categories
─────────────────────────────────
```

Then ask which targets to work through. Only two targets exist (Env files, .gitignore), so if only one has findings, a multi-select with a single option isn't valid — AskUserQuestion requires at least 2. Use whichever question shape matches how many targets actually have findings:

If both targets have findings:

AskUserQuestion:
  question: "Which findings would you like to work through?"
  header:   "Fix scope"
  multiSelect: true
  options:
    - label: "Env files"
      description: "All env-file findings: sync, missing keys, secrets/placeholders, hardcoded values, unreferenced keys, formatting"
    - label: ".gitignore"
      description: "All .gitignore findings: missing entries, tracked files, overly-broad entries, formatting"

If only one target has findings, skip this picker and ask directly whether to work through it:

AskUserQuestion:
  question: "Work through the {N} {target} finding(s)?"
  header:   "Fix scope"
  multiSelect: false
  options:
    - label: "Yes (Recommended)"
      description: "Walk through {target}'s findings"
    - label: "Skip"
      description: "Exit without changes"

  "Yes" is equivalent to selecting that target in the multi-select above — proceed the same way.

Selecting/confirming a target walks through each of its findings in Step 3 — every sub-flow shows what it found and asks, so you can skip any you do not want. Selecting neither (or Skip) exits without changes (the report above already lists everything).

Wait for response before proceeding.

---

## Step 3 — Apply fixes

### Commit boundary — applies to every sub-flow and commit

Environment edits and committable changes are separate. Keep `.env` and all other non-example `.env*` files local, even when already tracked; never stage their contents, use force-add to bypass ignore rules, or copy their real values into templates, reports, or commit messages. A reviewed `.env.example` may be committed only when its entire resulting content is free of real secrets. Source files and `.gitignore` must also be checked for credentials before staging.

Track the exact files and changes made by this run. Stage only approved, safe changes using explicit paths (or task-specific hunks when a file also has unrelated edits), never a repository-wide `git add -u`, `git add -A`, or `git commit -a`. A developer-confirmed `git rm --cached` deletion is allowed: preserve that index deletion without re-adding the local file. This removes tracking; it does not erase secrets from existing history.

Before every commit, including per-file commits below, verify the complete proposed index: only this run's approved changes may be present, no non-example env file may be added or modified, and all resulting staged file contents must be free of real credentials. Inspect locally without emitting credential values or raw secret-bearing diffs in tool output. If a check fails or cannot be completed, stop the commit/push path and report paths and key names only; do not silently unstage the developer's changes or claim a successful commit. A skipped secret cleanup is not permission to commit a template that still contains credentials.

Run the sub-flows for each selected target: the **Env files** sub-flows if "Env files" was selected, the **.gitignore** sub-flows if ".gitignore" was selected. Within a selected target, run a sub-flow only if it has findings — each shows its findings and asks, with a Skip.

Apply each sub-flow one at a time. Complete each fully before moving to the next. Never mark the command done if a sub-flow was only partially applied — partial fixes leave the project in an inconsistent state.

---

**Env files sub-flows** — run these only if "Env files" was selected.

### Secret cleanup (.env.example)

Only run this section if real secrets were found in `.env.example`.

Display the flagged keys with their planned replacement:

```
.env.example — real secrets found. Planned replacements:

KEY_NAME        API credential (value omitted) → <YOUR_KEY_NAME>
GITHUB_TOKEN    access token (value omitted)   → <YOUR_GITHUB_TOKEN>
```

Then ask:

AskUserQuestion:
  question: "Replace real secrets in .env.example with placeholders?"
  header:   "Secret cleanup"
  multiSelect: false
  options:
    - label: "Replace all"
      description: "Replace all {N} flagged values with the placeholders shown above"
    - label: "Skip"
      description: "Leave .env.example unchanged — handle manually"

If Replace all selected: replace each flagged key's value with `<YOUR_{KEY_NAME}>`.
If user selects Other and types instructions: follow their instructions exactly. Apply only what was explicitly requested.
If Skip selected: note in Step 5 report under manual action.

Do not touch values in any other env file during this section.

### Placeholder cleanup (other env files)

Only run this section if placeholders were found in non-example env files.

Display findings grouped by file:

```
Other env files — placeholders found (should be real values):

.env
  KEY_NAME        your-key-here
  DB_PASSWORD     <YOUR_DB_PASSWORD>

.env.staging
  API_SECRET      REPLACE_ME
  KEY_NAME        your-key-here

Fill in the real values in each file, then mark done.
```

Then ask:

AskUserQuestion:
  question: "Have you filled in the placeholder values?"
  header:   "Placeholders"
  multiSelect: false
  options:
    - label: "Done — move to next step"
      description: "Continue to the next sub-flow"
    - label: "Skip"
      description: "Leave these placeholders as-is and move on"

Do not recheck or validate what was filled in.

---

### Env sync

Process one env file at a time. For each file with missing keys:

1. Display the missing keys and where they exist:

```
.env.staging — 3 keys missing

KEY_NAME       exists in: .env, .env.production
DB_URL         exists in: .env only
API_SECRET     exists in: .env, .env.production
```

2. Let the developer add the keys manually to the file.

3. Ask to proceed:

AskUserQuestion:
  question: "Have you finished updating .env.staging?"
  header:   "Env sync"
  multiSelect: false
  options:
    - label: "Done — move to next file"
      description: "Continue to the next env file with missing keys"
    - label: "Skip this file"
      description: "Leave .env.staging as-is and move on"

4. Move to the next file. Do not recheck or validate what was added.

### Missing from env

Display keys that are completely missing from all env files with their code reference locations:

```
Keys referenced in code but missing from all env files:

KEY_NAME        src/config.js:14
KEY_NAME        src/api/client.ts:8

Add these to .env and all relevant env files manually.
```

Then wait:

AskUserQuestion:
  question: "Have you finished adding the missing keys to your env files?"
  header:   "Missing from env"
  multiSelect: false
  options:
    - label: "Done — move to next step"
      description: "Continue to the next sub-flow"
    - label: "Skip"
      description: "Leave these keys unresolved and move on"

### Hardcoded values

Display all findings:

```
Hardcoded values found — should be moved to env vars:

[High] src/api/stripe.js:23
  Type: API credential (value omitted)
  Suggested env var: STRIPE_PUBLISHABLE_KEY

[Medium] src/config.js:5
  Type: environment-specific URL (value omitted)
  Suggested env var: API_BASE_URL
```

Then ask:

AskUserQuestion:
  question: "Move hardcoded values to env vars?"
  header:   "Hardcoded values"
  multiSelect: false
  options:
    - label: "Replace all"
      description: "Substitute in source + add to all env files using the suggested names above"
    - label: "Skip"
      description: "Leave all hardcoded values as-is"

If Replace all selected:
- If there are more than 10 findings, process one source file at a time. After applying that file's fixes, stage only its approved, credential-free source changes and any updated, verified placeholder-only `.env.example`; exclude all non-example env contents. Apply the Commit boundary above and git.md's Auto-Commit rule, then commit `fix(env): move hardcoded values to env vars ({file})` before moving to the next file.
- For each finding:
  - Replace the hardcoded value in source with the env var access pattern for the detected stack
  - Add the key + real value to `.env` and all other non-example env files if absent
  - Add the key + placeholder (`<YOUR_{KEY_NAME}>`) to `.env.example` if absent
- Inform the dev which source files and env files were updated, distinguishing committable changes from local-only env edits

If user selects Other and types instructions: follow their instructions exactly. Apply only what was explicitly requested.
If Skip selected: no changes.

### Never referenced

Display keys that exist in env files but are never referenced in source code, grouped by file, with a note on whether each looks infrastructure-only or stale:

```
Keys in env files with no code reference:

KEY_NAME        .env, .env.staging     (looks infrastructure-only)
OLD_API_KEY     .env                   (looks stale — similar to STRIPE_API_KEY)
DEBUG_TOKEN     .env.staging           (looks stale)

What would you like to do? You can say things like:
- "delete OLD_API_KEY and DEBUG_TOKEN, keep KEY_NAME"
- "replace config/database.js line 12 with KEY_NAME"
- "delete all" / "keep all"
```

Read the developer's free-text response and act accordingly. Apply only what was explicitly requested.

### Env formatting

Only run this section if env formatting issues were found.

AskUserQuestion:
  question: "Fix formatting across all env files?"
  header:   "Env formatting"
  multiSelect: false
  options:
    - label: "Proceed"
      description: "Fix formatting, remove duplicates, and add category groupings consistently across all env files"
    - label: "Skip"
      description: "Leave env file formatting as-is"

If Proceed selected:
- Apply consistent formatting rules across all env files: spacing around `=`, line endings, no trailing whitespace
- Remove duplicate keys (keep last occurrence) in each file
- Add category groupings if absent — use the same grouping structure across all env files
- Preserve existing group order — do not reorder entries within a group

If Skip selected: no changes to env files.

---

**.gitignore sub-flows** — run these only if ".gitignore" was selected.

### Missing entries

Only run this section if missing entries were found in Step 1.8.

Display all missing entries with a reason:

```
Missing .gitignore entries (stack: Node.js):

node_modules/    dependency directory — never committed
.env.local       local override file — contains machine-specific values
dist/            build output — regenerated on every build
```

Then ask:

AskUserQuestion:
  question: "Add missing entries to .gitignore?"
  header:   "Missing entries"
  multiSelect: false
  options:
    - label: "Add all"
      description: "Add all {N} missing entries to .gitignore"
    - label: "Skip"
      description: "Leave .gitignore unchanged"

If Add all selected: add all entries to .gitignore, then proceed immediately to tracked files check below.
If Skip selected: skip to next section.

### Tracked files

Run this section in two cases:
- Automatically after Missing entries if new entries were added — check for tracked files matching those new patterns
- If pre-existing tracked files were found in Step 1.9 — handle those too

For each tracked file, ask:

AskUserQuestion:
  question: "{file} is tracked by git but matches a .gitignore pattern. Untrack it?"
  header:   "Untrack file"
  multiSelect: false
  options:
    - label: "Untrack"
      description: "Run git rm --cached {file} so .gitignore takes effect"
    - label: "Skip"
      description: "Leave it tracked — handle manually later"

If Untrack selected → run `git rm --cached {file}`.
If Skip selected → note it in the Step 5 report under manual action.

### Entries to remove

Only run this section if overly broad or harmful entries were found in Step 1.10.

Display all entries to remove with a reason:

```
Entries that should not be ignored:

*.js             overly broad — would exclude source files
config/          matches committed application code — likely added by mistake
```

Then ask:

AskUserQuestion:
  question: "Remove these entries from .gitignore?"
  header:   "Entries to remove"
  multiSelect: false
  options:
    - label: "Remove all"
      description: "Remove all {N} flagged entries from .gitignore"
    - label: "Skip"
      description: "Leave .gitignore unchanged"

If Remove all selected: remove all flagged entries from .gitignore.
If Skip selected: no changes.

### Gitignore formatting

Only run this section if formatting issues were found in Step 1.11.

AskUserQuestion:
  question: "Fix .gitignore formatting?"
  header:   "Gitignore formatting"
  multiSelect: false
  options:
    - label: "Proceed"
      description: "Fix formatting, remove duplicate entries, and add category groupings"
    - label: "Skip"
      description: "Leave .gitignore formatting as-is"

If Proceed selected:
- Fix formatting and remove duplicate entries
- Add category groupings if absent
- Preserve existing group order — do not reorder entries within a group

If Skip selected: no changes.

---

## Step 4 — Commit

After all fixes are applied, follow Step 3's Commit boundary for the remaining changes. Stage only the exact approved source changes, verified placeholder-only `.env.example` changes (new or existing), and `.gitignore` changes made by this run. Preserve any confirmed untracking deletions. Never stage non-example env contents, including modified tracked files. Verify the full proposed index before committing; do not use broad staging commands or commit unrelated pre-staged work.

Local-only env edits must remain on disk. If they block a checkout, merge, or cleanup, stop that affected operation and report the current branch and remaining work. Do not force checkout, discard, automatically stash, or commit those files to make Git operations succeed. Report local-only edits even when there is nothing safe to commit.

Account for both remaining safe changes and earlier verified per-file commits. Nothing newly staged is not a no-op when the Hardcoded values flow already committed work; under either Git mode those commits remain eligible for the normal publication/review handoff. Track actual run commits rather than assuming main or a final-stage commit exists.

Commit remaining approved safe changes under the invocation's auto-commit policy, after the complete index check above, with an accurate scoped message. A decline or failed verification/commit stops with actual local-only edits, drafts and branch preserved. Never commit a local env file to unblock a checkout. If no workflow writes/commits exist, use the shared genuine-no-op cleanup only when local-only work does not block it; report local edits separately.

After all intended safe commits are verified, read `{package_root}/prompts/shared/content-sync.md` and apply **Finalize verified workflow commits** with `{workflow} = env`. This includes confirmed PR/push handoff, configured merge strategy, `{base_branch}`, exact-SHA CI-gated fan-out and safe cleanup. Local-only env edits that block checkout/integration stop that action without reset, stash, discard or publication of those files.

---

## Step 5 — Confirm completion

If publication/review/CI remains pending, label that outcome explicitly rather than claiming a completed base merge/push. Distinguish a published review branch from the published base, report the PR/manual handoff, current checkout and retained work, and keep output/assessment completion separate from Git finalization.

Report:

```
ENV COMPLETE
─────────────────────────────────
Env files
  Secret cleanup:   .env.example — {N} replaced, {N} skipped
  Placeholder:      {N} keys flagged across {N} files — done / skipped
  Env sync:         {N} keys added across {N} files
  Missing from env: {N} keys identified — added manually
  Hardcoded values: {N} replaced, {N} skipped
  Never referenced: {N} deleted, {N} kept
  Env formatting:   {N} files fixed
.gitignore
  Missing entries:  {N} added
  Tracked files:    {N} untracked, {N} skipped
  Entries removed:  {N} overly-broad removed
  Formatting:       {N} duplicates removed, groupings added: yes/no
─────────────────────────────────
Needs manual action:
- Secret cleanup skipped: real secrets remain in .env.example — replace with placeholders manually
- Tracked files skipped: {list} — run git rm --cached to untrack manually
- Local-only env edits: {paths or none} — kept on disk, excluded from commits
- Commit blocked: {paths/key names and reason, or none} — no credential values
─────────────────────────────────
Committed: yes / no
Pushed: yes / no — push manually when ready / N/A (nothing to commit)
Environments promoted: {list or none}
```

If GitHub Flow: also report the temporary branch's fate ({merged and deleted / left as-is, uncommitted or unpushed}) and which branch you were returned to.
