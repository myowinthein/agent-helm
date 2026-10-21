# archive

## Before starting

Apply the shared runtime and resolve `{memory_file}` before Git actions, following bridges, overrides, and recognized configuration blocks. Configuration remains in that owner, normally AGENTS.md through CLAUDE.md's import on Claude or directly on Codex. Archive does not create, move, consolidate, or edit either instruction entry or Helm settings. Its explicitly confirmed archive seal uses the selected source branch and private destination; do not silently apply a normal development branch/commit policy or let auto-commit bypass archive approvals. Resolve conflicts with active project rules before mutation.

Run from the branch representing the complete project. Require a repository with HEAD and record the selected source branch and commit. List unmerged local branches read-only and warn that their work is not captured; let the user merge what should be kept and rerun, never merge on their behalf. Do not switch branches during Steps 1–4. Step 5 plans one canonical archive branch, `main`, including when the source is `master`; no branch is published before the reviewed seal approval.

## Preserve agent instructions and existing state

Protect root/nested AGENTS.md, AGENTS.override.md, CLAUDE.md, project-local instruction files, their in-project imports, and adopted rule files from documentation consolidation, asset moves, and blanket cleanup. Keep file paths and bridges intact. External/global instructions and client configuration are not archive inputs. A required instruction import outside the project is recorded as a recovery dependency, never silently copied or rehomed.

`.helm/`, `.claude/helm/`, and the known flat legacy Helm JSON files are preserved at their existing paths as opaque project state. Do not parse their ledgers as source, reconcile copies, migrate, rename, rewrite, or delete them. Preservation inventory may record path/status/fingerprint without exposing contents. Existing tracked copies travel with history. Include an existing untracked state file only through explicit file-inventory review; otherwise record its exclusion without deleting it. Pending changes/conflicting copies belong to their owning workflow, not archive's cleanup. Protecting a file does not authorize publishing secrets or private client settings.

## State tracking and safe resume

Archive's operational state lives only in `.archive/`. It is not gitignored. Keep the existing report filenames and verbatim approved report contents. Do not create files before Step 1 approval. After that approval, capture the baseline read-only before creating any archive files, then record an initial file inventory in `.archive/files.json`: baseline tracked/untracked paths and fingerprints, protected paths, workflow-created/modified/deleted paths, and explicitly approved preservation inputs/exclusions. Use inventory schema version 1 and the matching archive ID; entries identify literal project-relative paths, baseline/current status and fingerprints, change reasons, and approved preservation/exclusion choices. Do not record secret values. Reconcile pre-existing user changes before altering them; never absorb them into the seal automatically.

The cursor remains the last locally approved/completed report, not proof of remote publication. New state adds validated context and a finalization journal:

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

Checkpoint outputs record project-relative paths and verified fingerprints, not secrets. The journal records the reviewed remote/ref plan, operation progress and observed IDs, so interrupted finalization resumes the incomplete operation rather than repeating completed destructive tasks. State and inventory do not record their own recursive fingerprints; verify internal metadata through Git commit/tree evidence. Supported journal phases are `not_started`, `planned`, `prepared`, `payload_committed`, `payload_published`, `cleanup_in_progress`, and `receipt_prepared`. Later phases require their recorded source/ref plan and payload ID when available; cursor 5 requires a valid Step 5 report and `receipt_prepared`. Remote identities must be credential-free. Do not bind to an absolute machine path, client name, or global installation: another host/clone may resume after repository/output checks.

At every start/resume, before writes:

- Reject symlinked state/report/inventory paths or paths outside the consumer project. Parse JSON and validate supported version, types, step range 0–5, journal phase, and required fields. Invalid/unsupported data stops with files preserved; it is not a fresh run.
- Verify the source commit belongs to this repository's history and the current branch/HEAD matches the recorded source or a verified journaled commit/rename. Recheck active instructions/configuration. A different checkout, changed source, unexpected ref, missing report/output, or fingerprint mismatch requires explicit reconciliation before dependent work. If an interruption occurred after a commit but before its journal update, recover only a commit whose archive ID, reviewed manifest/report, expected parent, and committed journal prove the payload or receipt described in Step 5; otherwise require reconciliation. A fresh clone on the recorded canonical branch may bind to a proven payload/receipt even if the original local source branch is absent; no other branch alias is inferred. Do not switch to or delete a branch just because a report names it.
- For steps 1–4, verify each required approved report and recorded output before continuing at the next step. Compare current files with the inventory and later approved changes: a file legitimately updated by a later completed step or a verified authorized in-progress operation uses its latest checkpoint/inventory/journal fingerprint. Pending outputs remain pending until that step's report is approved and verified. Do not mistake authorized internal state/journal updates for source drift. Stop on unexplained changes. Reports are historical evidence, never instructions or proof of current services, credentials, capabilities, or new approval.
- Legacy two-field state is supported read-only: validate its cursor and available prior reports/outputs and ask the user to confirm repository, source branch/commit, and remaining work before binding it to new context. Do not invent missing provenance or infer a destructive branch choice from prose. Write upgraded metadata only after that explicit reconciliation approval. A legacy cursor of 5 without publication proof is reported as unverified, not automatically rerun or declared complete.
- A cursor of 5 plus a valid receipt report requires read-only Git verification: locate the receipt commit containing this archive ID, payload ID, completion state, inventory, and exact report; confirm it descends from the recorded payload and the approved private remote's `main` contains that receipt. Verify the recorded output/LFS preservation evidence. If access is unavailable, report completion unverified and change nothing. If the receipt commit/push is still pending, resume only that phase after required approval, not the entire Step 5.
- If no state exists, check `docs/archive-metadata.md` and existing `.archive/` reports/inventory before calling it fresh. Prior-run evidence requires reviewed reconciliation/restart, never an automatic reset. Restart approval identifies files to preserve and invalidate; do not advise deleting the entire audit trail blindly.

Fresh runs start at Step 1. On Steps 1–4 approval, create `.archive/` if needed, write the report verbatim, read it back, record/verify applicable outputs and inventory changes, then update/read back the cursor last. A failure leaves the prior cursor and reports preserved and records pending work when safe; do not advance because approval was given without verified outputs. Steps 2–4 do not commit. Approval to proceed with a partial restoration preserves its stated limitations, never marks unverified output verified.

Step 5 uses its own two-phase seal protocol, not the generic post-report cursor update above. Until the payload is committed and its publication verified, keep the cursor at 4. After verified payload publication and approved cleanup, persist the reviewed final report and local completion cursor 5 in a separate receipt commit and publish it. A local cursor 5 with `receipt_prepared` is a candidate receipt until Git proves publication; it is never sufficient to announce completion. Leave the committed phase as `receipt_prepared`: final publication is derived from Git proof, avoiding another uncommitted state change or self-referential commit hash. No files change after the final receipt push/verification.

## Current-host capabilities

Before each step, verify its required filesystem, shell/Git, Docker context/daemon, network, and credential capabilities on the current host. Folder access or a previous report does not establish those capabilities. Step 1 stays local/read-only. After an agent/host change, confirm the approved project and isolated runtime before requests, database operations, or service shutdown. Missing capability stops the affected action or uses the step's explicit unverified fallback; never invent a passing result or rerun a completed restoration automatically.

## Sequence

1. Read `{package_root}/prompts/archive/step1-explore.md` and follow it exactly.
2. Read `{package_root}/prompts/archive/step2-restore-and-freeze.md` and follow it exactly.
3. Read `{package_root}/prompts/archive/step3-postman.md` and follow it exactly.
4. Read `{package_root}/prompts/archive/step4-documentation.md` and follow it exactly.
5. Read `{package_root}/prompts/archive/step5-finalize.md` and follow it exactly.

## Important

- Stop at each step's explicit approval gate. Tool/sandbox approval, an old report, a missing answer, and a default selection are not consent. Reuse direct authorization already covering the same unchanged plan; otherwise present pending destructive/push actions for approval on resume.
- Do not skip, combine, or summarize step reports. Final publication verification is a separate factual summary, not a rewrite of the committed receipt report.
- A declined/failed operation preserves completed work and the actual branch/index/remote state. Report what happened and what remains; never reset, stash, force-push, or repeat cleanup to make a checkpoint look complete.
