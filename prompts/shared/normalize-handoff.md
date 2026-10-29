# Local normalize handoff

Loaded by normalize for an approved rewrite/resume or ship's history/release-evidence discovery. Log/manifest may use only **Location and bounded I/O** for read-only lookup under [review-anchor recovery](review-anchor.md), then return there; ship's selection/publication requirements below are not their procedure. A locator finds private recovery evidence across sessions and hosts; it grants neither approval nor proof. Other workflows and source maintenance leave real locators and recovery records untouched. No live-ledger access, tracked record/schema change, global setting or automatic cleanup follows.

## Location and bounded I/O

Resolve the selected clone's actual common Git directory with `git rev-parse --path-format=absolute --git-common-dir`; never assume `.git` is a directory or use a worktree-private Git directory. The exact owned lookup location is `{git_common_dir}/agent-helm/normalize-handoffs/`. It is local to this clone, shared by linked worktrees and absent from pushes/clones. External recovery directories stay outside the checkout. Existing locators and verified evidence paths remain usable regardless of normalize's new-run storage convention; never scan the home storage parent to discover backups. Moved/deleted backups or a new clone/machine may need an explicit transferred evidence path; no private-directory search or automatic upload.

Each rewrite has one immutable `{run_id}.json`, with a fresh lowercase UUID or equivalent collision-resistant ID. Use only these fields:

```json
{"run_id":"unique-run-id","recovery_directory":"/absolute/private/run-directory","entrypoint":"handoff.json"}
```

The entrypoint is a JSON data basename in that directory, not a script. Use the run's existing private plan/index record, or a small index identifying the original repository/refs and named proof files. Prepare it before filtering and retain actual pending/verified results there under normalize's existing recovery procedure. A locator contains no review coverage, mutable status, remote lease or copied graph/map; the private evidence remains authoritative.

The packaged standard-library Python 3.11+ `helpers/normalize_handoff.py` handles only locator I/O. It performs no Git, network, recovery-body reads, ledger access or publication. Pass paths/IDs as individual data arguments:

```text
python3 -I -B {package_root}/helpers/normalize_handoff.py register --git-common-dir {git_common_dir} --run-id {run_id} --recovery-directory {recovery_directory} --entrypoint {entrypoint}
python3 -I -B {package_root}/helpers/normalize_handoff.py discover --git-common-dir {git_common_dir}
```

Use the actual host's safe equivalent tools when Python or required filesystem operations are unavailable; do not install tools or load the ledger-helper runtime here. Equivalence requires all the same checks below. Without safe registration stop before rewriting; unavailable automatic discovery uses the existing explicit-path fallback only when evidence is needed. Ordinary ship work acquires no Python setup gate.

- Resolve canonical absolute paths; refuse symlink traversal, linked/nonregular leaves, foreign ownership and unsafe writable metadata directories. Locator directories use 0700 and files 0600, or verified equivalent access restrictions. Preserve existing files/permissions; never repair them automatically.
- Locator JSON is strict UTF-8, at most 8 KiB, with exactly the three string fields and no duplicate keys. Filename/run ID must agree; IDs contain only lowercase ASCII letters, digits and hyphens, at most 80 characters. Recovery paths are absolute; entrypoints are JSON basenames, not traversal paths. Check recovery-directory/entrypoint metadata without opening bodies. A small entrypoint is at most 256 KiB; full graphs/maps remain separately named proof inputs under the existing publication protocol.
- Enumerate only the exact locator directory, at most 1,024 entries. Exceeding the limit stops automatic selection without truncation; retain everything and follow the caller's fallback. Recognized unfinished `.pending-` writes are not locators; unexpected or invalid entries remain visible issues. Capture results transiently and inspect bounded summaries, not an entire registry/proof dump.
- Register only after the existing rewrite approval and verified recovery preparation. Publish a complete locator atomically without clobbering another file, then read it back **before filtering**. An identical already-written locator may satisfy an uncertain same-run retry; a collision/different body stops. Registration failure retains the backup and prevents rewriting. Independent locator files do not authorize concurrent Git/normalize writers.
- Ship and permitted review-anchor discovery are read-only: never create locators, rebuild missing evidence, run saved scripts, mark runs consumed or delete anything. Keep earlier locators after publication because later correspondence can still need them. Source updates do not retroactively register old operational runs.

## Discovery and selection

Ship probes this exact local location during its existing assessment, before asking the developer to find a path. A conversational or explicitly supplied handoff remains supported; reconcile it with discovered candidates rather than silently overriding a conflict. Parse locators as untrusted data. `present` means only safe path metadata exists, not that a rewrite completed or its proof passed.

Read bounded identity/ref information from the identified data entrypoints, then validate required full evidence under [history publication](history-publication.md). Match actual repository, original and rewritten objects/refs, subsequent branch movement and remote containment. Use one uniquely established relevant run or a fully proven sequence automatically. Deduplicate identical directory/entrypoint references; never choose by timestamp, filename order or newest-folder heuristics. Provably unrelated runs need no full proof load or human picker.

Repeated rewrites may have checkpoint/application commits between them. Validate each original/current-run map, intervening ancestry/content and affected refs independently before following an ordered correspondence across runs. Preserve the original maps; never guess a link, flatten unverified maps or require adjacent recorded tips to be identical. Disclose each run and every affected publication/local-only branch under the existing review. Release correspondence may need older already-published runs; do not mistake their rewritten IDs for new product work.

Missing, invalid or conflicting evidence cannot be silently dropped when it might supply a required history/release link. Keep the dependent action pending and ask once for the missing path, necessary run set or reconciliation. An unrelated stale locator does not block independently proven ordinary publication. A pre-filter-only run needs actual proof of unchanged refs before being reported as unapplied; an interrupted rewrite with incomplete verification stays pending, never auto-runs filtering or becomes an ordinary-push fallback.

After selection, all existing full-proof, tag preservation, fixed remote-expectation/lease, subsequent-change review and final publication approvals remain. Automatic discovery removes path bookkeeping, not these gates. Report the selected recovery location briefly for transparency; remembering or copying it is not a prerequisite on the normal same-clone path.
