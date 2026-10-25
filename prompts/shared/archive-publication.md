# Publish and verify an archive backup

Loaded only after ship's metadata-only archive candidate check and the developer's explicit selection to inspect that bundle for backup, or a verified continuation of the same selected backup. A folder name alone is not preparation or publication approval. This backup procedure is terminal: no ordinary source push, release/version/tag, feature PR or environment promotion follows it. `ship-method: direct|pr` governs ordinary shipping, not this exact private backup protocol. A PR/squash cannot substitute for verified payload/receipt ancestry; actual required policy may block publication.

## Narrow archive ownership and preflight

Load the packaged [archive bundle procedure](../../workflows/archive.md#resolve-one-archive-root), including its schema/context/inventory/checkpoint validation and resume rules. This explicitly invoked publication route is the narrowly authorized continuation of that one archive bundle. It may read only its reserved files/reports and update publication journal, reviewed receipt/inventory metadata and checkpoint state. Other Helm ledgers/siblings are opaque preserved inputs; no discovery/migration of another command's state. No new run, root relocation, restoration, asset move, service stop, local branch selection or automatic cleanup is authorized. Missing/incomplete local payload means run archive to finish local preparation first; an identified interrupted current-format seal may resume only its already reviewed missing commit/publication phase.

Record `{original_branch}` and starting HEAD before any allowed mutation. Validate source/actual current branch, archive ID, complete local payload provenance, checkpoints/inventory, protected files and project/provider policy. Normally require clean index/worktree and no ongoing Git operation. A narrow exception permits only validated pending publication-journal/receipt changes owned by this exact identified archive, including interrupted current-format runs, whose complete diffs and expected prior versions are proved under this protocol; unrelated staged/unstaged/untracked work and changed source/artifacts block. Never stash/reset/absorb work. Revalidate expected snapshots before every mutation. Do not checkout a reported branch automatically; a wrong current source/verified continuation branch blocks with the reason.

A previously verified-complete receipt needs no writes/pushes: report it and stop (optional separately approved external portable copy below). Unavailable remote proof yields unverified status, not replay. A prepared local payload with cursor 4/phase prepared and no stored payload ID is valid only after exact committed source/report/manifest/journal proof, never by commit subject or newest HEAD alone. Reports are evidence, not authorization.

Local archive approval grants no publication permission. Freshly show the exact payload/destination/known triggers and obtain backup publication approval, including the later bounded receipt commit/push and only expressly selected cleanup. Apply all secret/history/LFS, signing/review/protection and deferred-check gates; do not turn unknowns into safe/absent. Use the [provider procedures](release-providers.md) where supported for identity/PR requirements, never to turn the archive into a tagged release.

## Resume only missing publication phases

After read-only validation, build the actual phase matrix before any journal write: local payload committed, exact payload remote/object proof, selected cleanup postconditions, local receipt draft/commit and exact receipt remote proof. Preserve the highest proved phase and all prior expected IDs. Never reset cursor 5 to 4 or phase receipt_prepared/payload_published to planned/payload_committed, overwrite an already prepared receipt report, re-create a payload/receipt commit or repeat a verified push/cleanup merely because numbered tasks follow. A pending verified receipt needs only its exact approved missing push/readback; do not publish the older payload over a remote receipt/descendant. Uncertain results are read back first. Changed destination/source/manifest or missing proof requires reconciliation, not replay. Existing legacy runs retain their literal journal/root/report paths and pending reviewed scope.

## Task 1 — Private destination and capabilities

Present credential-free existing remote identities and ask for the already-existing private archive repository. Verify actual identity/access/privacy with an authenticated supported interface, or obtain explicit informed confirmation when privacy cannot be inspected, labelling that evidence as user-confirmed rather than API-verified. A URL/name alone is not privacy proof. No automatic account/client/global configuration changes or credential-bearing journal URLs.

Resolve a **single actual push destination**, including differing push URLs, fork identities and existing named-remote configuration. Multiple push destinations require a single explicit choice. Prefer a usable explicit credential-free destination with existing authentication, or an unused separately approved archive remote. Named additions/removal/repointing of source remotes occur only if explicitly requested and reviewed, with original fetch/push mappings preserved as evidence; never mandatory cleanup. Revalidate the exact identity on resume rather than executing a redacted/nonfunctional placeholder URL.

Read expected remote heads and relevant protection/review/CI/deployment facts without silently fetching. Inspect workflows carried with this archive for possible execution on its main pushes; do not assume a private/new repository has no effects or change provider settings automatically. Explain known/unknown triggers before publication approval. Inaccessible required evidence leaves the affected action pending. Nothing in this task publishes/deletes refs.

Revalidate this host's filesystem/Git, free space, LFS and runtime/process capabilities. A prior report does not prove another host's daemon/services can be accessed or stopped here.

## Task 2 — Source/ref preservation and optional cleanup plan

Use the validated source branch/full commit and journal, not incidental HEAD or a prose guess. Confirm current source plus approved restoration/doc/artifact outputs match checkpoints. Keep local refs/remotes by default, publishing selected source history plus payload/receipt to remote main. An empty destination is valid; existing remote main must accept a normal fast-forward from its observed tip. Divergence stops for a separately reviewed destination/history plan, never deleting main or forcing a push.

Show which local/remote branches, tags, submodule repositories, LFS objects, release/package assets, wiki/issues or other hosted metadata are captured or excluded. A source-branch push transports neither unrelated refs nor every hosted/external object. Local tags remaining unchanged does not mean they reached the archive. Additional requested preservation needs an exact reviewed ref/artifact plan and supported checks, without mirror-all push or rewriting tags/history; otherwise retain originals and document exclusions. Never merge unmerged work automatically.

Offer **Preserve local refs/remotes (default)** or review exact optional cleanup paths/refs. Cleanup is unnecessary for a successful seal; an empty list proceeds straight from verified payload to receipt. A selected plan lists original expected IDs, permitted local rename, exact deletion targets/destination and postconditions. Respect protected main/master/environment refs, other worktrees and project rules; no force deletion or implicit permission to discard unpreserved work. If a requested rename conflicts with an existing protected ref, retain names or leave a separate manual plan.

Record source/canonical ref, private destination identity, expected IDs and selected/no-cleanup plan in the existing journal; record the plan only after review without regressing any already proved phase; fresh local payloads remain prepared/payload_committed as appropriate. Recheck inputs before every action. New/moved refs invalidate affected plans, never expand deletion scope. An already-absent approved target is a satisfied observation, not a deletion to replay. A clone on proven canonical main needs no fictional original-source rename.

## Recovery bytes and policy before publication

Revalidate actual artifact IDs/checksums/sizes, local LFS objects, destination-specific historical blob/object limits, endpoint/support/quota, privacy/access and any approved separate storage evidence from the existing archive reports. A pointer alone is not retrievable-byte proof. Missing required bytes/storage or required checks blocks the affected complete-backup claim/publication; explicitly reviewed exclusions remain qualified. Do not reconfigure global LFS/hooks, move assets, re-export data, install tools or change archived source to manufacture readiness. Source preparation changes return to archive for explicit reconciliation. Selected credentials in existing history block backup publication for separate resolution; no automatic history rewrite.

## Reviewed publication and completion receipt

### Inventory and seal approval

Compare `{archive_root}/files.json`, expected source/checkpoints and actual index/worktree. The manifest identifies literal workflow-created/modified/deleted files, approved unchanged/untracked preservation inputs and exclusions. Include restoration source/config/overrides outside docs/recovery; use latest approved fingerprints for legitimate later changes. Preserve protected tracked instructions/rules/opaque state at original paths through source history. Do not absorb pre-existing user edits, another command's drafts or unrelated staged changes.

Exclude real credential files/values, private client settings/records and secret-bearing reports/images/data/artifacts. Review actual selected payload risks from Step 2, not just LFS pointer diffs. Absent findings mean none found in inspected surfaces; material uninspected inclusion risk needs resolution/manual review. Detected credentials in selected existing history block publication for separate reviewed resolution. Do not rewrite history/tags or modify protected originals automatically to make publication pass.

Show source/destination/ref IDs, the already verified local payload and complete included history/files, actual LFS objects and backup exclusions, verification performed/deferred/unknown, provider policy/triggers, any cleanup and the **payload-then-receipt publication protocol**. The existing payload commit is reused; no second payload commit is created merely to store a destination. Reuse exact unchanged approvals; obtain seal approval before its mutations. Cancel makes no commits/ref cleanup/publication from this task; earlier approved preparation/stops remain actual work. Internal metadata entries do not recursively hash themselves; Git tree evidence covers them.

### A. Payload publication

1. Validate the selected local payload by exact archive ID/source parent, committed prepared journal, reviewed fifth report/inventory/output fingerprints and actual complete tree. This includes the narrow clean-worktree exception above for proven own journal/report deltas only. Reconcile other work or material source/outputs changes before publication. The archive command's already verified payload is never automatically recommitted or silently extended with current HEAD.
2. Reuse the uniquely proved existing payload SHA. An incomplete local payload must be finished through archive before publication.
3. Recheck the exact private destination and expected remote main; publish the **verified payload SHA**, not mutable HEAD: `git push --no-follow-tags {single_destination} {payload_sha}:refs/heads/main`, passing arguments safely. Normal fast-forward only, no implicit refs/tags/configured refspecs. The reviewed seal authorizes this exact bounded push. On failure/uncertain result, read back remote main before classifying success/pending; never blindly repeat the push or commit.
4. Verify remote main contains the exact payload with expected contents and observed ancestry; record its actual tip. Verify required recovery/LFS bytes at the approved destination with supported retrieval/identity evidence, not pointer-only success. A legitimate known descendant requires reconciliation before further writes; an unexpected advance is not automatic receipt permission. Unavailable/failed proof leaves cursor 4 and stops cleanup/receipt. Only verified payload publication sets phase `payload_published`.

### B. Opt-in cleanup and receipt publication

1. If cleanup was selected, set phase `cleanup_in_progress` and perform only its remaining approved actions after verified payload publication. Recheck expected ref IDs and target ownership, preserve published main/payload/tags/protected refs/unrelated worktrees, and use supported safe local deletion/rename. Remote deletion is its exact separately described push, with expected-ID protection and readback; unavailable protection leaves it pending rather than risking a moved ref. Record completed observations; do not replay them after a crash. Partial cleanup stays at cursor 4 until resolved or its changed plan explicitly reviewed. With no cleanup selected, record that source refs/remotes/names were retained and go directly to receipt preparation.
2. Produce the factual final report below from actual results. Seal approval covers this bounded report/receipt unless a material change requires review. For a fresh receipt, explicitly review its replacement of the local-preparation fifth report (whose prior version stays in Git), then write it verbatim to `{archive_root}/step5-finalize.md`, read back its digest/checkpoint, and update `{archive_root}/state.json` to cursor 5 with phase `receipt_prepared`, actual working branch, verified payload ID and approved destination/canonical ref. A local cursor 5 is a candidate receipt, not publication proof. No cursor 5 before a verified report/payload and resolution of selected cleanup.
3. Stage only that report, state and approved changed inventory/journal metadata. Verify no new restoration/code/other-ledger work entered it. Commit `chore(archive): record completion receipt` as a child of the verified payload, verify the exact receipt SHA/tree, then recheck remote/policy and publish only `{receipt_sha}:refs/heads/main` to the same single destination with `--no-follow-tags`. This uses the seal's bounded receipt approval, not an implicit push of local main or current HEAD. Failed/declined commit/publication retains the actual draft/commit and pending action; resume only that missing phase.
4. Read back the exact remote receipt and its cursor/report/inventory tree, payload ancestry and recovery-object evidence before reporting the seal published. For an uncertain push, remote proof may establish success; if unavailable, report unverified and preserve state. No post-push `published` flag, receipt-self-hash or repository-file update. The committed report records receipt preparation; the final conversational summary supplies actual receipt SHA/publication proof. Recovery/build/backup completeness remains separately qualified.

## Final report to persist verbatim

### Remote Changes
Actual approved destination and privacy/access evidence, source remotes retained or explicitly changed; credentials omitted. Known push/provider requirements and results.

### Branch Cleanup
Validated source branch/commit, canonical remote main, actual retained/renamed/deleted refs with evidence, selected/excluded tag/branch/hosted resources. No cleanup is a normal result.

### Recovery Tarballs & Git LFS
Unique required artifacts/paths/IDs/platforms/checksums/sizes, actual LFS retrieval or separate-backup proof, exclusions/local-only inputs and remaining storage needs. Not applicable where appropriate; never certify backup from a pointer.

### Asset and Protected-File Preservation
Actual moves/reference updates, protected instruction/import/rule/opaque state paths preserved and approved untracked inputs/exclusions. No ledger contents, secrets or private records.

### Services Stopped
Exact currently identified targets/results on this host, plus inaccessible/unknown services. No cross-host shutdown claim.

### Payload Commit and Publication
Actual payload SHA, reviewed file scope, private canonical ref and verified remote results; partial/unverified facts clearly labelled.

### Completion Receipt
Report/cursor-5 metadata is the prepared receipt. Its own commit ID/publication proof is reported separately from Git, without a recursive self-reference. List pending limitations, not a fabricated success flag.

### Recovery
Archive date, approved credential-free destination/clone instructions and actual index/setup paths. Selected goal and source/tool/platform constraints; original/last-working versus unchecked support status. Actual static/build/run/data/cold-rehearsal/offline-rebuild evidence, deferred/unavailable checks and accepted missing features. Include image load, isolated database startup where needed for restore, then data/file restoration before dependent application startup; native SDK/toolchain inputs when relevant. Required external or excluded inputs and verified backup status are explicit. A published seal does not certify future recovery, rebuild completeness or safe production deployment.

## Optional: portable recovery copy after receipt verification

After the final receipt is verified, offer **Prepare portable copy** or **Finish without a copy**, reusing an existing exact copy request if present. A verified-complete resume may offer the same copy without replaying any seal phase. This is a separately approved external export, not a sixth tracked phase or another ledger. Do not write repository files/state or amend the receipt.

Review a specific unused external destination owned by the developer, selected committed source/receipt/ref IDs, artifact bytes, size/free space, privacy classification and omissions. Reject symlink/escape/collision hazards and recursion inside the source archive; never copy the whole home directory/global configuration/credentials or overwrite an existing backup silently. Missing capability/input yields explicit manual instructions or an incomplete copy, not false success. No automatic cloud upload, scheduler, tool installation or network acquisition; separately requested acquisition needs its own reviewed plan.

Create a verified self-contained Git bundle for the exact approved available refs/receipt history, with no missing prerequisites, plus required locally available approved images/data/config/setup/receipt evidence. Preserve selected LFS **objects**, not just pointers; include separately verified submodule repositories at their exact referenced commits when available. Missing objects, SDKs, hosted resources or required inputs remain listed omissions. A bundle alone excludes untracked/runtime/external inputs; source refs and credential configuration remain unchanged. Use safe Git reads with no project hooks/code execution; if frozen refs cannot be exported without mutating the source, use supported external-only preparation or provide a manual handoff.

Write an external inventory/restore index with actual included paths/IDs, byte sizes and SHA-256 values, copies checked against intended artifacts, and instructions to restore the Git/LFS/submodule/data/runtime pieces. The external index may include the verified receipt SHA and bundle/artifact checksums; do not require it to hash itself or put the bundle into its own source payload. Verify the bundle's heads/prerequisites and included objects through appropriate independent Git evidence before claiming a self-contained source copy. A recovery rehearsal remains separately optional, not implied by copying/checksums.

On failure preserve the verified seal and actual partial external copy, identifying exact missing/retry actions without replaying publication or deleting prior backups. A finished copy is reported in conversation with destination/scope/checksums/omissions; no post-receipt tracked update. Suggest a second independent copy as advice only, unless the developer separately authorizes that action. Finish with seal, recovery-verification, backup and portable-copy outcomes stated separately.
