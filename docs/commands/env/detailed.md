---
title: env
description: Follow the complete env procedure, including its choices, prerequisites, approval boundaries, verification and outcomes.
parent: Commands
nav_exclude: true
has_toc: false
overview: /docs/commands/env.html
guide_source: guides/env.md
permalink: /docs/commands/env/detailed.html
title_category: Details
---

# env

{% include guide-depth.html %}

Use env when environment settings or Git ignore rules have become hard to trust. It checks how configuration is used, reports problems and lets you choose fixes or a safe template.

## Flow

```mermaid
flowchart TD
  Start(["Start env"]) --> Audit["Inspect configuration usage,<br/>env files and Git ignore rules"]
  Audit --> Findings{"Actionable findings or<br/>a requested template?"}
  Findings -->|No| Report(["Report the scoped audit"])
  Findings -->|Yes| Select["Choose Env files,<br/>.gitignore or both"]
  Select --> Plan["Review exact fixes,<br/>local-only work and dependencies"]
  Plan --> Choice{"Apply the plan?"}
  Choice -->|Revise| Plan
  Choice -->|Skip| Finish(["Finish locally"])
  Choice -->|All or selected changes| Apply["Apply approved changes<br/>and verify their effects"]
  Apply --> Finish
```

The complete procedure follows, including conditions and exceptions within each phase.

{{ page.guide_source | guide_intro }}

{{ page.guide_source | guide_body }}
