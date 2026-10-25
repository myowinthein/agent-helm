# Step 4 — Documentation

Make future recovery understandable from preserved evidence, with current instructions and useful history retained. Read verified `step1-explore.md`, `step2-restore-and-freeze.md` and `step3-postman.md` within the orchestrator's validated `{archive_root}`; missing/mismatched context stops dependent work.

## Preservation and consolidation plan

Apply the orchestrator's protected-instruction/import/rule/state policy before planning any output. Preserve original paths/content/bridges and Helm settings. A protected README/setup/metadata/other target needs a reviewed alternate unused path with correct recovery references, or a stop for instruction reconciliation outside archive. Do not copy global/external instructions; document required dependencies instead. Other workflows' operational Helm records remain opaque. Neither those records nor archive's own reports/state are consolidation/assets/cleanup targets. Keep recovery deliverables at their approved purpose-specific paths; any current archive-state reference uses the actual `{archive_root}`, without rewriting historical reports.

Inventory existing documentation by purpose and read relevant recovery/build/domain/history/contract context before proposing changes. Reuse validated facts and target changed dependencies; do not repeatedly reread the entire source tree. Separate verified current facts, historical claims and unknowns. Do not invent versions, setup/demo commands, API results or future availability. No secrets, private records, real credentials or production endpoints in generated docs. Credential-free approved archive destination identity is included only as reviewed recovery information.

For each proposed action, explain value, exact paths and effects, retaining useful content by default:

| Existing material | Default decision |
|---|---|
| Accurate recovery/setup/domain/API evidence | Keep and link; minimally repair actual gaps. |
| Build/CI/deployment notes and runbooks | Keep useful commands, versions, provenance and operational context, clearly labelled where historical. |
| ADRs, changelogs, release notes, contributor guidance | Retain useful design/behavior/history; do not remove solely because active development ended. |
| LICENSE/NOTICE and other relevant legal documents | Preserve; no automatic legal rewrite or deletion. |
| Generated documentation | Keep when useful or not demonstrably regenerable from preserved inputs. |
| Duplicate/outdated content | Prefer links or a reviewed minimal merge/update; preserve useful originals/history when necessary. |
| Proven no recovery/historical value | Remove only by explicit per-file reason and approval, checking references first. |

Present the complete coherent consolidation/output plan and wait for approval before edits. Reuse approval already covering the exact unchanged plan. A generic cleanup approval never permits protected-file changes or wholesale history loss. An approved tracked-file removal does not rewrite Git history, but can make recovery evidence less discoverable; disclose that effect. Do not move everything into one historical file merely because it is old.

## Current recovery outputs

### Archive index, normally README.md

Preserve useful existing README content and style through focused edits where possible. Propose a fresh archive-focused index only when the reviewed content/value plan justifies it. For a protected README, offer **Keep protected README and create an archive index** at a reviewed unused path such as `docs/archive-index.md`, or **Stop for instruction reconciliation**. Keep protected files/imports byte-for-byte; do not extract from or repoint them. Record actual index/setup/metadata paths in report/inventory/metadata, including approved alternatives for other protected outputs.

Use an archive-specific information contract, independent of manifest and `readme-style`; do not invoke manifest or introduce a shared README helper. Fit these facts into useful existing structure, with a whole rewrite only under the reviewed plan:

- Snapshot/source/date and current preparation status; distinguish snapshot date from actual scoped verification dates/platforms.
- Project purpose/stack, last known working state and selected recovery goal/complexity.
- Quickest supported recovery route, linking the ordered setup rather than copying every command.
- Actual platform/runtime/artifact requirements and required data presence/classification or missing inputs.
- Known limitations, unverified dependencies and what has actually been checked.
- Links to setup, artifact metadata, applicable API materials, retained useful docs and supplementary material.
- Existing licence and only confirmed maintenance/support intent. Do not assume archiving means unsupported or unmaintained.

Keep the index an entry point, not a copy of raw reports. This step precedes the payload and later ship receipt: do not claim a published backup or insert a permanent unqualified publication status that needs a post-seal edit. Label any publication statement as the checked snapshot's status. Link the actual persistent `{archive_root}/` directory only when it is a valid tracked navigation target; do not link a future Step 5 report before it exists. Use a plain path when a target is not available yet.

### Setup reference, normally docs/setup.md

Use the actual approved path from Step 2. Carry over its verified commands unchanged where still accurate; update current commands only from reviewed evidence if later config/data/asset changes require it. Historical approved reports stay verbatim, with legitimate supersession in inventory/checkpoints rather than editing old evidence.

Include applicable sections:

- **Environment:** original/last-working versus actual restored versions; OS/architecture, Engine/Compose/API/SDK/toolchain constraints, native lockfiles and missing inputs. Vendor support is not checked unless evidenced. No universal version-list freeze guarantee.
- **Restore & Run:** ordered source/config/artifact prerequisites, linking the metadata inventory for full identities/checksums while retaining explicit image arguments needed by executable commands. For container recovery, load images, start an isolated database engine if needed for restoration, restore database/file inputs to fresh owned storage, then start dependent application components with the approved isolation/recovery mapping. Use supported no-build/no-pull commands only for the recorded toolchain; missing images/inputs must not silently trigger acquisition. Native/static/library recovery uses its evidenced procedure instead of invented container steps. Include initialization order, credentials-as-placeholders/local provisioning, demo/access/stop instructions and expected results.
- **Recovery Priority:** required, optional and unused components, actual captured runtime versus offline rebuild inputs, plus artifacts omitted or stored separately and how to obtain/verify them.
- **Demo:** useful reproducible UI/API/CLI/library/notebook/native workflow when relevant, synthetic/demo setup without persisted runtime tokens/private records; skip only genuinely inapplicable subsections.
- **API:** actual Retain/Repair/Create/Skip/not-applicable outcome, owned specs and retained/updated Postman paths/import instructions, source-only limitations and script/client caveats. `Postman collection generated: no` alone does not mean the API or retained collection is absent.
- **Restoration Fixes:** approved changes and why, compatible deviations and future recovery constraints.
- **Verification & Known Limitations:** actual static/build/run/data/domain results, cold rehearsal and offline rebuild performed/not performed, capability/deferral gaps, storage/backup evidence and missing components. No blanket recovery guarantee.

### Inventory snapshot, normally docs/archive-metadata.md

Keep a human-readable Markdown inventory, without a new JSON schema/profile file: name/snapshot date/purpose/source branch+commit; selected recovery goal and complexity; actual stack/platform/toolchain; restoration outcome; scoped verification dates/platforms/results and developer-check outcome when recorded; unique artifact paths/full identities/digests/SHA-256/byte sizes/provenance/storage and verification scope; data classification/consistency and source paths; `Postman collection generated: yes/no` plus actual API outcome/retained paths; approved index/setup/spec paths; rough versus verified storage route/backup omissions; support unknowns and missing runtime/rebuild inputs. Keep full artifact identity tables here and link them from setup; this is neither a second command manual nor a dump of AI reports. Approved reports remain historical evidence, while this inventory reflects the current checked recovery snapshot. Final receipt publication is verified later, not invented here.

### Optional docs/historical-notes.md

Create only for useful historical context that benefits from a separate readable home. Preserve meaningful source references, labels and existing historical docs where better than a wholesale merge. No invented reconstruction of why the project was built.

## Verify documentation and references

Use static readback/link/path inspection before claiming the step's outputs complete. Follow the actual approved index to each active recovery document. Check referenced image/data/config/script/spec paths, setup command ordering and intended image mapping against Step 2/3 evidence, not file existence alone. Protected instructions/rules/opaque state are exempt from recovery navigation and never removed as orphan docs.

Step 5 may move assets only through its reviewed dependency/reference check. It must update current setup/index/metadata/config/manifest paths and verify closure before sealing, preserving historical reports. Missing evidence or deferred runtime execution stays labelled; do not run tests/builds/API requests just to write documentation. Record all approved file changes/fingerprints and legitimate earlier-output supersession.

## Report

- **Consolidation Summary:** protected inputs preserved; each reviewed remaining document's Keep/Update/Merge/Archive/Remove decision and reason, including retained build/legal/history evidence.
- **Files Created:** actual new output paths/purpose, including any alternate index/setup/metadata.
- **Files Updated:** meaningful existing-file changes and evidence used; historical reports unchanged.
- **Files Removed:** exact approved paths/reasons/reference review, or none.
- **Navigation:** approved index and reachable active recovery docs, image/data/config/reference consistency and protected-file exemptions; report gaps rather than claiming unperformed checks.
- **Gaps:** missing/deferred/unverified inputs, backup and runtime/rebuild limits, exact pending actions.

No commit or push. Present this report and wait for explicit approval before Step 5, which separately approves the local payload commit; only a later explicit ship archive approves private backup publication/receipt and any opt-in ref cleanup.
