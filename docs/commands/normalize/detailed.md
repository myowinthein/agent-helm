---
title: normalize
description: "Normalize reviews commit messages and can apply the corrections you approve. Because a message change creates new commit identities, the workflow coordinates affected branches and preserves verified recovery evidence before rewriting."
parent: Commands
nav_exclude: true
has_toc: false
overview: /docs/commands/normalize.html
permalink: /docs/commands/normalize/detailed.html
title_category: Details
source_files:
  - guides/normalize.md
---

# normalize

{% include guide-depth.html %}

Normalize reviews commit messages and can apply the corrections you approve. Because a message change creates new commit identities, the workflow coordinates affected branches and preserves verified recovery evidence before rewriting.

## Flow

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
  Changes -->|No| Checkpoint["Save review coverage only when proven"]
  Changes -->|Yes| Impact["Prove the full affected graph, constraints and recovery plan"]
  Impact --> Approval{"One final message and impact decision"}
  Approval -->|Edit or change selection| Messages
  Approval -->|Cancel| Report["Report without rewriting or saving new review coverage"]
  Approval -->|Apply| Rewrite["Continue to approved rewrite and verification"]
  ReviewOnly --> Report
```

```mermaid
flowchart TD
  Recheck["Recheck approved messages, policy, branches and worktrees"] --> Backup["Create and verify the private recovery bundle"]
  Backup --> Evidence["Preserve the recovery plan for later publication"]
  Evidence --> Filter["Rewrite the exact approved graph once"]
  Filter --> Verify{"Messages, graph, metadata and preserved refs match?"}
  Verify -->|No| Hold["Stop dependent work; keep actual results and recovery evidence"]
  Verify -->|Yes| Map["Save the independently verified old-to-new mapping"]
  Map --> State["Save verified review results and preserve earlier provenance"]
  State --> Commit["Write and commit eligible records under local policy"]
  Commit --> Finish["Report the same-branch local result and retained recovery path"]
  Finish --> Ship["Use ship separately for publication approval"]
```

## Start the command

Ask for Review only if you want findings without writes; that can inspect a dirty or detached checkout. Applying corrections requires a clean attached branch, no ongoing Git operation and safe access to every affected local branch.

## Before history review

An ordinary run first shows the full coordination notice, then waits for **Team ready**, **Review only** or **Stop**. An explicitly read-only request skips that coordination question and creates no records or recovery artifacts.

Readiness means you have coordinated included branches, conflicting work and later synchronization with other clones. It is not enforcement on teammates or devices, and approves neither rewriting nor pushing.

After readiness, the agent checks for newly pushed agreed branches. Any fetch or local branch preparation needs its concrete approval before the inventory is frozen. Preparation continues in the same run so a newly discovered branch is not quietly omitted.

## Review messages

The current local branch is the default, with named branches, ranges or broader history available when requested. Actual project policy comes first; otherwise [Helm's message conventions](../../rules/git.html#conventional-commits) guide the review.

Python can check message syntax, while the agent reads changes to assess meaning. A correctly formatted subject can still misdescribe a commit. Bodies, trailers and breaking-change information remain unless their proposed changes are shown explicitly.

Review exact old and new messages together with the impact. You can change the selection, revise wording or cancel. Earlier semantic review is reused only while its evidence still matches; an unchanged formatting result alone establishes no such coverage.

## Which branches change?

Every affected existing or approved prepared local branch must be handled together. Changing an older commit also changes its descendants' IDs, even when their messages and file contents stay the same. A blocked affected branch stops the coordinated rewrite.

Tags and excluded refs remain fixed. Consequently, an old release tag can point to history that is no longer an ancestor of the rewritten branch. Commit signatures may also be lost. Other clones require deliberate synchronization afterward.

## Approve and verify the rewrite

One final decision covers exact messages, affected branches, commit and tag effects, and the recovery plan. The unchanged plan is not asked twice, but changed scope or messages need the corresponding review again.

Applying requires Python and git-filter-repo. Before rewriting, the agent verifies recovery material under `Agent Helm/normalize/<run-id>/` in your OS user's home, outside every checkout. An interrupted continuation reuses its existing folder.

After the bounded rewrite, verification compares messages, file contents, graph relationships and preserved refs. A mismatch stops dependent work and retains the actual results and recovery evidence. It does not cause an automatic destructive retry or rollback.

## Your result and later publication

The report gives old and new tips, checks that actually ran and the recovery location. A clean result does not by itself establish a new complete assessment checkpoint; incomplete review and declined changes remain visible.

Private locators let [ship](../ship.html#publish-normalized-history) find the evidence later in the same clone. Another machine may need the retained files and an explicit path. Ship separately verifies that evidence and seeks publication approval with fixed lease expectations. Existing tags stay intact, and rewording released history alone does not create a release.

## Explore the source

For implementation details, read [guides/normalize.md](https://github.com/myowinthein/agent-helm/blob/main/guides/normalize.md).
