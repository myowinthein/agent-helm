---
title: "Step 4: Documentation"
parent: /helm:archive
grand_parent: Commands
nav_order: 4
---

# Step 4: Documentation

Write current recovery instructions while retaining useful historical evidence. Reuse verified prior reports and targeted source reads; distinguish current facts, historical claims and unknowns. No invented commands, versions, demo results or future availability.

Use prior reports and record this step's approved report only in the [validated run directory](../archive.html#archive-directory-and-existing-projects): canonical `.helm/archive/` only. Current docs reference that actual directory where needed; historical reports remain verbatim. Recovery documentation stays at its approved paths below, outside state storage.

## Review before editing

Inventory docs by purpose and show a coherent per-file Keep/Update/Merge/Archive/Remove plan. Keep/link useful content by default, including build/CI/deployment notes, runbooks, architectural decisions, changelogs, contributor context, LICENSE/NOTICE and generated docs that may not be regenerable. Being old or public-facing is not a removal reason by itself.

Only remove/merge/move through a specific reviewed value/reference decision. A tracked-file removal preserves Git history but may make evidence harder to discover; disclose it. Reuse exact unchanged approval, while preserving all protected files and imports. No secrets, private records, real credentials or production endpoints in generated docs.

## Recovery outputs

| Output | Contents and restraint |
|---|---|
| Archive index, normally `README.md` | Orientation: source/snapshot/status, purpose/stack/goal, supported recovery entry, requirements/data/limits and links. Preserve useful content; a fresh rewrite needs its reviewed content/value plan. |
| Setup reference, normally `docs/setup.md` | Ordered developer procedure: source/config/tools, load or native preparation, database-engine startup as needed, restore data before consumers, run/demo/API/stop and limits. Link full artifact identities in metadata while retaining executable command arguments. |
| Inventory snapshot, normally `docs/archive-metadata.md` | Human-readable Markdown tables: source/snapshot, full artifact identities/platforms/checksums/byte sizes/provenance/storage, data classification, actual API outcome/paths, scoped verification dates/platforms and omissions. No new JSON schema or duplicate command manual. |
| Optional `docs/historical-notes.md` | Useful separately labelled context when beneficial; no forced wholesale merge of every historical document. |

Check protected imports before writing any required output. An imported README/setup/metadata target stays byte-for-byte at its path; choose an approved unused alternate output and update recovery references, or stop for instruction reconciliation. Do not extract content/repoint imports or edit AGENTS.md/CLAUDE.md ownership/settings. Opaque Helm state/rules stay in place and are exempt from recovery navigation.

Archive uses its own README information contract, independent of manifest and `readme-style`, without invoking manifest or introducing a shared README helper. Adapt the useful existing structure to include the last working state, quickest supported recovery route, platform/runtime/artifact requirements, data presence/classification/missing inputs, verified versus unknown behavior and links to setup/metadata/API/retained supplementary docs. Preserve the licence and state maintenance/support intent only when confirmed.

Separate snapshot date from actual verification dates/platforms. Step 4 precedes the payload and ship receipt: do not claim a published backup or insert an unqualified permanent publication status requiring a post-seal edit. Link the actual persistent run directory only when it is a valid tracked target; do not create a dangling link to a future Step 5 report. Use a plain path until a target exists.

Setup uses the actual paths chosen earlier and carries approved Step 2 commands unchanged where accurate. Legitimate later configuration/asset changes update current instructions and inventory/checkpoints, while old approved reports stay verbatim. Record missing native SDK/binary inputs explicitly; version documentation alone is not a working freeze.

The metadata inventory owns full artifact identity tables; setup links them and keeps the ordered instructions useful for the selected container/native/static/library approach. Metadata reflects the checked recovery snapshot rather than duplicating raw AI reports. Record actual retained/repaired/created/skipped API files: `Postman collection generated: no` alone does not imply no API or useful collection.

## Reference and navigation verification

Read back the approved index and follow links to active recovery docs. Check actual image/data/config/build/script/spec references and restore ordering against preserved evidence, not only file existence. Later Step 5 asset moves must update that same dependency wiring before sealing. Protected instructions/rules/state never become orphan-cleanup targets.

Document runtime tokens as local provisioning instructions/placeholders, never persisted values. Report actual static/build/run/data/cold-rehearsal/offline-rebuild evidence and unrun/deferred checks separately. No tests/builds/API execution is implied by documentation writing.

## Report and approval

Report consolidation decisions and protected preservation, exact created/updated/removed paths/reasons, current navigation/reference checks, accepted missing inputs and remaining gaps. No commit or push. Stop for explicit approval before the separately reviewed local payload preparation. Ship's later archive backup procedure owns the private backup publication. See the [archive guide](../archive.html) for progress, partial outcomes and preservation rules.
