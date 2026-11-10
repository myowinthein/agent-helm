---
title: "Step 1: Explore"
description: Follow the complete archive 1-explore procedure, including its review, execution limits and saved results.
parent: archive
grand_parent: Commands
nav_exclude: true
has_toc: false
overview: /docs/commands/archive/1-explore.html
guide_source: prompts/archive/step1-explore.md
permalink: /docs/commands/archive/1-explore/detailed.html
title_category: Details
---

# Step 1: Explore

{% include guide-depth.html %}

Agree what you want to preserve before attempting recovery. This phase inspects local source and metadata without running the project or contacting services.

## Flow

```mermaid
flowchart TD
  Start(["Source branch confirmed"]) --> Inventory["Inspect components, setup,<br/>data and recovery materials"]
  Inventory --> Scope["Agree recovery goals;<br/>identify missing and excluded inputs"]
  Scope --> Report["Present findings and<br/>the proposed restoration approach"]
  Report --> Approval{"Approve the report?"}
  Approval -->|Revise| Report
  Approval -->|Stop| End(["Leave exploration unsaved"])
  Approval -->|Yes| Save["Save report and initial<br/>file inventory"]
  Save --> Next(["Continue to Restore and Freeze"])
```

The full step follows. It runs only as part of archive, with the approvals and preservation boundaries stated below.

{{ page.guide_source | guide_intro }}

{{ page.guide_source | guide_body }}
