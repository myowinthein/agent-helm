---
title: "Step 5: Prepare locally"
description: Follow the complete archive 5-finalize procedure, including its review, execution limits and saved results.
parent: archive
grand_parent: Commands
nav_exclude: true
has_toc: false
overview: /docs/commands/archive/5-finalize.html
guide_source: prompts/archive/step5-finalize.md
permalink: /docs/commands/archive/5-finalize/detailed.html
title_category: Details
---

# Step 5: Prepare locally

{% include guide-depth.html %}

Review and commit the local recovery kit. A private remote backup is a separate action through ship.

## Flow

```mermaid
flowchart TD
  Start(["Documentation report approved"]) --> Storage["Review artifact storage<br/>and preservation exclusions"]
  Storage --> Assets["Keep or approve moves of<br/>supplementary documents/assets"]
  Assets --> Services["Stop only identified owned<br/>services when approved"]
  Services --> Review["Review the final report,<br/>exact payload and limitations"]
  Review --> Approval{"Commit the local archive?"}
  Approval -->|Revise| Review
  Approval -->|Leave uncommitted| Pending(["Keep drafts and pending work"])
  Approval -->|Yes| Commit["Verify files and recovery bytes;<br/>commit the approved payload"]
  Commit --> End(["Prepared locally;<br/>ship is a separate next action"])
```

The full step follows. It runs only as part of archive, with the approvals and preservation boundaries stated below.

{{ page.guide_source | guide_intro }}

{{ page.guide_source | guide_body }}
