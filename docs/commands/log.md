---
title: log
parent: Commands
nav_order: 1
---

# log

Keep project instructions useful for new agent sessions. Log reviews the project and proposes lasting context, working agreements and lessons.

## Start the command

```text
log
```

Use the prefix for your app or terminal from [Setup]({{ '/docs/setup/' | relative_url }}#run-a-command).

Git-backed updates require a clean **main or master** branch. Without Git history, log can create instructions and leave them uncommitted.

## Flow

```mermaid
flowchart TD
  Start(["Start log"]) --> Inspect["Check instruction files<br/>and the saved review point"]
  Inspect --> Layout{"Shared setup needed?"}
  Layout -->|Yes| Connect["Review layout changes<br/>for the selected work"]
  Layout -->|No| Scope{"Source review selected?"}
  Connect --> Scope
  Scope -->|No| Current(["Report the local result"])
  Scope -->|Yes| Scan["Investigate the selected<br/>Full scan or Gap scan"]
  Scan --> Review["Review findings and<br/>proposed instruction changes"]
  Review --> Choice{"Apply the proposal?"}
  Choice -->|Revise| Review
  Choice -->|Skip| Finish(["Finish locally"])
  Choice -->|All or selected changes| Write["Update and verify<br/>the accepted instructions"]
  Write --> Finish
```

## Shared project instructions

`AGENTS.md` holds shared knowledge and Helm settings; `CLAUDE.md` imports it with `@AGENTS.md` and keeps any Claude-specific additions.

| Existing files | Proposed setup |
|---|---|
| Neither | Create both during the first Full scan. |
| Only `AGENTS.md` | Keep it and add the Claude import. |
| Only `CLAUDE.md` | Review moving shared content into `AGENTS.md`. |
| Both | Keep a working connection or review reconciliation. |

Custom content, imports, settings and adopted rules are preserved unless you approve a specific change. Conflicting or shadowed instructions need reconciliation first.

## What the review covers

- **Full scan:** trace important workflows, setup, configuration and tests across every first-party package. This gathers project knowledge rather than auditing every line for code quality.
- **Gap scan:** review commits and relevant patches since the saved review point, including affected code. Missing or unusable history calls for Full scan.

The review looks for useful identity, configuration, development commands, architecture, domain rules, working agreements, safety hazards and traps. Relevant corrections from the current conversation can become proposed lessons too.

For existing instructions, review one proposal and apply all, select changes, revise or cancel. New safety instructions need explicit approval. Custom layouts receive focused edits.

## Your result

You get updated instructions, unresolved findings and a size report. Missing Helm preferences are saved only through approved changes. New configuration uses Markdown bullets; existing supported formats stay intact.

The `last-reviewed` comment advances only after a complete source review and acceptance of all substantive changes. Partial acceptance and layout-only work keep the earlier marker.

Changes follow your local commit policy and stay on the same branch. Use [adopt](adopt.html) for copied rules and [ship](ship.html) for publication.
