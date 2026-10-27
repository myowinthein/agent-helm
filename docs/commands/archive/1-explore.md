---
title: "Step 1: Explore"
parent: archive
grand_parent: Commands
nav_order: 1
---

# Step 1: Explore

Identify what recovery needs through local source and metadata inspection, without running the project or contacting services.

## Flow

```mermaid
flowchart TD
  Start(["Source branch confirmed"]) --> Inventory["Inspect components, setup,<br/>data and recovery materials"]
  Inventory --> Scope["Agree recovery goals;<br/>identify missing and excluded inputs"]
  Scope --> Report["Present findings and<br/>the proposed restoration approach"]
  Report --> Approval{"Approve the report?"}
  Approval -->|Revise| Report
  Approval -->|Stop| End(["Leave exploration unsaved"])
  Approval -->|Yes| Save["Save report and initial<br/>file inventory"]
  Save --> Next(["Continue to Restore and Freeze"])
```

## What gets discovered

- Project purpose, architecture and useful demonstration scope.
- Last-working stack, toolchain, platform and missing inputs.
- Data sources, provenance and sensitivity.
- External integrations and isolation needs.
- Setup notes, API materials and useful artifacts or history.
- Branches, tags and external objects outside the selected snapshot.

Secret values and private records stay out of reports. Cached remote information does not prove current availability.

## Agree the preservation goal

Choose source preservation, a runnable demonstration, offline runtime recovery or rebuild inputs. Missing data, services, licensed tools or hardware remain explicit limits. Restoration does not imply modernization.

## What happens next

Review the findings and restoration approach, then approve, revise or stop without saving. Approval creates the initial report, inventory and progress under `.helm/archive/`.

[Step 2: Restore and freeze](2-restore-and-freeze.html) proposes the actual restoration work.
