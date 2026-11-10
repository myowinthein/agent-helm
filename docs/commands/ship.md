---
title: ship
description: Publish reviewed changes, select independent branch updates and approve releases through separate checks and concrete publication decisions.
parent: Commands
detailed: /docs/commands/ship/detailed.html
nav_order: 9
---

# ship

{% include guide-depth.html %}

Use ship when reviewed work is ready to publish. It checks the source and destination, asks for concrete approval and reports what was actually published. Branch updates and releases are separate choices.

## Flow

Ordinary source publication follows this outline. History rewrites and private archive backups use the dedicated routes below.

```mermaid
flowchart TD
  Review["Review changes and destination"] --> Approve{"Approve publication?"}
  Approve -->|Yes| Publish["Publish source or open a PR"]
  Approve -->|Not now| Keep["Keep work local"]
  Publish --> Next["Optional targets or release"]
```

## Start the command

```text
Codex → $ship    Claude → /ship
```

Use your client's [command prefix]({{ '/docs/setup/' | relative_url }}#run-a-command). Start on **main/master, an established feature or a confirmed environment branch**. Commit pending edits first; on main/master, ship can offer a reviewed safe commit.

A fresh session is useful for a long-running chat, but ship still discovers pending work and verifies the source.

## Publish the current branch

[`ship-method`](../rules/git.html#configuration-owner) selects the approach:

- **direct:** publish the reviewed current branch.
- **pr:** publish source and create or reuse review handoffs. Main and environment work use a separate `ship/*` source; features use their own branch.

The default is `pr`. Each push needs concrete approval covering its destination, content and effects. Required checks and protection still apply. Already-published work needs no duplicate push.

Ship does not wait for reviews, merge PRs or delete branches. New pushes update open PRs sharing that source; an already merged PR needs a new handoff for later changes.

## Optional branch updates

| Starting branch | Optional targets |
|---|---|
| main/master | Confirmed environments. |
| Feature | main/master and environments. |
| Environment | main/master and other environments. |

Choose targets or finish without them. Direct shipping integrates, checks and pushes each target; PR shipping creates independent review handoffs from the same source. There is no automatic main-first chain. You can also request updates from a specific published base or release.

## Optional versioned release

A release requires ship to start on **main/master with ready integrated work**. An open code PR must be merged independently before rerunning.

Review the version, tag, metadata, notes and checks in a separate release decision. Proposals follow [Semantic Versioning](https://semver.org/spec/v2.0.0.html) and actual compatibility changes; 0.x, initial and prerelease versions need an explicit suitable choice.

Skipping a release keeps published source intact. If metadata needs a PR, tagging waits for integration. Published tags and versions stay immutable. Package publication, asset uploads and deployment are separate work.

## Publish normalized history

Ship finds and verifies [normalize's recovery evidence](normalize.html#your-result-and-later-publication), including across sessions in the same clone. Ambiguous or missing evidence needs reconciliation rather than a guessed backup.

Publication uses fixed `--force-with-lease` expectations and separate approval. A PR cannot replace published commit IDs. Other clone owners receive sync guidance; existing tags stay fixed, and rewording released history alone creates no release.

## Publish an archive backup

For a prepared [archive](archive.html), approve an existing private destination. Ship verifies the payload backup, then commits and publishes its completion receipt. Cleanup and portable copies are optional, separately reviewed work.

This route ends without ordinary branch targets or release tags.

## Hosting support and your result

GitHub and GitLab have dedicated PR/MR and release support. Other hosts use Git and manual provider handoffs where needed.

The result separates source publication, branch updates, PRs, releases and pending checks. Partial success is preserved and interrupted work is checked before retrying. Publication alone does not prove integration or deployment.
