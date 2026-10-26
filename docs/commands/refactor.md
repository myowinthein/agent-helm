---
title: refactor
parent: Commands
nav_order: 5
---

# refactor

Review code that has become harder to understand or change, then apply selected improvements without changing its behavior. Findings include their practical benefit, priority, transformation risk and verification needs.

## Start the command

```text
refactor
```

Use the prefix for your app or terminal from [Setup]({{ '/docs/setup/' | relative_url }}#run-a-command).

Source-only inspection can run on any checkout. Recorded scans and edits require a clean, eligible **main/master, feature or existing refactor branch**. Confirmed non-base environment branches remain **inspection and report only**, even when their name starts with `refactor/`. Branch roles come from project evidence or your confirmation, not naming alone.

## Flow

```mermaid
flowchart TD
  Start(["Start refactor"]) --> Preview["Inspect project scope<br/>and branch eligibility"]
  Preview --> Route{"Choose review work"}
  Route -->|Source-only report| Advisory(["Report advice without saving state"])
  Route -->|Full scan or Gap scan| Scan["Assess source and reconcile<br/>new and existing findings"]
  Route -->|Fix Backlog| Backlog["Revalidate selected<br/>existing findings"]
  Scan --> Assess["Record the completed assessment<br/>under local commit policy"]
  Assess --> Plan["Choose findings and approve<br/>one dependency-aware plan"]
  Backlog --> Plan
  Plan --> Choice{"Apply selected work?"}
  Choice -->|No| Finish(["Report results and pending work"])
  Choice -->|Yes| Work["Apply bounded units<br/>and verify preserved behavior"]
  Work --> Record["Commit verified work and<br/>record supported closures"]
  Record --> Finish
```

## Choose the review scope

A **Full scan** reads every eligible human-maintained implementation and test file in full, in bounded chunks. It includes scripts and prompt workflows when those implement the product. Permitted read-only subagents can cover independent chunks; the parent reconciles shared contracts and unread areas before recording completion.

A **Gap scan** reviews changed logical units and their affected callers, consumers, tests and configuration since a valid saved baseline. It is not limited to changed lines or a fixed number of reference hops. Broad or uncertain impact can call for Full scan.

**Fix Backlog** revalidates existing findings you choose without claiming a new discovery scan. A **source-only report** stays advisory and writes no code or ledger. Missing or invalid history does not become a guessed Gap scan; malformed state needs resolution before recorded work.

## The six review perspectives

| Perspective | What it looks for |
|---|---|
| Architecture and boundaries | Responsibilities or coupling that make real changes harder. |
| Contracts and state consistency | Duplicated or contradictory representations of confirmed shared behavior. |
| Code clarity and maintainability | Misleading names, tangled flow, unnecessary indirection and duplicated knowledge. |
| Performance and resource use | Evidenced avoidable work or resource cost, with behavior preserved. |
| Test quality and maintainability | Existing test structure, fixtures, helpers and isolation that can be improved without losing protection. |
| Dependency and integration boundaries | Costly coupling to libraries, frameworks or workspace packages. |

The review follows the project's actual stack, versions and conventions, using applicable official guidance when needed. Design principles help explain a concrete improvement; they do not justify imposing repositories, queues, interfaces or a new architecture on every project.

Product bugs, new features, security behavior changes, upgrades and migrations are separate follow-ups. A refactor approval does not quietly include them.

## Priority, risk and your selection

Priority measures the present burden or benefit of the improvement. Transformation risk is a separate judgment.

| Priority | Meaning |
|---|---|
| **High** | Substantial demonstrated maintenance, change, verification or resource cost. |
| **Medium** | Meaningful localized cost without evidence warranting High. |
| **Low** | A small concrete benefit, beyond cosmetic preference. |
| **Unknown** | A real issue is assessed, but a material fact is missing before it can be ranked. |

A **safe** transformation has specific evidence of mechanical equivalence and suitable verification. **Needs review** involves intent, tradeoffs or insufficient equivalence evidence. Neither label grants permission to edit; costly High work stays High even when blocked.

Findings are grouped by module or behavior, with individual IDs, reasons, remedies, affected paths and checks. For larger reports, choose **Recommended**, **All listed ready**, **Choose findings or groups**, or **None**. Individual IDs and category, priority or risk filters remain available. Held, uncertain and intrusive work stays visible outside the ordinary ready set.

Before editing, you review one plan across the selected findings, including dependencies, companion changes, behavior to preserve and verification. Selection does not silently add other findings. None leaves findings open and preserves an already authorized assessment checkpoint.

## Apply and verify

Selected changes run in bounded sequential units. The agent checks the baseline, applies the agreed transformation and verifies relevant behavior before committing a fix and recording its closure. Expected performance benefits are distinguished from measured results.

Failed, unavailable or deferred required checks leave affected work pending. Explicitly approved unverified drafts stay uncommitted; existing test protections are not retired or weakened to accommodate them. A later run reconciles actual code and evidence before resuming, rather than applying an old finding twice.

## Refactor vs test

Refactor owns maintenance of existing test code that preserves its guarantees, along with explicit guards or mechanical companions needed for a selected refactor. Old protection is retired only after the mapped replacement or remaining protection is verified.

[Test](test.html) owns missing or stronger protection and independent changes to test layers, strategy or tools. Refactor reports those gaps as follow-ups; neither command invokes the other or reads its ledger automatically.

## Your result and finding history

You get verified local improvements, their checks and remaining findings. `.helm/refactor-log.json` uses schema 2 to retain stable finding IDs, current assessments, human decisions and supported closures. Open, resolved and obsolete findings keep their history. Skip, defer and accepted risk remain held open work, not fixes.

The agent retrieves bounded views rather than loading the entire history into its working context. Python helpers are preferred, with an equivalent validated fallback when unavailable. Unsupported state requires explicit handling outside the command; it is not converted or erased during a review.

A complete Full scan records both assessment baselines; Gap scan advances the incremental baseline. Fix Backlog preserves both. Assessment currency is separate from completed fixes and runtime verification. All work follows your local commit policy, stays on the current eligible branch and leaves publication to [ship](ship.html).
