# Normalize review mechanics and schema 2

Load only from normalize's owning review entry. This is a supporting contract, not a skill or a state migration. Source maintenance never reads live normalize records. Only schema 2 is supported; there is no schema-1 reader, compatibility conversion or automatic reset. An unsupported record blocks reuse and dependent mutation, while independent committed-message review can continue without it.

## Mechanical checks and semantic coverage

Use the packaged standard-library Python 3.11+ helper at `helpers/normalize_check.py`. It reads one JSON object from stdin and writes JSON to stdout; it opens no files, runs no Git/project commands, writes no state and uses no network. The parent separately collects exact committed objects and resolves policy using normalize's existing local-only Git rules. Keep raw messages, policy inputs and graph data inside safe local tooling, not shell interpolation or temporary reports. Never print secrets. Output pages contain IDs/diagnostics, not message bodies.

Invoke `python3 -I -B {package_root}/helpers/normalize_check.py check` or `plan`, with structured JSON stdin. These are helper operations, not new workflow modes or user pickers. Optional `--offset N --limit N` pages at most 200 records (default 100); subsequent pages require `--expect-digest` from the first result. Reconcile every page/ID; do not certify from the first page or counts. Limits: 32 MiB JSON, 100,000 commits, 256 branch records/tips, 1 MiB per UTF-8 message. Oversized/incomplete/invalid input is an explicit blocker for this helper, not a truncated success. Use bounded equivalent local tooling or the full manual review when the helper/Python is unavailable; do not install tools automatically or relax data/coverage checks. Invalid state stays blocked.

The effective `policy` object contains `resolved` (Boolean), `rules` (object) and `semantic_rules` (array of strings). Include every effective rule, exception, language/body/footer constraint and direct owner instruction in the normalized rules/semantic rules; never omit an unknown rule to obtain a reusable fingerprint. Normalize meaning consistently, preserving meaningful ordering. Source paths/raw configuration remain transient evidence; unrelated comment/review-marker edits need not change the effective policy. `resolved: false` disables reuse and checkpoint advancement. Never execute arbitrary config, custom plugins or extends to resolve it.

Supported mechanical `rules`: `types` and `scopes` (arrays or null for unrestricted), `scope_required` and `type_case_sensitive` (explicit Booleans), `header_max_length` (positive integer or null). Other rule keys are reported as unsupported and need manual checking; a diagnostic against this subset is not a final spec/project classification when exceptions apply. The policy fingerprint is SHA-256 of the entire effective policy encoded as sorted-key compact JSON, ASCII-escaped, with no omitted fields. The helper returns that fingerprint; do not invent or copy one from a different policy. Unknown/custom rules must be resolved and assessed manually before full semantic acceptance, even when no supported check fails.

`check` input adds `commits: [{"id": "<full lowercase SHA>", "message": "<complete original UTF-8 message>"}]`. Use exact IDs, no duplicates, full bodies/trailers and preserved newlines. Other encodings remain explicit manual/unsupported cases without silent recoding. Results are `syntax: pass/findings/unresolved`, fixed diagnostic IDs and formal breaking-marker presence, always with `semantic: not_reviewed`. A parse pass never proves type, scope, description or breaking intent. The parent still reads every full message/metadata requiring semantic review and only fetches supporting diffs where intent needs them. Generated merges, reverts, fixups, multi-scope conventions and unusual languages need their actual policy/intent assessment, not automatic relabeling.

## Incremental selection

`plan` input adds:

- `commits: [{"id": "<SHA>", "parents": ["<SHA>"]}]`: the full frozen parent graph, including merge side-history and roots with empty parents. Every parent must be supplied; duplicates, missing parents and cycles stop. The caller also verifies actual Git identity, ancestry interpretation, shallow/promisor completeness and absence of replace/graft effects; JSON alone cannot prove real Git provenance.
- `tips: {"main": "<SHA>"}`: only the explicit message-review branches/tips, using short branch names matching ledger keys, not every rewrite-only branch.
- `ledger`: the fully validated owning schema-2 record, or null if absent/explicit full review. Do not suppress invalid/unsupported state by passing null as if it were absent. A full review may deliberately ignore a valid baseline for selection while preserving the actual record unchanged for later writing.
- `recheck_ids`: optional IDs for newly found mechanical/semantic concerns requiring reassessment. If one lies in a proposed reused prefix, the affected branch falls back to full review. Never hide a new retained finding under an old anchor.

The helper validates the graph and each selected branch independently. Reuse requires a full ancestor baseline, matching effective policy fingerprint, `review_kind: semantic`, and the current `review_contract: 1`. Missing/non-ancestor/incompatible/invalidated coverage selects the whole reachable branch history. Otherwise selection is `reachable(tip) - reachable(baseline)`, not a date range or first-parent walk; newly merged side commits remain included. Deduplicate the union across branches, but an unproven branch's required IDs cannot be subtracted using another branch's baseline. Syntax checks may still cover the full selected history locally without sending reused messages back to the model.

The result provides counts, per-branch reuse/fallback reasons and a digest-bound page of IDs requiring semantic review, in parent-before-child order. Empty remaining work with a valid baseline is a no-op, not a fresh full scan/date. Review all selected IDs to the existing depth. A deliberately bounded requested range may intersect this selection after exact set reconciliation; excluded/unreviewed history must remain explicit and cannot create a full-prefix checkpoint without a proven older prefix. No heuristic or path summary can silently remove an ID. Report syntax checked, newly semantically reviewed, reused prior semantic coverage and not reviewed separately.

This optimization affects message-review work only. All-affected-branch detection, complete descendant graphs, recovery, tag preservation, rewrite approvals and later ship publication retain their full contracts. The pure helper neither authorizes rewriting nor validates the all-branch rewrite graph.

## Schema 2

```json
{
  "schema_version": 2,
  "branches": {
    "main": {
      "last_checked_commit": "<full lowercase SHA>",
      "last_checked_date": "YYYY-MM-DD",
      "review_kind": "semantic",
      "review_contract": 1,
      "policy_fingerprint": "<64 lowercase hexadecimal characters>"
    }
  }
}
```

`last_checked_commit` certifies the entire reachable prefix was semantically assessed and accepted under the recorded effective policy/review contract, not that every possible mistake was detected. It is not a formatting-only cache. Record only fully covered accepted prefixes after actual semantic work and verified rewrites. Code checks, candidate heuristics, incomplete/bounded suffixes without older proof, unresolved policy, Keep/Defer or consistency-only rewrites never create full-tip coverage. Preserve unknown fields and untouched records. Require real canonical ISO dates, full 40/64-character lowercase commit IDs, valid branch names, semantic kind, positive integer review contract and a valid fingerprint. Higher/different review contracts remain structurally valid but cannot be reused by contract 1.

Do not refresh date/anchor for a reused no-op, syntax-only review, cosmetic serialization or bookkeeping-only tail. After a verified rewrite, remap an existing valid prefix only through the independent current-run map, preserving its policy/contract/date and proving all covered ancestry/message correspondence. If its policy/coverage is invalid, retain it only as non-reusable historical data or propose the existing explicit invalidation; do not label a consistency-only branch newly reviewed. Do not replace its fingerprint with today's to manufacture compatibility.

Only normalize writes this schema at its existing eligible approved checkpoint step. A missing record is created only by meaningful full semantic assessment, never an empty check. Preserve the same-branch commit policy, strict readback and unknown data. Schema 1 is unsupported; no automatic migration, conversion or deletion follows detection. The developer may explicitly retire obsolete records in a separate maintenance task; this source change never inspects or alters live records.
