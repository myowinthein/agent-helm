# Step 2 — Restore and Freeze

Restore the approved project scope and preserve its working environment and data for later recovery. Read the verified `{archive_root}/step1-explore.md` and `{archive_root}/files.json` first in normal mode, using only the root validated by the orchestrator; missing/mismatched context stops dependent work. Plan mode uses only static facts already inspected and never opens operational state, executes or writes.

Within this same phase, follow **restore plan → restore → actual evidence → offer developer check → freeze recommendation → approved freeze execution**. Initial freeze candidates are provisional. Keep the existing single Step 2 report/checkpoint; no extra phase, state field or setup workflow is introduced. For older reports without a component handoff, recover needed facts from bounded source/config/docs reads before dependent actions.

## Establish reliable setup inputs

For each required component, cross-check existing setup notes against its manifests/locks, scripts, CI, Dockerfiles, version declarations and actual platform. No source always wins: docs, a lockfile or CI can be stale or describe another component. Resolve material conflicts from compatible evidence or a concrete developer choice. Reconstruct missing instructions from inspected inputs and label them reconstructed; do not invent successful commands.

Consult version-matched official guidance only when needed to resolve a real setup/freeze decision. Current upstream advice is not permission to modernize an old project. Audit/Plan make no network requests and leave any needed external research to check. Record and obtain approval for necessary compatible deviations instead of silently upgrading.

## Plan before execution

Prefer compatibility fixes and restoration over modernization. Reuse existing project conventions and native tools. Before mutations, present one coherent plan covering:

- Selected recovery goal/features, original versus proposed versions/platform, exact file/output changes, missing inputs and accepted limitations. Apply protected-import checks before every write; use reviewed alternate paths or stop, never edit instruction owners/imports or opaque Helm ledgers.
- Intended commands, installs/pulls, project lifecycle hooks, Dockerfile steps/build context and entrypoints. Separate explicitly approved package/image acquisition from runtime service contact. No production/live database or external-service access; waiting for access is not permission to connect later. A developer may provide an approved export or choose a limited fallback.
- This host's Docker context/daemon or native runtime, dedicated project/container/process identities, fresh owned data targets, local endpoints and ownership evidence. Inspect broad bind mounts, socket/host-network/privileged settings, inherited env, external volumes/networks, jobs/schedulers, telemetry/webhook/message/payment paths and persisted endpoints.
- Supported project-local isolation, disabled integrations/jobs and localhost-only exposure as applicable. Placeholders and a dedicated project name alone do not stop egress or make shared storage safe. Do not alter global firewall/client settings. If the no-live-contact requirement cannot be met, leave affected execution pending/source-only. Retain an approved credential-free recovery override/configuration when needed so future recovery uses the same isolation; a temporary machine-only override is not a preserved setup.
- Data source/classification, exact import/migration/seed/backup targets and side effects, image/data outputs, scoped checks and optional cold rehearsal. Obtain missing action-specific approval, reusing authorization already covering this exact unchanged plan. No surprise broad test suite or another Helm workflow invocation.
- Rough sizes, free-space needs, intended provider/object limits/LFS or separate-backup route before costly exports. An estimate/user-known preference is not verified provider capability; Step 5 rechecks actual facts. Avoid creating large artifacts with no agreed preservation route.

When recovery needs a missing safe configuration template, include its exact native path/content in that plan. Use evidenced key names, placeholders and approved safe defaults, preserving tracking/ignore policy and protected imports. Never copy a real `.env` or credential values, or create empty/redundant templates merely for symmetry.

Before each side effect, verify capabilities, source/inventory and target identity again. No Git commit/push/fetch/pull/checkout/reset/rebase/merge/history changes in this step. Work inside the project except explicitly approved isolated runtime resources; another repository requires a developer-provided input or an explicit limited-scope decision. Record actual changes, partial output and commands without secrets. Reconcile interruption before reapplying imports, migrations or other non-idempotent actions; do not replay merely because the step report is unapproved.

## Choose a project-aware freeze

Use these conditional candidates when planning, then finalize the recommendation after restoration evidence and the developer-check opportunity below. Recommend the best practical fit and at most a useful alternative for the selected goal, available inputs and actual project. Preserve useful existing distributables; propose new builds only when needed and approved. Do not create every candidate output.

| Project shape | Useful preservation candidate and limits |
|---|---|
| Web/API/CMS/full-stack, SSR or backend-dependent SPA | Compatible runtime/images plus required databases/files and recovery configuration. A frontend build alone does not freeze its server or services. |
| Genuinely self-contained static site | Built output plus source/build requirements for the chosen goal. Confirm it has no required server/runtime dependency. |
| Library or CLI | Source, native locks/environment and useful existing distributables. A container is optional when it adds recovery value. |
| Data science or ML | Environment plus required models/datasets; record hardware/GPU/driver and external-input constraints. |
| Mobile, desktop or browser extension | Useful existing builds and compatible toolchain/SDK/OS/CPU/signing/browser requirements. Signing or SDK availability may still limit future recovery. |
| Hardware or proprietary tooling | Available firmware/binaries, hardware and licensed toolchain/acquisition requirements. Document unavailable or non-redistributable inputs instead of copying them. |

Preserve only required runtime/build/test components for the selected goal, not every daemon image. Running now, offline runtime recovery and offline rebuild are separate claims. A binary, source plus lockfile, or version list with an unavailable SDK is not proof of offline recovery/rebuild or future platform availability.

Record actual language/runtime/package-manager/SDK versions, native lockfiles, required OS packages and platform restrictions. Use native locked/frozen installs when supported; never silently upgrade, regenerate locks or substitute another platform's dependencies. Preserve additional build inputs/caches/installers only when needed for the selected rebuild goal and approved. Frozen runnable artifacts do not imply that source can rebuild offline or bit-for-bit.

For Docker, record full base/runtime references and upstream digests where available, actual local image IDs, stable recoverable tags and `os/arch/variant`. Version tags are mutable; pin known compatible digests rather than resolving a different version silently. Local builds may have no registry digest. Use stable explicit service image names or an approved recovery mapping so changing directory/Compose project name does not demand a rebuild. Record compatible Engine, Compose and API requirements. Prefer supported installed `docker compose` when applicable, without forcing upgrades or unsupported flags on an old toolchain.

Inspect `.dockerignore`, actual build context/`COPY`, build arguments/env, image configuration/history and other relevant binary/layer/data risks with output filtered before exposure. Image Env/history and an LFS pointer diff do not reveal every copied secret. Known secret-bearing artifacts block publication; unresolved material inclusion risk leaves the affected artifact pending/manual review. Record inspected versus uninspected surfaces, never a blanket secret-free pass. Do not copy real credentials or private client configuration into images, recovery files or reports.

## Data restoration and persistence

Choose data by provenance, safety, usefulness and compatibility, not a fixed dump-first hierarchy. Prefer sufficient synthetic/sanitized fixtures, seeds or dumps. An existing owned isolated source can be considered only after classification and applicable exact-target approval. Localhost may be a tunnel/shared/live service; never use it automatically. No production/private-user-data collection or automatic sanitizer is introduced.

For each applicable store, preserve the necessary database, embedded/file storage, uploads/blobs, local object files, model weights/datasets and indexes, or document a verified regeneration procedure. External API consumers may need approved mocks/fixtures; no-data-layer projects state not applicable only after checking actual required inputs. Separate schema-only recovery from representative populated demonstration data.

- Prefer a consistent engine-native logical dump plus required roles/extensions/schema/restore inputs when appropriate. Use commands compatible with the actual engine/version and capture successful results, checksums, sizes and provenance.
- A physical backup is a valid fallback only with the engine's supported consistency procedure: stopped/quiesced source or supported consistent snapshot, complete required data/logs, exact engine/platform and permissions. Never tar an arbitrarily running database volume. Preserve required pinned helper images too; an unpinned helper fetched later breaks offline recovery.
- Restore into a fresh explicitly owned isolated target, not an existing user/shared volume. Document exact load/init/restore order, first-start-only init behavior and ownership requirements. Start an isolated database engine first when its restore method requires it, then restore/verify data before starting dependent application consumers. Review scripts/dumps before executing them; import success and a populated correct result are distinct evidence.
- Re-runnable schema/seed/dump inputs must actually travel with the archive, including required files outside the database. Verify backup readability/structure and restoration when authorized. Nonempty tar/dump size alone proves neither consistency nor recoverability.

Missing data: offer an explicitly limited empty/schema-only restoration or wait for a suitable supplied source. A network/cloud/VPN source is not contacted; skip it or wait for an approved local export. Record gaps and exact file changes without exposing private records.

## Review restoration before freezing

After approved restoration, capture actual build/run/data/domain evidence using relevant checks only when authorized. A listening port or a developer's feedback alone does not establish full restoration. If execution is deferred or blocked, offer only an explicitly limited preservation recommendation and retain the unverified outcome.

Offer the developer a chance to inspect the restored app or relevant CLI/library/native behavior before selecting the final freeze approach. Record checked/declined/deferred in the existing report; omit the live pause only when an explicitly authorized unattended plan covers it. Silence or an assumed unattended session is not consent. Combine feedback and the remaining freeze decision when useful; reuse exact still-applicable action approval instead of asking again for unchanged exports/configuration.

Recommend the final approach from the actual evidence, goal and available inputs before freeze execution. Freeze the original approved safe restoration inputs by default, not silently the developer's post-demo mutated dataset. A different dataset needs an explicit source/classification choice and applicable export approval. Code/configuration/data changes invalidate affected builds, exports and verification evidence; reassess only those dependencies before capture. Do not manufacture an export or successful runtime result to complete this phase.

## Failure-safe image export

Export the selected unique images to `recovery/docker/` after the applicable build/runtime evidence is obtained. A useful partial/build-only artifact may be preserved through explicit limited-outcome approval, never described as a verified working app.

1. Derive the real service-to-image reference/ID mapping from inspected configuration and actual approved runtime evidence, including required init/helper images. A Compose service name is not necessarily an image reference. Render configuration only on the authorized execution path, redacting resolved secrets; static Plan does not run Compose. Deduplicate shared images while recording all consuming services and target platforms.
2. Give every export a reviewed contained destination and safely passed image arguments. Use a new temporary file and check each command's result: either separate successful save/compress stages or a supported pipeline with `pipefail`. `gzip` of empty input is nonempty, so `[ -s ]` cannot detect a failed `docker save`. Do not truncate/replace the last verified artifact when a new attempt fails; remove only this run's known temporary output when safe.
3. Validate compression/archive structure and compare captured tags/image configuration identity/platform with the intended mapping. Record SHA-256, byte size, actual image ID and source/build context in the report/inventory. A tag match alone is not identity proof. Controlled `docker load` validation, when authorized, accepts gzip directly and restores tags; use an approved isolated context or resolve possible tag collisions first. A tool/daemon/permission failure is not automatically archive corruption and must not trigger blind re-export.
4. On resume, reuse an artifact only when its verified fingerprint and captured image/source/platform still match the current approved outputs. Mere existence, nonzero size or successful loading of an old image does not qualify. A changed mapping requires reassessment, not silent overwrite.
5. Keep artifacts in place for Step 5's reviewed LFS/separate-backup decision; do not claim local-only files have been backed up or ignore/untrack them automatically. Record pending exclusions, duplicates avoided and unavailable exports.

## Progressive verification and recovery commands

During restoration, use relevant cheap checks first: referenced paths/configuration, data inputs and platform prerequisites, then approved safe build/start and representative API/UI/CLI/library/native behavior checks. During capture, verify inventory/checksums and archive/image identity. Reuse still-valid evidence rather than replaying restoration after export; changed inputs require only affected reassessment. Separate original failures, environment/capability gaps, new failures and unrun checks; a listening port/loadable image alone is not full restoration.

Offer a default-off, separately approved cold-recovery rehearsal for the selected scope using a supported throwaway daemon/image store/VM/context and fresh data storage. Prove it uses preserved images/data/configuration rather than cached builds/registry acquisition. Never clear the developer's images/caches/volumes or substitute a new Compose project on the same image cache as proof of cold recovery. Missing capability leaves a manual rehearsal plan or unperformed result. Offline rebuilding is a separate goal with its own complete inputs and evidence.

Honor testing/verification deferral: run no deferred checks or rehearsal; mark affected results unverified and avoid Fully Restored claims. Explicitly approved partial preservation/documentation may continue with limitations. No prerequisite check becomes passed merely because another host's report says it ran.

Write the actual recovery procedure in the approved setup path, normally `docs/setup.md`, including:

1. Required source/configuration, platform/Engine/Compose or native toolchain and selected artifacts, with checksum/identity validation. Step 4's human metadata holds the full artifact inventory; link it once present instead of duplicating identity tables, while keeping commands' necessary explicit arguments.
2. Where images were selected, load each unique captured image with its correct recoverable mapping; gzip needs no separate decompression for supported Docker load. For native/static/library paths, give the actual supported preparation/launch procedure instead.
3. Restore each data/file input to fresh owned targets in the verified order before starting dependent components; do not silently reuse existing volumes or rerun init on every start.
4. For container recovery, use the reviewed recovery override and supported no-build/no-pull startup, such as `docker compose ... up --no-build --pull never` only when the recorded toolchain supports those flags. An unavailable image must fail explicitly rather than rebuilding/downloading. Do not assume a saved registry digest is resolvable offline without checking the restored mapping. Other approaches document their evidenced prerequisites and acquisition limits without invented Docker steps.
5. Local access/useful demonstration commands, expected results, isolation/stop instructions and unresolved inputs. Reuse these facts in Step 4 and update current commands after approved later changes; historical reports stay verbatim.

## Report

Preserve these sections, keeping factual evidence and unknowns separate:

- **Restoration Strategy:** setup evidence/conflicts or reconstructed instructions, chosen goal/scope, provisional versus recommended/selected freeze approach; original versus actual compatible versions, accepted deviations and missing native/toolchain/rebuild inputs. Include optional `Developer check:` text with actual feedback, decline/deferral or explicit unattended scope; older reports without it remain valid.
- **Docker Setup:** actual source/recovery config paths, base references/digests, service-to-image IDs/tags/platform and Engine/Compose requirements; not applicable where appropriate.
- **Image Exports:** unique paths, SHA-256/size/identity/platform, validation commands/results, reused artifacts and remaining omissions.
- **Data Persistence:** every required database/file/blob/model input or regeneration source, consistency/restore method, provenance/classification and actual setup instructions. Not applicable only when no such input is required.
- **Data & Database:** selected source and why, isolated restore target, synthetic/sanitized/demo-data availability and actual populated/schema-only result, with values/private records omitted.
- **Changes Made:** every created/modified/deleted path/reason, protected files preserved, approved alternate outputs and pending drafts.
- **Environment Variables:** changed key names and purpose, never real values or runtime tokens.
- **Commands Used:** actual commands in order with scope/outcome; secret-free useful flags, no invented successful execution.
- **Access Points:** local URLs/ports/CLI/notebook/native entry points or not applicable. On its own line: `App running: yes/no/not applicable`.
- **Runtime Identity:** current host/context, project/container or process/cwd/start identity, owned data targets and verification time. Historical evidence to revalidate, never permanent authorization.
- **Verification Results:** static/build/run/domain/data checks separately, cold rehearsal and offline rebuild performed/not performed with scope/results, deferrals and capability gaps, artifact privacy inspection limits.
- **Restoration Outcome:** Fully Restored / Partially Restored / Buildable But Not Runnable / Blocked / Cannot Be Restored Without Missing Dependencies, with an evidence-based sentence. No full/offline promise from static checks or local startup alone.
- **Remaining Blockers:** missing artifacts/features, rough versus verified storage route, local-only backup needs and exact next actions.

Normal mode outputs the report and stops for explicit approval before Step 3. Warn when the outcome is not Fully Restored; the developer can approve continuing with stated limitations without certifying unverified recovery. Do not commit or push.
