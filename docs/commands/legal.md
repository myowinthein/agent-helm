---
title: legal
parent: Commands
nav_order: 7
---

# legal

Prepare source-based legal documents and write uncommitted drafts for editor review. You decide whether to commit them.

## Start the command

```text
legal
```

Use the prefix for your app or terminal from [Setup]({{ '/docs/setup/' | relative_url }}#run-a-command).

Start on clean **main or master**. Commits containing legal document text need explicit content and commit approval, even with auto-commit enabled.

## Flow

```mermaid
flowchart TD
  Start(["Start legal"]) --> Inspect["Inspect source, context<br/>and existing documents"]
  Inspect --> Needed{"Document changes?"}
  Needed -->|No| End(["Report the result, gaps<br/>and any record-only changes"])
  Needed -->|Yes| Draft["Prepare useful documents<br/>with existing conventions"]
  Draft --> Facts{"Essential missing facts?"}
  Facts -->|Yes| Ask["Ask one consolidated batch;<br/>resolve or hold affected documents"]
  Facts -->|No| Files["Write and read back complete<br/>uncommitted document files"]
  Ask --> Files
  Files --> Review["Short summary and file links;<br/>developer reviews in editor"]
  Review --> Approval{"Commit / Revise / Leave uncommitted"}
  Approval -->|Revise| Draft
  Approval -->|Leave uncommitted| End
  Approval -->|Commit| Save["Recheck reviewed files,<br/>record eligible provenance and commit"]
  Save --> End
```

## Understand the service first

Review actual data flows, integrations, payments and existing policies. Source and supplied answers come first; essential missing facts are asked in one batch.

Relevant provider or legal research may be needed, but there is no standard business interview, home-address requirement or worldwide clearance process. Off-code practices remain limits of source inspection.

## Prepare the useful documents

| Document | Purpose |
|---|---|
| Privacy policy | Explain personal-data processing. |
| Terms | Set approved service rules. |
| Cookie policy | Explain tracking/storage not already covered. |
| Refund policy | Describe confirmed sales/refund responsibilities. |
| EULA | Set an approved compatible licensing arrangement. |
| Disclaimer | Explain relevant content or advice limitations. |

Prepare the smallest useful set. Terms, refund policies and EULAs need your request or an existing approved policy. You can request or exclude supported types; no useful changes can mean no files written.

## Draft from confirmed facts

Follow existing locations and language. Preserve approved custom or lawyer-reviewed clauses unless a specific replacement is agreed. Missing facts do not become invented promises.

Routing, consent controls, navigation and store submissions are separate implementation work.

## Reconcile missing recorded documents

Legal checks the current files/Git snapshot, current conversation, existing project documents and references, then relevant local Git history as needed. It automatically corrects a confirmed move's recorded path or removes a confirmed deleted document's entry, preserving historical assessment dates/source IDs. It asks where a file went only after relevant investigation cannot resolve it; uncertain records stay intact. This never deletes an actual legal document.

No cleanup approval is added. With drafts, record repairs join the existing content commit or stay uncommitted with the drafts. Record-only work follows auto-commit or existing commit authorization; otherwise it stays uncommitted. Explicit read-only requests remain read-only.

## Handle gaps precisely

Omit optional unsupported promises, narrow claims or ask about indispensable missing facts. A known material problem holds the affected document while other complete drafts may proceed. Incomplete preliminary wording stays off public routes.

Unassessed sufficiency is a limit, not automatically a violation. Drafting and owner approval do not establish compliance or enforceability.

## Review before committing

Read complete files in your editor or Markdown preview. Chat stays with links, meaningful changes and important gaps. A full chat dump or second-model critique is available only on request.

Choose **Commit / Revise / Leave uncommitted**. Approval covers actual content, dates and the disclosed commit/record changes. You may edit drafts yourself; the agent rereads them before committing. Unchanged approved work needs no second question.

## Your result

You get document links, gaps, record repairs and local commit or draft status. Only approved complete substantive document changes refresh assessment dates/source IDs in `.helm/legal-manifest.json`; path/removal reconciliation makes no new legal assessment.

Unchanged source does not prove business or legal freshness. Work stays on the same branch; use [ship](ship.html) for publication.
