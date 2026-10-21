# adopt

Install or update the helm rule files (`git.md`, `safety.md`) into the current project. Setup helper, not a workflow command.

## Entry files and host scope

Resolve `{memory_file}` with the shared runtime before the branch checks below. In the shared layout, `{adopt_file}` is the root AGENTS.md owner on either host, not the CLAUDE.md adapter. With neither file, bootstrap AGENTS.md plus a real CLAUDE.md containing only `@AGENTS.md`. With an AGENTS.md owner and no Claude entry, create that adapter as part of the chosen installation/connection. Only patch Helm's rule entries in the owner; preserve configuration, review markers and unrelated instructions. Never put a second Rules section into the Claude adapter.

Legacy layouts keep their existing ownership until a reviewed `log` migration. In those layouts, `{adopt_file}` remains the current host's persistent entry (CLAUDE.md in Claude, AGENTS.md in Codex), preserving existing adoption behavior. Do not move project knowledge or replace an independent entry here. If two independent roots or another Claude entry need reconciliation to claim shared setup, stop before branching/writing and direct the user to `log`. Outside shared-owner rule pointers and creation of a missing Claude adapter, do not edit the other host's entry.

If CLAUDE.md imports AGENTS.md but still holds shared Helm settings, adopted Rules or a review marker, it is only partially connected. Stop before branching or writing and direct the user to log's reviewed reconciliation; do not add a second owner/pointer set and discover the mismatch only during final verification.

On either host, check for a root AGENTS.override.md before branching. If it explicitly reads AGENTS.md, adoption may update that persistent entry while preserving the override and reporting host-specific policy. Otherwise stop and explain that the override shadows AGENTS.md: the user must explicitly connect the persistent entry from the override or resolve it before retrying. Do not write an inactive AGENTS.md and claim shared setup succeeded, and do not edit or commit the override on the user's behalf.

Only for a legacy Claude-owned project, creating a Codex entry may retain the existing reverse-bridge behavior: `Project instructions and Helm configuration live in CLAUDE.md. Read and follow that file before any project work; do not duplicate or migrate its configuration here.` Preserve CLAUDE.md and recommend `log` for reviewed migration. Never create this reverse bridge when AGENTS.md owns the project. A missing entry alone is not a fresh bootstrap when an owner exists.

A legacy CLAUDE.md owner with no AGENTS.md is not an independent-root conflict. Choosing `Connect Codex to existing Claude references` authorizes creation of its missing Codex bridge when the targets are readable; do not substitute a log-migration gate for that chosen connection. Report the legacy connection accurately, separately from canonical layout migration.

Read `{adopt_file}`, the resolved `{memory_file}`, and the explicit chains of both when detecting existing rule references, including older references outside a `## Rules` section. This includes a CLAUDE.md owner even when AGENTS.md does not exist yet. Preserve user-authored references outside the managed section. Reuse an existing effective pointer instead of duplicating it. If a mode switch would leave an old pointer active outside the managed section, stop before any write/deletion and show the dependency that needs an explicitly reviewed reconciliation; do not activate two versions or silently rewrite user instructions.

Adopt owns no operational state. Do not inspect, create, stage, or migrate `.helm/`, `.claude/helm/`, or known flat legacy ledger files. `.claude/rules/` is rule storage, not a legacy state directory to relocate.

## Before starting

Resolve and state the effective `git-strategy`, `git-auto-commit`, and `git-merge-strategy` from {memory_file}'s recognized configuration, including bridges and active overrides. Defaults are GitHub Flow, false, and squash respectively. Missing AGENTS.md/CLAUDE.md means missing settings, not missing Git history. Do not create configuration declarations just to apply defaults.

Only **no repository or no HEAD** is a Git bootstrap: proceed to Step 1 without branch setup, and later leave installed files uncommitted. Do not initialize Git or invent a base branch.

With a repository and HEAD, record `{original_branch}` and resolve `{base_branch}` to the project's actual `main` or `master`, using its default branch and existing refs; stop if ambiguous or unavailable. Use that exact name throughout setup, integration, publication, and promotion. Require a clean index/working tree before branch changes or adoption writes; leave user changes on their current branch for reconciliation, without automatic stash/reset/commit.

**Solo Mode:** proceed only on `{base_branch}`; otherwise stop and ask the user to switch and rerun. No temporary branch is created.

**GitHub Flow:** safely switch to `{base_branch}`, fast-forward it from its configured upstream when available (never merge a divergent pull automatically), then create an unused `chore/adopt-{YYYYMMDD}` branch from its tip. If the date name exists, choose an unused suffix rather than reusing or deleting it. Record `{branch}` and that this invocation created it. Never base adoption on unmerged feature work.

After every checkout/update and before proposing writes, re-read the active entries, owner, explicit chains, overrides, and effective settings on the actual destination branch. Reapply all entry/layout gates above. If ownership, policy, or a dependency differs from preflight, stop without writes and report the difference; do not carry old configuration or approvals into another layout. Scan rule files and plan patches only from this branch. Snapshot the relevant entries, overrides, rule files and source files, including absent paths, and recheck them before applying the plan; unexpected changes invalidate it. The invocation policy governs finalization; installing a newer rule must not silently change that policy mid-run.

For a no-write exit, safely switch back to `{original_branch}` first, then delete only this invocation's empty temporary branch with `git branch -d`. Never delete the currently checked-out branch, an existing branch, or one containing work. Any pending/failed write or Git operation instead follows Step 5's pending-work rule and preserves the actual branch and files.

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

First detect active read directives/imports in {adopt_file}, the resolved {memory_file}, and the explicit memory chains of both for each rule, even when {adopt_file} is absent. Resolve paths relative to their referring file and distinguish actual instructions from quoted examples. Record all effective targets; simultaneous different targets are a conflict to reconcile, not permission to pick the first substring. Classify each pointer as:
- **marketplace ref** — points to the exact stable marketplace `rules/{name}` target
- **local ref** — points to the exact consumer `.claude/rules/{name}` target
- **no ref** — neither is present

Then classify each of `.claude/rules/git.md` and `.claude/rules/safety.md` as one of:
- **Helm-marked** — file exists and starts with `<!-- helm-rule: claude-helm@v{X.Y.Z} -->`; record version
- **Foreign** — file exists without a valid leading Helm version marker
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

Keep that summary state, but make an explicit plan for **each** rule: existence, current effective pointer(s), marker/version, selected source/version, and proposed action. An absent/dangling rule or missing required read directive is not an in-sync installation. A referenced rule counts as usable only after verifying its target is readable. Never let an aggregate state suppress a missing rule.

For a complete copied installation with no mixed references, version states are mutually exclusive:
- **ahead** — at least one marker is newer than `current_version`; take precedence over behind and list the relationship for both files.
- **behind** — none is ahead and at least one marker is older.
- **in sync** — both expected files exist, both markers equal `current_version`, and their effective directives are correct.

Except for a genuinely FRESH installation with neither rule nor an existing pointer, treat missing rules, mixed copy/reference installations, or missing directives as **REPAIR**, before the normal aggregate-state choices. Foreign files still require CONFLICT review and are never automatically repaired. In REPAIR, offer `Review repairs per rule` or `Cancel` on either host. Show each exact file/pointer change, then ask `Apply this repair` or `Skip` per proposed change before writing anything. For missing/older copied rules, use the selected package source; preserve current/newer readable copies byte-for-byte. An ahead file can only be replaced through an explicit per-file rollback choice showing old and new versions, never through a bulk update/repair. A missing pointer to an existing managed copy needs no rule rewrite. Missing/dangling references or mixed modes need a coherent reviewed install-mode plan; Codex may connect to valid existing references but cannot silently repair them by creating competing copies. If it cannot repair without a mode switch, stop and direct the user to Claude's copy-mode flow. Preserve all Skip decisions. Apply only a mutually consistent approved subset; if a skipped dependency would leave an active pointer broken or two versions active, stop without applying the plan. All-Skip writes nothing, creates no adapter, and cannot report a complete installation. Report any remaining missing rules as partial rather than fully connected.

## Step 3 — Choose install mode

First display the scan summary so the user sees the per-file state before deciding:

```
.claude/rules/git.md     {Absent / Helm v{X.Y.Z} / Foreign / Referenced in {adopt_file}}
.claude/rules/safety.md  {Absent / Helm v{X.Y.Z} / Foreign / Referenced in {adopt_file}}
Installed helm version:  v{current_version}
```

Then choose the question and labels based on state.

For an AGENTS.md-owned installation with both expected readable Helm rules and a missing CLAUDE.md adapter, include its exact `@AGENTS.md` contents in the proposed action. When the rules need no update or repair, offer `Connect agents without changing rules` or `Cancel` on either host; run the connection path below. Connection adds only missing approved pointers/adapter, never rewrites in-sync/newer rules. A cancelled action, all-foreign-files Skip, or a choice explicitly promising no changes must not create either entry. Do not report both agents connected if the adapter or either required rule is absent.

### Codex install choices

In Codex, use these choices and then proceed directly to Step 4, skipping the Claude-only questions below:

The REPAIR review above takes precedence over these aggregate choices. Before any Codex copy/overwrite/repair, check for existing marketplace dependencies in the effective entry/owner chains. Never create or overwrite local copies alongside those references, even if the local-file-first scan classified the installation as CONFLICT/UPDATE. With existing references, Codex can only make a valid connection; unresolved mixed files/modes or unavailable targets stop for Claude's reviewed copy-mode flow.

- **FRESH:** offer `Copy shared rules and connect Codex`, or `Cancel`. Explain that copies live in `.claude/rules/` and the current Codex entry reads them explicitly.
- **UPDATE:** preserve the same behind/in-sync/ahead comparison below. Behind offers `Update shared copies` or `Cancel`; in sync offers `Connect Codex` or `Cancel`; ahead defaults to `Keep project rules and connect Codex`, with `Review updates and rollbacks per rule` and `Cancel` as alternatives. Keeping preserves both copies even if one is behind; use per-rule review to update the older file without downgrading the newer one. State that updating shared copies also affects Claude projects reading those files. Connecting only patches a missing Helm entry/bridge; if already connected, it is a no-op. Never overwrite in-sync or newer rules just to add a bridge.
- **CONFLICT:** offer `Review each foreign file` or `Cancel`. Preserve each Skip decision. Skip leaves both that file and its existing entry unchanged; it does not authorize adding a new pointer to the foreign file. Add pointers only for rules actually installed or preserved Helm-managed copies. If all files are skipped, make no entry changes and use the no-change cleanup. Do not report skipped foreign files as Helm-managed.
- **REFERENCED:** offer `Connect Codex to existing Claude references`, or `Cancel`. This preserves the existing installation, not a new Codex reference-mode install. Verify both referenced sources are readable before adding the Codex bridge. If unavailable, report the missing paths and stop; advise using Claude's adopt flow to switch the shared installation to copies. Do not create copies alongside Claude references, delete copies, repoint CLAUDE.md, or silently switch either host's install mode.

`Connect Codex` runs only the entry-file update in Step 4, using existing readable copied paths or the already-loaded memory entry. For legacy existing references, the bridge points only at the owner; never duplicate its marketplace paths into AGENTS.md. For references already owned by AGENTS.md, preserve them and connect only the missing Claude adapter; never create a self-bridge or a second rule installation. A Cancel still follows the original branch cleanup path.

### Claude install choices

The canonical missing-adapter connection-only choice above takes precedence when no rule update is needed. Otherwise keep the original choices below on Claude. Omit every new/switch-to-reference choice when the stable marketplace source is unavailable; copy/update, keep, and cancel choices remain. Reference mode is a shared policy change: if a separate Codex entry explicitly reads local copies, report that dependency and stop before deleting them. Do not leave the other host with broken pointers; the user can reconcile those entries before retrying.

After filtering, every picker must still have 2–4 choices. In the in-sync case without a stable marketplace source, there is no action left: report up to date and take the no-change cleanup without showing a one-option picker. Use the connection choice above instead when a missing adapter actually needs connecting.

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
      - label: "Review updates and rollbacks per rule"
        description: "Choose each older-file update or newer-file rollback explicitly, showing both versions."
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
        description: "Point {adopt_file} at the installed plugin path. Each foreign file must be explicitly deleted; keeping one stops the switch without writes."
      - label: "Cancel"
        description: "Exit without changes."

Wait for response.

## Step 4 — Execute

### Plan before mutation

Collect every per-file Overwrite/Skip, repair/rollback, and reference-mode deletion decision before changing any file. Show the resulting rule actions, exact pointer patches, any entry/adapter creation, and all retained/missing rules. These are the concrete effects authorized by the selected mode and per-file answers; do not ask again for the same action. Recheck the branch, effective policy, source version/content, and recorded target snapshots immediately before writing. Changed inputs or a remaining conflicting pointer stop the plan before mutation. Reject write/delete targets that resolve outside the consumer project or through symlinked destinations; do not modify another checkout or plugin installation.

Cancellation before mutation writes nothing. If a later write/read-back fails or the user stops after mutation began, preserve the actual drafts and remaining originals, report pending work, and do not fall through to a no-change exit, commit, or cleanup. Never reset unrelated work to simulate an atomic rollback.

### Updating {adopt_file}'s `## Rules` section

The Copy or Update and Reference paths both update {adopt_file} the same way — only the snippet content differs. Wherever a path says "update the `## Rules` section with {snippet}", do this:

- Identify Helm entries by their exact resolved rule targets: `.claude/rules/git.md`, `.claude/rules/safety.md`, or the verified stable marketplace's `rules/git.md` and `rules/safety.md`. A directory prefix, basename alone, quoted example, or mention of another plugin does not establish ownership. Preserve custom entries such as `.claude/rules/security.md` byte-for-byte. Change only the approved Helm pointer spans, preserving user prose, other imports, existing Skip pointers, and section order. If a line combines Helm and unrelated instructions and cannot be patched unambiguously, stop for a reviewed patch instead of replacing the line/section wholesale. Reuse effective pointers outside this section; a mode switch requiring a change there follows the entry-scope reconciliation gate above. Create a new `## Rules` section only when required and none exists, never add a second heading or duplicate pointer.
- The snippets show a complete two-rule install. For per-file review, add entries only for successfully installed rules; preserve an existing entry for a skipped file, but never add a new one for it. If every file was skipped and no connection was selected, leave the entry untouched.
- When an existing review marker is at end of file, insert any new Rules/directives before it so it stays at the end without changing its value. Preserve an existing non-final marker's placement during targeted adoption; do not relocate it as unrelated cleanup. New knowledge files produced by log put their review marker last.
- If {adopt_file} exists: write silently — the install mode was already chosen in Step 3.
- If {adopt_file} does not exist: create it silently with the `## Rules` section and the required memory-owner bridge when the owner is a different file. Do not prompt and do not offer a manual-placement path — the pointer is required for the rules to load, so anything short of writing it leaves the install non-functional. The Report step notes that {adopt_file} was created.
- In a fresh or AGENTS.md-owned layout, the selected install/connection also creates a missing root CLAUDE.md containing the standalone `@AGENTS.md` import. Do this only after at least one rule was installed/preserved as Helm-managed or a valid connection was approved; never after all foreign files were skipped or an action was cancelled. If another Claude entry already exists, do not create an independent competing entry; direct the user to log's reviewed layout flow. Preserve an existing correct Claude adapter byte-for-byte.

### Copy or Update path

- Create `.claude/rules/` if it does not exist.
- For each of `git.md`, `safety.md`:
  - Read the selected source from `{rule_source_root}/rules/{name}`. Write only the files approved by the chosen mode or per-file review; skipped files and preserved current/newer copies must remain byte-for-byte unchanged. Per-file rollback approval covers only that named file and version.
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

For each Foreign file, collect the answer before any mutation. If at least one overwrite was selected, include a proposed action for a missing or outdated companion rule in the same reviewed plan, using the explicit per-rule Apply/Skip questions; it must not disappear merely because the aggregate state is CONFLICT. Preserve newer managed companion rules unless their rollback was explicitly approved. Never bundle a companion write into approval to overwrite a different file.

AskUserQuestion:
  question: "{file} already exists and was not created by helm. Overwrite it with the plugin's version?"
  header:   "Foreign file"
  multiSelect: false
  options:
    - label: "Overwrite"
      description: "Replace it with the helm version — adds the marker and the local ## Rules entry"
    - label: "Skip"
      description: "Leave your file untouched"

- On Overwrite → queue the named file for the Copy or Update path after all decisions are collected.
- On Skip → leave the user's file as-is. (To compare first, the developer can diff their file against the plugin source manually.)

If every foreign file was skipped, write nothing and create no entries; do not initiate companion repairs in this cancelled install. A skipped foreign file is not an installed Helm rule; disclose partial coverage rather than claiming both rules apply to both hosts. Do not add a pointer to it just to make Codex imitate Claude's native loading.

### Reference path

- Verify both stable marketplace targets and all entry dependencies before any deletion. Queue removal of Helm-marked local files at `.claude/rules/git.md` and `.claude/rules/safety.md`, covered by the chosen mode. Do not delete them until the full plan is approved and coherent.
- If either of these two local paths is Foreign, ask before removing it. Claude can load it natively while Codex follows only explicit pointers, so retaining it beside the marketplace rules cannot be treated as a shared installation. Leave every other file in `.claude/rules/` untouched.

  AskUserQuestion:
    question: "{file} is your own rule file. Keeping it could give Claude and Codex different instructions. Delete it for the reference switch, or keep it and stop this switch without changes?"
    header:   "Local rule file"
    multiSelect: false
    options:
      - label: "Delete it"
        description: "Remove your file so only the referenced plugin rules apply."
      - label: "Skip"
        description: "Keep your file and stop the entire reference switch without writes or deletions."

  On Skip, abandon the entire pending reference plan, preserving all local files and pointers, including earlier queued deletions. Report that shared reference setup is blocked pending a reviewed reconciliation; do not call the retained file shared or add a foreign-file pointer without approval. Run no-write cleanup only if no earlier mutation occurred.
- Once all decisions and dependencies pass, apply only the approved deletions and pointer patches. A failure stops with the exact pending state; no publication.
- Update {adopt_file}'s `## Rules` section (see *Updating {adopt_file}'s `## Rules` section* above) with this snippet:
  ```
  ## Rules

  This project follows the rules shipped in claude-helm:
  - ~/.claude/plugins/marketplaces/claude-helm/rules/git.md
  - ~/.claude/plugins/marketplaces/claude-helm/rules/safety.md

  At the start of every session, read the rule files at the paths above and follow them.
  If either path is missing, inform the user: "helm rules are referenced in {adopt_file} but the
  referenced Claude marketplace source is unavailable on this machine. Restore that source using
  Claude's plugin setup, or use Claude's adopt workflow to switch the shared installation to copies.
  Do not create competing copies or assume a Claude plugin command is available in Codex."
  ```

### No-change path

- For "Nothing" (in sync), "Keep project rules" (ahead), or "Keep references" (already in reference mode): make no changes and report the status (already up to date, project ahead of the installed plugin, or references kept). No files written. Proceed to Step 5 for cleanup.

### Cancel path

- Exit silently. No files written. Proceed to Step 5 for cleanup.

### Overwrite mapping

- "Update rules" (behind) runs Copy or Update for the approved older copies only, preserving current copies. "Review updates and rollbacks per rule" uses the per-rule repair questions, showing each old/new version and requiring a separate explicit choice for each rollback. No bulk choice may downgrade a newer file.
- "Switch to reference mode" runs the Reference path.

### Verification gate before Git finalization

After applying the reviewed plan, read back every written entry/rule and follow the actual directives from both host entries when present. A complete shared installation requires both entries and both expected rules; legacy adoption verifies only its approved entry/bridge and reports any missing host connection without creating an unauthorized entry. For a partial install, verify only approved installed rules and disclose which required rules are absent/skipped; never describe partial coverage as fully connected. Verify source content as well as the exact marker on each copied file, not just that a marker exists. Confirm all intended deletions, that no old pointer remains active, that skipped/preserved files and unrelated entries are unchanged, and that configuration, knowledge, review markers and existing adapters are preserved. A new shared adapter must import AGENTS.md with no duplicate Rules/settings. Respect active overrides and do not claim connection through a shadowed entry.

Any write, read-back, content, directive, or preservation failure blocks Step 5 commit/integration/publication. Report the actual pending files and branch; keep remaining originals intact. Successful verification is required **before** any commit, merge, push or promotion; Step 6 only summarizes that evidence. Recheck approved outputs before staging/commit and after any integration, so branch changes cannot bypass this gate.

## Step 5 — Commit and finalize

### Pending-work and no-op rules

A declined commit, failed write/read-back/staging/commit, unresolved policy change, merge conflict, failed push, or incomplete review/CI gate stops the affected finalization. A pending PR/review/CI gate blocks integration/promotion but still permits the separately approved review-branch publication and PR handoff below; it does not permit publishing the base. Preserve the actual current branch, drafts, index and successful prior operations. Report installed, committed, integrated and published status separately. Do not reset/stash drafts, continue promoting, delete branches, or return to the original branch with pending work. A cancelled push leaves verified local commits intact. Never infer success from having run a command.

No repository or no HEAD: report verified files as uncommitted; do not initialize Git, commit, push, or promote. Missing instruction files in a repository **with** HEAD never take this path.

No changes: skip commit/integration/push/promotion. If this invocation created an empty temporary branch, safely switch back first, then delete it with `git branch -d`. Otherwise leave branches alone. A blocked reference plan or all-Skip follows this path only when no mutation occurred, while retaining its blocked/partial report status.

### Commit verified adoption changes

Use the invocation's resolved `git-auto-commit`: true permits the scoped adoption commit silently; false/missing requires approval for the exact diff. If declined, stop with pending files, without integration or cleanup. Never interpret commit approval as push approval.

Stage only the exact approved entry, adapter, copied-rule paths and tracked rule deletions using literal pathspecs, for example `git --literal-pathspecs add -- {approved_paths}` and `git --literal-pathspecs add -u -- {tracked_rule_deletions}` when nonempty. Do not stage whole directories, operational state, unrelated changes or client settings. Inspect the staged diff against the verified plan before committing. Commit with a scoped Conventional Commit such as `chore(adopt): install shared Helm rules`, then verify the commit contains exactly the approved changes. A partial install's message/report must describe its actual coverage.

### Required CI and destination-policy gates

Before integration, resolve the destination branch's effective instructions/configuration read-only and compare with the invocation policy. Do not silently change ownership, merge strategy, or authorization after switching branches. Conflicting policies stop for reconciliation. Use the expected branch/HEAD and a clean index before each Git mutation; recheck output snapshots and effective instruction chains after a switch/integration. Installing rules never authorizes their policy to override an existing project's policy mid-run.

Apply applicable local quality checks before publication, then read `{package_root}/prompts/shared/ci.md`. Its integration gate covers the exact adoption tip and required PR/reviews; its promotion gate covers the exact published `{base_branch}` SHA. Respect provider-aware complete check coverage and no-waiver policy. This workflow's publication and destination-policy checks above remain in force.

### Solo Mode

The verified commit is already on `{base_branch}`. If there is no publication remote, leave it local and report push as N/A. Otherwise preview the exact destination, commits and diff, and ask a separate two-choice `Push {base_branch} now?` / `Leave local` question describing `git push origin {base_branch}` (or the explicitly configured publication remote). On decline/failure stop, with no promotion or cleanup. Verify a successful push by checking the remote ref equals the intended SHA, then freeze that published SHA for promotion.

### GitHub Flow

1. The verified adoption commit stays on `{branch}` until review and CI gates are satisfied. Never bypass PR requirements with a local merge. If the required PR/reviews are not yet available, offer `Publish branch and open PR` or `Leave branch local`. The question must explicitly describe the exact branch push; that answer supplies its push confirmation. On approval, push only `{branch}`, verify its remote SHA, then use an authenticated supported provider interface to open the PR against `{base_branch}`. If unavailable, leave the verified branch and give manual review instructions. Do not claim a PR exists unless creation succeeds; attach a created PR to the task when the host supports it. Report the PR/review/CI handoff and stop without merging, promotion or deletion. An existing PR for the exact tip is reused, not duplicated. No remote or declined branch publication leaves the committed branch local for review. The PR should state the configured merge strategy and actual full/partial rule coverage.
2. If review and CI gates are already satisfied for this exact tip, state the resolved `git-merge-strategy` (default squash) and apply it only through an integration path permitted by repository protection. Preview the exact integration diff and obtain any integration-commit approval required by `git-auto-commit` **before** a merge command/API can create a commit. If policy requires provider-side PR merging, first obtain the separate publication confirmation describing the base-branch update, then invoke that authenticated path with the selected strategy, safely fast-forward the local base and verify the integrated result. Missing capability leaves a review handoff, never a bypass. Where local integration is permitted after the PR gate:
   - `merge`: switch to `{base_branch}`, then `git merge {branch} --no-ff` with an approved scoped Conventional Commit message.
   - `squash`: switch to `{base_branch}`, run `git merge --squash {branch}`, then commit the approved result under the invocation's auto-commit policy.
   - `rebase`: rebase only this invocation's private, unpushed branch onto `{base_branch}`, then integrate with `git merge --ff-only {branch}`. A pushed/shared branch instead requires an explicitly reviewed rewrite plan or provider-supported PR rebase; do not rewrite it or force-push implicitly.
3. Stop on conflict or any failed operation. Verify the integrated content and both agents' instruction chains again before publication. Any integration commit still follows `git-auto-commit`; declining approval leaves pending work and stops. Do not integrate a newer/unreviewed branch tip or unrelated base changes without rechecking policy, CI and the reviewed diff.
4. For a local integration, ask separately before publishing `{base_branch}`, describing exact commits and `git push origin {base_branch}`. A decline/failure stops without promotion or deletion. A provider PR merge that publishes the base is also a push/publication action: describe that consequence and obtain its publication confirmation **before** invoking the merge API; do not add a second push of the same approved result. Verify the remote base SHA and integrated adoption contents. Freeze that published SHA for promotion. With no publication remote, report local integration only and retain the adoption branch.

### Environment promotion and cleanup

Promotion is this command's existing **fan-out** content sync from `{base_branch}`, regardless of release-pipeline configuration. Only a verified published base and passed/not-applicable required CI gate may reach selection. Discover qualifying environment branches through the configured remote as ship does. No qualifying branches means no promotion.

Ask which environments should receive the rule update; each option explicitly says `Merge {base_branch} into {environment} and push`. Use a multi-select for 2–4 branches, capped at four with recognized tiers first (staging/stage/uat/preprod, production/prod, then others alphabetically), disclosing any remainder for follow-up. For one branch use a two-choice Yes/Skip prompt. Preserve explicit none. The selection authorizes only those described merges/pushes, not an implicit deployment-policy waiver.

For each selected environment, recheck the published base SHA and CI gate, switch safely to an up-to-date destination, and check its instructions for conflicting policy without rewriting configuration. Merge `{base_branch}` with `--no-ff` and `chore(deploy): promote {base_branch} for Helm rule updates`, then push only after successful merge and verify the remote SHA. Return safely to `{base_branch}`. Stop on any failure, preserving actual state; report completed and pending targets separately.

Only after successful authorized finalization, a clean index/tree, and verified adoption content may cleanup run. Safely leave `{branch}` before deleting it. Delete this invocation's local branch only if its tip is an ancestor of `{base_branch}` and `git branch -d` succeeds. Squash/rebase can leave the old tip outside ancestry; retain/report it instead of using `-D`. Deleting a published remote branch requires its own explicit push confirmation. Never delete protected, existing, pending or unverified branches. Return to `{original_branch}` only when safe; report if retained work prevents that return.

## Step 6 — Report

Summarize the verification already completed on the adoption/integration branch before Git finalization, including actual rule content/markers and instruction chains. Do not make reporting the first read-back gate, or validate a different original branch after cleanup as though it were the adoption result. Report skipped foreign files separately without requiring Helm markers on them or claiming they were installed.

For a connection, summarize the verified readable chain from entry/adapter to owner and rules, preserved rule bytes/configuration/knowledge, and any approved missing-pointer edits. Report `connected` or `already connected`, actual entry/owner/adapter paths, actual rule versions/references, and files written, committed or pushed. Do not apply the copy/update marker check to this action. Do not report unavailable references or skipped foreign files as a successful Helm installation.

For every shared-layout install/connection, report the verified CLAUDE.md import of AGENTS.md with no duplicated Helm settings/Rules. Report any adapter creation and actual shared owner in addition to the outcome below. Existing reference-mode paths in the shared owner remain machine-local dependencies for both readers; do not claim cross-machine portability.

Print outcome.

Use the complete-outcome templates below only after the relevant installation and finalization gates pass. A verified installation awaiting review/publication uses the pending outcome instead. Legacy-only adoption must state that host scope explicitly.

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

For a blocked/pending/partial outcome, do not print an unqualified ADOPT COMPLETE. List missing/skipped rules, affected entries and actual branch, draft/commit/integration/publication status, PR URL if created, CI status and remaining action. Distinguish verified local installation from review or publication still pending. Do not stamp a partial install or broken reference as both agents connected.

For No-change (in sync or project ahead):
```
ADOPT COMPLETE — no changes
- Rules already at v{current_version} (in sync)         # in-sync case
- {name}: v{actual_marker_version}, {ahead / in sync / behind} source v{current_version}; left as-is  # one line per preserved rule in the ahead case
```

## Notes

- The marker line at the top of each copied file is required for future `/helm:adopt` runs to detect helm-managed files vs. user-managed files. Do not strip it.
- This command writes only `.claude/rules/`, the selected `{adopt_file}`, and a missing root CLAUDE.md adapter for fresh/AGENTS.md-owned setup in the current project. It does not migrate existing owners; use log for that reviewed change.
- This command may read a verified marketplace source in the user's `~/.claude/` directory; it never writes there or changes client/plugin settings. It never reads or migrates operational `.helm/` or legacy Helm state.
