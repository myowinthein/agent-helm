---
title: "Step 3: Postman collection"
description: Follow the complete archive 3-postman procedure, including its review, execution limits and saved results.
parent: archive
grand_parent: Commands
nav_exclude: true
has_toc: false
overview: /docs/commands/archive/3-postman.html
guide_source: prompts/archive/step3-postman.md
permalink: /docs/commands/archive/3-postman/detailed.html
title_category: Details
---

# Step 3: Postman collection

{% include guide-depth.html %}

Preserve useful API materials for recovery. Projects without an applicable owned API can record this phase as not applicable.

## Flow

```mermaid
flowchart TD
  Start(["Restoration report approved"]) --> API{"Project owns an<br/>applicable API?"}
  API -->|No| NA["Report not applicable"]
  API -->|Yes| Inspect["Compare existing collections/specs<br/>with routes, validation and auth"]
  Inspect --> Plan["Review Retain, Repair,<br/>Create or Skip"]
  Plan --> Prepare["Apply approved file changes;<br/>keep portable placeholders"]
  Prepare --> Verify["Review static validity and<br/>any separately approved local requests"]
  Verify --> Report["Report saved materials<br/>and unverified behavior"]
  NA --> Approval{"Approve the phase report?"}
  Report --> Approval
  Approval -->|Revise| Report
  Approval -->|Stop| End(["Keep actual work and pending items"])
  Approval -->|Yes| Next(["Save progress;<br/>continue to Documentation"])
```

The full step follows. It runs only as part of archive, with the approvals and preservation boundaries stated below.

{{ page.guide_source | guide_intro }}

{{ page.guide_source | guide_body }}
