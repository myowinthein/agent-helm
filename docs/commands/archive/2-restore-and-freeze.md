---
title: "Step 2: Restore and Freeze"
parent: /agent-helm:archive
grand_parent: Commands
nav_order: 2
---

# Step 2: Restore and Freeze

Restore the approved useful scope and preserve the actual working inputs, without silently upgrading an old project. Frozen source/runtime, offline recovery and offline rebuilding are separate goals. Docker is useful where applicable; mobile, desktop, hardware or proprietary SDK projects may need native inputs that cannot be replaced by a version list.

Read the verified Step 1 report and inventory from the [validated run directory](../archive.html#archive-directory-and-existing-projects). Current runs use only `.helm/archive/`; unsupported old bundles stop with upgrade guidance. Record this step's report in that same directory. Recovery artifacts and setup files keep their approved purpose-specific paths.

The sequence stays within this phase: **restore plan → restore → actual evidence → offer developer check → freeze recommendation → approved freeze execution**. Initial freeze proposals are provisional. There is no new checkpoint or state field; older reports without a component handoff remain valid, with missing details recovered from scoped source reads.

## Use reliable setup evidence

Cross-check each component's setup notes, manifests/locks, scripts, CI, Dockerfiles and version declarations against the actual platform. No source always wins; resolve material conflicts through compatible evidence or a concrete developer decision. Reconstruct absent instructions from inspected inputs and label them reconstructed. Consult version-matched official docs only to resolve a real decision, without modernizing by default.

## Plan before mutation

Review exact file changes, compatible versions/platforms, commands/hooks, acquisition, data targets, isolation, artifacts and scoped verification. Check rough sizes/free space and an intended LFS/separate-backup route before expensive exports. Reuse approval already covering the unchanged plan, with missing side-effect approvals still required.

Create a safe configuration template only when needed and included in that exact plan, at the approved native path. Use evidenced keys, placeholders and safe approved defaults, preserving tracking/ignore policy. Never copy a real `.env` or create empty companion files.

Check protected instruction imports before every output write, including setup/Compose files; use an approved alternate path or stop. Preserve Helm settings, agent paths and opaque state. No Git changes/commits/publication in this step, and no automatic use of another repository.

Verify this host's Docker/native context and actual project/container/process/storage ownership. Inspect broad binds, external volumes/networks, privileged/socket/host-network settings, inherited env, jobs and persisted endpoints. Use supported project-local isolation and appropriate localhost exposure. Placeholders/project names alone do not stop live-service contact. Approved package/image acquisition is distinct from forbidden runtime production/external access. Unmet isolation requirements leave execution pending; no global firewall or credential changes.

## Freeze actual versions and artifacts

Choose candidates by project needs, then finalize after restoration evidence and the developer check. Recommend the best practical approach and at most a useful alternative; preserve useful existing builds, with new builds only when needed and approved.

| Project shape | Candidate and important limits |
|---|---|
| Web/API/CMS/full-stack, SSR or backend-dependent SPA | Compatible runtime/images plus data/files and recovery configuration; frontend output alone is insufficient. |
| Self-contained static site | Built output plus source/build requirements; first confirm there is no required server. |
| Library or CLI | Source, native locks/environment and useful existing distributables; container only when useful. |
| Data science or ML | Environment, models/datasets and hardware/GPU/driver constraints. |
| Mobile, desktop or extension | Useful existing builds and toolchain/SDK/OS/CPU/signing/browser requirements; future availability remains a constraint. |
| Hardware or proprietary tooling | Firmware/binaries, hardware and lawful licensed-toolchain acquisition requirements; unavailable inputs remain gaps. |

These are conditional candidates, not a checklist of outputs. Running now, offline runtime recovery and offline rebuild remain distinct; a native binary or source plus lockfile alone proves neither offline result.

Retain native lockfiles and use compatible locked/frozen installs without silent dependency updates or lock regeneration. Capture actual image IDs, upstream digests where available, stable recoverable service tags/mappings, OS/architecture/variant and Engine/Compose/API requirements. Directory/project-name changes must not cause a missing-image rebuild. Do not force tool upgrades or flags unavailable to the frozen toolchain.

## Preserve consistent, useful data

Choose a suitable synthetic/sanitized or explicitly classified owned isolated source, not a blanket dump-first rule. Localhost may be shared or a tunnel. Prefer appropriate engine-native consistent logical dumps; physical backup is a valid fallback only through a stopped/quiesced or engine-supported consistent procedure with complete inputs and matching version/platform/permissions. Never tar an arbitrary running database volume.

Include required uploads, file/embedded stores, blobs, models/datasets and indexes or their documented regeneration. Restore into fresh owned targets and record schema-only versus representative populated results. Missing/network sources offer a supplied local export or an explicitly limited fallback, never implied production access. Images alone do not preserve volume data.

## Developer check and final freeze choice

After approved restoration, record actual evidence and offer the developer a chance to inspect the useful app/CLI/library/native behavior. Record checked, declined or deferred in the existing report, or the explicit unattended plan allowing the pause to be omitted. Silence is not approval; feedback alone is not proof all runtime behavior passed. Combine feedback and the final freeze choice when useful, reusing unchanged exact action approvals.

Recommend and select the freeze from actual results, goal and available inputs before capturing final artifacts. Preserve the original approved safe restoration inputs by default, not silently the dataset changed during the developer's demo. A different dataset needs its source/classification and export approval resolved. Code/config/data changes invalidate affected builds/exports/evidence. Deferred or blocked restoration permits only an explicitly limited preservation outcome.

## Capture selected artifacts

After the final freeze choice and applicable approval, capture only its required outputs.

Preserve only required unique images, including applicable init/helper images. A Compose service name may differ from its image reference. Export through new temporary output with checked save/compression statuses; gzip can produce a nonempty file from empty input, so size-only checks are insufficient. Validate compression, intended image identity/platform, checksum and size before finalizing; a failed replacement preserves the last valid artifact. Reuse only proven current matches on resume.

Authorized controlled loading accepts gzip directly but may restore tags, so validate in an appropriate approved context. A daemon/permission/tool failure does not prove archive corruption. Neither loading nor matching tags proves full recovery.

Review build contexts, `.dockerignore`, copied files, image configuration/history and relevant layered/binary/data risks with redacted output. LFS pointers do not expose the artifact payload. Known secret-bearing outputs block publication; unresolved material risk needs manual review. State exactly which surfaces were inspected rather than certifying all binaries secret-free.

## Verification and recovery instructions

During restoration, start with cheap path/platform/input checks, then approved build/start/useful behavior checks. During capture, check artifact identity/integrity and reuse still-valid restoration evidence; do not repeat startup merely because export finished. An optional separately approved cold rehearsal uses a supported throwaway daemon/image store/VM and fresh storage; it must not clear developer caches/images/volumes. A new Compose project sharing cached images is not proof of cold recovery.

Honor verification deferral without running deferred checks or claiming Fully Restored. Report baseline/capability/new failures separately. Partial outputs may be preserved with explicit limitations. Offline rebuilding needs its own complete inputs and evidence.

The actual approved setup path documents this order:

1. Obtain preserved source/configuration, compatible platform/tools and required artifacts; check identities/checksums. Link Step 4's metadata inventory once present instead of duplicating full identity tables, keeping explicit arguments needed by commands.
2. Load captured images into their stable recovery mapping where applicable; native/static/library approaches use their actual supported preparation instead.
3. Start an isolated database engine if its restore method requires it, then restore every required database/file input into fresh owned storage in the verified order.
4. Start dependent application components with the retained isolation configuration. Container recovery uses supported no-build/no-pull options, such as `docker compose ... up --no-build --pull never` where supported. Native approaches document their own prerequisites. Missing inputs fail explicitly instead of downloading/rebuilding silently.
5. Use the documented local demo/access commands and known limits.

## Report and approval

Keep setup evidence/conflicts, reconstructed instructions, recommended/selected freeze strategy, actual versions/configuration, unique exports/checksums, all data inputs/consistency/provenance, file changes, env key names, actual redacted commands and access points. Optional `Developer check:` text records feedback/decline/deferral or explicit unattended scope without invalidating older reports. Record `App running: yes/no/not applicable` plus current-host runtime identity as historical evidence to revalidate later.

Report static/build/run/data/cold-rehearsal/offline-rebuild results separately, including unperformed/deferred checks and storage/backup gaps. The existing restoration outcome labels remain; no broad future-recovery guarantee. Stop for report approval before Step 3, warning on a partial/blocked outcome while allowing an explicitly limited continuation. See the [archive guide](../archive.html) for resume and final preservation.
