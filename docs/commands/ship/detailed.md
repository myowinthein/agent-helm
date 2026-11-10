---
title: ship
description: Follow the complete ship procedure, including its choices, prerequisites, approval boundaries, verification and outcomes.
parent: Commands
nav_exclude: true
has_toc: false
overview: /docs/commands/ship.html
guide_source: guides/ship.md
permalink: /docs/commands/ship/detailed.html
title_category: Details
---

# ship

{% include guide-depth.html %}

Use ship when reviewed work is ready to publish. It checks the source and destination, asks for concrete approval and reports what was actually published. Branch updates and releases are separate choices.

## Flow

```mermaid
flowchart TD
  Start(["Start ship"]) --> Inspect["Review current work, remote state,<br/>existing PRs and release candidates"]
  Inspect --> Special{"Special publication<br/>handoff identified?"}
  Special -->|Archive| Backup["Approve and verify<br/>private archive backup"]
  Backup --> End(["Report verified results<br/>and any pending actions"])
  Special -->|Normalized history| History["Review private evidence;<br/>approve and verify history publication"]
  Special -->|Ordinary work| Source["Approve source publication<br/>or reuse a verified handoff"]
  History --> Targets["Optionally choose and approve<br/>independent branch updates"]
  Source --> Targets
  Targets --> Ready{"Started on main/master<br/>with a ready release?"}
  Ready -->|No or skip| End
  Ready -->|Yes| Release["Review version and notes;<br/>approve the release plan"]
  Release --> Result["Verify checks, then publish tag<br/>or hand off a metadata PR"]
  Result --> End
```

The complete procedure follows, including conditions and exceptions within each phase.

{{ page.guide_source | guide_intro }}

{{ page.guide_source | guide_body }}
