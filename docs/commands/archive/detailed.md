---
title: archive
description: "Archive prepares a project for a specific future recovery goal. It brings the relevant source, runtime or build materials, data choices and instructions into a reviewed local kit; private remote backup happens later through ship."
parent: Commands
nav_exclude: true
has_toc: false
overview: /docs/commands/archive.html
permalink: /docs/commands/archive/detailed.html
title_category: Details
source_files:
  - guides/archive.md
---

# archive

{% include guide-depth.html %}

Archive prepares a project for a specific future recovery goal. It brings the relevant source, runtime or build materials, data choices and instructions into a reviewed local kit; private remote backup happens later through ship.

## Flow

```mermaid
flowchart TD
  Start(["Start archive"]) --> Progress["Validate existing progress<br/>and the current source"]
  Progress --> Done{"Already prepared<br/>or completed?"}
  Done -->|Verified| Existing(["Report the existing result"])
  Done -->|No| Branch["Confirm the source branch<br/>and preservation scope"]
  Branch --> Explore["1. Explore the project"]
  Explore --> Restore["2. Restore and freeze<br/>the selected setup"]
  Restore --> API["3. Preserve useful API materials"]
  API --> Docs["4. Prepare recovery documentation"]
  Docs --> Payload["5. Review and commit<br/>the local archive payload"]
  Payload --> End(["Prepared locally;<br/>use ship later for private backup"])
```

## Start the command

Confirm the branch, exact source commit and exclusions you want to preserve. Archive stays on that branch and does not merge missing work into the snapshot. A project without recoverable source history cannot be described as a verified Git payload.

Choose the recovery goal before attempting restoration:

| Goal | What needs to be established |
|---|---|
| Source preservation | The selected source and required external objects are retained. |
| Runnable demonstration | An identified setup can demonstrate the agreed behavior. |
| Offline runtime recovery | Necessary runtime artifacts and data can be restored without live dependencies. |
| Rebuild inputs | Toolchains, dependencies and other inputs support the promised rebuild scope. |

A saved container image may support one goal without proving the others. Missing licensed tools, hardware, services or datasets remain explicit limits.

## The five steps

[Explore](1-explore.html) establishes what exists and what is missing without executing the project. [Restore and freeze](2-restore-and-freeze.html) proposes an isolated restoration plan, checks the selected behavior and captures what later recovery needs.

[Postman collection](3-postman.html) preserves useful owned-API materials when applicable. [Documentation](4-documentation.html) gives future readers an entry point and ordered recovery instructions. [Prepare locally](5-finalize.html) reviews storage, exclusions and the exact payload commit.

Each phase keeps its own complete report. When the next plan is fully prepared, one review can approve the current report and the exact next actions together. You can instead approve only the report and stop, revise, or leave it unsaved. A report-only approval grants no execution authority.

The approved report and checkpoint are saved and verified before next-phase actions begin. Unknown targets, effects or results still need later review; the agent never treats a plan as approval of a future report. Source confirmation, restored-result feedback and the final payload content/commit decision remain separate.

## Output files

Existing suitable locations can stay. A typical kit uses `README.md` as its recovery index, `docs/setup.md` for the procedure, `docs/archive-metadata.md` for artifact identities, and `recovery/` for selected materials.

The index should let a future reader choose a route quickly; it links the detailed command order and artifact tables instead of repeating them. Credentials and private records do not become portable examples. Useful instructions, licenses, history and domain material remain protected.

## Returning to an existing archive

Archive keeps phase progress and approved reports in its own canonical `.helm/archive/` bundle. A rerun checks whether local preparation is already proven and continues only missing work. It does not replay restoration or overwrite recovery evidence just to make the run look fresh.

Unexpected changes need reconciliation. Unsupported historical bundles remain untouched, and an earlier successful check does not establish that a newly selected runtime is isolated or still works.

## Your result

You receive a local payload commit or explicitly pending drafts, together with the recovery route, retained materials, exclusions and unverified checks. The result is **prepared locally**, not backed up remotely.

[Ship's private backup procedure](../ship.html#publish-an-archive-backup) separately publishes and verifies the payload, then its completion receipt. Cleanup and supplementary portable copies remain optional decisions after that proof.

## Explore the source

For implementation details, read [guides/archive.md](https://github.com/myowinthein/agent-helm/blob/main/guides/archive.md).
