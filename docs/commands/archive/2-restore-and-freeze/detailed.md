---
title: "Step 2: Restore and freeze"
description: Follow the complete archive 2-restore-and-freeze procedure, including its review, execution limits and saved results.
parent: archive
grand_parent: Commands
nav_exclude: true
has_toc: false
overview: /docs/commands/archive/2-restore-and-freeze.html
guide_source: prompts/archive/step2-restore-and-freeze.md
permalink: /docs/commands/archive/2-restore-and-freeze/detailed.html
title_category: Details
---

# Step 2: Restore and freeze

{% include guide-depth.html %}

Restore the agreed scope, then capture what later recovery needs. What works now and what remains unverified are recorded separately.

## Flow

```mermaid
flowchart TD
  Start(["Exploration report approved"]) --> Plan["Cross-check setup and data;<br/>review the isolated restoration plan"]
  Plan --> Restore["Run only approved restoration<br/>and relevant checks"]
  Restore --> Check["Report actual results and offer<br/>a developer inspection"]
  Check --> Freeze["Recommend the final freeze<br/>from the recovery goal and evidence"]
  Freeze --> Capture["Approve and capture selected<br/>runtime, data and configuration"]
  Capture --> Report["Review artifacts, recovery commands<br/>and remaining limitations"]
  Report --> Approval{"Approve the phase report?"}
  Approval -->|Revise| Report
  Approval -->|Stop| Pending(["Keep actual work and pending checks"])
  Approval -->|Yes| Next(["Save progress;<br/>continue to API materials"])
```

The full step follows. It runs only as part of archive, with the approvals and preservation boundaries stated below.

{{ page.guide_source | guide_intro }}

{{ page.guide_source | guide_body }}
