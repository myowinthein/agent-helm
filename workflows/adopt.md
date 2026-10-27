# adopt

Install or update selected Helm rules as shared local copies in `.claude/rules/`. Claude and Codex use the same files. External installation/cache/GitHub references are unsupported; preserve any such pointers and stop with upgrade guidance before dependent writes. This command has no reference-mode converter or unavailable-external-target recovery.

## Question points

Use [QM](../prompts/shared/question-mechanism.md) at the existing gates below; ask only when their conditions hold.

| Point | QM form |
|---|---|
| Ambiguous project/adoption root or supplied copy source | Single for known candidates; Input for an explicit safe path or missing facts. |
| Populated directory without project markers | Include the directory warning in the concrete installation Review; no preliminary Continue question. |
| Installation, replacement, repair, connection or optional writing | Review of the shown bodies/diffs, versions and exact entry patches; approve all shown changes or an explicit subset. Preserve the Git/safety dependency. |
| Missing overwrite, rollback or pointer approval after changed inputs | Review only the new or changed effects; reuse unchanged concrete approval. |
| Local commit when approval is missing | Review of the exact adoption diff and commit. |

## Rule catalog and selection

Use this catalog for inventory, source validation, per-file decisions, copy/update, pointer handling and reporting. `{name}` is a catalog filename, never an arbitrary path. Do not infer a fixed two-rule installation from older copies or examples.

| Name | Packaged source | Shared destination | Purpose |
|---|---|---|---|
| `git.md` | `{package_root}/rules/git.md` | `.claude/rules/git.md` | Git/configuration/commit/publication policy, paired with safety. |
| `safety.md` | `{package_root}/rules/safety.md` | `.claude/rules/safety.md` | Operational boundaries, paired with Git policy. |
| `writing.md` | `{package_root}/rules/writing.md` | `.claude/rules/writing.md` | Independent guidance for clear, natural prose. |

- **New adoption:** when there is no established Helm rule installation, propose all three rules in the existing reviewed plan unless the developer explicitly scoped the request to particular rules. Show each body, destination and pointer; writing may be omitted before approval. Proposed defaults are not consent, and every foreign/custom-file decision still applies.
- **Existing installation:** inventory all catalog rows, preserving established Git/safety dependencies. If writing has no established Helm copy/pointer, list it separately as **new rule available, not selected**. In a general review, show its full body and exact pointer patch with the other proposals so Install writing / Not now is an installation decision, not permission to start another review. Explicit approval of all three shown rules covers it too. An explicitly scoped Git/safety connection or repair only reports this availability without an extra writing question. Never install it as a companion repair or upgrade side effect.
- **Already adopted writing:** apply the same marker/body, customization, rollback, missing-target and connection procedures as for any installed rule. A missing target for an existing writing pointer is a repair, not a newly available rule. A foreign file named writing.md is protected, not evidence of adoption.
- Keep the existing Git/safety pair usable without writing. Writing introduces no Git/safety dependency, setting, persistent selection/decline record or required third file. Not now/omission preserves files and pointers; offer again on a later applicable run without treating absence as a defect. No rule removal is offered.
- Carry each row's selection, established dependencies and actual installed/kept status through the plan. Verify connectivity only for the approved scope and existing dependencies; report unselected writing separately from skipped/broken selected rules. Never generate pointers from the catalog or directory contents alone: use verified managed copies or explicitly approved replacements and exact pointer patches. Presence or a basename alone is not ownership.

## Read-only preflight

Resolve the selected adoption root under **Before starting** and apply **Source-project and installation guard** before installation/connection proposals or Git preparation. Inspect an eligible consumer, then show concrete changes before asking to apply them. Reuse explicit Keep/Skip/Cancel answers without asking whether to review excluded work. Prepare Git only when the approved action needs writes.

Pass developer requests and answers safely and unchanged, never as shell code. An explicit source location is evidence to validate under Step 2, not permission to install/update plugins or change client settings. Clarify ambiguous requests before dependent work.

The initial preview permits dirty/staged/untracked files, feature branches, detached checkouts and no repository/HEAD. Label the inspected working tree, branch/SHA when available, adoption root and limitations. Assess this checkout, not an unseen base/upstream. Use local-only Git reads with `GIT_OPTIONAL_LOCKS=0` where inspection might refresh the index; suppress executable diff/textconv, pagers, filesystem-monitor helpers and lazy fetching with supported capabilities. Unavailable reads are unknown, not empty results.

Static preflight executes no project code, hooks, dynamic configuration, tests/discovery, linters, builds, installs or services. It performs no fetch, checkout, branch/index/ref/file/report-artifact write, publication or state access. Keep output in conversation. Report layout/source blockers and safe independent observations without following broken chains or escalating to writes. Whole-plan Keep/Cancel/no-action exits leave Git untouched. A later write requires Step 4's destination verification.

## Source-project and installation guard

Adopt is for consumer projects. It must not install copied rules or change instruction pointers inside Helm's own source project or a Helm package installation, even when the loaded package is older or newer than the target. Source rules are maintained directly through authorized development; adoption could instead activate stale copies and competing rule sources.

Use only read-only path/metadata and bundled-source evidence before any proposal or mutation:

- Resolve the selected adoption root and relevant enclosing workspace/project/Git roots to their physical paths, including existing symlinked parents. Compare with the actual loaded `{package_root}` and any selected alternative `{rule_source_root}` once resolved. A target at or below either package root is blocked. Do not traverse unresolved/unsafe paths or infer containment from a string prefix.
- At the selected root and its already identified enclosing workspace/project/Git roots, check for Helm's own package identity: a readable `.claude-plugin/plugin.json` with `name: agent-helm`, together with its canonical `workflows/adopt.md`, `skills/adopt/SKILL.md`, `prompts/shared/runtime.md` and catalog `rules/` sources. This also identifies renamed checkouts, clones, forks retaining that identity, and nested targets inside them; a nested `.git` never bypasses a proven containing Helm source root. Version equality, a particular remote or matching rule bytes are not prerequisites. Inspect this known layout only, without a directory crawl, client-cache search or operational-state access.
- A folder named `agent-helm`, existing adopted `.claude/rules/` copies, or an unrelated plugin project is not sufficient evidence. A consumer merely containing Helm as a nested dependency/package remains eligible when the actual adoption target is outside all protected roots. A disposable consumer fixture must likewise be outside the protected source/installation roots.
- On a protected target, explain the observed path/identity and stop without writes, Git preparation, copied-rule creation, instruction/bootstrap/pointer edits or cleanup. State that this source project should load its maintained source rules directly, or that an installation is not a consumer project; direct testing to a separate consumer fixture. Do not offer Continue anyway, a version override or automatic relocation/update/removal of existing copies.
- If relevant identity, containment or symlink evidence leaves a material ambiguity, report the unresolved target and stop dependent adoption rather than treating it as an ordinary non-project directory. Resolve only the missing scope facts through the existing clarification path; no bypass approval or new persistent record is introduced.

Reapply this guard after a target/source change and at the existing destination recheck before any write. It adds no restriction on ordinary authorized maintenance of Helm source files and invokes no other workflow.

## Entry files and host scope

Resolve `{memory_file}` with the shared runtime before the branch checks below. In the shared layout, `{adopt_file}` is the root AGENTS.md owner on either host, not the CLAUDE.md adapter. With neither file, bootstrap AGENTS.md plus a real CLAUDE.md containing only `@AGENTS.md`. With an AGENTS.md owner and no Claude entry, create that adapter as part of the chosen installation/connection. Only patch Helm's rule entries in the owner; preserve configuration, review markers and unrelated instructions. Never put a second Rules section into the Claude adapter.

A resolved CLAUDE.md-only owner, independent roots or partially shared setup needs log's reviewed shared-layout onboarding before adoption writes. Preserve existing instructions and report the required local setup; do not create a reverse bridge. Fresh projects with neither file and AGENTS.md-owned projects retain the limited bootstrap/adapter handling below.

If CLAUDE.md imports AGENTS.md but still holds shared Helm settings, adopted Rules or a review marker, it is only partially connected. Stop before branching or writing and direct the user to log's reviewed reconciliation; do not add a second owner/pointer set and discover the mismatch only during final verification.

On either host, check for a root AGENTS.override.md before branching. If it explicitly reads AGENTS.md, adoption may update that persistent entry while preserving the override and reporting host-specific policy. Otherwise stop and explain that the override shadows AGENTS.md: the user must explicitly connect the persistent entry from the override or resolve it before retrying. Do not write an inactive AGENTS.md and claim shared setup succeeded, and do not edit or commit the override on the user's behalf.

Read the resolved owner, applicable entries/bridges and scoped project-rule dependencies to inventory actual local Helm targets, including exact pointers outside `## Rules`. Use `{adopt_file} = {memory_file}`, never a second host-specific owner. Preserve custom/global/nested instructions. An external Helm pointer stops dependent writes with upgrade guidance; do not read its target or convert it here.

Adopt owns no operational state. Do not inspect, create, stage, or migrate `.helm/`, `.claude/helm/`, or protected unsupported ledger paths. `.claude/rules/` is active shared rule storage.

## Before starting: scope and policy, without Git preparation

State the invocation directory, enclosing Git/workspace root if available, and `{adoption_root}`. Resolve entries and `.claude/rules/` relative to the selected adoption root, and Git operations in its verified enclosing working tree. Pointer text resolves from the referring owner: for an allowed in-project non-root owner compute/review the relative path to those same physical local copies, rather than creating another rule directory (for example `../.claude/rules/git.md`). An external owner requiring a write outside the selected project remains blocked for placement reconciliation; no outside write or implicit owner move.

An existing unambiguous owner or explicit project selection may establish scope. Otherwise, if a nested package and repository root are both plausible, ask which project to adopt into before dependent work; never silently use the shell directory or Git root. Inspect relevant ancestor/nested entries, `.claude/CLAUDE.md`, `CLAUDE.local.md` and active overrides when they affect that scope. Do not scan global settings/instructions or claim all nested/custom rules are shared.

Resolve local `git-auto-commit` (default false), effective ownership/bridges/overrides and applicable project instructions before writes. Ship settings do not select an adoption branch or publication flow. Missing entries mean absent settings, not absent Git history; never create declarations merely to apply defaults.

Record Git/HEAD/branch and whether a write would be eligible, without switching/updating branches. No repository or no HEAD remains a bootstrap with files left uncommitted, never `git init`. An ambiguous/missing main/master base, current branch other than actual main/master, dirty/index/untracked work, detached HEAD, in-progress merge/rebase/cherry-pick/revert, or affected branch held by another worktree blocks the affected Git-backed write, not an advisory inspection. Never stash, reset or commit user work to satisfy a prerequisite. Snapshot inspected entries, overrides, source/rules and absent targets for the preview; a preview does not certify the later destination.

## Step 1 — Sanity check

Before any Git preparation, check whether the selected adoption root looks like a project — any of:
- `.git` (directory or worktree file)
- `CLAUDE.md` or `AGENTS.md`
- `package.json`, `composer.json`, `Cargo.toml`, `pyproject.toml`, `go.mod`

Decide based on what is present:
- **Project markers found** → proceed.
- **Empty directory** (no project markers and no other files) → proceed silently. This is a plausible fresh-project setup with nothing to clobber.
- **Non-empty but no project markers** → warn that this may be the wrong directory. Include its exact path and the warning in Step 3's installation proposal, then ask Install shown rules here / Cancel once. That approval covers both placement and the shown changes, not unrelated existing files. Ambiguous roots and protected targets still stop under their own guards; no separate Continue question precedes the proposal.

If a destination recheck reveals a new sanity blocker, stop dependent writes and refresh only the affected placement/content decision.

## Step 2 — Scan existing rules

Inventory actual directives/imports for each catalog rule in the owner and applicable entries. Resolve local targets relative to the referring file; quoted examples are not pointers. Classify local, missing/dangling and custom/unknown targets separately. Report a known external installation pointer as unsupported and block dependent work, without fetching/loading its target.

Establish managed local ownership from exact directives, a recognized leading agent-helm marker and actual body evidence, or explicit confirmation of the exact project-local span. Basenames, directory prefixes and another plugin's mention do not establish ownership. Name unknown/custom files explicitly in the proposed overwrite; unavailable local bodies block a claimed comparison.

Classify each catalog destination `.claude/rules/{name}` separately, including unselected writing without treating it as required:

- **Helm-marked:** its entire first line is `<!-- helm-rule: agent-helm@v{X.Y.Z} -->`. Record its numeric version, never assume pristine content/authenticity.
- **Foreign:** an existing file without a valid leading Helm marker; require explicit named overwrite approval through Step 3.
- **Absent:** no file; a dangling local pointer is a repair, not an installed rule.

Use one per-rule table for local status, marker/body relation, pointer spans, source, selection, proposed action, approval and dependencies. Missing selected companions remain visible. Unsupported external dependencies are blockers rather than a conversion display mode.

### Source required by the selected action

On **both** hosts default `{rule_source_root}` to the actual loaded `{package_root}` resolved through the runtime, with `current_version` from its `.claude-plugin/plugin.json`. Verify manifest name `agent-helm`, a usable numeric version and readable catalog sources required by the selected copy/update and its dependencies within that verified package root; freeze their exact bytes. Source absence blocks the affected source-dependent action, never Keep/connection to valid existing copies or an unrelated action merely because writing is unselected. Do not prefer a Claude marketplace checkout, guess a Codex/Claude cache, enumerate installations or install/update a plugin to find a copy source. Package identity is observed evidence, not authentication.

Use an unambiguous developer-supplied alternative package after the same manifest/rule/containment validation; disclose differences from the loaded package in the proposal without another source-confirmation gate. Ask only for conflicting or ambiguous source choices. Never mix packages or silently fall back from an invalid selected source. This choice creates only local copies, never a persistent installation/URL pointer.

Copy/update and missing-local-copy repair require a valid selected copy source. Keep or connection-only to readable managed local copies needs no unrelated update source; unknown comparison remains unknown, never current/in sync. Do not require another client or marketplace installation.

### Content and version are separate evidence

For a marked local copy, remove **only** the recognized first marker line and its actual line terminator for comparison. Compare the remaining bytes with the selected source rule bytes, without trimming blank lines, normalizing line endings/BOMs or ignoring prose. Preserve the original bytes for every Keep/Skip action. Use this same comparison for post-write verification; new copies are exactly the new marker plus `\n` plus the frozen source bytes.

- **Content-equivalent:** body equals the selected source. An older/differently branded marker alone requires no rewrite, marker refresh or commit; report that marker separately.
- **Different / customization unknown:** body differs, including equal-version differences. Without an already available verified historical baseline, a pristine old copy cannot be distinguished from local edits. Never call it pristine or authorize replacement/deletion from its marker. Do not fetch, construct or check out an old baseline. A verified baseline already supplied may inform the diff, never bypass approval.
- **Unknown:** comparison/source/read unavailable. Preserve the file, report the limitation, and allow only otherwise valid Keep/connection actions until a source-dependent action can be reviewed.
- **Absent / foreign:** retain those per-file distinctions and identify each proposed replacement explicitly. Unknown markers remain foreign; an existing filename or recorded version alone never establishes ownership or permits overwrite.

Show the raw before/after diff for each proposed replacement and the complete proposed file for a missing copy. An unreadable existing body leaves its replacement pending. A short summary may explain changed Git, commit, safety, CI or ownership obligations, but never substitutes for the diff.

Identify every different/uncertain body and any proposed rollback by file and old/new version. Approval may cover all shown replacements or an explicit subset in one answer; separate prompts per file are not required. Keep preserves bytes and existing pointers. Never merge policies automatically or infer replacement permission from an older marker.

Report Fresh (no files/pointers), Update (managed local copies), Conflict (foreign files/competing targets) and Repair (missing local dependencies) as display summaries. Unsupported external pointers stop for explicit maintenance outside adopt. Preserve the exact per-rule evidence and requested scope.

Content-equivalent local bodies retain exact bytes/markers even when older or newer; never offer a downgrade merely to refresh a marker. A proposed replacement with a lower version needs explicit rollback disclosure. Missing comparison data permits valid local Keep/connection choices, never a current/in-sync claim. No new provenance ledger is introduced.

### Static destination checks

For the exact paths in the per-rule proposal, inspect containment, symlinked ancestors/destinations, case-insensitive filename/directory collisions, non-file targets and existing tracked/untracked occupants. Unexpected occupants are protected, never automatically adopted or replaced. With Git available, inspect ignore/tracking evidence without refreshing the index: an ignored required output or a required untracked file omitted from the proposed commit is a publication blocker. Newly created untracked outputs explicitly included in the plan are normal. Never force-add or edit `.gitignore` to hide the problem. Report these blockers; without Git or resolved scope, report unavailable checks. Repeat these observations on the prepared destination and immediately before writes.

## Step 3 — Show changes and obtain direct approval

Show every catalog row: local path/status/marker/body relation, actual effective target(s), loaded/selected copy source and comparison limitations. Then show the proposed source bodies or raw diffs and exact pointer/adapter patches before the first action question. Distinguish proposed updates from optional unselected writing. Updating shared copies affects both clients using them.

Ask directly about the shown effects, using applicable choices with at most four options. Do not insert Review updates first, a rule-selection gate before showing content, or a final confirmation of already approved changes. Keep every file/action identifiable; allow an explicit subset through custom text or a faithful QM selection. Choosing which displayed actions to apply authorizes only those exact actions, not unseen changes.

| Situation | Choices and protections |
|---|---|
| Fresh | Show the proposed rules and minimal instruction entries, then Install shown rules / Cancel. Allow explicit omissions in the same review; no later per-file installation questions. |
| All required bodies equivalent and connected, including older/newer markers | Preserve files/markers and report no changes without a question. Handle optional new writing separately below; its absence is not a repair. |
| Kept or equivalent managed copies need an entry/adapter | Show only the exact entry patches, then Apply connection / Skip / Cancel. Preserve rule bodies and markers; no update source or replacement decision is required. |
| Different managed bodies | Show the named body diffs and entry changes, then Replace shown rules / Keep existing / Cancel. An explicit subset is valid; do not ask again for each approved file. |
| Missing copies or directives | Show the complete missing bodies and entry patches, then Apply repairs / Skip / Cancel. Include required companions in the proposal, never silently add them after approval. |
| New writing available in an existing installation | In a general review, show its full body and pointer patch, then Install writing / Not now. Explicit Git/safety-only scope just reports availability. No later installation approval follows. |
| A proposed body replacement would downgrade a managed copy | Show the exact named downgrade, old/new versions and diff, then Replace with shown version / Keep existing / Cancel. A concrete answer can approve multiple explicitly listed downgrades. |
| Foreign local files selected for adoption | Show the named custom-file diffs, replacement effects and any required repairs, then Overwrite shown files / Skip / Cancel. Never infer overwrite permission from a filename or general install request. |
| Copy source or comparison unavailable | Keep bodies unchanged. A valid connection can use its direct patch approval; source-dependent replacements/repairs stay pending, with no speculative install question. |
| External references | Stop with upgrade guidance; preserve pointers and installations. |

Use one concrete review for mixed cases: name every update, repair, connection, optional addition and retained file. Approval can cover all shown actions or exact IDs; state whether each combined choice includes writing. An answer such as "apply all three" after all three bodies/diffs and entry patches were shown approves those exact actions. Preserve exclusions; keeping one rule does not cancel another approved action. If the user only asks to inspect or choose, ask which shown actions to apply, not another approval afterward. Clarify conflicting/incomplete answers or missing required dependencies without silently broadening scope.

A whole-plan Keep/Cancel/no action exits without Git preparation or new entries. If all foreign files are skipped and no independent writing addition or valid connection was explicitly approved, write nothing, including adapters/companion repairs; this is not a complete shared Helm installation. An explicitly accepted writing-only addition can proceed under its own exact reviewed scope, without silently installing/repairing the skipped Git/safety pair or claiming its coverage.

For partial ordinary local repairs, preserve each Skip and existing pointers; add no pointer to an uninstalled foreign file. Broken/shared-version dependencies stop the affected plan before writes. Do not rename/delete existing files or add client-specific rule copies to make the table look complete.

## Step 4 — Execute

### Verify the approved destination

With no approved changes or a whole-plan Cancel, stop without checkout/fetch/branch creation. For approved writes, reapply **Source-project and installation guard** and verify target containment, symlinks, collisions and ignore status. Unchanged evidence needs no new plan or question; these checks grant no additional scope.

Only **no repository or no HEAD** skips Git preparation: freeze the selected project's snapshots and later leave files uncommitted, without initializing Git or inventing a base. Preserve existing originals; Git recovery may not exist. A repository with HEAD still requires current-base write eligibility even with no instruction files.

For Git-backed writes, record `{original_branch}`, require an attached branch, clean index/worktree including untracked project work, no in-progress operation, and no conflicting worktree checkout. Resolve `{base_branch}` to the actual `main` or `master` from policy/default/existing refs; ambiguous/missing identity blocks the write. Use that exact name for current-branch eligibility. No automatic stash/reset/commit or unrelated cleanup.

Require the current actual main/master base for Git-backed writes; block elsewhere and explain without checkout/update/branch creation. Record current `{branch}` and `{original_branch}` as the same branch. No-Git/no-HEAD bootstrap remains uncommitted. Existing copied rules that mandate old branching need explicit reviewed replacement/reconciliation, not a silent bypass.

Before local writes, re-read the actual entries, owner, chains, relevant overrides/native project entries and effective settings. Reapply all layout/sanity/scope gates. Conflicting ownership/policy/dependencies stop without writes. Compare with the reviewed destination/snapshot/actions; matching inputs proceed under the existing approval. If relevant inputs changed, refresh only the affected proposal and obtain missing authorization, never reuse approval from a different branch/HEAD. Freeze invocation policy: newly installed rule text cannot silently govern this run's finalization or weaken active safety rules.

Snapshot the relevant entry/override/source/rule bytes and absent targets on this destination. Before any write, check each exact planned path for ignore status, existing tracked/untracked occupants, case-insensitive filename/directory collisions, non-file targets and symlinked/escaping destinations. New untracked files explicitly in the plan are expected, not a blanket blocker. Unexpected occupants invalidate the plan.

Ignored outputs needed for a committed installation must be reported for explicit resolution or leave the action blocked, never force-added or accompanied by an unapproved `.gitignore` edit. Do not commit pointers to required ignored/untracked rule files omitted from the same approved local installation. Without Git, disclose that tracking/ignore checks are unavailable rather than inventing a pass; entry/rule preservation and target checks still apply.

### Plan before mutation

Before any mutation, reconcile the answer with the shown rule actions, pointer patches, entry/adapter creation and retained/missing rules. Reuse approval of the whole plan or named subset; no additional per-file or overall confirmation follows unchanged approval. A request received before the actual contents were shown does not authorize unseen overwrites: show them in the first direct review. Recheck branch, policy, source bytes and target snapshots immediately before writing. Changed inputs or a conflicting pointer stop dependent work. Reject targets outside the consumer project or through symlinked destinations; never modify another checkout or plugin installation.

Include all affected-rule local install/update/repair decisions; a blocking required rule stops the affected plan before writes. Raw before/after diffs are authoritative. Retained/customized bodies keep their markers; no automatic merge or marker-only refresh. Freeze each new rule body/marker and each exact pointer/adapter patch for execution and readback.

Cancellation before mutation writes nothing. If a later write/read-back fails or the user stops after mutation began, preserve the actual drafts and remaining originals, report pending work, and do not fall through to a no-change exit, commit, or cleanup. Never reset unrelated work to simulate an atomic rollback.

### Updating {adopt_file}'s `## Rules` section

Copy/update and connection patch only approved exact Helm pointer spans in the owner. Use this procedure whenever a path updates the `## Rules` instructions:

- Identify candidate Helm entries by exact resolved catalog destinations from the reviewed inventory, then confirm managed ownership or the explicitly approved replacement. A directory prefix, basename alone, quoted example, or mention of another plugin does not establish ownership. A foreign `.claude/rules/writing.md` is not automatically a Helm pointer. Preserve custom entries such as `.claude/rules/security.md` byte-for-byte. Change only the approved Helm pointer spans, preserving user prose, other imports, existing Skip pointers, and section order. If a line combines Helm and unrelated instructions and cannot be patched unambiguously, stop for a reviewed patch instead of replacing the line/section wholesale. Reuse effective pointers outside this section; changing a local outside-Rules pointer span requires its exact patch in the reviewed **Plan before mutation**; otherwise stop for reconciliation. Create a new `## Rules` section only when required and none exists, never add a second heading or duplicate pointer.
- The snippet shows a full three-rule install. Add entries only for successfully installed or verified managed copies whose connection was approved, never from the catalog or filenames alone. Preserve an existing entry for a skipped file, but never add a new one for it. Omit unselected writing from new directives without deleting an established pointer. If every file was skipped and no connection was selected, leave the entry untouched.
- When an existing review marker is at end of file, insert any new Rules/directives before it so it stays at the end without changing its value. Preserve an existing non-final marker's placement during targeted adoption; do not relocate it as unrelated cleanup. New knowledge files produced by log put their review marker last.
- If {adopt_file} exists, apply only the exact pointer diff already reviewed; do not infer ownership or permission from a generic install intent.
- If neither instruction owner exists, create only the minimal AGENTS.md Rules content already shown in the approved install plan and the approved CLAUDE.md adapter. No additional question is needed for these unchanged already-approved contents; an unspecified entry diff still needs review.
- In a fresh or AGENTS.md-owned layout, the selected install/connection also creates a missing root CLAUDE.md containing the standalone `@AGENTS.md` import. Do this only after at least one rule was installed/preserved as Helm-managed or a valid connection was approved. An all-foreign Skip without an independently approved writing addition/connection, or a cancelled action, creates no adapter. If another Claude entry already exists, do not create an independent competing entry; direct the user to log's reviewed layout flow. Preserve an existing correct Claude adapter byte-for-byte.

### Copy or Update path

- Create `.claude/rules/` if it does not exist.
- For each selected catalog rule approved for copying/updating:
  - Read the frozen selected source from `{rule_source_root}/rules/{name}`. Write only the exact approved rule bodies and versions, whether authorized together or as a named subset. Skipped/kept copies and content-equivalent bodies remain byte-for-byte unchanged regardless of marker age. No unapproved replacement, companion or downgrade follows.
  - Prepend exactly `<!-- helm-rule: agent-helm@v{current_version} -->` followed by `\n`, then the unchanged source bytes. Do not normalize source line endings or add another blank line.
  - Write to `.claude/rules/{name}`.
- Read back each approved copy and verify exact marker/body before patching pointers. Then update {adopt_file}'s `## Rules` section and approved adapter/bridge (see above), read back the resulting chains, using this root-owner snippet for a full install (adjust only the reviewed relative path for an allowed non-root owner):
  ```markdown
  ## Rules

  This project follows the rules shipped in agent-helm:
  - .claude/rules/git.md
  - .claude/rules/safety.md
  - .claude/rules/writing.md

  At the start of every session, read the rule files at the paths above and follow them.
  ```

A failure between local copy readback and pointer update leaves a partial installation. Preserve actual files and report missing connections; do not reset user work, run hooks/reloads or declare both clients connected during that transition.

### Connect agents without rewriting rules

Use this path for in-sync copies, keeping newer project copies, or a missing Claude adapter on a shared owner. Verify the actual rule paths first. In a canonical layout, preserve AGENTS.md byte-for-byte when its pointers are already correct; otherwise add only missing explicit Helm-rule directives to it, preserving its configuration and knowledge. Add a missing CLAUDE.md import adapter, never duplicate rule pointers into it. Existing noncanonical ownership needs log's reviewed setup first.

Record the action as `connected` (or `already connected`), not as a rule copy/update. Do not convert external pointers, delete files, rewrite markers or fall through into Copy or Update from this connection-only action. Do not require or install absent unselected writing to reconnect the Git/safety pair. Report the versions actually present; keeping newer copies must not be reported as a rollback to the loaded plugin version.

### Customized files and required companions

The direct review must name every foreign/custom file being overwritten and every companion repair or rollback, with their actual diffs and entry changes. Explicit approval can cover these named effects together; approval of one file never silently adds another. Writing stays independent. Missing comparison evidence blocks an overwrite, not valid Keep/connection actions.

Skip preserves that file and its existing pointers; add no new pointer to an uninstalled foreign file. Kept customized managed bodies likewise remain unchanged. No automatic policy merge follows.

If every foreign file was skipped and no independent writing addition or valid connection was explicitly approved, write nothing and create no entries; do not initiate companion repairs in this cancelled install. A skipped foreign file is not an installed Helm rule; disclose actual coverage rather than claiming the catalog applies to both hosts. Do not add a pointer to it just to make Codex imitate Claude's native loading. Existing unselected foreign writing stays untouched and outside Helm's installation claim.

### No-change path

- With no approved changes, preserve all files and report actual content/marker/source evidence, including unknown relations. No Git preparation for a normal preflight exit. If a destination recheck finds no remaining action, Step 5 reports no local changes without cleanup. Keeping selected bodies never discards an independently approved writing addition or connection. A current-checkout preview does not certify unseen base/upstream content.

### Cancel path

- Before preparation, exit without files or Git mutations. After preparation, no-write exits leave the same branch untouched. After any mutation/failure, preserve actual pending work instead of calling it Cancel/no-change.

### Verification gate before Git finalization

After applying the reviewed plan, read back every written entry/rule and follow both applicable root chains. Verify each selected/established required local rule, expected new source bytes/markers and kept-copy snapshots. A new shared adapter imports AGENTS.md without duplicated Rules/settings. Preserve knowledge, settings, review markers, existing adapters, custom/skipped entries and active overrides. The Git/safety pair remains complete where selected; absent unselected writing is not a defect. A partial install reports missing dependencies and never claims both hosts connected. Unsupported external pointers cannot pass this gate; there is no conversion outcome. No unexpected deletion or unrelated pointer change is permitted.

This gate proves **static inspected-root Helm connectivity**, not actual native startup loading, model compliance, or parity of custom/global/nested rules. Preserve the AGENTS.md owner, real CLAUDE.md adapter and explicit Codex read-and-follow directives; do not inline rule bodies into the owner. Claude's native rule discovery and Codex's explicit reads differ. Relevant known import-depth/trust/exclusion/override issues must be reported, never bypassed by editing client settings.

Codex's discovered startup instructions have a configurable combined byte limit (32 KiB by default); if already inspected instructions approach/exceed that default, warn that tail directives may be truncated. A small owner is not proof it fits after other instructions, and no fixed default is a universal failure gate. Do not read/write global settings solely to quantify the budget. Recommend a fresh session after instruction changes; native/runtime loading remains unverified unless separately observed, never assumed from readable paths.

Any write, read-back, content, directive, or preservation failure blocks Step 5 local commit. Report the actual pending files and branch; keep remaining originals intact. Successful verification is required **before** any local commit; Step 6 only summarizes that evidence. Recheck approved outputs/policy before staging/commit; no branch change occurs.

## Step 5 — Commit and finalize

### Pending-work and no-op rules

Failed/declined writes, verification or commits preserve actual files/index/current branch and earlier successful work. Report partial/draft/pending status. On continuation, reconcile completed outputs and perform only missing approved actions; changed inputs need the affected review, never a blind retry. No reset/stash/absorption or branch cleanup. No changes means no commit. No repository/HEAD keeps verified outputs uncommitted without initializing Git. Local completion needs no remote/provider access.

### Commit verified adoption changes

Use the invocation's resolved `git-auto-commit`: true permits the scoped adoption commit silently; false/missing requires exact commit approval, reusing any already supplied with the reviewed plan. Install/replace approval alone does not approve a commit. An explicit leave-uncommitted choice finishes with drafts and no repeated commit question. Never interpret commit approval as push approval.

Stage only the exact approved owner, entry/adapter/bridge and local-rule paths using literal pathspecs, for example `git --literal-pathspecs add -- {approved_paths}`. This workflow has no rule-file deletion action; unexpected staged deletions block the commit for reconciliation. Resolve those paths from the selected adoption root into the verified Git working tree's path namespace, especially for nested projects; never accidentally stage the root's similarly named files. Do not stage whole directories, operational state, unrelated changes or client settings.

Inspect the staged diff against the verified plan before committing. Commit with a scoped Conventional Commit such as `chore(adopt): install shared Helm rules`, then verify the commit contains exactly the approved changes. A partial install's message/report must describe its actual coverage.

### Verify and finish locally

Apply configured local checks relevant to the exact rule/entry changes under project policy; never install tools or run unrelated application suites just because rules changed. Report performed/passed, failed, configured-but-unavailable, not configured with evidence and user-deferred separately. Deferred verification is not passed; preserve local work and name unmet gates. Revalidate current instructions/policy and approved rule bodies before claiming local installation complete.

Finish on the current branch. Never offer a push/PR, integrate/promote, create/switch/delete branches or perform cleanup/return checkout. Invoke ship separately for publication. Installing updated rules never silently overrides stronger active project policy; old copied branch rules require explicit reviewed update/reconciliation. Read-only Keep/Cancel/no-op remains a no-write exit.

## Step 6 — Report

A current-checkout Keep/Cancel/no-action report identifies the inspected root/branch/SHA, inventory/content evidence and known blockers/unknowns. State that no Git preparation occurred; never certify an uninspected base or upstream or print ADOPT COMPLETE for an incomplete installation.

Summarize the verification already completed on the current adoption branch before local completion, including actual rule content/markers and instruction chains. Do not make reporting the first read-back gate, or validate a different original branch after cleanup as though it were the adoption result. Report skipped foreign files separately without requiring Helm markers on them or claiming they were installed.

Reuse the per-rule rows: recorded marker, actual body relation, observed/reference source and selected copy source, selection/action/decision and preserved/missing coverage. Name writing as installed, retained, selected-but-pending or available/not selected as applicable; never call unselected writing a broken Git/safety installation or stamp it with a copied version. Distinguish content-equivalent older markers from real content updates; list customized/unknown kept bodies honestly. Without a valid comparison source, say unknown rather than current. Separate static local installation, drafts, verified commits and actual/unperformed checks. Publication, integration and promotion are not performed. List passed/failed/unavailable/not-configured/user-deferred checks with their scope; never turn deferred runtime/testing into a pass.

For a connection, summarize the verified readable chain from entry/adapter to owner and rules, preserved rule bytes/configuration/knowledge, and any approved missing-pointer edits. Report `connected` or `already connected`, actual entry/owner/adapter paths, actual rule versions/references, and files written or committed locally; publication not performed. Do not apply the copy/update marker check to this action. Do not report unavailable references or skipped foreign files as a successful Helm installation.

For shared setup report actual owner/entry paths and the verified CLAUDE.md import of AGENTS.md without duplicated shared Rules/settings. State **statically connected for the inspected root Helm rules; fresh session recommended; runtime loading unverified** unless separately observed. Custom/global/nested parity is outside that claim.

Print outcome.

Use the complete-outcome templates below only after the relevant installation and finalization gates pass. A verified local installation can complete without publication; incomplete rule connectivity, unapproved edits or failed required local verification remain pending.

For a local-rule connection on either host:
```text
ADOPT COMPLETE — {statically connected / already statically connected}
- Entry:    {adopt_file} — {created / updated / unchanged}
- Owner:    {memory_file} — preserved
- Rules:    {shared local paths and actual recorded versions, resolved through the preserved owner}
- Committed: {yes / no}
- Publication: not performed; run ship when ready
```

For Copy/Update:
```text
ADOPT COMPLETE — static installation verified
- {written_name} {written / updated} → .claude/rules/{written_name} (v{current_version})
- {skipped_name} skipped (foreign, unchanged; not installed)
- {adopt_file} {created / updated / unchanged}: {only the successful rule pointers changed, or no entry changes}
- Publication: not performed; run ship when ready
```

Include one written/updated line per file actually written, and one skipped line per foreign file left untouched. Omit inapplicable lines; never attach the plugin version or a copied-file claim to a skipped file.

For a blocked/pending/partial outcome, do not print an unqualified ADOPT COMPLETE. List missing/skipped rules, affected entries and actual branch, local draft/commit status, verification limits and remaining action. Distinguish verified local installation from required local review/checks still pending. Publication is a separate later ship action. Do not stamp a partial install or broken reference as both agents connected.

For No-change (prepared destination verified or explicitly scoped current-checkout snapshot):
```text
ADOPT NO CHANGES — {current-checkout snapshot / verified prepared destination}
- {name}: marker v{actual_marker_version}; body {equivalent / different / unknown}; source {path/version or unavailable}; preserved
- Git: {same current branch / no repository; no branch creation or cleanup}
- Connectivity: {inspected root chain status}; runtime loading unverified
```

## Notes

- Keep the leading marker on a copied file as recorded-version evidence. It never proves a body is pristine or disposable. Preserved managed markers stay unchanged; differing marked bodies require review before replacement. Adopt has no delete-to-reference path. Adopt does not merge policy files automatically or add a provenance ledger.
- This command writes only approved catalog copies at `.claude/rules/{name}` and owner pointers, a missing root CLAUDE.md adapter for fresh/AGENTS.md-owned setup. It creates no host-specific second rule copy and deletes no rule or external source. It does not migrate existing owners; use log for that reviewed change.
- Read only the verified selected copy package and scoped existing project copies for comparison. Never write installations, search homes/caches, remove checkouts or change client/plugin settings. Plugin updates do not silently update copied project rules; rerun adopt for reviewed updates. Adopt never reads operational state.
