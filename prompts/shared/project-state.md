# Shared project state

Apply this procedure only when the invoked workflow owns one of the files below. This is shared Claude/Codex behavior, independent of the host's instruction entry or `{memory_file}`. It does not invoke any other command.

| Owning command | State filename | Current schema |
|---|---|---|
| `refactor` | `refactor-log.json` | 1 |
| `test` | `test-log.json` | 2, with the workflow's existing v1 conversion |
| `normalize` | `normalize-log.json` | 1 |
| `legal` | `legal-manifest.json` | 1 |

## Resolve before using state

The canonical directory, `{helm_state_dir}`, is `.helm/` at the consumer project root. Never resolve it under the installed package, client home, or a global plugin data/cache directory. State remains version-controlled under the owning workflow's existing Git policy; do not ignore the whole directory.

For the selected command's filename only, inspect all three candidate paths:

1. `.helm/{filename}`: canonical.
2. `.claude/helm/{filename}`: namespaced legacy.
3. `.claude/{filename}`: original flat legacy.

Do not enumerate, load, or migrate another command's state. A directory containing different commands' files at different stages of migration is valid. Do not treat these operational files as source code during scans. Commands without a state file in this table do not trigger migration.

Resolve paths inside the selected consumer project, rejecting symlinked state files/directories or paths escaping that project. Record which candidates exist, their exact contents, and which are tracked. An absent file is a first run, not an instruction to create an empty file or directory.

Parse every existing candidate and validate it using the owning workflow's schema before using it to select work. Missing schema versions follow that workflow's documented rules. Malformed JSON, unsupported versions, or an unrecognized shape block the affected workflow with every file preserved; do not treat them as an empty history or as Helm data merely because a filename matches.

Compare parsed content across every candidate, even if canonical state exists. Ignore object-key ordering and JSON formatting only; preserve array order, records, IDs, statuses, watermarks, and unknown fields. Normalize the workflow's documented missing-version default for comparison only, and apply only its explicitly supported schema conversion in memory before comparison, including test's v1-to-v2 conversion. A path change alone never bumps a schema version.

- One valid candidate: use it and queue any required path migration.
- Multiple candidates with equivalent data: use that data once and queue legacy duplicates for retirement at the next eligible write.
- Different data: show the paths and meaningful differences and ask the user to choose or approve a reconciled result before using state or continuing dependent work. Never automatically pick canonical, newest, or a union of arrays. Preserve all candidates until the reviewed result is verified and an authorized write completes. A flat file that belongs to another tool stays untouched; resolve its ownership explicitly before proceeding.

## Write and retire legacy state

Apply this procedure to every state write/checkpoint in the owning workflow, not just its first scan. Keep its existing prerequisites, schema transitions, data updates, Git destination, and approval gates. Reading a file, switching hosts, Skip, cancellation before a write, a no-op exit, or a failed/incomplete operation does not trigger migration. Do not perform a cleanup-only write on such paths. A completed scan that normally records a checkpoint is an eligible write, even when no fixes were selected.

1. Describe the canonical destination and any same-file legacy removals as part of the workflow's normal write/commit plan. Reuse approval already covering that plan; honor `git-auto-commit` and any stronger workflow confirmation such as legal's mandatory document review.
2. Before writing, recheck all three candidates against the recorded contents/existence, including a legacy copy newly created by an older client. Changed inputs invalidate the pending write; stop and resolve them without overwriting either history. Repeat resolution after any branch switch because paths and data can differ between branches.
3. Create `.helm/` only now. Write the intended updated state to `.helm/{filename}`, then read it back and validate the complete result. Verify that all loaded history/fields were carried forward, except for the owning workflow's documented updates or the user's approved reconciliation. A write/read-back failure preserves legacy sources, blocks the checkpoint/commit, and is reported as incomplete.
4. Until commit approval is available, keep legacy sources intact. If the user declines the commit, leave any canonical draft and other workflow outputs pending as that workflow allows, report the migration as pending, and do not delete legacy files. On a later invocation, differing draft/source contents require explicit reconciliation; do not silently prefer the draft.
5. Once verification and the required commit authorization are complete, retire only this filename's queued legacy sources. Stage the verified canonical file and tracked legacy removals together with explicit paths in the same owning-workflow commit. Use `git add -- .helm/{filename}` and `git add -u -- {tracked_legacy_paths}` after removal; omit the latter when none are tracked. An untracked legacy source is removed only after verification and authorization too, but has no Git deletion to stage. Never use a wildcard, `git add -A`, or remove either parent directory or unrelated files. Do not remove a legacy file that changed since resolution.
6. Verify the commit includes the canonical result and every applicable tracked removal. If cleanup, staging, or commit fails, stop checkpoint advancement, preserve the verified canonical copy and remaining sources, and report the exact pending changes. Do not claim migration completed or reset unrelated user work. After each verified write and successful commit, refresh the recorded snapshots to reflect this workflow's own changes before another checkpoint; unexpected external changes still require resolution.

Successful migration ends writes to legacy paths; never dual-write. Client-specific settings, `.claude/rules/`, other `.claude/` content, and `.archive/` are unaffected. Update both clients' complete Helm packages before switching between them; an old installed workflow can recreate legacy state. Concurrent writers in the same working tree remain unsupported.

Report the loaded path(s), canonical destination, and migration status (not needed, completed, pending, or blocked) in the owning workflow's final summary. Never claim other commands' files migrated.
