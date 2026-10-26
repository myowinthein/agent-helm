# archive

Preserve a selected old project, its working environment and useful recovery evidence. Source preservation, frozen-runtime recovery, offline rebuilding, backup coverage and archive publication are separate results.

## Question points

Use [QM](../prompts/shared/question-mechanism.md) at the existing gates below and throughout all five supporting steps; ask only when their conditions hold.

| Point | QM form |
|---|---|
| Actual source branch/full HEAD and excluded work | Review Proceed on this branch / Cancel before pending phases. |
| Recovery goal/features, optional offline goals and missing setup/data facts | Single for alternative goals/data routes; Multi for independent optional scope; Input for missing nonsecret facts/safe supplied paths. |
| Each phase's proposed actions and exact report | Review at its existing separate plan/report gates. No combined blanket approval across phases. |
| Restoration feedback/developer check and freeze approach | Single Check / Decline / Defer as applicable, then Input for feedback and Single for actual freeze alternatives; execution retains Review. |
| API materials Retain / Repair / Create / Skip and useful optional companions | Single per actual artifact; independent optional outputs use Multi within the reviewed phase plan. |
| Protected output alternatives, documentation/consolidation, storage per artifact | Single for safe placements/storage routes; Input for custom paths; Review for exact content/moves/exclusions. |
| Cold rehearsal, requests/imports, image exports, service stops and local payload commit | Review of the exact existing action/target gate. Local preparation never asks to publish. |

## Before starting: recovery goal and policy

Apply the shared runtime and resolve `{memory_file}` before Git actions, following bridges, overrides, and recognized configuration blocks. Configuration remains in that owner, normally AGENTS.md through CLAUDE.md's import on Claude or directly on Codex. Archive does not create, move, consolidate, or edit either instruction entry or Helm settings. Its explicitly confirmed local payload uses the current selected source branch; remote backup publication is separately approved through ship; do not silently apply a normal development branch/commit policy or let auto-commit bypass archive approvals. Resolve conflicts with active project rules before mutation.

Follow the existing five approved report phases below. A request to resume follows validated actual progress; it never starts another restoration automatically. Pass developer requests and answers unchanged, never as shell code.

Before source-branch confirmation, perform only the stated local read-only prerequisite/ref inventory and root/progress validation. No project code/configuration/hooks, collection, analyzers, tests, installers, builds, containers, service requests or dry-runs are executed, and no network/fetch, checkout, branch/index/ref/file/report writes or state migration occurs. Use local-only Git reads with `GIT_OPTIONAL_LOCKS=0` where relevant; suppress executable diff/textconv, pagers, filesystem-monitor helpers and lazy fetching with supported capabilities. Unavailable reads leave explicit limits. Step 1 exploration remains local and static; later actions require their own reviewed scope and approval.

Run from the attached branch representing the complete project. Require a repository with HEAD, no in-progress Git operation, and record the selected source branch/commit. Reconcile pre-existing index/worktree changes before altering them; never reset, stash or absorb them automatically. Inventory unmerged local branches, tags, submodules, LFS and relevant hosted artifacts read-only; state what this source-only seal excludes. Let the developer merge needed source work and rerun, or separately review additional preservation inputs. Never merge on their behalf. Never create or switch branches during this command.

Step 5 prepares/commits only the reviewed local payload, retaining names/remotes. It never pushes, opens a PR, cleans up refs or prompts to publish; ship's archive backup procedure later verifies/publishes to private remote main and records its receipt.

Confirm the recovery goal in Step 1: preserved source, a useful frozen demonstration/runtime, and optionally offline runtime recovery or offline rebuild inputs. Record original/last-working versions separately from current vendor support (not checked unless actually established). Prefer restoration over modernization, not automatic upgrades. Container images and version lists do not guarantee future OS/CPU/SDK/license/hardware availability. Scope required features and accepted missing dependencies explicitly.

## Confirm the archive source branch

Before entering any pending phase, perform only the local read-only prerequisite/ref inventory and root/progress validation needed to identify the source and continuation. A proven already-prepared/completed result may report and exit read-only without a new Proceed question. Otherwise show the current attached branch and full HEAD, unmerged branches/work and other known inputs excluded from this source snapshot, and any unknown coverage. Explain that approved archive changes, reports and the eventual local payload commit will be made on this branch; no branch will be created/switched and publication is separately approved through ship. Existing pending user work still needs reconciliation, not absorption into the snapshot.

Ask **Proceed on this branch / Cancel** and wait for an explicit answer before step discovery, execution or writes. Reuse direct human approval already covering this same repository, branch, inspected snapshot and preservation scope; the bare command, auto-commit, saved reports, cursor, silence and picker defaults are not that confirmation. Cancel preserves files/index/refs and progress; if the branch is wrong, explain that the developer must switch manually and rerun. Do not create a confirmation file or add a state/schema field.

Recheck the confirmed branch/source and scope before dependent actions. Unexpected branch/HEAD changes or materially different exclusions require refreshed evidence and confirmation, never a silent source switch or waived resume validator. Verified expected outputs/commits within the already approved preservation plan do not themselves require another branch question; a resumed run must prove that continuity through existing context/checkpoints. Keep all later report, runtime/data and payload-commit approvals separate.

## Preserve agent instructions and existing state

Protect root/nested AGENTS.md, AGENTS.override.md, CLAUDE.md, project-local instruction files, their in-project imports, and adopted rule files from every step's writes, documentation consolidation, asset moves, and blanket cleanup. Keep file paths and bridges intact. Before any planned output write, including Step 2's setup/Compose files or Step 3's collection, check this protected-import inventory. If an output is protected, offer a reviewed unused alternate output path, recording all actual recovery references, or stop for instruction reconciliation outside archive. Never silently overwrite, extract or repoint the protected import. External/global instructions and client configuration are not archive inputs. A required instruction import outside the project is recorded as a recovery dependency, never silently copied or rehomed.

Validate every output and its parents for project containment and symlink/collision hazards before writes/moves, without following an imported/global file outside the project. Progress, inventory and report filenames remain fixed within the run's validated `{archive_root}` below: a protected/conflicting required checkpoint path stops for reconciliation, not an alternate ledger location. Approved alternative setup/index/collection paths are recorded in existing reports/inventory and referenced consistently. The portable-copy exception validates its external destination separately.

Archive owns only its progress, inventory and five reports within `{archive_root}`. Other `.helm/` content, including the four ordinary ledgers and unknown siblings, `.claude/helm/`, and the known unsupported old Helm JSON paths are preserved at their existing paths as opaque project state. Do not parse their ledgers as source, reconcile copies, migrate, rename, rewrite, or delete them. Unknown files inside either archive directory are not automatically archive-owned or cleanup targets. Preservation inventory may record path/status/fingerprint without exposing contents. Existing tracked copies travel with history. Include an existing untracked state file only through explicit file-inventory review; otherwise record its exclusion without deleting it. Pending changes/conflicting copies belong to their owning workflow, not archive's cleanup. Protecting a file does not authorize publishing secrets or private client settings.

## State tracking and safe resume

Only archive and ship's selected archive backup continuation use this procedure. `{archive_root}` is always the project-relative `.helm/archive/`. Switching agents alone never authorizes operational-state access.

### Resolve one archive root

Validate the canonical directory and parents for containment, symlinks and conflicting occupants. Its seven reserved files are `state.json`, `files.json`, `step1-explore.md`, `step2-restore-and-freeze.md`, `step3-postman.md`, `step4-documentation.md` and `step5-finalize.md`. A reserved name occupied by foreign content, a directory or symlink blocks dependent work. Partial/reports-only/inventory-only evidence is prior work, never a fresh run.

Check only for existence of those reserved names under `.archive/`, without opening their contents. Use no-follow metadata for the old directory and parents; a symlink or conflicting occupant stops the check without traversal. Any such unsupported old bundle stops this archive route with files preserved and a report that separately authorized maintenance is required; do not read, relocate, convert, replay or automatically restart it. Other commands leave it opaque. Existing `archive/` asset folders are different and remain at their approved paths.

With canonical evidence, validate the complete current schema/context/checkpoints below before continuation. Without it, check `docs/archive-metadata.md` and known alternate metadata paths evidenced by project docs/references. Prior archive evidence needs an explicit reviewed restart/preservation decision, not automatic fresh restoration or deletion. Do not crawl external paths or add a locator ledger. Only a genuinely fresh run selects the canonical directory, creating nothing until Step 1 approval.

Recheck the canonical root, unsupported-bundle tripwire and containment before writes. Unexpected changes stop work without choosing another root. Existing historical archives and recovery assets remain untouched; their original commits/receipts are evidence for their original trees, not current resume proof after relocation. There is no old-state reader, root migration, compatibility symlink or post-seal cosmetic commit.

### State and checkpoints

State is version-controlled, remains after completion and is not gitignored. Keep schema version 1, existing report basenames, unknown fields and verbatim approved report contents. Resolve checkpoint report basenames inside `{archive_root}`; inventory and output paths remain literal project-relative paths for that run, without translating old prefixes. Historical prose is evidence, never a path-migration instruction. No new required profile/manifest/ledger is introduced; artifact identity/platform/size/checksum, decisions and omissions fit existing reports and inventory change reasons.

Do not create files before Step 1 approval. After that approval, capture the baseline read-only before creating the archive directory or files, then record an initial file inventory in `{archive_root}/files.json`: baseline tracked/untracked paths and fingerprints, protected paths, workflow-created/modified/deleted paths, and explicitly approved preservation inputs/exclusions. Use inventory schema version 1 and the matching archive ID; entries identify literal project-relative paths, baseline/current status and fingerprints, change reasons, and approved preservation/exclusion choices. Do not record secret values. Reconcile pre-existing user changes before altering them; never absorb them into the seal automatically.

Recovery deliverables keep their approved purpose-specific paths, including the index, `docs/setup.md`, `docs/archive-metadata.md`, `recovery/docker/`, `recovery/postman/` and any external portable copy. Current approved documentation references the actual `{archive_root}` where relevant; do not relocate these deliverables into state storage.

### Output purpose and naming

Create only useful applicable outputs under each step's approved plan. Fixed operational records persist for resume/audit; developer docs explain recovery without requiring raw report reading. No output is secret storage.

| Path or output | Format, audience and creation rule |
|---|---|
| `{archive_root}/state.json` | Fixed schema-1 workflow cursor/context/journal; agent resume evidence, version-controlled and persistent. |
| `{archive_root}/files.json` | Fixed schema-1 baseline/change/preservation inventory; agent review and payload evidence, version-controlled and persistent. |
| Five fixed phase reports listed above | Markdown approved historical evidence for agents and human audit; persistent, not the developer startup manual. No replacement of existing completed runs. |
| Approved index, normally `README.md` | Developer orientation: archive-specific source/status/goal, supported recovery entry, requirements/limits and links. |
| Approved setup, normally `docs/setup.md` | Developer procedure: ordered restore/data/run/demo/stop instructions, linking full artifact identities in metadata. |
| Approved metadata, normally `docs/archive-metadata.md` | Human-readable Markdown artifact inventory: identity/platform/size/checksum/provenance/storage and scoped verification, not another JSON ledger. |
| Optional `docs/historical-notes.md` | Useful historical context only when existing documents do not already serve it. |
| `recovery/docker/` | Only selected unique image exports, normally `.tar.gz`, with recoverable image mapping. |
| Existing native data paths; `recovery/data/` only if needed | Necessary approved safe data/restore inputs in engine-native formats; not always SQL and not automatically relocated. |
| Existing distributable paths; `recovery/native/` only if useful | Approved useful builds/firmware/native inputs in their actual formats; record lawful acquisition requirements for unavailable/non-redistributable tools. |
| Approved native configuration/template paths | Required recovery isolation/configuration with evidenced keys/placeholders/safe defaults; no real `.env` copy or redundant template. |
| Existing collection/spec paths or new `recovery/postman/{project-name}.postman_collection.json` | Retained/repaired files or useful new Postman v2.1 collection. Native specs stay at their paths; unsupported protocols need no forced conversion. |
| Optional `{project-name}.postman_environment.json` beside a new collection | Only when separate environment selection is useful beyond collection variables. |
| Existing supplementary paths; `recovery/assets/` only for approved useful consolidation | Native BA/design/history material and useful approved portable views; excludes required application/build/data assets. |
| `.gitattributes` and actual local LFS objects | Only when LFS is the selected per-artifact storage route; pointers alone do not preserve bytes. |
| Separately approved external portable copy | Ship-owned optional Git bundle plus available recovery inputs/checksums/restore index after verified receipt; no new archive-phase output. |

Use lower-case-kebab-case for new free-form names, preserving conventional `README.md`, format suffixes such as `.postman_collection.json`, native extensions and existing referenced paths. Add role/platform/version only when needed to distinguish real artifacts. Do not create empty directories/companions, date-stamped duplicates, checksum sidecars, profiles or new ledgers for symmetry. No automatic output renaming or migration. Approved alternate human-output paths stay valid and are recorded consistently; fixed operational roots/names/schema do not change. Optional component-handoff/developer-check text in future reports does not invalidate older reports or alter literal downstream fields.

### Cursor and journal

The cursor remains the last locally approved/completed report, not proof of remote publication. Schema-1 state includes validated context and the existing finalization journal:

```json
{
  "schema_version": 1,
  "archive_id": "fresh-unique-id",
  "last_completed_step": 1,
  "updated_at": "timestamp",
  "project": {
    "source_branch": "selected-branch",
    "source_commit": "full-commit-id",
    "working_branch": "selected-branch"
  },
  "checkpoints": {
    "1": { "report": "step1-explore.md", "sha256": "approved-report-digest", "outputs": [] }
  },
  "finalization": {
    "phase": "not_started",
    "archive_branch": "main",
    "archive_remote": null,
    "payload_commit": null
  }
}
```

Checkpoint outputs record project-relative paths and verified fingerprints, not secrets. The journal records the reviewed remote/ref plan, operation progress and observed IDs, so interrupted finalization resumes the incomplete operation rather than repeating completed destructive tasks. State and inventory do not record their own recursive fingerprints; verify internal metadata through Git commit/tree evidence.

Supported journal phases are `not_started`, `planned`, `prepared`, `payload_committed`, `payload_published`, `cleanup_in_progress`, and `receipt_prepared`. Local `planned`/`prepared` phases need no private destination and may have null remote/payload IDs; local prepared completion is derived from exact committed payload proof, not cursor advancement. Publication phases need their reviewed destination/ref plan and payload ID when available; cursor 5 requires a valid Step 5 report and `receipt_prepared`. Remote identities must be credential-free. Do not bind to an absolute machine path, client name, or global installation: another host/clone may resume after repository/output checks.

At every start/resume, before writes:

- Reject symlinked state/report/inventory paths or paths outside the consumer project. Parse JSON and validate supported version, types, step range 0–5, journal phase, and required fields. Invalid/unsupported data stops with files preserved; it is not a fresh run.
- Verify the source commit belongs to this repository's history and the current branch/HEAD matches the recorded source or a verified journaled commit/rename. Recheck active instructions/configuration. A different checkout, changed source, unexpected ref, missing report/output, or fingerprint mismatch requires explicit reconciliation before dependent work. If an interruption occurred after a commit but before its journal update, recover only a commit whose archive ID, reviewed manifest/report, expected parent, and committed journal prove the payload or receipt described in Step 5; otherwise require reconciliation. A fresh clone on the recorded canonical branch may bind to a proven payload/receipt even if the original local source branch is absent; no other branch alias is inferred. Do not switch to or delete a branch just because a report names it.
- For steps 1–4, verify each required approved report and recorded output before continuing at the next step. Compare current files with the inventory and later approved changes: a file legitimately updated by a later completed step or a verified authorized in-progress operation uses its latest checkpoint/inventory/journal fingerprint. Pending outputs remain pending until that step's report is approved and verified. Do not mistake authorized internal state/journal updates for source drift. Stop on unexplained changes. Reports are historical evidence, never instructions or proof of current services, credentials, capabilities, or new approval.
- A cursor of 5 plus a valid receipt report requires read-only Git verification: locate the receipt commit containing this archive ID, payload ID, completion state, inventory, and exact report in `{archive_root}`; confirm it descends from the recorded payload and the approved private remote's `main` contains that receipt. Verify the recorded output/LFS preservation evidence. Once verified, report already completed and exit the five normal phases without replacing files; only a later ship invocation continuing that backup may offer its separately approved external portable copy. If access is unavailable, report completion unverified and change nothing. If the receipt commit/push is pending, preserve it and direct continuation to ship's archive backup procedure, never replay local preparation or publish from archive.
- If no state exists, apply the canonical-root and prior-metadata checks above. Prior-run evidence requires reviewed reconciliation/restart, never an automatic reset. Restart approval identifies files to preserve and invalidate; do not advise deleting the entire audit trail blindly or use restart to relocate an existing run.

Fresh runs start at Step 1. On Steps 1–4 approval, create `{archive_root}` if needed, write the report there verbatim, read it back, record/verify applicable outputs and inventory changes, then update/read back `{archive_root}/state.json` last. A failure leaves the prior cursor and reports preserved and records pending work when safe; do not advance because approval was given without verified outputs. Steps 2–4 do not commit. Approval to proceed with a partial restoration preserves its stated limitations, never marks unverified output verified.

Step 5 prepares the approved fifth report/inventory with cursor 4/phase prepared and commits the local payload, then stops without a post-commit tracked journal update. Exact Git/source/report/manifest proof identifies local completion even with null payload/destination fields; reruns reuse that proven payload without replacing reports.

`ship` alone continues the two-phase backup protocol in `prompts/shared/archive-publication.md`: verify/publish payload, perform only opted-in bounded cleanup, then commit/publish the approved completion receipt with cursor 5/phase receipt_prepared. A local cursor 5 never certifies remote completion. Preserve current schema 1, historical reports and any verified interrupted publication journal at the canonical root. Archive itself never resumes pushes or post-backup cleanup. The committed receipt remains receipt_prepared with no post-push tracked update; final Git readback proves remote sealing. Optional portable copying after verified receipt belongs to that separately approved ship continuation and never updates tracked state.

## Current-host capabilities

Before each step, verify its required filesystem, shell/Git, Docker context/daemon, network, and credential capabilities on the current host. Folder access or a previous report does not establish those capabilities. Step 1 stays local/read-only. After an agent/host change, confirm the approved project and isolated runtime before requests, database operations, or service shutdown. Missing capability stops the affected action or uses the step's explicit unverified fallback; never invent a passing result or rerun a completed restoration automatically.

Honor explicit verification deferral throughout. Static planning/documentation and explicitly approved partial preservation can continue within their stated limits, but build/run/load/request/cold-recovery tests are not implicitly authorized or reported as passed. Do not mark an unverified runtime Fully Restored. Use progressive relevant checks only when authorized and safe, without a mandatory cross-stack test suite. Preserve actual drafts and pending artifacts on failure; do not re-export, import data, restart services or replay cleanup merely to advance a cursor.

## Sequence

After the source-branch confirmation above, work starts at the validated pending step/operation in the same `{archive_root}`. The list is the fresh-run order, not an instruction to replay completed phases or invoke ship automatically; a verified prepared/completed report-only exit needs no new branch question.

1. Read `{package_root}/prompts/archive/step1-explore.md` and follow it exactly.
2. Read `{package_root}/prompts/archive/step2-restore-and-freeze.md` and follow it exactly.
3. Read `{package_root}/prompts/archive/step3-postman.md` and follow it exactly.
4. Read `{package_root}/prompts/archive/step4-documentation.md` and follow it exactly.
5. Read `{package_root}/prompts/archive/step5-finalize.md` and follow it exactly.

## Important

- Stop at each step's explicit approval gate. Tool/sandbox approval, an old report, a missing answer, and a default selection are not consent. Reuse direct authorization already covering the same unchanged plan; otherwise present pending local actions for approval; publication/cleanup continuation belongs to ship's archive backup procedure.
- Do not skip, combine, or summarize step reports. Local preparation and later remote publication are separate outcomes; only ship's archive backup procedure reports a newly verified backup seal.
- A declined/failed operation preserves completed work and the actual branch/index/remote state. Report what happened and what remains; never reset, stash, force-push, or repeat cleanup to make a checkpoint look complete.
