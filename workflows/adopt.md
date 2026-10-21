# adopt

Install or update the helm rule files (`git.md`, `safety.md`) into the current project. Setup helper, not a workflow command.

## Entry files and host scope

Resolve `{memory_file}` with the shared runtime before the branch checks below. In the shared layout, `{adopt_file}` is the root AGENTS.md owner on either host, not the CLAUDE.md adapter. With neither file, bootstrap AGENTS.md plus a real CLAUDE.md containing only `@AGENTS.md`. With an AGENTS.md owner and no Claude entry, create that adapter as part of the chosen installation/connection. Only patch Helm's rule entries in the owner; preserve configuration, review markers and unrelated instructions. Never put a second Rules section into the Claude adapter.

Legacy layouts keep their existing ownership until a reviewed `log` migration. In those layouts, `{adopt_file}` remains the current host's persistent entry (CLAUDE.md in Claude, AGENTS.md in Codex), preserving existing adoption behavior. Do not move project knowledge or replace an independent entry here. If two independent roots or another Claude entry need reconciliation to claim shared setup, stop before branching/writing and direct the user to `log`. Outside shared-owner rule pointers and creation of a missing Claude adapter, do not edit the other host's entry.

If CLAUDE.md imports AGENTS.md but still holds shared Helm settings, adopted Rules or a review marker, it is only partially connected. Stop before branching or writing and direct the user to log's reviewed reconciliation; do not add a second owner/pointer set and discover the mismatch only during final verification.

On either host, check for a root AGENTS.override.md before branching. If it explicitly reads AGENTS.md, adoption may update that persistent entry while preserving the override and reporting host-specific policy. Otherwise stop and explain that the override shadows AGENTS.md: the user must explicitly connect the persistent entry from the override or resolve it before retrying. Do not write an inactive AGENTS.md and claim shared setup succeeded, and do not edit or commit the override on the user's behalf.

Only for a legacy Claude-owned project, creating a Codex entry may retain the existing reverse-bridge behavior: `Project instructions and Helm configuration live in CLAUDE.md. Read and follow that file before any project work; do not duplicate or migrate its configuration here.` Preserve CLAUDE.md and recommend `log` for reviewed migration. Never create this reverse bridge when AGENTS.md owns the project. A missing entry alone is not a fresh bootstrap when an owner exists.

A legacy CLAUDE.md owner with no AGENTS.md is not an independent-root conflict. Choosing `Connect Codex to existing Claude references` authorizes creation of its missing Codex bridge when the targets are readable; do not substitute a log-migration gate for that chosen connection. Report the legacy connection accurately, separately from canonical layout migration.

Read `{adopt_file}`, the resolved `{memory_file}`, and the explicit chains of both when detecting existing rule references, including older references outside a `## Rules` section. This includes a CLAUDE.md owner even when AGENTS.md does not exist yet. Preserve user-authored references outside the managed section. Before writing a second pointer to the same rule, reuse the existing entry or explain any conflicting reference instead of silently activating two versions.

## Before starting

Check `git-strategy` in {memory_file}'s recognized configuration block (absence defaults to GitHub Flow, per git.md).

If there is no git repository yet, or {memory_file} does not exist yet (so `git-strategy` cannot be read) — skip the rest of this section and proceed directly to Step 1. This is a fresh bootstrap: there is no main to branch from, and Step 5 later skips its branch/merge/promote logic for the same reason.

**Solo Mode** (`git-strategy: solo`):
- Only proceed if on `main` or `master`. If on any other branch, stop: "adopt must be run on main or master in Solo Mode. Current branch is {branch} — switch and re-run."

**GitHub Flow** (`git-strategy: github-flow`, or absent):
- Record the current branch as `{original_branch}` — the workflow returns here at the end, whatever it was.
- Checkout a fresh branch from main's current tip: update local main (`git pull` if a remote exists), then `git checkout -b chore/adopt-{YYYYMMDD}` from it.
- Call this branch `{branch}` for the rest of this command.
- If this command exits at any point without writing anything (e.g. Cancel at any prompt, or the No-change path), delete `{branch}` and return to `{original_branch}` before exiting — never leave the user stranded on an empty temporary branch it created.

## Step 1 — Sanity check

Check whether the current directory looks like a project — any of:
- `.git` (directory or worktree file)
- `CLAUDE.md` or `AGENTS.md`
- `package.json`, `composer.json`, `Cargo.toml`, `pyproject.toml`, `go.mod`

Decide based on what is present:
- **Project markers found** → proceed.
- **Empty directory** (no project markers and no other files) → proceed silently. This is a plausible fresh-project setup with nothing to clobber.
- **Non-empty but no project markers** → this is the suspicious case (a populated folder that isn't a project — possibly the wrong directory). Confirm before writing:

  AskUserQuestion:
    question: "This directory has files but does not look like a project (no .git, no {adopt_file}, no recognised manifest). Continue anyway?"
    header:   "Confirm"
    multiSelect: false
    options:
      - label: "Continue"
        description: "Adopt rules here anyway"
      - label: "Cancel"
        description: "Exit without changes"

  If Cancel → proceed to Step 5, which correctly handles either outcome: cleans up the GitHub Flow branch if one was created (normal flow), or does nothing further if this was a fresh bootstrap (no branch was created).

## Step 2 — Scan existing rules

First detect the reference type in {adopt_file}, the resolved {memory_file}, and the explicit memory chains of both for each rule, even when {adopt_file} is absent. Classify each as one of:
- **marketplace ref** — a line with `marketplaces/claude-helm/rules/{name}` is present
- **local ref** — a line with `.claude/rules/{name}` is present
- **no ref** — neither is present

Then classify each of `.claude/rules/git.md` and `.claude/rules/safety.md` as one of:
- **Helm-marked** — file exists and starts with `<!-- helm-rule: claude-helm@v{X.Y.Z} -->`; record version
- **Foreign** — file exists but does not contain the helm marker
- **Referenced** — file does not exist and a marketplace ref is present
- **Absent** — file does not exist and no marketplace ref is present (a stray local ref does not block this — Step 4 rewrites it)

Classification is driven by the file first; the reference type only disambiguates the file-absent cases (Referenced vs Absent) and is reconciled in Step 4.

Resolve `{rule_source_root}` and `current_version` together before offering an update:

- In Claude, prefer `~/.claude/plugins/marketplaces/claude-helm/`, preserving the existing copy and reference update behavior. Verify its manifest names plugin `helm` and both rule files exist. Read its version from `.claude-plugin/plugin.json`.
- If that Claude marketplace installation has no manifest, use the loaded `{package_root}` only after verifying the same identity and files. Report why the fallback was needed, its path, and its version explicitly. If a marketplace manifest exists but is invalid, has the wrong identity, or references missing rules, report the inconsistent installation and stop instead of silently using another source. With a valid marketplace source, prefer it as before; if its version differs from the loaded package, show both versions and the selected copy source. Never silently downgrade newer project rules. Reference mode cannot be newly installed without the stable Claude marketplace source.
- In Codex, use the loaded `{package_root}` and its `.claude-plugin/plugin.json`, not a guessed Claude or Codex cache path. Verify identity and both rules. Codex installs copies; it does not create version-specific cache references.
- If no valid source is available, report the missing or inconsistent paths and stop before writing. Source selection never grants permission to alter another installation.

Compute the overall state:
- All Absent → state = FRESH
- Any Referenced, none Helm-marked, none Foreign → state = REFERENCED
- Any Helm-marked, none Foreign → state = UPDATE
- Any Foreign → state = CONFLICT

For UPDATE state, compare each Helm-marked file's marker version against `current_version` (semver) and record the relationship:
- **behind** — any marker version is lower than `current_version` (a real update is available)
- **in sync** — every marker version equals `current_version` (nothing to reconcile)
- **ahead** — any marker version is higher than `current_version` (project is newer than the installed plugin — unusual, e.g. the install was downgraded)

## Step 3 — Choose install mode

First display the scan summary so the user sees the per-file state before deciding:

```
.claude/rules/git.md     {Absent / Helm v{X.Y.Z} / Foreign / Referenced in {adopt_file}}
.claude/rules/safety.md  {Absent / Helm v{X.Y.Z} / Foreign / Referenced in {adopt_file}}
Installed helm version:  v{current_version}
```

Then choose the question and labels based on state.

For an AGENTS.md-owned installation with existing readable Helm rules and a missing CLAUDE.md adapter, include its exact `@AGENTS.md` contents in the proposed action. When the rules need no update, offer `Connect agents without changing rules` or `Cancel` on either host; run the connection path below. Connection adds only missing approved pointers/adapter, never rewrites in-sync/newer rules. A cancelled action, all-foreign-files Skip, or a choice explicitly promising no changes must not create either entry. Do not report both agents connected if the adapter is absent.

### Codex install choices

In Codex, use these choices and then proceed directly to Step 4, skipping the Claude-only questions below:

- **FRESH:** offer `Copy shared rules and connect Codex`, or `Cancel`. Explain that copies live in `.claude/rules/` and the current Codex entry reads them explicitly.
- **UPDATE:** preserve the same behind/in-sync/ahead comparison below. Behind offers `Update shared copies` or `Cancel`; in sync offers `Connect Codex` or `Cancel`; ahead defaults to `Keep newer project rules and connect Codex`, with `Roll back shared copies to v{current_version}` and `Cancel` as alternatives. State that updating shared copies also affects Claude projects reading those files. Connecting only patches a missing Helm entry/bridge; if already connected, it is a no-op. Never overwrite in-sync or newer rules just to add a bridge.
- **CONFLICT:** offer `Review each foreign file` or `Cancel`. Preserve each Skip decision. Skip leaves both that file and its existing entry unchanged; it does not authorize adding a new pointer to the foreign file. Add pointers only for rules actually installed or preserved Helm-managed copies. If all files are skipped, make no entry changes and use the no-change cleanup. Do not report skipped foreign files as Helm-managed.
- **REFERENCED:** offer `Connect Codex to existing Claude references`, or `Cancel`. This preserves the existing installation, not a new Codex reference-mode install. Verify both referenced sources are readable before adding the Codex bridge. If unavailable, report the missing paths and stop; advise using Claude's adopt flow to switch the shared installation to copies. Do not create copies alongside Claude references, delete copies, repoint CLAUDE.md, or silently switch either host's install mode.

`Connect Codex` runs only the entry-file update in Step 4, using existing readable copied paths or the already-loaded memory entry. For legacy existing references, the bridge points only at the owner; never duplicate its marketplace paths into AGENTS.md. For references already owned by AGENTS.md, preserve them and connect only the missing Claude adapter; never create a self-bridge or a second rule installation. A Cancel still follows the original branch cleanup path.

### Claude install choices

The canonical missing-adapter connection-only choice above takes precedence when no rule update is needed. Otherwise keep the original choices below on Claude. Omit every new/switch-to-reference choice when the stable marketplace source is unavailable; copy/update, keep, and cancel choices remain. Reference mode is a shared policy change: if a separate Codex entry explicitly reads local copies, report that dependency and stop before deleting them. Do not leave the other host with broken pointers; the user can reconcile those entries before retrying.

Apply the same dependency check before switching from reference mode to copies: a separate Codex entry with direct marketplace-rule pointers would keep reading a different version after the switch. Stop and have those entries connected through the owner first; do not silently modify them. A Codex bridge pointing only at the owner follows either mode without changes.

If state = REFERENCED:
  AskUserQuestion:
    question: "Helm rules are already referenced in {adopt_file} (reference mode). What would you like to do?"
    header:   "Already installed"
    multiSelect: false
    options:
      - label: "Keep references (no change)"
        description: "References point to the marketplaces path and stay current after /plugin update."
      - label: "Switch to copy mode"
        description: "Copy versioned rule files into .claude/rules/ and repoint the {adopt_file} references at them."
      - label: "Cancel"
        description: "Exit without changes."

If state = FRESH:
  AskUserQuestion:
    question: "How should helm install the rules into this project?"
    header:   "Install mode"
    multiSelect: false
    options:
      - label: "Copy into .claude/rules/ (Recommended)"
        description: "Self-contained. Rules get committed with your project and travel with it."
      - label: "Reference from {adopt_file}"
        description: "Lighter footprint. Pulls latest after /plugin update, but references are machine-local."
      - label: "Cancel"
        description: "Exit without changes."

If state = UPDATE, branch on the version relationship:

If **in sync** (marker versions all equal `current_version`):
  Inform the user: "Helm rules are already up to date (v{current_version})." Do not offer an overwrite.
  AskUserQuestion:
    question: "Rules are already at v{current_version}. Anything to change?"
    header:   "Up to date"
    multiSelect: false
    options:
      - label: "Nothing (Recommended)"
        description: "Leave everything as-is."
      - label: "Switch to reference mode"
        description: "Delete the copied files and reference the installed plugin path from {adopt_file} instead."

If **behind** (a marker version is lower than `current_version`):
  AskUserQuestion:
    question: "Update the helm rules in this project from v{marker_version} to v{current_version}?"
    header:   "Update mode"
    multiSelect: false
    options:
      - label: "Update rules in .claude/rules/ (Recommended)"
        description: "Overwrite helm-marked files with v{current_version} from the installed plugin."
      - label: "Switch to reference mode"
        description: "Delete the copied files and reference the installed plugin path from {adopt_file} instead."
      - label: "Cancel"
        description: "Exit without changes."

If **ahead** (a marker version is higher than `current_version`):
  Warn the user: "This project's rules (v{marker_version}) are newer than the installed plugin (v{current_version}) — the installed plugin may have been downgraded. Overwriting would roll the rules back."
  AskUserQuestion:
    question: "Project rules (v{marker_version}) are ahead of the installed plugin (v{current_version}). How would you like to proceed?"
    header:   "Project ahead"
    multiSelect: false
    options:
      - label: "Keep project rules (Recommended)"
        description: "Leave the newer files in place — update the installed plugin instead if you want to move forward."
      - label: "Roll back to v{current_version}"
        description: "Overwrite with the older installed-plugin version anyway."
      - label: "Cancel"
        description: "Exit without changes."

If state = CONFLICT:
  AskUserQuestion:
    question: "Existing rule files without the helm marker were found. How should helm proceed?"
    header:   "Conflict"
    multiSelect: false
    options:
      - label: "Review per file (Recommended)"
        description: "For each foreign file, ask whether to overwrite it or skip it."
      - label: "Reference from {adopt_file} instead"
        description: "Point {adopt_file} at the installed plugin path. You'll be asked per foreign file whether to keep or delete it, since a local copy would coexist with the referenced rules."
      - label: "Cancel"
        description: "Exit without changes."

Wait for response.

## Step 4 — Execute

### Updating {adopt_file}'s `## Rules` section

The Copy or Update and Reference paths both update {adopt_file} the same way — only the snippet content differs. Wherever a path says "update the `## Rules` section with {snippet}", do this:

- Detect the helm entries in any existing `## Rules` section (lines pointing at `.claude/rules/` or the marketplaces path) and set them to the snippet's entries. Preserve any user-authored entries — add or replace only the helm entries. Create a new `## Rules` section only if none exists — never add a second `## Rules` heading.
- The snippets show a complete two-rule install. For per-file review, add entries only for successfully installed rules; preserve an existing entry for a skipped file, but never add a new one for it. If every file was skipped and no connection was selected, leave the entry untouched.
- If {adopt_file} exists: write silently — the install mode was already chosen in Step 3.
- If {adopt_file} does not exist: create it silently with the `## Rules` section and the required memory-owner bridge when the owner is a different file. Do not prompt and do not offer a manual-placement path — the pointer is required for the rules to load, so anything short of writing it leaves the install non-functional. The Report step notes that {adopt_file} was created.
- In a fresh or AGENTS.md-owned layout, the selected install/connection also creates a missing root CLAUDE.md containing the standalone `@AGENTS.md` import. Do this only after at least one rule was installed/preserved as Helm-managed or a valid connection was approved; never after all foreign files were skipped or an action was cancelled. If another Claude entry already exists, do not create an independent competing entry; direct the user to log's reviewed layout flow. Preserve an existing correct Claude adapter byte-for-byte.

### Copy or Update path

- Create `.claude/rules/` if it does not exist.
- For each of `git.md`, `safety.md`:
  - Read the selected source from `{rule_source_root}/rules/{name}`. Write only the files approved by the chosen mode or per-file review; a skipped foreign file must remain byte-for-byte unchanged.
  - Prepend a marker line: `<!-- helm-rule: claude-helm@v{current_version} -->`
  - Write to `.claude/rules/{name}`.
- Update {adopt_file}'s `## Rules` section (see *Updating {adopt_file}'s `## Rules` section* above) with this snippet, so the copied rules load as context:
  ```
  ## Rules

  This project follows the rules shipped in claude-helm:
  - .claude/rules/git.md
  - .claude/rules/safety.md

  At the start of every session, read the rule files at the paths above and follow them.
  ```

### Connect agents without rewriting rules

Use this path for in-sync copies, keeping newer project copies, existing readable Claude references, or a missing Claude adapter on a shared owner. Verify the actual rule paths first. In a canonical layout, preserve AGENTS.md byte-for-byte when its pointers are already correct; otherwise add only missing explicit Helm-rule directives to it, preserving its configuration and knowledge. Add a missing CLAUDE.md import adapter, never duplicate rule pointers into it. In a legacy layout, preserve the owner byte-for-byte and add or repair only the current Codex entry's directives/owner bridge. When a bridge already loads the owner's references, reuse it instead of adding competing pointers. Preserve all rule files and their actual marker versions byte-for-byte. If already connected, make no changes and use normal cleanup.

Record the action as `connected` (or `already connected`), not as a rule copy/update. Do not run the Reference path, delete files, rewrite markers, or fall through into Copy or Update. Report the versions actually present; keeping newer copies must not be reported as a rollback to the loaded plugin version.

### Review per file path

For each Foreign file:

AskUserQuestion:
  question: "{file} already exists and was not created by helm. Overwrite it with the plugin's version?"
  header:   "Foreign file"
  multiSelect: false
  options:
    - label: "Overwrite"
      description: "Replace it with the helm version — adds the marker and the local ## Rules entry"
    - label: "Skip"
      description: "Leave your file untouched"

- On Overwrite → write the file via the Copy or Update path.
- On Skip → leave the user's file as-is. (To compare first, the developer can diff their file against the plugin source manually.)

### Reference path

- Delete the Helm-marked local files at `.claude/rules/git.md` and `.claude/rules/safety.md` — no need to ask, the user already chose reference mode. This also makes the next scan classify as REFERENCED, not UPDATE.
- If `.claude/rules/git.md` or `.claude/rules/safety.md` is Foreign (unmarked) — the user's own file sitting at helm's path — ask before removing it, since it would coexist with and conflict with the referenced rule of the same name. Only these two names; leave any other file in `.claude/rules/` untouched.

  AskUserQuestion:
    question: "{file} is your own rule file. In reference mode it would sit alongside the plugin's referenced {name} and could conflict. Delete it?"
    header:   "Local rule file"
    multiSelect: false
    options:
      - label: "Delete it"
        description: "Remove your file so only the referenced plugin rules apply."
      - label: "Skip"
        description: "Keep your file — it stays active alongside the referenced rules."

  On Skip, note the kept file in the Report as a possible conflict.
- Update {adopt_file}'s `## Rules` section (see *Updating {adopt_file}'s `## Rules` section* above) with this snippet:
  ```
  ## Rules

  This project follows the rules shipped in claude-helm:
  - ~/.claude/plugins/marketplaces/claude-helm/rules/git.md
  - ~/.claude/plugins/marketplaces/claude-helm/rules/safety.md

  At the start of every session, read the rule files at the paths above and follow them.
  If either path is missing, inform the user: "helm rules are referenced in {adopt_file} but the
  plugin is not installed on this machine. Install it with: /plugin install helm@claude-helm"
  ```

### No-change path

- For "Nothing" (in sync), "Keep project rules" (ahead), or "Keep references" (already in reference mode): make no changes and report the status (already up to date, project ahead of the installed plugin, or references kept). No files written. Proceed to Step 5 for cleanup.

### Cancel path

- Exit silently. No files written. Proceed to Step 5 for cleanup.

### Overwrite mapping

- "Update rules" (behind) and "Roll back to v{current_version}" (ahead) both run the Copy or Update path.
- "Switch to reference mode" runs the Reference path.

## Step 5 — Commit and finalize

**Fresh bootstrap** (Before starting's branch-strategy setup was skipped — no repo, or no pre-existing {memory_file}): there is no branch to clean up, since none was created. If Step 4 made no changes, there is nothing to do at all — skip straight to Step 6 to report.

If no repository or no HEAD exists, do not initialize Git or attempt commit/push/promotion. Report the actual installed files and entries as uncommitted. The remaining bootstrap finalization applies only when HEAD exists.

If Step 4 wrote anything, commit it per git.md's Auto-Commit rule — no merge or promotion applies here, since there's no branch strategy to run them under. Then check whether a remote named `origin` exists (`git remote get-url origin`):
- If none exists (the "no repo yet" sub-case, or a repo with no remote configured), stop here — there's nothing to push to.
- If one exists (a real repo that simply had no {adopt_file} yet), push always requires its own confirmation regardless of `git-auto-commit`, same as every other command:

  AskUserQuestion:
    question: "Push main now? This publishes the commit to origin."
    header:   "Push"
    multiSelect: false
    options:
      - label: "Push (Recommended)"
        description: "git push origin main"
      - label: "Cancel"
        description: "Leave main committed locally but unpushed — push manually when ready"

  If Push selected: `git push origin main`.

Proceed to Step 6 to report the outcome either way.

**Normal flow** (branch-strategy setup ran in Before starting):

If Step 4 made no changes (No-change path or Cancel path): skip commit, merge, and environment promotion below — there is nothing to act on. Under GitHub Flow, still delete `{branch}` and return to `{original_branch}` — do not skip that part. Under Solo Mode there is nothing further to do, since no branch was created.

Otherwise, commit per git.md's Auto-Commit rule: silent if `git-auto-commit: true`, otherwise ask for confirmation before committing, merging, and pushing together. Either way, push itself always requires its own confirmation regardless of `git-auto-commit` — git.md's Auto-Commit rule states this as an explicit exception, and rules/safety.md lists `git push` as always requiring confirmation with no exceptions. Environment promotion's branch-selection prompt below already serves as that confirmation for environment-branch pushes; under GitHub Flow, confirm separately before step 2's `git push origin main`, even when the commit above was silent.

**Environment promotion** — shared by both modes below. If environment branches exist (discover via `git branch -r`, filter for known environment names, same detection as ship.md), ask which should also receive this update. (This block is intentionally duplicated across every content-sync command — see rules/git.md's Environment Branches section for the canonical shape; keep all copies in sync if it changes.)

  AskUserQuestion:
    question: "main will be updated. Which environment branches should also receive these rule files?"
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
  - git merge main --no-ff -m "chore(deploy): promote main to {environment} for helm rule updates"
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
2. Merge into main: `git checkout main`, `git merge {branch} --no-ff -m "{same message as the commit above}"`. Before pushing, confirm:

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

## Step 6 — Report

For Copy/Update, verify only the rule files actually written: read each back and confirm it contains the `<!-- helm-rule: claude-helm@v{current_version} -->` marker. Report skipped foreign files separately, without requiring a Helm marker on them or claiming they were installed. If a written file is missing or its marker is absent, report the error instead of ADOPT COMPLETE.

For a connection, read the selected entry and any created Claude adapter back and follow their directives to the owner and rules. Verify targets are readable, rules and existing configuration/knowledge were preserved, and any owner edits are limited to approved missing Helm pointers. Report `connected` or `already connected`, actual entry/owner/adapter paths, actual rule versions/references, and files written, committed or pushed. Do not apply the copy/update marker check to this action. Do not report unavailable references or skipped foreign files as a successful Helm installation.

For every shared-layout install/connection, verify CLAUDE.md imports AGENTS.md and has no duplicated Helm settings/Rules. Report any adapter creation and actual shared owner in addition to the outcome below. Existing reference-mode paths in the shared owner remain machine-local dependencies for both readers; do not claim cross-machine portability.

Print outcome.

For a Codex connection:
```
ADOPT COMPLETE — {connected / already connected}
- Entry:    {adopt_file} — {created / updated / unchanged}
- Owner:    {memory_file} — preserved
- Rules:    {existing paths and actual versions, resolved through the owner for reference mode}
- Committed: {yes / no}
- Pushed:   {yes / no / N/A}
```

For Copy/Update:
```
ADOPT COMPLETE
- {written_name} {written / updated} → .claude/rules/{written_name} (v{current_version})
- {skipped_name} skipped (foreign, unchanged; not installed)
- {adopt_file} {created / updated / unchanged}: {only the successful rule pointers changed, or no entry changes}
- Pushed:   {yes / no — push manually when ready / N/A, no remote}
```

Include one written/updated line per file actually written, and one skipped line per foreign file left untouched. Omit inapplicable lines; never attach the plugin version or a copied-file claim to a skipped file.

For Reference:
```
ADOPT COMPLETE
- {adopt_file} {created / updated}: ## Rules section references claude-helm rules at v{current_version}
- Pushed:   {yes / no — push manually when ready / N/A, no remote}
```

For No-change (in sync or project ahead):
```
ADOPT COMPLETE — no changes
- Rules already at v{current_version} (in sync)         # in-sync case
- Project rules v{marker_version} are ahead of installed v{current_version}; left as-is   # ahead case
```

## Notes

- The marker line at the top of each copied file is required for future `/helm:adopt` runs to detect helm-managed files vs. user-managed files. Do not strip it.
- This command writes only `.claude/rules/`, the selected `{adopt_file}`, and a missing root CLAUDE.md adapter for fresh/AGENTS.md-owned setup in the current project. It does not migrate existing owners; use log for that reviewed change.
- This command never touches anything in the user's `~/.claude/` directory.
