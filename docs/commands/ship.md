---
title: ship
parent: Commands
nav_order: 9
---

# ship

Publish reviewed work, optionally update other branches and prepare a versioned release. Publication and release need separate approval.

## Start the command

```text
ship
```

Use the prefix for your app or terminal from [Setup]({{ '/docs/setup/' | relative_url }}#run-a-command).

Start on **main/master, an established feature or a confirmed environment branch**. Commit pending edits first; on main/master, ship can offer a reviewed safe commit.

## Flow

```mermaid
flowchart TD
  Start(["Start ship"]) --> Inspect["Review current work, remote state,<br/>existing PRs and release candidates"]
  Inspect --> Special{"Special publication<br/>handoff identified?"}
  Special -->|Archive| Backup["Approve and verify<br/>private archive backup"]
  Backup --> End(["Report verified results<br/>and any pending actions"])
  Special -->|Normalized history| History["Review private evidence;<br/>approve and verify history publication"]
  Special -->|Ordinary work| Source["Approve source publication<br/>or reuse a verified handoff"]
  History --> Targets["Optionally choose and approve<br/>independent branch updates"]
  Source --> Targets
  Targets --> Ready{"Started on main/master<br/>with a ready release?"}
  Ready -->|No or skip| End
  Ready -->|Yes| Release["Review version and notes;<br/>approve the release plan"]
  Release --> Result["Verify checks, then publish tag<br/>or hand off a metadata PR"]
  Result --> End
```

## Publish the current branch

`ship-method` selects **direct** or **pr**, defaulting to `pr`. Review the changes, destination, checks and deployment effects before publication.

| Starting branch | `direct` | `pr` |
|---|---|---|
| **main/master** | Push the reviewed tip. | Publish a `ship/*` source and open/reuse its PR into main/master. |
| **Feature** | Push the feature branch. | Push it; choose PR targets afterward. |
| **Environment** | Push the reviewed tip. | Publish a `ship/*` source and open/reuse its PR into that environment. |

Already-published work needs no duplicate push or empty PR. Protection and required checks still apply. Later source pushes update all open PRs using it; merged PRs need a new handoff for further changes.

## Optional branch updates

Choose independent targets or **None / Finish**:

| Starting branch | Optional targets |
|---|---|
| **main/master** | Confirmed environments. |
| **Feature** | main/master and environments. |
| **Environment** | main/master and other environments. |

`direct` integrates, checks and pushes each target using the permitted merge strategy, defaulting to squash. `pr` creates/reuses independent handoffs from the same source. Review each target's delta and effects; there is no automatic main-first chain.

Ship does not wait for reviews, merge PRs or delete branches. You may also request environment updates from a specific published base or release without publishing unrelated work.

## Optional versioned release

A release requires ship to **start on main/master** with ready integrated work. An open code PR must be merged independently before rerunning.

Version proposals follow [Semantic Versioning 2.0.0](https://semver.org/spec/v2.0.0.html) and actual public compatibility changes. For stable versions, compatible fixes suggest patch, compatible public additions or deprecations minor, and incompatible changes major. Initial versions, 0.x and prereleases need a suitable explicit choice.

Review the version, tag, metadata, notes, destination and checks. **Skip release** keeps published code intact. If metadata needs a PR, tagging waits for integration; rerun to continue the same candidate.

Required checks must pass. Published tags and versions stay immutable. Interrupted releases verify completed actions before resuming; no unreleased work or pending action means no new release.

Hosted release creation is optional after Git publication. Packages, assets and deployment are separate work.

## Publish normalized history

Ship automatically finds [normalize](normalize.html)'s local recovery pointers, including across terminal or agent sessions in the same clone. It matches and verifies the actual history before publication approval. Multiple rewrites retain separate evidence; ship never simply picks the newest backup. Missing, invalid or ambiguous required evidence prompts for a path or reconciliation. Another clone/machine needs the recovery files transferred.

Fixed remote expectations and `--force-with-lease` protect the agreed rewrite; a discovered pointer never approves a push, and a PR cannot replace commit IDs.

Existing tags stay fixed. Rewording released history alone does not create a product release.

## Publish an archive backup

For a prepared [archive](archive.html), approve an existing private destination. Ship verifies the payload backup, then commits and publishes its completion receipt. Cleanup is optional and separately reviewed.

This route ends without ordinary targets or release tags. Interrupted steps are checked before retrying.

## Hosting support and your result

GitHub and GitLab have dedicated PR/MR and release support. Other hosts use Git with manual provider handoffs where needed.

The report separates pushes, target updates, PRs, releases and pending checks. Blocked actions preserve earlier successes. Ship returns to the original branch when safe; publication alone does not prove deployment.
