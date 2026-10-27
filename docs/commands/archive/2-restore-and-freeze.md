---
title: "Step 2: Restore and freeze"
parent: archive
grand_parent: Commands
nav_order: 2
---

# Step 2: Restore and freeze

Restore the agreed scope, review what works and capture what later recovery needs. The approach follows the project and goal.

## Flow

```mermaid
flowchart TD
  Start(["Exploration report approved"]) --> Plan["Cross-check setup and data;<br/>review the isolated restoration plan"]
  Plan --> Restore["Run only approved restoration<br/>and relevant checks"]
  Restore --> Check["Report actual results and offer<br/>a developer inspection"]
  Check --> Freeze["Recommend the final freeze<br/>from the recovery goal and evidence"]
  Freeze --> Capture["Approve and capture selected<br/>runtime, data and configuration"]
  Capture --> Report["Review artifacts, recovery commands<br/>and remaining limitations"]
  Report --> Approval{"Approve the phase report?"}
  Approval -->|Revise| Report
  Approval -->|Stop| Pending(["Keep actual work and pending checks"])
  Approval -->|Yes| Next(["Save progress;<br/>continue to API materials"])
```

## Restore from reliable inputs

Cross-check setup notes against manifests, locks, scripts and platform requirements. Resolve conflicts before execution, favoring compatibility over upgrades.

Review exact edits, commands, downloads, targets and checks first. Execution uses owned isolated resources without live-service contact; uncertain isolation leaves affected work pending.

## Choose and preserve data

Use suitable synthetic or sanitized inputs. Missing data can mean waiting for an approved local export or accepting empty/schema-only recovery.

Imports need fresh owned empty targets and the correct initialization order. Partial failure stops dependent work without automatic reset or retry. Localhost alone does not establish safety.

## Freeze what the project needs

After restoration, you can inspect the result before choosing the final capture approach.

| Project | Possible route |
|---|---|
| Server or full-stack app | Runtime/images, stores and recovery configuration. |
| Self-contained static site | Built output and selected build inputs. |
| Library or CLI | Source, locked environment and useful distributables. |
| Native, data or hardware project | Useful builds, models or firmware with platform requirements. |

Selected artifacts retain identities and checksums. Real env credentials are not copied into the kit. A working app does not prove offline rebuilding or future platform availability.

## What happens next

The setup file records artifact validation, runtime preparation, data restore, startup, demonstration and shutdown in order.

Review performed and deferred checks separately. An optional cold-recovery rehearsal needs separate approval and isolation; existing caches and volumes are preserved.

Approve the report to continue to [Step 3: Postman collection](3-postman.html), including any accepted limitations. This phase does not commit.
