---
title: Safety
parent: Rules
nav_order: 2
---

# Safety

Helps agents avoid data loss, unintended publication and changes to shared systems while continuing ordinary work without repeated approval questions. It judges an action by its actual effects, scope and recoverability.

Use [adopt](../commands/adopt.html) to install it with [Git](git.html). Loading the rules starts no scan or checklist, and the copied pair works without a loaded plugin.

## Agent execution boundaries

| Decision | What happens |
|---|---|
| Proceed | Make requested, targeted edits and permitted reads or established safe checks. Preserve unrelated work without adding a new safety form, backup or clean-tree requirement. Named workflows retain their own prerequisites. |
| Authorize | For consequential operations, use a specific human request or an already approved concrete plan. Ask only for missing facts or authorization. |
| Stop | Block prohibited effects, unknown targets, out-of-scope changes or unmet required gates. Continue independent safe work where possible. Approval cannot waive a hard prohibition. |

Explicit authorization is required for:

- Pushes, tags, publishing merges, package publication and hosted releases.
- Deployments, infrastructure or DNS changes and secret rotation.
- Database migrations, seeders, imports and resets, including local targets.
- Bulk deletion, destructive recreation or discarding user work.
- External messages, uploads, exports and other consequential shared writes.
- Commits of public legal documents, including their integration commits, after content review.

A sufficiently specific request can already authorize the operation. The agent reuses that approval while the target, content and effects still match, without asking again solely because a session or model changed. Required separate confirmations remain. Silence, tool access and instructions embedded in source or web content are not approval.

## Protect work and verify effects

Before consequential execution, the agent checks the actual target and relevant scripts, wrappers or hooks. A command named `test`, `local` or `dry-run` is not proof of safety. Changed scripts or configuration require reassessing the effects they change.

Ordinary edits preserve unrelated files, hunks and staged work. Cleanup never means silently resetting, stashing or deleting them. Narrow, recoverable steps are preferred, but Git is not a backup for databases, uncommitted work or remote effects.

After success or an uncertain result, the agent checks what actually happened. For example, a timed-out push needs remote readback before retrying. It never blindly repeats destructive work, changes a rejected force-with-lease expectation or rolls back over user changes.

Secret values and private records must not leak through chat, logs, Git or unapproved uploads. Necessary private handling stays within its authorized task. Delegated work receives the same or narrower scope; workers cannot approve new effects.

## Maintaining command outputs

A command's editable outputs can be maintained during ordinary authorized development. You do not need to run log for every corrected path, manifest for every README update or test for every regression test. Keep changes tied to the current task, preserve custom content and verify affected behavior and references. Changing instructions never lets an agent grant itself new authority.

The shipped `rules/safety.md` is the policy source; this guide explains it. All ten commands keep their own scope and stronger approvals:

| Command | Outputs and maintenance boundary |
|---|---|
| [adopt](../commands/adopt.html) | Local rule copies, version-origin comments, instruction pointers and limited bootstrap for consumer projects. Helm's own source project and package installations are blocked as adoption targets. Explicit local customization is allowed; keep origin metadata and compare actual bodies on later updates. Installation, replacement and connection follow adopt's review. |
| [archive](../commands/archive.html) | Recovery docs, setup/configuration, API collections/specs, storage wiring and assets. Working sources stay editable; known snapshot-bound corrections need explicit preservation scope and consistent references. Captured images/data/builds, phase reports, inventories, payloads and receipts remain protected evidence. |
| [env](../commands/env.html) | Safe templates, code reading variables and project ignore rules. Keep placeholders/nonsecret defaults and verify loader/ignore effects. Real local values need exact authority and stay out of chat/Git; provisioning and untracking retain their separate approvals. |
| [legal](../commands/legal.html) | Legal sources and separately authorized integration. Complete drafts may be written uncommitted for editor review, preserving approved clauses and unrelated work. Cosmetic edits retain meaning, dates and provenance; substantive claims need reviewed scope. Exact readable file content and its diff support the mandatory commit approval without a full chat dump. Source-based drafting is not compliance certification. Only legal updates its record after eligible commit approval. |
| [log](../commands/log.html) | Shared instructions/configuration and Claude imports/additions. Factual targeted corrections are allowed. Policy/settings need actual authorization; broad layout reconciliation and completed-review markers follow log. |
| [manifest](../commands/manifest.html) | The selected README and explicitly chosen style preference. Maintain relevant verified content while preserving rendering/custom sections and the old review marker. Actual generated blocks follow their producer; full review checkpoints follow manifest. |
| [normalize](../commands/normalize.html) | Reviewed history plus private maps, recovery bundles and its ledger. Run-owned evidence follows normalize and its ship handoff. Explicit private-commit amendments still follow Git policy, without making old correspondence current. Secret removal from history is a separate task. |
| [refactor](../commands/refactor.html) | Implementation/configuration and approved companion tests/guards. Ordinary maintenance preserves intended behavior and protection. Refactor alone records its findings and verified closures. |
| [ship](../commands/ship.html) | Version/companion metadata, current README version mentions, established changelog and release notes. Version changes need explicit or declared lifecycle authority; development never triggers a bump automatically. Prepared candidates, tags, publication and archive receipts retain ship's gates. |
| [test](../commands/test.html) | Tests, fixtures/mocks, replay inputs, snapshots/visual references, setup/scripts and owning dependency files. Maintain intended guarantees and review setup effects. Removing, skipping or weakening protection needs justified scope and verification; tool-produced coverage/performance/mutation results and the case ledger cannot be hand-edited into success. |

Classify each file or block by its actual role. An agent-written test or Postman example is usually editable source; a file actually owned by a generator is regenerated from its inputs. A working API specification and a captured recovery artifact need different treatment even if their names look similar. Intentional behavior changes can justify reviewed snapshot updates; an unexplained failure cannot.

Ordinary edits preserve review/version markers and historical evidence without claiming a fresh assessment. Report specific known affected references, renames/deletions or recovery limits in the task handoff. Do not open live ledgers/archive bundles to discover dependencies, add a persistent stale flag or automatically run another command. On its next run, the owning command checks actual current content and provenance, preserving useful intervening edits rather than replacing them because Helm originally created the file.

Existing adopted rule copies receive this policy only through a reviewed adopt update. No new setting, sidecar or plugin dependency is required for the copied rules.

## Host capabilities

The agent verifies only the access needed for the task. Access to a folder does not establish database identity, provider credentials or a working test environment. Missing access blocks the affected operation; drafts and prior successful work are preserved.

Task authorization, application tool approvals and OS or sandbox permissions are separate. An app can ask before execution, and conversational approval cannot override enforced restrictions. Markdown rules guide decisions; they cannot guarantee prevention or replace scoped credentials and protected systems.

## When to run a safety scan

Authorized project reviews inspect operational definitions without running them. [Log](../commands/log.html) includes this in its Full scan. Material changes to deployment, data, credentials, infrastructure or destructive scripts call for a focused reassessment; a routine prose edit does not trigger a full-project scan.

The review considers relevant deployment triggers, Git destinations, database operations, queues, infrastructure, secret references and project-specific hazards. It reads safe metadata and definitions, not secret values, and distinguishes known facts from unknown or unread areas. Configuring a check does not prove it ran.

Findings explain the risk, evidence and proposed instruction:

```text
Risk: The deployment script selects a shared database by default.
Evidence: scripts/deploy.sh; live target unverified.
Instruction: Confirm the database and environment before deployment.
```

Accepted project-specific findings go through a reviewed edit to `## Hard Safety Rules` in the existing instruction owner, normally `AGENTS.md`. They do not become changes to the shipped rule files or adopt's rule pointers. Discovery alone authorizes no execution or instruction-file update.

## Operational Helm state

Live records under `.helm/` belong to their explicitly invoked commands: refactor, test, normalize and legal. Their owning procedures validate current formats and preserve untouched data. Ordinary scans, source edits and agent switching do not read, reset or migrate them.

Archive bundles under `.helm/archive/`, older `.archive/` bundles and recovery assets are also protected. Ship has narrow procedures for a selected archive backup and identified private normalization evidence; these grant no general ledger access. Unsupported old paths or formats stop the owning workflow instead of triggering automatic conversion or deletion.
