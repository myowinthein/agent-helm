# Completed Normalize backup retention

Ship-only completion procedure. Load at the end of an otherwise successful Ship involving verified Normalize evidence, after all selected publications/targets and any selected release are verified complete. An explicitly skipped or inapplicable release is complete for this purpose; a release-metadata PR handoff, failed/pending action, partial history publication or deliberately unpublished affected branch is not. Normalize never deletes older backups when creating a new one. Ordinary publication, missing-proof replacement backups under `Agent Helm/ship/`, archive, read-only runs and source maintenance gain no cleanup authority.

The standing workflow policy keeps the newest **three completed cycles per clone**, plus evidence still required by pending work or historical correspondence. There is no cleanup question, setting intake or automatic command invocation. Include this retention effect briefly in Normalize's existing rewrite plan. Stronger applicable preservation instructions retain their force: skip cleanup and report the conflict without adding an approval pause. Source updates never delete existing backups.

## Complete a publication cycle

A completion is a verified result, not a backend exit code, selected subset, timestamp, receipt claim or inference from a new backup. Confirm every affected branch of that run was published at its approved destination and read back, including already-satisfied destinations. Finish any selected release and its required boundary verification first. Finalize the run's existing publication/results evidence before freezing it; completed evidence is no longer a mutable log. Do not open Normalize's live ledger.

A successfully published result is the starting history for a later independent cycle. If the next run's self-contained original bundle contains the freshly observed remote history, verify that next run directly. Do not reopen completed ancestors solely because their locators exist. Multiple unshipped rewrites, partially updated branches or disconnected preserved release tags still require their actual earlier correspondence. A fixed number of retained backups never limits verification depth or excuses missing proof.

Before completion, establish which older run IDs must remain for current/future release boundaries or unfinished publication sequences. Preserve their full evidence unless a separately supported independently verified replacement proof exists. Do not invent compressed proof or assume keeping a map alone replaces its bundle. Unknown dependency evidence prevents retirement, not publication already verified. Missing/legacy completion records remain unclassified; no backfill from timestamps or automatic migration.

Dependencies mean evidence still needed after this cycle closes. Do not pin every run used to verify a now-completed publication merely because it was once part of that transaction. For several runs completed by one Ship, record each verified run sequentially after the whole invocation succeeds; an as-yet-unrecorded run conservatively prevents early cleanup.

## Fixed helper and bounded data

Use Python 3.11+ on a supported POSIX host and the reviewed packaged `helpers/normalize_retention.py`. It uses `normalize_handoff.py`'s no-follow locator I/O and shared nonblocking writer lock; it runs no Git, project code or network operations and accesses no ledger. Do not generate a cleanup script or fall back to recursive shell deletion. The helper never establishes publication correctness: the parent owns the preceding verification and supplies its actual results.

```text
python3 -I -B {package_root}/helpers/normalize_retention.py inspect --git-common-dir {actual_git_common_dir}
python3 -I -B {package_root}/helpers/normalize_retention.py complete --git-common-dir {actual_git_common_dir} --expect-digest {inspect_digest}
```

Inspect is read-only and enumerates only the exact clone-local locator directory, never the home backup parent. It reads bounded fixed completion receipts, returning run IDs, completion times, dependencies and a digest. It does not read arbitrary recovery entrypoints. Complete consumes one strict UTF-8 JSON object on stdin, at most 256 KiB, with these exact fields:

```json
{
  "schema_version": 1,
  "run_id": "the-actual-lowercase-uuid",
  "git_common_dir": "/actual/canonical/common/git/directory",
  "completed_at": "2026-01-01T00:00:00Z",
  "published_refs": [
    {
      "local_ref": "refs/heads/main",
      "remote_ref": "refs/heads/main",
      "commit": "actual-full-read-back-commit-id",
      "destination_id": "sha256-of-the-bound-credential-free-destination-identity"
    }
  ],
  "release_outcome": "completed",
  "required_runs": []
}
```

Use actual canonical UTC completion time and exact full IDs, with all affected branches/destinations represented. `release_outcome` is `completed`, `skipped` or `not_applicable`; neither pending nor failed is accepted. `required_runs` names all earlier evidence still required, including release correspondence. Hash a credential-free canonical destination identity already verified during publication, never a token-bearing URL. This data is a private completion receipt, not a tracked ledger, permission record or replacement for Git proof.

The helper resolves the OS user's home and accepts only registered UUID runs at `{home}/Agent Helm/normalize/{run_id}/`, tied to this exact canonical Git common directory. Other clones, moved/custom/legacy directories, symlink traversal, foreign ownership, unsafe permissions, linked/nonregular files and unsupported records are protected. No global home-directory search or cross-project deletion is permitted. Read-only discovery retains its existing behavior.

Under the shared writer lock, complete rechecks the registry digest and writes one immutable private `.helm-retention.json` inside the current run. It records completion data, root identity and a complete file/directory inventory with file hashes; file contents/hashes are not dumped into output. A matching 65-byte checksum at `{git_common_dir}/agent-helm/normalize-completions/{run_id}.sha256` detects edits to that receipt itself. Its directory/files are private and no-follow, with no global scan or automatic repair. Limits are 2 MiB per receipt, 8,192 inventory entries and depth 32. An identical already-recorded completion preserves the original time/receipt and performs no second cleanup; conflicts or missing checksums stop retention. No failed or unverifiable request becomes completed.

## Automatic retirement and reporting

Only after verified completion, the helper keeps the newest three completed receipts by their canonical completion time, with run ID as a deterministic tie-breaker. It preserves the transitive `required_runs` closure of retained records. An unfinished/unclassified run has unknown dependencies, so cleanup conservatively retains all potentially needed completed runs. This can exceed three; never silently drop dependencies to enforce a hard count.

Run sequentially with no other writers to these recovery folders. The shared lock coordinates packaged locator/retention writers; it does not sandbox arbitrary same-user file edits. Before any deletion, validate the entire eligible deletion set against its exact recorded inventories and root identities. Recheck each run and locator immediately before removal, atomically claim it into a fresh private `.retiring-{run_id}/backup` container, then verify its identity/inventory again before deletion. Detected new/changed files, symlinks, hardlinks or moved/replaced paths stop cleanup. Remove only that verified backup and staging container, then its matching locator and completion checksum; no Git refs, tags, configuration, ledgers or unrelated files change. Interrupted removal may leave partial evidence or a stale pointer: retain/report the exact staging path and separate folder/pointer outcomes, without blind retry, rollback, locator repair or claiming complete cleanup.

Report deleted run count, logical file bytes recovered, completed runs retained and dependency/pending exceptions in the existing final result. No extra approval follows. Unavailable tools, policy conflicts, validation failures or cleanup I/O errors leave retention skipped/incomplete; they do not undo or relabel verified publication, trigger further publication, or prompt for a cleanup workaround. Never report a partial deletion as a fully recovered amount. Existing unknown runs can remain protected until a separately verified continuation establishes their actual state.
