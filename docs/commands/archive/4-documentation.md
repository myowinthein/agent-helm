---
title: "Step 4: Documentation"
parent: archive
grand_parent: Commands
nav_order: 4
---

# Step 4: Documentation

Make the preserved project understandable to someone opening it later. The entry point explains where to begin, the setup gives ordered recovery commands and the metadata records exactly what was captured.

## Flow

```mermaid
flowchart TD
  Start(["API-materials report approved"]) --> Inventory["Review existing documentation<br/>and verified recovery evidence"]
  Inventory --> Plan["Propose focused outputs<br/>and any consolidation"]
  Plan --> Approval{"Approve the editing plan?"}
  Approval -->|Revise| Plan
  Approval -->|Stop| End(["Keep prior work"])
  Approval -->|Yes| Write["Update the index, setup and<br/>artifact metadata where useful"]
  Write --> Check["Verify links, paths,<br/>commands and preserved context"]
  Check --> Report["Present the phase report<br/>for approval"]
  Report --> Next(["Save approved progress;<br/>continue to local preparation"])
```

## Keep useful documentation

Accurate setup, domain and API information is kept and linked. Design decisions, build notes, changelogs and useful history remain available; LICENSE/NOTICE and legal documents are preserved. Outdated or duplicate material gets a proposed focused repair or consolidation rather than automatic deletion.

Before editing, you review exact Keep/Update/Merge/Archive/Remove actions and reasons. Agent instruction files, their imports, adopted rules and operational Helm state are protected. A conflicting output path needs an agreed alternative, not an overwritten instruction file.

## Give each output a clear purpose

| Default output | What belongs there |
|---|---|
| `README.md` | Archive orientation: purpose, source snapshot, selected goal, quickest recovery route, requirements, limitations and useful links. |
| `docs/setup.md` | Actual ordered configuration, image/runtime preparation, data restore, run/demo and stop procedures. |
| `docs/archive-metadata.md` | Artifact paths, identities, platforms, sizes, checksums, provenance, storage, verification and missing inputs. |
| Optional `docs/historical-notes.md` | Useful historical context that benefits from a separate home. |

Existing suitable locations can be retained. The README uses archive-specific information needs, independently of [manifest](../manifest.html) and `readme-style`. It links to the full procedure instead of copying setup commands and raw phase reports into the entry point.

The setup carries forward evidenced commands from Step 2 and actual API-material paths from Step 3. The metadata holds full identity tables so other pages can link to them. Missing inputs and unrun checks remain visible; the docs do not promise a published backup before ship verifies it.

## What happens next

Static review checks the recovery navigation, paths, configuration and command order against the preserved evidence. It does not execute the app merely to write documentation.

You review the actual files, consolidation decisions and gaps. Approval saves `step4-documentation.md` under `.helm/archive/` and continues to [Step 5: Prepare locally](5-finalize.html). Earlier approved reports remain unchanged. No commit or push happens in this phase.
