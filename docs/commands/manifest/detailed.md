---
title: manifest
description: Follow the complete manifest procedure, including its choices, prerequisites, approval boundaries, verification and outcomes.
parent: Commands
nav_exclude: true
has_toc: false
overview: /docs/commands/manifest.html
guide_source: guides/manifest.md
permalink: /docs/commands/manifest/detailed.html
title_category: Detailed guide
---

# manifest

{% include guide-depth.html %}

Use manifest to create a README or keep an existing one accurate. It checks the project, proposes changes and preserves the voice and useful structure you already have.

## Flow

```mermaid
flowchart TD
  Start(["Start manifest"]) --> Target["Confirm the README<br/>and its style"]
  Target --> Scope{"What review is needed?"}
  Scope -->|Already current or skip| Finish(["Report the local result"])
  Scope -->|Full scan or Gap scan| Scan["Verify README claims and<br/>missing reader information"]
  Scope -->|Structure repair| Repair["Investigate the specific<br/>content or layout gaps"]
  Scan --> Review["Review proposed section changes"]
  Repair --> Review
  Review --> Choice{"Apply the proposal?"}
  Choice -->|Revise| Review
  Choice -->|Skip| Finish
  Choice -->|Keep prose and record review, when eligible| Marker["Update only the review marker"]
  Marker --> Finish
  Choice -->|All or selected changes| Write["Update and read back<br/>the approved content"]
  Write --> Finish
```

The complete procedure follows, including conditions and exceptions within each phase.

{{ page.guide_source | guide_intro }}

{{ page.guide_source | guide_body }}
