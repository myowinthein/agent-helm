---
title: Safety
description: Define when agents can proceed, need authorization or must stop, with safeguards for user work, credentials, operational state and shared systems.
parent: Rules
nav_order: 2
---

# Safety

Protect user work, private information and shared systems while allowing ordinary development to continue. Install with [Git](git.html) through [adopt](../commands/adopt.html).

## Agent execution boundaries

| Decision | What the agent does |
|---|---|
| Proceed | Make requested edits, permitted reads and established safe checks. |
| Get authorization | Confirm missing authority for a concrete consequential action. |
| Stop dependent work | Respect prohibitions, uncertain targets and unmet required gates. Continue independent safe work. |

Publication, deployment, data imports, resets, destructive cleanup, secret rotation, exports and external messages need authority for their effects. Public legal-document commits need exact content review. Approval can be reused while the target, content and effects still match; silence and tool access supply no consent.

## Protect work and verify effects

Inspect scripts, hooks and targets before execution. Names such as `test` or `dry-run` do not prove safety. Preserve unrelated files and staged hunks; Git cannot recover every database or remote effect.

Verify results before continuing or retrying. A timeout does not prove nothing happened. Never blindly repeat destructive actions or roll back over user work. Keep credentials and private records out of chat, logs, Git and unapproved uploads. Delegation does not expand authority.

## Maintaining command outputs

Agent-written guides, instructions and tests can be edited as source during authorized work. Rerunning their creating command is unnecessary. The file’s role determines the safeguards:

| File role | Maintenance approach |
|---|---|
| Source and guides | Make focused edits, preserving custom content and behavior. |
| Legal commitments or test protection | Obtain required legal approval; justify and verify reduced protection. |
| Actual generated output | Update authoritative inputs and use the approved generator. |
| Assessment or recovery evidence | Preserve records; use their owning workflow. |

Ordinary edits do not establish a fresh assessment, passing test or archive seal.

## Host capabilities

Verify the workspace, account and runtime needed for the action. Missing capability blocks dependent work while preserving drafts and completed results. Markdown instructions guide decisions; they do not replace enforced permissions or guarantee prevention.

## When to run a safety scan

[Log’s Full scan](../commands/log.html#what-the-review-covers) includes static operational review. Material changes to deployment, data, credentials or destructive scripts need focused reassessment; routine prose edits do not trigger a full scan.

Findings explain the risk, evidence, uncertainty and proposed instruction. Accepted project hazards enter the instruction owner’s `## Hard Safety Rules` through a reviewed edit. Discovery authorizes no execution or policy update.

## Operational Helm state

Records under `.helm/`, archive bundles and recovery evidence remain protected. Ordinary source work neither reads nor resets them. Only invoked owning workflows and narrow publication procedures access their permitted state. Unsupported state is not automatically converted or deleted.

[View the rule source](https://github.com/myowinthein/agent-helm/blob/main/rules/safety.md).
