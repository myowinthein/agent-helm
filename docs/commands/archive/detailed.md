---
title: archive
description: Follow the complete archive procedure, including its choices, prerequisites, approval boundaries, verification and outcomes.
parent: Commands
nav_exclude: true
has_toc: false
overview: /docs/commands/archive.html
guide_source: guides/archive.md
permalink: /docs/commands/archive/detailed.html
title_category: Detailed guide
---

# archive

{% include guide-depth.html %}

Use archive when an older project needs a recovery kit: source, setup, useful runtime/data and instructions for running it again. It prepares the kit locally; ship handles the later private backup.

## Flow

```mermaid
flowchart TD
  Start(["Start archive"]) --> Progress["Validate existing progress<br/>and the current source"]
  Progress --> Done{"Already prepared<br/>or completed?"}
  Done -->|Verified| Existing(["Report the existing result"])
  Done -->|No| Branch["Confirm the source branch<br/>and preservation scope"]
  Branch --> Explore["1. Explore the project"]
  Explore --> Restore["2. Restore and freeze<br/>the selected setup"]
  Restore --> API["3. Preserve useful API materials"]
  API --> Docs["4. Prepare recovery documentation"]
  Docs --> Payload["5. Review and commit<br/>the local archive payload"]
  Payload --> End(["Prepared locally;<br/>use ship later for private backup"])
```

The complete procedure follows, including conditions and exceptions within each phase.

{{ page.guide_source | guide_intro }}

{{ page.guide_source | guide_body }}
