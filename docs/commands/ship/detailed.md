---
title: Ship
description: "Ship takes reviewed local work to its publication destination. It separates publishing source, updating other branches and making a release, so you can approve each result with its actual effects in view."
parent: Commands
nav_exclude: true
has_toc: false
overview: /docs/commands/ship.html
permalink: /docs/commands/ship/detailed.html
title_category: Details
source_files:
  - guides/ship.md
  - prompts/ship/targets.md
  - prompts/ship/release.md
  - prompts/shared/history-publication.md
  - prompts/shared/ci.md
---

# Ship

{% include guide-depth.html %}

Ship takes reviewed local work to its publication destination. It separates publishing source, updating other branches and making a release, so you can approve each result with its actual effects in view.

## Flow

```mermaid
flowchart TD
  Entry{"Requested route eligible?"} -->|No| Blocked["Report the reason and stop"]
  Entry -->|Yes| Start
  Start(["Start ship"]) --> Inspect["Review current work, remote state,<br/>existing PRs and release candidates"]
  Inspect --> Special{"History replacement<br/>or archive backup?"}
  Special -->|Archive| Backup["Approve and verify<br/>private archive backup"]
  Backup --> End(["Report verified results<br/>and any pending actions"])
  Special -->|History replacement| History["Review rewrite proof or a backed-up replacement;<br/>approve exact publication"]
  Special -->|Ordinary work| Source["Review publication and known targets;<br/>approve the selected actions"]
  History --> Method{"Direct publication?"}
  Source --> Method
  Method -->|Yes| Validation{"Configured source<br/>validation passed?"}
  Validation -->|Yes or none applies| Targets["Review any new target choices;<br/>apply approved branch updates"]
  Validation -->|Failed or unresolved| End
  Method -->|PR handoff| Targets
  Targets --> Ready{"Started on main/master<br/>with a ready release?"}
  Ready -->|No or skip| End
  Ready -->|Yes| Release["Review version, notes and<br/>tag-only or hosted-page choice"]
  Release --> Result["Verify checks; publish the selected outputs<br/>or hand off a metadata PR"]
  Result --> End
```

## Start the command

Start on main/master, an established feature branch or a confirmed environment branch. Pending edits normally need a separate commit first; on main/master, the publication review can cover a bounded safe commit and its push or PR together. A fresh chat can help with context, but the command still discovers unfinished work rather than assuming the project is ready.

History replacement and prepared archive backups use specialist publication reviews. A changed branch alone does not establish its cause or authorize either route; ship checks the actual source and destination.

A failed prerequisite or selected action stops the run, including further target or release planning. Ship preserves earlier successes and reports the actual checkout without an automatic return or cleanup. An unanswered workflow question pauses the run; it does not authorize independent investigation while you decide.

## Publish the current branch

The project's [ship-method](../../rules/git.html#configuration-owner) chooses direct publication or a PR/MR handoff; the default is `direct`. Features use their own source branch. Main and environment work in PR mode use an associated `ship/*` helper so a real review handoff can be created.

Previous Helm setup is not required. Ship checks the existing AGENTS.md/CLAUDE.md instructions, including active overrides and imports, for the method. An explicit `pr` remains PR mode. If the setting is absent, or neither file exists, Ship proceeds with direct-mode assessment without asking you to run Log/Adopt or creating instruction files. Missing files are different from unreadable files or invalid/conflicting settings; those unresolved cases cannot silently choose a default. Publication still needs your approval.

Before publication, you review the destination, outgoing changes, refs, required checks and deployment effects together. The plan can include a safe preparatory commit and the resulting push or PR. Ship verifies the created commit against the reviewed changes and reports its actual ID before continuing under that approval. Unexpected changes require a revised review; auto-commit alone grants no publication permission.

Applicable target choices can join that review when their effects are already known. You approve only the listed actions you select, with the option to publish the source alone. History replacement and destructive cleanup retain explicit reviews, and required protections and checks remain binding.

In direct mode, Ship verifies the push, then waits for configured build, lint and test validation for the exact published commit before continuing to branch updates or offering a release. Validation applies even if branch protection does not require it. With no applicable validation configured, there is nothing to wait for. A separate deployment job can continue independently unless the project requires its success; if one job combines validation and deployment, Ship must wait for that whole job.

If validation fails or is cancelled, Ship reports the commit and failed check, preserves the published source and stops. Fix the problem and rerun Ship. Running or missing checks can remain pending, but a pending result does not permit a release. A rerun checks the actual current commit and results, so an already-published tip needs no duplicate push and an older successful build cannot validate new changes. Tag-triggered checks still run at the release stage; Ship does not expect a tag pipeline before creating its tag.

Ship can create or reuse a matching review handoff, then reports its verified link without waiting for reviewers or later PR checks. It does not merge the request or delete branches. Later pushes update open requests sharing that source; a request merged earlier needs a new handoff for new work.

## Optional branch updates

Choose independent target updates in the publication review when their complete effects are known, or once afterwards if they need later preparation. Selecting the explained actions supplies their approval; execution still waits for verified source publication and required checks. Main can target confirmed environments; features can target main and environments; an environment can target main or other environments. There is no implied main-first chain.

Direct mode integrates, checks and publishes each chosen target. PR mode creates independent handoffs from the same reviewed source. A green source check does not prove a target merge, review or deployment is complete. Partial successes are retained. On continuation, ship rechecks the remaining work and reuses valid approval; an interruption alone does not create another confirmation.

## Optional versioned release

A release needs ready, integrated work on main/master and its own decision. An open source PR must be merged independently first. If release metadata itself needs a PR, tagging waits for that integration too.

Review the semantic version, exact tag, metadata, release notes and checks together. Where supported, choose a tag alone or a tag plus its hosted release page in that same review. Ship creates a selected page only after verifying Git publication and required checks; tag-only selection does not lead to another page offer. Initial, 0.x and prerelease versions need choices suited to their actual compatibility. New tag annotations and hosted titles normally match the tag exactly; notes explain the benefit, necessary upgrade steps and relevant changes without empty boilerplate sections.

Prerelease and Latest settings are explicit. Published tags and versions remain immutable. Package publication, asset uploads and deployment are separate operations; a release page alone proves none of them.

## Publish rewritten history
{: #publish-normalized-history}

Ship first checks the intended destination against the local result. If you already pushed independently and the remote matches, it reports publication satisfied without another push or retrospective approval. That observation does not certify how the earlier rewrite was performed.

For a normalize run, ship verifies [the recovery evidence](../normalize.html#your-result-and-later-publication), including the approved correspondence and preserved refs, then offers **Publish rewritten history / Cancel**. The review lists the affected branches and force-push effects above those choices. Cancel preserves local work and recovery evidence. A PR cannot replace already-published commit identities.

If you rewrote history manually or the original proof is unavailable, the existing publication review offers **Publish replacement history / Leave local**. It shows the exact current remote and intended local commits, the changes being replaced, known effects and any remaining uncertainty. Your approval covers both the backup and that replacement; no additional risk-acknowledgement question follows.

After approval, ship preserves the selected remote histories in a private bundle under `Agent Helm/ship/<run-id>/` in your home folder and verifies recovery in an empty repository. Any necessary object retrieval stays in an isolated repository, leaving your working refs alone. If retrieval exposes material effects outside the reviewed plan, that changed decision needs review before publication. Backup failure, changed remote expectations and required-check/protection failures still stop the push.

A separately approved push uses fixed force-with-lease expectations. If the remote moved, the old approval is not a reason to overwrite unseen work. Other clone owners receive synchronization guidance; the private recovery material is retained. The fallback backup protects the remote snapshot being replaced, while the original rewrite remains unverified. Release analysis still needs independently established boundaries; successful source publication does not invent that missing proof.

Once every affected history branch and all selected publication/release work have been verified complete, Ship automatically keeps three completed backups total for this clone, counting Normalize recovery bundles and fallback remote-history backups together. It removes eligible older folders and their matching local pointers/checksums, without another approval question. Fallback pointers support continuation and retention without becoming Normalize proof. Unpublished, failed, partial or release-PR-pending runs do not qualify. A later cycle starts from actual published history and needs earlier correspondence only when a remote or preserved release boundary still depends on it.

Required older proof remains protected beyond the three-cycle target. Unknown legacy records, stronger preservation policy, unsafe paths or files added/changed after completion prevent cleanup. The final result reports removed backups and space recovered, or explains skipped/incomplete retention. A cleanup failure preserves actual remaining evidence and does not undo verified publication; it does not trigger a blind retry. No real backups are deleted merely by installing a source update.

## Publish an archive backup

For a prepared [archive](../archive.html), you approve an existing private destination. Ship verifies the payload backup before committing and publishing its completion receipt. The local payload and the receipt are distinct evidence of progress.

Cleanup and a later portable copy are optional, separately reviewed actions. A Git bundle alone does not contain external data, container images or LFS object bytes. This route ends without ordinary branch targets or release tags.

## Hosting support and your result

GitHub and GitLab have dedicated review-request and release support. Other hosts use Git with manual provider handoffs where needed.

The report separates published source, target updates, PR/MR status, release status and unresolved checks. It reads back actual results and preserves completed work after interruptions. Only missing permission or material changes to the approved action need another review. Published source is not proof of integration or a successful deployment.

## Explore the source

For implementation details, read [guides/ship.md](https://github.com/myowinthein/agent-helm/blob/main/guides/ship.md), [target updates](https://github.com/myowinthein/agent-helm/blob/main/prompts/ship/targets.md), the [release procedure](https://github.com/myowinthein/agent-helm/blob/main/prompts/ship/release.md), [history publication](https://github.com/myowinthein/agent-helm/blob/main/prompts/shared/history-publication.md) and [CI checks](https://github.com/myowinthein/agent-helm/blob/main/prompts/shared/ci.md).
