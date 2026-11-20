---
title: Safety
description: Define when agents can proceed, need authorization or must stop, with safeguards for user work, credentials, operational state and shared systems.
parent: Rules
detailed: /docs/rules/safety/detailed.html
nav_order: 2
---

# Safety

{% include guide-depth.html %}

Protect user work, private information and shared systems while allowing ordinary development to continue. Install with [Git](git.html) through [adopt](../commands/adopt.html).

## Agent execution boundaries

| Decision | What the agent does |
|---|---|
| Proceed | Make requested edits, permitted reads and established safe checks. |
| Get authorization | Confirm missing authority for a concrete consequential action. |
| Stop dependent work | Respect prohibitions, uncertain targets and unmet required gates. Continue independent safe work. |

Before changes, the agent establishes which project and environment you mean. If your request concerns Helm while the session is in a demo project, it clarifies the target before implementation. Reading another project's instructions supplies no permission to change it. An explicit request already identifying the target needs no repeated confirmation.

Publication, deployment, actual data changes, destructive cleanup, credential changes, exports and external messages need authority for their effects. Implementing a deletion feature does not authorize deleting real records. Established safe tests with isolated fixtures can continue within their approved scope. Public legal-document commits need exact content review. Approval can be reused while the target, content and effects still match; silence and tool access supply no consent.

Necessary related code, tests and documentation can accompany the requested work within their maintenance boundaries. Unrelated repairs are reported before expanding the task.

## Protect work and verify effects

Inspect scripts, hooks and targets before execution. Names such as `test` or `dry-run` do not prove safety. Preserve unrelated files and staged hunks; Git cannot recover every database or remote effect.

Verify results before continuing or retrying. A timeout does not prove nothing happened. Never blindly repeat destructive actions or roll back over user work. Preserve credentials and access configuration unless their removal, replacement or rotation has a clear authorized purpose; apparent non-use is insufficient. Keep secrets and private records out of chat, logs, Git and unapproved uploads. Delegation does not expand authority.

## Maintaining command outputs

Ordinary code, tests and general guides remain editable during development. Documents and configuration maintained by a command normally stay with that command. For an edit outside it, the agent first reads its authoring standards and presents the proposed content, affected files and reason before writing. You can approve the bounded change or use the owning command. A specific request already covering the edit needs no repeated approval.

| File role | Maintenance approach |
|---|---|
| Ordinary source and guides | Make focused edits, preserving custom content and behavior. |
| Command-maintained documents and configuration | Review the concrete proposal before changes; preserve the owning command’s standards and selected format. |
| Legal commitments or test protection | Obtain required legal approval; justify and verify reduced protection. |
| Actual generated output | Update authoritative inputs and use the approved generator. |
| Assessment or recovery evidence | Preserve records; use their owning workflow. |

This includes AGENTS.md, standard and custom READMEs, adopted rules and legal documents. A general coding request does not authorize their update. Generated versions follow the same approval boundary through their actual producer.

Approval for a document edit does not grant access to ledgers or recovery evidence. Ordinary edits preserve review markers and do not establish a fresh assessment, passing test or archive seal.

## Host capabilities

Verify the workspace, account and runtime needed for the action. Missing capability blocks dependent work while preserving drafts and completed results. Markdown instructions guide decisions; they do not replace enforced permissions or guarantee prevention.

## When to run a safety scan

[Log’s Full scan](../commands/log.html#what-the-review-covers) includes static operational review. Material changes to deployment, data, credentials or destructive scripts need focused reassessment; routine prose edits do not trigger a full scan.

Findings explain the risk, evidence, uncertainty and proposed instruction. Accepted project hazards enter the instruction owner’s `## Hard Safety Rules` through a reviewed edit. Discovery authorizes no execution or policy update.

## Operational Helm state

Records under `.helm/`, archive bundles and recovery evidence remain protected. Ordinary source work neither reads nor resets them. Only invoked owning workflows and narrow publication procedures access their permitted state. Unsupported state is not automatically converted or deleted.

After a fully successful Normalize publication cycle, Ship's defined retention procedure can automatically keep the latest three completed backups for that clone and remove eligible older ones. Unfinished or dependency-required proof stays protected. This grants no general cleanup access, and changed or uncertain evidence is preserved.
