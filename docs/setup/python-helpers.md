---
title: Python ledger helpers
parent: Setup
nav_order: 8
permalink: /docs/setup/python-helpers.html
---

# Python ledger helpers

Refactor and test prefer one shared read-only Python helper to validate their complete current ledger and retrieve small selections. Claude and Codex run the same installed implementation, with an approved equivalent-tool fallback when Python/execution is unavailable. Source assessment, findings, priorities, human decisions and verification remain the workflow's responsibility.

## Preferred runtime and fallback

The bundled helper needs **Python 3.11 or newer**, with standard-library modules only. Python is preferred, not mandatory for the workflow when equivalent tools can meet the same checks. The interpreter must be available in the agent's actual shell/execution environment. A Python installation in your terminal does not establish availability inside Cowork or another sandbox; neither agent is assumed to bundle Python.

When Python/execution is unavailable at a normal owning-state step, explain the limitation and offer **Set up Python / Continue without Python / Stop**. Ask once for the run, honoring a choice already given; reuse it for pages, cases and later readback. Keep the choice in conversation and the existing outcome report, not a setting or ledger field. Resume can reuse a known choice when its scope is clear.

- **Set up Python:** use a compatible existing interpreter or explain the concrete setup operation/instructions. Install or change the environment only with authorization covering the actual operation and effects; no automatic Python/package installation, permission changes or client-setting edits follow.
- **Continue without Python:** use available safe equivalent tools under the same readable contract and workflow. Disclose the actual validation method and which Python automation did not run. This does not authorize edits, commits or weaker validation.
- **Stop:** preserve work/checkpoints and report the handoff, without creating an empty ledger or claiming completion.

If suitable equivalent validation is unavailable, independent source assessment/planning can continue while ledger-dependent edits/writes remain pending. Refactor Audit/Plan remain available without Python, ledger reads or a runtime-setup question. Other workflows keep their existing tool requirements; normalize's rewrite path already has its own Python/filter-repo prerequisite.

Refresh the complete plugin package, including `helpers/`, and start a fresh task after an update. A missing helper or contract is a broken installation. The consumer project receives no helper copies or caches. When using Helm on its own development checkout, invoke helpers from a separate installed plugin, keeping the package and consumer workspace distinct.

## Two internal operations

These operations support workflows; they are not additional commands in the skill picker.

| Operation | Result |
|---|---|
| `ledger-check` | Validate the entire current owner ledger and return its original-byte SHA-256, roots, record count and aggregate counts. A missing file is reported without creating anything. |
| `ledger-view` | Revalidate that same digest, then return a filtered, paged index or complete selected records. Includes total matches and the next offset. |

The helper accepts only owner `refactor` with `.helm/refactor-log.json` schema 2, or owner `test` with `.helm/test-log.json` schema 3. It does not accept arbitrary ledger paths, archives, old formats or draft files. Only the invoked owner accesses its file at its eligible workflow step. Refactor Audit/Plan, workers, unrelated commands and source maintenance never invoke it or read live records.

Each invocation uses an isolated interpreter and disabled bytecode, for example:

```text
python3 -I -B "<installed-package>/helpers/helm.py" ledger-check
```

The parent supplies a complete JSON request on stdin with `interface_version: 1`, its `owner` and absolute consumer `workspace`. For a view, it adds the check's actual `expected_digest`. Optional filters select IDs, path/directory prefixes, states, priorities and literal text; refactor also supports its raw categories and risks. Filter values combine as OR within a list and AND between lists. All states remain eligible unless filtered. `index` is the default projection; `records` includes complete selected objects and custom data.

The helper never echoes the request or returns the whole ledger by default. Follow `next_offset` with the same digest and filters; changed bytes stop retrieval rather than mixing pages from different versions. Literal text/path matching supports retrieval, not semantic deduplication. The parent retrieves related findings and human decisions as needed, including closed history.

## Validation and limits

Complete parsing rejects duplicate JSON keys, unsupported versions, wrong field types/enums, malformed full commit IDs and dates, unsafe relative path shapes, duplicate record IDs and inconsistent closure data. Refactor also checks native provenance, finding references and recurrence cycles. Unknown fields remain uninterpreted data. A successful structural check does not establish commit availability/ancestry, current applicability, a genuine human decision, complete source review or passing tests.

Approved available local fallback tools must establish that same complete validation before dependent use, including exact unknown numeric data and all owner-specific cross-field checks. A JSON viewer or syntax parser alone is insufficient: some parsers accept duplicate keys or round numbers. The same no-follow containment, owner-only old-path guard, resource bounds, SHA-256 of original bytes, bounded retrieval with totals/continuation and drift checks apply. Approved existing persistence still needs the complete original, preservation/delta evidence and full canonical readback validation. No project scripts/configuration, network requests/uploads, new runtime installs, persistent fallback scripts or extra files are introduced just to obtain a fallback. Transient read-only validation/retrieval code retains these same effect limits and adds no alternative writer. A manual visual review alone cannot replace these checks.

The readable package file `helpers/ledger-contract.json` defines structural shapes, current schema enums, owner filenames and bounds. Workflow prose defines their meaning and source/approval/verification requirements. This is a helper interface contract, not a new ledger schema. Existing IDs, layouts and record history are not migrated or rewritten.

Requests are limited to 64 KiB, ledgers to 32 MiB, responses to 256 KiB, JSON depth to 64, nodes to 500,000 and records to 100,000. Pages default to 20 records and allow at most 100. These bounds are resource limits, not reasons to prune history or narrow a source scan. An oversized page fails without truncating fields; request fewer records or index projection. If one complete record is too large, report that retrieval limit and preserve it.

Python helper failures provide a structured kind and safe location without raw ledger values: invalid request, unavailable runtime, invalid/unsupported state, changed input, IO failure or helper defect. Only actual runtime unavailability offers the fallback choice. Invalid requests need correction; malformed/unsupported data, old-path guards, resource limits, drift, access failures and broken installations retain their blockers. Switching tools cannot bypass a rejected check. No automatic conversion/reset occurs. Symlinks/junctions, conflicting occupants and detected file/parent changes block dependent access. Digest checks detect ordinary drift; they are not a lock or sandbox. Concurrent writers remain unsupported, and host permissions remain binding for either method.

## No ledger writers

This interface writes nothing and performs no Git, subprocess, network or project-code execution. It does not create `.helm/`, a journal or another persistent index. Existing approved workflow writes still need the complete safely parsed original, exact ID/root changes, preservation checks, matching source/branch policy, readback and local commit rules. Helper pages must never be used to reconstruct the ledger. The helper can validate the canonical readback, but that alone proves neither a correct edit delta nor checkpoint eligibility.

With approved equivalent tools, use the same complete preflight and canonical readback checks and report the actual method. Without that evidence, a permitted manual bounded view stays advisory and ledger-dependent work remains pending; never reconstruct history from pages or claim that automation ran. No helper writer is added by fallback. Standalone copied Git, safety and writing rules retain no Python or plugin dependency.

The implementation and workflow integration are added with execution testing deferred. No cross-platform or end-to-end validation is claimed yet; ledger writers remain a later change.
