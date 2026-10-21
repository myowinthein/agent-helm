# Step 5 — Finalize

Seal the approved project snapshot at the verified private archive remote, then publish its completion receipt. Read all four approved reports from `.archive/`, validate their checkpoints/current inventory, and follow the orchestrator's resume and preservation rules. Missing or mismatched context stops this step. Never replay destructive tasks solely because the cursor is still 4.

## Rules

- Present exact paths, refs, destination, and effects before approval. Resolve conflicts with active project rules rather than silently overriding them. Keep published tags unchanged.
- Archive owns its `.archive/` progress/report files, not agent instructions or other Helm ledgers. Preserve protected paths and bridges, with no configuration or ledger migration.
- No commit, branch deletion/rename, remote-ref mutation, or push until the reviewed seal plan authorizes it. Earlier approvals may cover local remote configuration, file changes, and stopping specific services; they do not publish the archive.
- The seal approval explicitly covers the reviewed payload commit/push, bounded cleanup, and completion-receipt commit/push. It does not authorize unrelated changes or force-push. On resume, reuse only direct authorization still covering the unchanged pending plan; stored reports/flags do not grant approval.
- Any failed/declined action preserves actual completed work and pending files/refs. Record verified journal progress when safe, report the precise remaining action, and stop dependent work. Do not claim rollback, success, or a completed receipt without evidence.

## Task 1 — Private destination and runtime verification

Present configured remotes using credential-free identities. Ask which are external/company/client remotes and obtain the private archive destination. The repository must already exist; verify its identity, access, and private status through an available authenticated interface or explicit informed user confirmation if privacy cannot be inspected. Do not infer privacy from a name or URL. Never print embedded credentials or change authentication/global client settings automatically.

Obtain approval for the exact local remote changes, remove only the named non-personal remote configurations, and set origin to the approved private archive URL. Snapshot fetch/push destinations and remote heads, checking for differing push URLs; later operations target only this approved archive repository, never another retained personal remote. Record the plan/journal, not secret URLs. Unavailable Git/network/LFS access blocks the affected operation. Nothing in this task pushes or deletes remote refs.

Revalidate current-host filesystem/Git/Docker/process access. Previous service reports are evidence only. No access to another host's daemon/processes means no claim to have inspected or stopped them.

## Task 2 — One explicit branch/ref plan

Use the validated source branch and full commit from Step 1 and the journal, never an inferred prose name or whatever branch happened to be checked out on resume. Confirm current HEAD/source contents match approved checkpoints. Resolve missing/renamed branches explicitly before proceeding. The canonical archive ref is always `refs/heads/main`, including when the source branch is `master`.

Present the exact local/approved-origin refs and saved object IDs to retain, rename, or delete. All source work is kept through the payload and receipt; no merging or history rewriting occurs. A distinct old local main/master can be retired only in the explicitly approved cleanup after payload publication, then the kept working branch is renamed to main. Do not mutate other worktrees or unrelated remotes. Respect any protected-branch prohibition, resolving the plan before deletion rather than forcing it.

This task plans only. Final execution uses the source branch for the payload commit and an explicit `HEAD:refs/heads/main` push, so master/custom names cannot accidentally publish an unrelated local main. Verify the approved remote main is absent or permits a normal fast-forward. If it diverges, stop for a separate reviewed destination/history plan; do not delete remote main to evade a rejected push or force-push. Other approved remote deletions wait until the payload is verified and never include the newly published main or any tag. A new empty archive remote is valid: do not expect a branch to exist there before the first push.

Record the source ref/ID, canonical ref, permitted local rename, exact deletion refs/expected IDs, remote identity, and progress in the journal; set phase `planned` after review. Recheck each ref against its expected ID immediately before mutation. Unexpected new/changed refs invalidate the plan, never expand the deletion list. A crash resumes from verified Git evidence and journaled operations, not a fresh blanket cleanup. A planned deletion target already absent at the approved repository is an observed satisfied postcondition, not a deletion to replay; report it as already absent rather than claiming this run removed it. A clone whose canonical main already points at the proven payload needs no fictional source-branch rename.

## Task 3 — Git LFS and recovery tarballs

Report total `recovery/docker/` size and other files over 100 MB, using paths, sizes, and types only. Ask how the recovery tarballs travel:

  AskUserQuestion:
    question: "Recovery tarballs total {size}. Store them in the archive through Git LFS, keep them local for separate backup, or cancel?"
    header:   "Recovery tarballs"
    multiSelect: false
    options:
      - label: "Commit via Git LFS (Recommended)"
        description: "Requires an LFS-capable private destination with sufficient quota; a clean clone downloads the tarballs"
      - label: "Keep local only"
        description: "Exclude recovery/docker/ and document the separate backup needed for recovery"
      - label: "Cancel"
        description: "Stop with changes and journal preserved"

For LFS, verify tool/remote support and use repository-local setup; track approved tarball/large-file patterns in `.gitattributes`. For local-only, add `recovery/docker/` to `.gitignore` and record the exclusion/backup requirement; inspect tracked status too, since ignore rules do not remove already tracked files. Any needed index removal is an explicit inventory/approval item, never file deletion. Other approved large files retained in the archive still use LFS. Record all changes in the inventory; do not stage a whole directory or set up global Git/client configuration. No large files means report not applicable.

## Task 4 — Asset consolidation

Identify archive assets such as screenshots, media, sample exports, and database dumps. Protected instructions/imports/rules, Helm state, `.archive/` journal/reports, client-local settings, and credential files are not assets to move.

For each candidate, check source/template/style/documentation references. Present exact paths and moves through the approved inventory. Move an unreferenced approved asset to `recovery/assets/`; referenced assets require an explicit decision and reviewed link changes. Do not treat a generic consolidation approval as permission to move protected files. Record fingerprints and verified new paths, including any legitimate update to an earlier checkpoint output. No assets means no changes.

## Task 5 — Stop currently identified project services

Discover services on this host and prove they belong to the approved isolated project. For containers, verify current Docker context/daemon, Compose project and working-directory labels/container IDs. For processes, verify current PID, start identity, command/cwd and project relationship; a reused PID or occupied port is not enough. Compare with Step 2 evidence but do not assume another host's services exist locally. Unknown ownership is a reported gap, never a shutdown target.

Present exact identified targets and obtain approval before stopping them. Recheck ownership immediately before each stop; stop only approved targets, with no blanket process/daemon shutdown or volume deletion. Record actual results and inaccessible/unknown targets separately. If no verified project services run here, say so without claiming services on other hosts were stopped. Do not restart them just to perform this task.

## Task 6 — Reviewed payload and completion receipt

### Inventory and approval

Review `.archive/files.json` against the current index/working tree and approved source. The seal manifest lists exact workflow-created/modified/deleted files and explicitly approved unchanged preservation inputs, with exclusions explained. Include protected tracked instruction/rule/state files at original paths through existing history; review any untracked preservation inputs by path before adding them. Neither `.helm/` nor either legacy location is migrated or reconciled. Pre-existing pending changes require their own resolution; do not absorb other commands' drafts.

The payload includes the approved restoration source/config changes (including new Docker/app files outside docs/recovery), recovery artifacts according to the LFS choice, recovery documentation, Steps 1–4 reports, inventory, and state/journal with cursor 4. Internal metadata paths are explicit manifest entries but must not hash themselves recursively; Git commit/tree verification covers them. Use latest approved fingerprints for outputs deliberately changed by later steps; record supersession without rewriting earlier verbatim reports.

Exclude unrelated changes, real credential files/values, private client-local settings, and secret-bearing reports/artifacts. Check selected new content and staged diffs without emitting secret values. A private destination is not permission to publish secrets. If selected existing history contains detected credentials, stop for a separate reviewed resolution; never rewrite history or remove published tags automatically. Keep immutable protected files intact locally when an exclusion/publication blocker is unresolved. Record only non-secret identifiers in reports and the journal.

Present the exact manifest, existing staged changes, LFS pointer/object availability, source/canonical refs, destination/privacy evidence, bounded cleanup, and two-commit/two-push protocol for final approval. Cancel leaves changes as they are, with no commits, remote-ref changes, branch cleanup, or publication from this task. Earlier approved local preparation/service stops are not rolled back. Auto-commit never bypasses this seal approval. If actual contents or refs change beyond this approved plan, stop and re-review.

### A. Payload publication

1. Recheck context, inventory, private fetch/push destination and expected local/remote refs. Before staging, keep the cursor at 4, set phase `prepared`, and finish writing the reviewed plan/journal metadata. Stage only the approved literal paths: `git add -- {approved_created_or_modified_paths}` and `git add -u -- {approved_tracked_deletion_paths}`. Omit empty lists. Do not use bare `git add -u`, `git add -A`, directory-wide additions, or blindly stage `.archive/`. Reconcile unrelated index entries instead of committing them. Verify the staged set/diffs match the manifest and LFS-managed binaries are pointers with their objects locally available.
2. Read back the staged metadata to confirm cursor 4 and phase `prepared`, then commit without further file changes as `chore(archive): seal project archive`. Verify the actual payload commit/tree and save its ID with phase `payload_committed` in the local journal after commit; do not try to embed its own ID into that same commit. If interrupted before the journal update, identify the payload only by matching archive ID, source ancestry, reviewed manifest and committed journal; ambiguity stops for reconciliation.
3. Under the seal's explicit push authorization, publish only that committed payload to the canonical ref: `git push origin HEAD:refs/heads/main`. Check normal fast-forward safety and expected remote tip again; never force-push. A failed push leaves cursor 4 and pending publication. Resume publishes the verified existing payload, without recommitting restoration or replaying cleanup.
4. Verify approved-origin main contains the exact payload commit and expected tree; verify the selected recovery/LFS objects are available at the destination through a supported check. A pointer-only success is not proof that tarballs can be recovered. If verification cannot be performed, record unverified/pending status and stop before cleanup/receipt completion. Set journal phase `payload_published` only after successful verification.

### B. Bounded cleanup and receipt publication

1. Only after verified payload publication set phase `cleanup_in_progress` and execute the exact approved remaining cleanup. Recheck expected ref IDs before each deletion; preserve the published main, payload history, all tags, and unrelated refs/worktrees. Retire only the approved distinct local base/other branches, then rename the kept working branch to main if needed, including master. Verify HEAD still identifies the payload and update the journaled working branch after a successful rename. Remote deletions are pushes authorized only for the exact refs in the seal plan; stop on any unexpected ref or failure. Record verified operations so a resume checks already completed actions rather than repeating them. A partial cleanup remains pending with cursor 4. Preserve expected original IDs and verified observations so an already completed deletion is not mistaken for an unexpected missing ref.
2. Produce the final factual report below using actual payload, cleanup, service, and preservation results. Present it without secrets. Approval of the reviewed seal plan covers this bounded report/receipt; obtain further approval only for a material change or pending operation not already authorized. Write that report verbatim to `.archive/step5-finalize.md`, read it back, record its digest/checkpoint, and set the local cursor to 5 with journal phase `receipt_prepared`, the verified payload ID, approved remote identity and canonical main. This is local report completion; published completion still requires the next verification. Never set cursor 5 after a failed payload/cleanup or before this verified report exists.
3. Stage only `.archive/step5-finalize.md`, `.archive/state.json`, and approved inventory/journal metadata changed for this receipt. Verify no restoration/code/other-ledger changes entered the receipt. Commit `chore(archive): record completion receipt` as a child of the verified payload and push main under the seal's bounded receipt authorization. If that commit/push fails, keep the receipt draft/commit and report pending status. Resume only the missing receipt operation after context/authorization checks; never replay the payload or cleanup.
4. Verify the private remote's main contains the exact receipt commit and its cursor/report/inventory tree, and that it descends from the verified payload. Only then report Archive complete. Do not write a new `published` flag, receipt's own hash, or another state update after this push: publication status is derived from Git proof. The committed report records the payload and preparation of the receipt; the final user-facing verification summary supplies the actual receipt commit and verified publication. If access/proof is unavailable, report unverified completion and leave state untouched.

## Final report to persist verbatim

### Remote Changes
Named approved local remote changes; confirmed private archive identity, with credentials omitted.

### Branch Cleanup
Validated source branch/commit, canonical main, actual local rename/deletions and approved-origin deletions, retained refs, and verification results.

### Recovery Tarballs & Git LFS
Committed via LFS or kept local only; sizes, verified object availability, exclusions and separate-backup requirements. State not applicable when appropriate.

### Asset and Protected-File Preservation
Approved moves/link changes; instruction entries/imports/rules and opaque Helm state preserved at original paths; approved untracked additions/exclusions. Do not reproduce ledger contents or credentials.

### Services Stopped
Currently identified project services stopped on this host, results, and any inaccessible/unknown services. Never imply another host was inspected.

### Payload Commit and Publication
Actual payload commit ID, approved file-manifest summary, private canonical ref and verified payload publication. Record actual failures as pending, never success.

### Completion Receipt
This report and the local cursor-5 checkpoint form the prepared completion receipt. Its commit ID and final publication are verified from Git and reported separately, not claimed inside a self-referential record. List any pending limitation explicitly.

### Recovery
Archive date, credential-free archive URL, restoration complexity, `docs/setup.md`, and clone instructions with Git LFS installed if used. If tarballs were excluded, explain how to restore the separate backup to `recovery/docker/`. If Docker was used, include image-load and data-restore steps from verified setup documentation before Compose startup; otherwise point to exact documented toolchain versions.

Stop after reporting verified publication or the precise pending action. The orchestrator must not append another post-push state/report write.
