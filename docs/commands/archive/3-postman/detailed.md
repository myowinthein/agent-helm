---
title: "step 3: Postman collection"
description: "This phase preserves the API knowledge someone will need during recovery. It favors useful existing contracts and requests, with explicit limits on anything that has not been executed against an approved isolated runtime."
parent: archive
grand_parent: Commands
nav_exclude: true
has_toc: false
overview: /docs/commands/archive/3-postman.html
permalink: /docs/commands/archive/3-postman/detailed.html
title_category: Details
source_files:
  - prompts/archive/step3-postman.md
---

# Step 3: Postman collection

{% include guide-depth.html %}

This phase preserves the API knowledge someone will need during recovery. It favors useful existing contracts and requests, with explicit limits on anything that has not been executed against an approved isolated runtime.

## Flow

```mermaid
flowchart TD
  Start(["Restoration report approved"]) --> API{"Project owns an<br/>applicable API?"}
  API -->|No| NA["Report not applicable"]
  API -->|Yes| Inspect["Compare existing collections/specs<br/>with routes, validation and auth"]
  Inspect --> Plan["Review Retain, Repair,<br/>Create or Skip"]
  Plan --> Prepare["Apply or reuse the exact approved plan;<br/>keep portable placeholders"]
  Prepare --> Verify["Review static validity and<br/>any separately approved local requests"]
  Verify --> Report["Report saved materials<br/>and unverified behavior"]
  NA --> Approval{"Approve the report<br/>and any ready documentation plan?"}
  Report --> Approval
  Approval -->|Revise| Report
  Approval -->|Stop| End(["Keep actual work and pending items"])
  Approval -->|Report only| Saved(["Save progress and stop"])
  Approval -->|Report and ready plan| Next(["Verify checkpoint;<br/>continue approved documentation"])
```

## Retain, repair, create or skip

The agent compares existing collections or specifications with the application's owned routes and functions. It checks methods, paths, inputs, authentication and useful examples. A dependency on someone else's API does not, by itself, require generating a collection.

Choose the appropriate result:

| Choice | When it helps |
|---|---|
| Retain | Existing materials accurately cover the recovery scope. |
| Repair | Useful requests need specific corrections or missing context. |
| Create | An owned API needs recovery coverage that is absent. |
| Skip or not applicable | The project has no relevant owned API, or API materials are not part of the chosen goal. |

Custom requests and canonical specifications are preserved. Unsupported protocols can keep their native materials rather than being forced into an HTTP collection. New Postman materials normally use v2.1 under `recovery/postman/`, with an environment file only when useful.

Examples use portable placeholders. Credentials, private records and production endpoints do not become a default recovery environment.

## Verification is optional execution work

Preparing a collection is a static activity. It does not send requests or prove that its examples work.

Actual requests need their own reviewed effects and current proof of an owned isolated runtime. Collection scripts are executable code too: setup, pre-request and test scripts can contact services or change data. An old restoration report or a responding port does not establish that those effects are safe now.

For example, a sample create request can be useful without running it. If later executed, its target and cleanup behavior need to be part of the approved plan. A deferred request remains unverified without requiring the earlier restoration to be repeated.

## What happens next

The report lists the retained or prepared files, applicability, static checks, any executed requests and unresolved gaps. You can approve a skipped or not-applicable result as well as a completed collection.

A complete [Documentation](../4-documentation.html) plan can be reviewed alongside this report, even when API materials are not applicable. Approve both to continue after saving and verifying this checkpoint, or approve only the report and stop. Each phase keeps its own complete report. This phase does not make a commit or turn an unexecuted collection into a passing API test.

## Explore the source

For implementation details, read [prompts/archive/step3-postman.md](https://github.com/myowinthein/agent-helm/blob/main/prompts/archive/step3-postman.md).
