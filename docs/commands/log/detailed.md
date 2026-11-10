---
title: log
description: Follow log through instruction ownership, shared setup, source review, approval and verified local updates, including its complete agent procedure.
parent: Commands
nav_exclude: true
has_toc: false
overview: /docs/commands/log.html
guide_source: guides/log.md
permalink: /docs/commands/log/detailed.html
title_category: Details
---

# log

{% include guide-depth.html %}

Log turns project evidence and confirmed lessons into instructions that Claude and Codex can share. This guide follows the complete procedure, including how it chooses a review scope, preserves existing knowledge and decides whether a review marker can advance.

## Flow

The setup and source review are separate phases. A completed layout change can be kept even when you skip the source review.

```mermaid
flowchart TD
  Inspect["Check the project, instruction owner and saved review"] --> Current{"Already current with no requested work?"}
  Current -->|Yes| Noop["Report without writes"]
  Current -->|No| Scope["Choose Full scan, Gap scan or layout only"]
  Scope --> Policy["Resolve missing settings and freeze local commit policy"]
  Policy --> Eligible{"Write prerequisites met?"}
  Eligible -->|No| Block["Report the blocker and preserve work"]
  Eligible -->|Yes| Layout{"Shared setup needs changes?"}
  Layout -->|Yes| Review["Review the exact layout diff"]
  Review --> Choice{"Approve layout?"}
  Choice -->|Yes| Save["Apply, verify and separately commit layout"]
  Choice -->|No| Block
  Layout -->|No| Next["Continue selected source review or finish layout only"]
  Save --> Next
```

After setup, only the selected source review runs. Coverage and acceptance determine the marker; writing a file alone does not establish a completed review.

```mermaid
flowchart TD
  Scope{"Source review selected?"} -->|No| Finish["Finalize approved local work and report"]
  Scope -->|Yes| Scan["Investigate the pinned Full or Gap scope"]
  Scan --> Audit["Check accuracy, preservation and useful context"]
  Audit --> Review{"Review the knowledge proposal"}
  Review -->|Revise| Audit
  Review -->|Cancel| Keep["Keep earlier approved work; retain prior marker"]
  Review -->|All or selected| Apply["Apply and read back accepted instructions"]
  Apply --> Complete{"Complete review and all substantive changes accepted?"}
  Complete -->|Yes| Marker["Advance to the reviewed source snapshot"]
  Complete -->|No| Prior["Keep prior review provenance and report gaps"]
  Marker --> Commit["Commit eligible work under the frozen policy"]
  Prior --> Commit
  Commit --> Finish
  Keep --> Finish
```

The procedure below is also the Markdown instruction source loaded by the log skill. Its question map is at the end; the shared runtime supplies the common execution and safety rules.

{{ page.guide_source | guide_body }}
