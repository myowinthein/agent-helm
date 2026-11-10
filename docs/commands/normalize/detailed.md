---
title: normalize
description: Follow normalize through coordination, message review, affected-branch analysis, recovery, history rewriting, verification and local checkpoints.
parent: Commands
nav_exclude: true
has_toc: false
overview: /docs/commands/normalize.html
guide_source: guides/normalize.md
permalink: /docs/commands/normalize/detailed.html
title_category: Details
---

# normalize

{% include guide-depth.html %}

{{ page.guide_source | guide_intro }}

## Flow

The first phase establishes coordination and a concrete message plan. Team readiness, any branch preparation and the final rewrite decision remain separate approvals.

```mermaid
flowchart TD
  Start{"Identified interrupted run?"} -->|Yes| Resume["Validate existing evidence and finish only missing local work"]
  Start -->|No| Readonly{"Explicit read-only request?"}
  Readonly -->|Yes| ReviewOnly["Review local messages without writes"]
  Readonly -->|No| Notice["Show the full coordination notice"]
  Notice --> Ready{"Team ready, Review only or Stop?"}
  Ready -->|Stop| Stop["Stop without further work"]
  Ready -->|Review only| ReviewOnly
  Ready -->|Team ready| Discover["Discover agreed branches and approve any preparation"]
  Discover --> Freeze["Freeze policy, refs and review scope; validate own review history"]
  Freeze --> Messages["Check syntax and review message meaning"]
  Messages --> Changes{"Proposed message changes?"}
  Changes -->|No| Checkpoint["Consider only a meaningful, proven checkpoint"]
  Changes -->|Yes| Impact["Prove the full affected graph, constraints and recovery plan"]
  Impact --> Approval{"One final message and impact decision"}
  Approval -->|Edit or change selection| Messages
  Approval -->|Cancel| Report["Report without a rewrite or new checkpoint"]
  Approval -->|Apply| Rewrite["Continue to approved rewrite and verification"]
  ReviewOnly --> Report
```

The rewrite starts only with a safe, complete plan and verified recovery inputs. Failures preserve the actual state for reconciliation; they do not trigger a blind retry.

```mermaid
flowchart TD
  Recheck["Recheck approved messages, policy, branches and worktrees"] --> Backup["Create and verify the private recovery bundle"]
  Backup --> Evidence["Retain the plan and register the local handoff"]
  Evidence --> Filter["Rewrite the exact approved graph once"]
  Filter --> Verify{"Messages, graph, metadata and preserved refs match?"}
  Verify -->|No| Hold["Stop dependent work; keep actual results and recovery evidence"]
  Verify -->|Yes| Map["Save the independently verified old-to-new mapping"]
  Map --> State["Maintain only proven checkpoints and reviewed anchor changes"]
  State --> Commit["Write and commit eligible records under local policy"]
  Commit --> Finish["Report the same-branch local result and retained recovery path"]
  Finish --> Ship["Use ship separately for publication approval"]
```

The complete procedure below is the same Markdown source loaded by the normalize skill. Read-only review, coordination, rewriting, checkpoint commits and publication each retain their stated boundaries.

{{ page.guide_source | guide_body }}
