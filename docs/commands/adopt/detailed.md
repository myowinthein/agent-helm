---
title: adopt
description: Follow the complete adopt procedure, including its choices, prerequisites, approval boundaries, verification and outcomes.
parent: Commands
nav_exclude: true
has_toc: false
overview: /docs/commands/adopt.html
guide_source: guides/adopt.md
permalink: /docs/commands/adopt/detailed.html
title_category: Detailed guide
---

# adopt

{% include guide-depth.html %}

Use adopt to give Claude and Codex shared working rules in a consumer project. Run it again when you want to review updates from the installed Helm package.

## Flow

```mermaid
flowchart TD
  Start(["Start adopt"]) --> Guard{"Helm source or<br/>installation target?"}
  Guard -->|Yes| Stop(["Explain and stop<br/>without changes"])
  Guard -->|No| Inspect["Check the project, instruction<br/>connections and existing rules"]
  Inspect --> Compare["Compare each rule with<br/>the loaded Helm package"]
  Compare --> Needed{"Changes needed?"}
  Needed -->|No| Current(["Report existing rules<br/>and connectivity"])
  Needed -->|Yes| Review["Summarize file actions, versions<br/>and meaningful policy changes"]
  Review --> Decision{"Apply the proposed changes?"}
  Decision -->|Cancel or keep| Finish(["Finish without replacing rules"])
  Decision -->|Yes| Apply["Copy approved rules and<br/>connect project instructions"]
  Apply --> Verify["Verify content and<br/>both instruction paths"]
  Verify --> Done(["Finish locally"])
```

The complete procedure follows, including conditions and exceptions within each phase.

{{ page.guide_source | guide_intro }}

{{ page.guide_source | guide_body }}
