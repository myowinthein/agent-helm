---
title: normalize
parent: Commands
nav_order: 8
---

# normalize

Review commit messages against project conventions and correct approved messages across affected local branches.

## Start the command

```text
normalize
```

Use the prefix for your app or terminal from [Setup]({{ '/docs/setup/' | relative_url }}#run-a-command).

Read-only review permits a dirty or detached checkout. Rewriting and record writes need a clean attached branch, no ongoing Git operation and safe access to every affected branch.

## Flow

```mermaid
flowchart TD
  Start(["Start normalize"]) --> Audit["Resolve commit policy and<br/>review the requested history"]
  Audit --> Messages["Prepare exact message proposals<br/>and resolve requested edits/subsets"]
  Messages --> Changed{"Any proposed corrections?"}
  Changed -->|No| Record["Record meaningful proven coverage<br/>only when eligible and authorized"]
  Changed -->|Yes| Impact["Show all affected local branches,<br/>ID changes, risks and recovery plan"]
  Impact --> Approval{"Apply these messages<br/>and their complete rewrite plan?"}
  Approval -->|Edit/change selection| Messages
  Approval -->|Cancel/keep review only| End(["Report the local result"])
  Approval -->|Apply| Backup["Recheck inputs and tools;<br/>verify private recovery bundle"]
  Backup --> Rewrite["Rewrite once and verify<br/>all affected commits and refs"]
  Rewrite --> Record
  Record --> End
```

## Review messages first

Default scope is the current local branch. Request named branches, all local branches, a bounded range or full history when needed. Project policy and compatible commitlint rules take precedence over Helm defaults.

Accepted messages stay unchanged. Corrections normally affect subjects; bodies, trailers and breaking information are preserved unless their edits are shown. Unclear intent needs clarification.

Wording and subset choices authorize no rewrite. Final approval covers exact messages and their complete impact, including effects on [ship](ship.html#optional-versioned-release)'s version proposal.

### Code-assisted checks and incremental review

A Python helper checks formatting. The agent reviews full messages and relevant changes for meaning: `feat(auth): fix login typo` can pass syntax while using the wrong type.

Later runs reuse proven semantic coverage only while history, policy and review requirements remain compatible. New commits still need review; explicit full-history review reassesses everything selected. Formatting-only checks establish no semantic coverage.

Reports distinguish mechanical checks, new review, reused coverage and unreviewed history.

## Which branches change?

Every local branch containing a corrected commit joins the coordinated rewrite. Its other messages stay unchanged unless separately approved. Shared ancestors change descendant IDs; feature-only corrections need not affect main.

Remote-tracking refs, tags, stashes, notes and other clones stay unchanged. Fixed tags can lose ancestry from rewritten branches; signatures may be lost.

## Approve and verify the rewrite

Review exact messages, affected branches, ID and tag effects, recovery location and record/commit changes. A blocked branch or incomplete history stops the coordinated rewrite.

Choose **Apply reviewed rewrite / Edit or change selection / Cancel/keep review only**. Unchanged preflight needs no second approval; material changes return for review. Cancellation creates no recovery artifacts or record.

Apply requires **git-filter-repo and Python**. After approval, verify a private recovery bundle outside the checkout, rewrite once and check messages, trees, topology, metadata and preserved refs. Failure leaves actual results for reconciliation, not a blind retry.

## Your result and later publication

You get old/new tips, message results, tag effects and the private recovery path. Before rewriting, normalize also registers a private local pointer so ship can find the evidence in another terminal or agent session. Each rewrite keeps its own pointer; backups and pointers remain after publication.

Eligible semantic coverage is saved in `.helm/normalize-log.json` under your commit policy. Coordinating another branch does not certify its unique messages as reviewed. Unsupported state remains preserved and blocks dependent work.

Normalize finishes locally. Use [ship](ship.html#publish-normalized-history) to publish reviewed replacement history. In the same clone, you normally do not need to supply a path. Missing/moved evidence or another clone/machine may need an explicit recovery path and transferred files. Other clones still need deliberate history coordination.
