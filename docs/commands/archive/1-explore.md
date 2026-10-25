---
title: "Step 1: Explore"
parent: /agent-helm:archive
grand_parent: Commands
nav_order: 1
---

# Step 1: Explore

Inspect enough local source, configuration, manifests, data flows and history to decide what should be preserved. No project execution or network contact occurs. Nothing is written before report approval.

First apply the [archive directory rules](../archive.html#archive-directory-and-existing-projects) read-only, then the [source-branch confirmation](../archive.html#confirm-the-source-branch) before entering a pending phase. Show the actual branch/full HEAD, known excluded work and same-branch edit/local-payload effects; obtain Proceed/Cancel or reuse explicit still-applicable approval. This is separate from Step 1 report approval and creates no confirmation state. Proven prepared/completed report-only exits need no new question. A fresh run creates `.helm/archive/` only after Step 1 report approval and baseline capture. Unsupported old bundles stay protected and block archive continuation; see the upgrade guide.

## Decisions and evidence

Read-only exploration follows the [shared investigation and exclusion contract](../../setup/investigation.html). Inventory exact recovery categories/components independently of familiar hotspots; trace required relationships and keep excluded versus inaccessible evidence separate. Permitted workers return inspected identities/depth, cross-topic dependencies, no-finding areas and unread remainder, with parent reconciliation. No new persistent inventory/report, generic Full/Gap mode or change to phase approvals is introduced.


- Identify project name/domain, packages, architecture, authentication and useful demonstration/run/build paths.
- Confirm the recovery goal: preserved source, frozen runtime/demo, offline runtime recovery and/or offline rebuild inputs.
- Record original/last-working runtime, package/lock/SDK/toolchain/platform evidence. Current vendor support stays not checked unless established; no automatic modernization.
- Classify required/optional external services and runtime side effects, env key names, jobs and isolation questions.
- Inventory database/file/blob/model/dataset inputs, available synthetic/sanitized sources, provenance/sensitivity and regeneration gaps. A repository dump or localhost address is not safety proof.
- Retain useful setup/build/deploy/design/legal/history/API evidence and identify protected instruction imports before proposing output paths.
- Distinguish supplementary BA/design/history documents from application assets and required build/runtime/data inputs. External material uses known safe references or supplied exact local paths; no personal-drive crawl or token-bearing links.
- Estimate artifact sizes/storage needs without claiming provider access or quota.

For multiple components, the existing Setup & Restoration Approach report section can include a compact handoff: role, required/optional status, evidenced setup source, config/data inputs, dependencies and unresolved gaps. This is useful context, not a new mandatory file or schema. Later steps reconstruct missing details from scoped evidence for older reports.

Use bounded package/data-flow reads and targeted follow-ups, not repeated whole-project reading. Missing reads and coverage limits remain visible. Vendor/generated exclusions require evidence, including whether files are tracked/custom or part of the build context.

## Git and credentials

Record literal `Project name:`, `Archiving from:` and full `Source commit:` fields. Normal work uses the actual attached project branch; an explicitly scoped advisory review can label dirty/staged/untracked/detached inputs or lack of HEAD without initializing Git.

Compare local ref tips/dates and ahead/behind metadata first, then relevant likely alternative branch content. Remote-tracking information is cached, never a remote-freshness claim. Report unmerged work and tags/submodules/LFS/hosted resources excluded from a source-only seal; never merge or select another source automatically.

Credential review exposes only inspected paths/key names/types and local evidence, with values/fragments/private records removed before output. List uncovered surfaces; none found in that scope is not a secret-free certificate. No credential liveness testing.

## Report and stop

The report covers overview/stack/architecture, data/integrations, retained docs/assets, Git safety, proposed restoration approach, credential review scope, specific unknowns and an Easy/Medium/Complex/Blocked rating. Confirm the goal and identify Step 2's planned edits, acquisitions, targets, isolation and checks needing resolution.

Wait for explicit approval before recording the report/inventory and proceeding. Stop-here/no-write remains available. See the [archive guide](../archive.html) for approval and protected-file rules.
