# Read-only ledger helper

Load at refactor/test's eligible own-state entry when an existing record or an authorized write needs validation/retrieval. The parent alone invokes it. Explicit source-only/report-only routes, workers, unrelated commands and agent switches gain no helper or ledger access. Apply the shared runtime's mechanical-helper boundary; this operation executes no project code and grants no writes or approval.

## Invoke only the needed operation

Use an available Python 3.11+ interpreter and this loaded package's `helpers/helm.py`, with isolated imports and bytecode disabled. It uses the standard library, reads only its fixed contract and permitted own record, and has no Git/subprocess/network calls or writer. Keep the consumer workspace as cwd, outside the loaded package. Do not inspect implementations or load the machine contract again merely to repeat a verified packaged check.

```text
python3 -I -B "<package_root>/helpers/helm.py" ledger-view
python3 -I -B "<package_root>/helpers/helm.py" ledger-check
```

Pass one complete JSON request on stdin through a safe pipe/execution API, never shell interpolation or a scratch request file:

```json
{"interface_version":1,"owner":"test","workspace":"/absolute/consumer/project"}
```

Owner is `test` or `refactor`, selecting only `.helm/test-log.json` schema 3 or `.helm/refactor-log.json` schema 2. No arbitrary path, other owner, archive or old-format input is accepted. The helper checks containment/regular files and that owner's unsupported old paths without reading old records, then validates the complete canonical JSON and cross-field consistency. The [machine contract](../../helpers/ledger-contract.json) owns field shapes and resource limits; the owning workflow defines meaning, human choices, provenance and checkpoint eligibility. Unknown data is preserved, never interpreted as instructions.

- **Initial index/retrieval:** call `ledger-view` once without a digest at offset 0. It validates the full input and returns the first bound index page together. Do not add a separate `ledger-check` solely to prepare that initial view.
- **Validation only/readback:** use `ledger-check` for a summary without records. It returns state/priority counts and counts of decisions/blockers for a valid input.
- **Continuation or revalidation:** pass `expected_digest` from the prior result, including offset-0 refiltering of that same snapshot. Never omit it to accept unexpected drift. Every later page requires it.

After safe owner preflight proves the record absent and the unsupported-path guard passes, there is no input to parse: skip helper/runtime setup until an authorized first write needs validation. Either helper operation can also report absence without creating anything. Missing is not a validated empty document or an empty successful page.

## Results and bounded retrieval

Success returns `{interface_version, owner, result}`. Results identify `status` (`valid`/`missing`), canonical `path`, current `schema_version`, complete-byte `sha256` (null if missing), `structurally_validated` and `records_total`. Valid results include root `anchors`. `source_review`, `runtime_verification` and `human_authorization` remain false: structure proves none of those.

A view adds `total_matched`, `offset`, `returned`, `next_offset`, `projection` and `records`. Optional request fields:

| Field | Meaning |
|---|---|
| `expected_digest` | Prior result's SHA-256; required for continuation and binding later work to that snapshot. |
| `projection` | `index` (default) or `records` for full selected records, including unknown fields. |
| `filters` | Nonempty string arrays: `ids`, `paths`, `states`, `priorities`, `terms`; refactor also supports `categories`, `risks`. OR within a filter, AND across filters. Omitted filters include all states. |
| Path/text matching | Paths are literal case-sensitive exact paths or directory prefixes at `/` boundaries. Terms are case-insensitive literal substrings throughout a record, including custom text. No globs/regex or file access. |
| `offset`, `limit` | Zero-based matched offset and page size, default 0/20, maximum 100 per page. Preserve stored order. |

Index rows retain stable IDs, full summary/expected text, paths, state, priority, assessment commit and held/blocked flags, plus refactor category/risk/dependency/recurrence or test action fields. Retrieve full relevant records across all states before semantic reconciliation; index flags, counts and an empty scoped result prove neither resolution nor project-wide currency. Continue the unchanged query/digest until `next_offset` is null when complete coverage requires it. Do not fetch irrelevant history or reconstruct a ledger from pages.

Requests are bounded to 64 KiB, complete ledgers to 32 MiB, responses to 256 KiB, depth to 64, nodes to 500,000 and records to 100,000. Results never silently truncate. Reduce page size/narrow the query on an oversized response, preserving required coverage; a whole-input limit or an oversized single record remains a reported limitation, never permission to prune evidence. Unknown JSON numbers stay numeric and exact. Preserve their bytes or use lossless structured tools when carrying records into edits; a normal JavaScript-number round trip cannot guarantee preservation.

## Unavailable runtime and failures

If required Python/execution is unavailable, use the caller's QM Single once: **Set up Python / Continue without Python / Stop**. Reuse an applicable answer. Setup needs concrete effect authorization and adds no permission to change global/client settings. Continue without Python permits only an already available, verified structured tool satisfying this same contract, including strict parsing, owner/path guards, complete validation, digest-bound retrieval and exact preservation/readback. Do not generate another validator, alternate writer or fallback framework. If those guarantees cannot be established, stop the workflow; do not continue advisory source work or manufacture an empty record. Keep the method in the existing report, not a new setting or artifact.

Failures return no success on stdout. Stderr has `{interface_version, error: {kind, message, location?}}` using fixed diagnostics/schema locations without input values or raw parser exceptions:

| Exit/kind | Action |
|---|---|
| 2 `invalid_input` | Correct a malformed request or oversized page at the same gate, under the runtime's bounded correction rule; do not edit the record to satisfy it. |
| 3 `runtime_unavailable` | Use the once-per-run choice above only when this operation is needed. |
| 4 `invalid_state` / `unsupported_state` | Preserve input and stop. No conversion, reset, old-path bypass or replacement method. |
| 5 `conflict` | Stop on changed/missing evidence; never discard the old digest and continue with a fresh baseline. |
| 6 `io_error` | Stop and report unavailable access; no permission changes or guessed success. |
| 7 `internal_error` | Report the package defect and stop; never patch/recreate installed code in the consumer run. |

A missing bundled resource is a package defect. Distinguish a request/transport bug from invalid state or a denied operation. Safe diagnostics must identify the failing check without exposing content. Host restrictions remain binding.

## Writes remain caller-owned

There is no helper writer. Existing approved persistence uses the complete safely parsed original, precise ID-keyed changes, preservation of untouched/unknown data and numbers, expected bytes/existence, source/branch/approval checks, canonical readback and exact-path commits. Validate the resulting complete record with `ledger-check` or the already verified equivalent, then compare the reviewed delta and preservation separately. Do not create a journal/schema/migration, regenerate history from pages or certify semantic evidence through a parser. Concurrent writers remain unsupported; a digest is not a lock or filesystem sandbox.
