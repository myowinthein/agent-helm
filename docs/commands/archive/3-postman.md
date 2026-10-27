---
title: "Step 3: Postman collection"
parent: archive
grand_parent: Commands
nav_order: 3
---

# Step 3: Postman collection

Preserve useful API recovery materials. Existing collections and specifications come first; projects without an applicable owned API need no collection.

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

## Retain, repair, create or skip

Owned server routes and functions can qualify; third-party API consumption alone does not. The review checks operations, inputs and authentication.

Keep useful files, approve repairs, create missing coverage or skip. Custom requests and canonical specs are preserved. Unsupported protocols can retain native materials.

New collections normally use Postman v2.1 under `recovery/postman/`. An environment companion is optional. Saved examples use placeholders without credentials, private records or production endpoints.

## Verification is optional execution work

Static generation needs no API requests. Request execution requires approved effects and a currently verified isolated runtime, including review of collection scripts. An old report or reachable port does not establish a safe target.

Deferred requests stay unverified; the command does not repeat restoration to test them.

## What happens next

Review retained or changed files, actual requests and remaining gaps. Skipped and not-applicable outcomes still need report approval before [Step 4: Documentation](4-documentation.html). This phase does not commit.
