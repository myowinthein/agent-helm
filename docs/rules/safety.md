---
title: Safety
parent: Rules
nav_order: 2
---

# Safety

Help agents avoid data loss, unintended publication and shared-system changes while continuing ordinary work. Install with [Git](git.html) through [adopt](../commands/adopt.html). Loading rules starts no scan.

## Agent execution boundaries

| Decision | Behavior |
|---|---|
| Proceed | Make requested edits, permitted reads and established safe checks while preserving unrelated work. |
| Authorize | Use a specific human request or approved concrete plan for consequential effects. Ask only for missing authorization. |
| Stop | Block prohibited effects, uncertain targets or unmet required gates; continue independent safe work. |

Consequential actions include publication, deployments, migrations, seeders, imports, resets, infrastructure changes, secret rotation, destructive cleanup, exports and external messages. Public legal-document commits require exact content review.

The agent reuses approval while its target, content and effects still match. Tool access, defaults and silence do not supply consent. Approval cannot waive a hard prohibition.

## Protect work and verify effects

The agent inspects relevant scripts, hooks and targets before execution. Names such as `test` or `dry-run` do not prove safety. Unrelated files and staged hunks are preserved; Git cannot recover every database, uncommitted edit or remote effect.

Results are checked before continuing or retrying. A timeout does not prove nothing happened. Destructive actions are not blindly repeated or rolled back over user work.

Credentials and private records must not leak through chat, logs, Git or unapproved uploads. Delegated work gets the same or narrower authority.

## Maintaining command outputs

Editable project content can be maintained during authorized development without rerunning its creating command. Preserve custom content and verify affected behavior and references.

| File role | Maintenance approach |
|---|---|
| Source, instructions, tests and guides | Make targeted task-relevant edits. Policy changes need human authority. |
| Legal commitments or test protection | Use required content approval for legal commits; justify and verify reduced test protection. |
| Actual generated output | Change authoritative inputs and use the approved generator. |
| Assessment and recovery evidence | Preserve historical markers and records; use the owning workflow for updates. |

Agent-written docs and tests are editable source unless an actual generator owns them. Ordinary edits do not establish a fresh assessment, passing test or archive seal. Report known follow-up needs without opening live records or adding tracking files.

## Host capabilities

The agent verifies the workspace, account and runtime needed for the action. Folder access proves neither database identity nor working tests. Missing capability blocks dependent work while preserving drafts and prior successes.

Task authorization, app approvals and OS restrictions are separate. Markdown rules guide decisions; they do not replace enforced permissions or guarantee prevention.

## When to run a safety scan

[Log](../commands/log.html) includes static operational review in Full scan. Material changes to deployment, data, credentials or destructive scripts need focused reassessment; routine prose edits do not trigger a full scan.

Findings identify evidence, uncertainty and a proposed instruction:

```text
Risk: Deployment selects a shared database by default.
Evidence: scripts/deploy.sh; live target unverified.
Instruction: Confirm the database and environment before deployment.
```

Accepted project hazards belong in the instruction owner's `## Hard Safety Rules`, through a reviewed edit. Discovery alone authorizes no execution or policy update.

## Operational Helm state

Records under `.helm/` belong to their explicitly invoked owners: refactor, test, normalize and legal. Ordinary source work neither reads nor resets them.

Archive bundles and recovery evidence remain protected. Ship has narrow publication procedures for selected backups and private normalization evidence. Unsupported state stops dependent work without automatic conversion or deletion.
