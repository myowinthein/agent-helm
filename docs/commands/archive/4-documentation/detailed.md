---
title: "Step 4: Documentation"
description: Follow the complete archive 4-documentation procedure, including its review, execution limits and saved results.
parent: archive
grand_parent: Commands
nav_exclude: true
has_toc: false
overview: /docs/commands/archive/4-documentation.html
guide_source: prompts/archive/step4-documentation.md
permalink: /docs/commands/archive/4-documentation/detailed.html
title_category: Detailed guide
---

# Step 4: Documentation

{% include guide-depth.html %}

Give future developers a clear starting point and an ordered recovery procedure, grounded in what the archive actually contains.

## Flow

```mermaid
flowchart TD
  Start(["API-materials report approved"]) --> Inventory["Review existing documentation<br/>and verified recovery evidence"]
  Inventory --> Plan["Propose focused outputs<br/>and any consolidation"]
  Plan --> Approval{"Approve the editing plan?"}
  Approval -->|Revise| Plan
  Approval -->|Stop| End(["Keep prior work"])
  Approval -->|Yes| Write["Update the index, setup and<br/>artifact metadata where useful"]
  Write --> Check["Verify links, paths,<br/>commands and preserved context"]
  Check --> Report["Present the phase report<br/>for approval"]
  Report --> Next(["Save approved progress;<br/>continue to local preparation"])
```

The full step follows. It runs only as part of archive, with the approvals and preservation boundaries stated below.

{{ page.guide_source | guide_intro }}

{{ page.guide_source | guide_body }}
