---
title: legal
description: Follow the complete legal procedure, including its choices, prerequisites, approval boundaries, verification and outcomes.
parent: Commands
nav_exclude: true
has_toc: false
overview: /docs/commands/legal.html
guide_source: guides/legal.md
permalink: /docs/commands/legal/detailed.html
title_category: Details
---

# legal

{% include guide-depth.html %}

Use legal to prepare the legal documents a project needs, based on its source and confirmed facts. It writes complete drafts for you to read in your editor; you decide whether to commit them.

## Flow

```mermaid
flowchart TD
  Start(["Start legal"]) --> Inspect["Inspect source, context<br/>and existing documents"]
  Inspect --> Reconcile["Resolve missing recorded paths;<br/>apply verified ledger repairs"]
  Reconcile --> Table["Show the six document types,<br/>file status, decisions and reasons"]
  Table --> Needed{"Drafts or proposed removals?"}
  Needed -->|No| End(["Report the result, gaps<br/>and any record-only changes"])
  Needed -->|Yes| Draft["Prepare eligible drafts;<br/>keep removal candidates intact"]
  Draft --> Facts{"Essential missing facts?"}
  Facts -->|Yes| Ask["Ask one consolidated batch;<br/>resolve or hold affected documents"]
  Facts -->|No| Files["Write/read back drafts;<br/>link removal candidates for review"]
  Ask --> Files
  Files --> Review["Short summary and file links;<br/>developer reviews in editor"]
  Review --> Approval{"Commit / Revise / Leave uncommitted"}
  Approval -->|Revise| Draft
  Approval -->|Leave uncommitted| End
  Approval -->|Commit| Save["Apply approved removals,<br/>verify document records and commit"]
  Save --> End
```

The complete procedure follows, including conditions and exceptions within each phase.

{{ page.guide_source | guide_intro }}

{{ page.guide_source | guide_body }}
