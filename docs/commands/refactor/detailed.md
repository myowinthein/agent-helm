---
title: refactor
description: Follow the complete refactor procedure, including its choices, prerequisites, approval boundaries, verification and outcomes.
parent: Commands
nav_exclude: true
has_toc: false
overview: /docs/commands/refactor.html
guide_source: guides/refactor.md
permalink: /docs/commands/refactor/detailed.html
title_category: Details
---

# refactor

{% include guide-depth.html %}

Use refactor when code has become harder to understand or maintain. It finds worthwhile improvements, then applies the ones you choose while preserving behavior and existing test guarantees.

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

The complete procedure follows, including conditions and exceptions within each phase.

{{ page.guide_source | guide_intro }}

{{ page.guide_source | guide_body }}
