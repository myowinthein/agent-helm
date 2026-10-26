---
title: archive
parent: Commands
nav_order: 10
has_children: true
has_toc: false
---

# archive

Preserve an old project so its source, setup and useful recovery materials remain understandable. Archive helps restore the selected project, freeze a suitable setup and prepare a local payload for later private backup through ship.

## Start the command

```text
archive
```

Use the prefix for your app or terminal from [Setup]({{ '/docs/setup/' | relative_url }}#run-a-command).

Start on the attached branch containing the project you want to preserve. Archive shows its branch, commit and excluded work, then asks you to confirm it before a pending phase begins. It does not switch branches or merge missing work for you.

## Flow

```mermaid
flowchart TD
  Start(["Start archive"]) --> Progress["Validate existing progress<br/>and the current source"]
  Progress --> Done{"Already prepared<br/>or completed?"}
  Done -->|Verified| Existing(["Report the existing result"])
  Done -->|No| Branch["Confirm the source branch<br/>and preservation scope"]
  Branch --> Explore["1. Explore the project"]
  Explore --> Restore["2. Restore and freeze<br/>the selected setup"]
  Restore --> API["3. Preserve useful API materials"]
  API --> Docs["4. Prepare recovery documentation"]
  Docs --> Payload["5. Review and commit<br/>the local archive payload"]
  Payload --> End(["Prepared locally;<br/>use ship later for private backup"])
```

Each phase presents a report for approval before advancing. Execution, data operations and the final payload commit also need their concrete action approvals; a report or saved cursor alone does not authorize them.

## The five steps

- [Step 1: Explore](archive/1-explore.html): inventory the project, dependencies, data and preservation gaps without executing it.
- [Step 2: Restore and freeze](archive/2-restore-and-freeze.html): agree a safe restoration, inspect its actual result, then capture a suitable runtime and data setup.
- [Step 3: Postman collection](archive/3-postman.html): retain, repair or create useful API recovery files when the project owns an API.
- [Step 4: Documentation](archive/4-documentation.html): make the recovery entry point, ordered setup and artifact inventory useful to a future developer.
- [Step 5: Prepare locally](archive/5-finalize.html): review storage, supplementary assets and the exact local payload, then commit it after approval.

The preservation goal can be source only, a useful runnable demonstration, offline runtime recovery or additional offline rebuild inputs. These need different evidence. A version list, saved image or currently running app does not prove every future recovery goal.

## Output files

Only useful applicable outputs are created. Existing recovery files can stay at their approved paths.

| Output | Purpose |
|---|---|
| `.helm/archive/state.json` and `files.json` | Persistent progress and file inventory for agent resume and payload verification. |
| Five `.helm/archive/step*.md` reports | Approved phase evidence for later review, not the startup manual. |
| Archive index, normally `README.md` | Human entry point explaining the snapshot, recovery route and limitations. |
| `docs/setup.md` | Ordered recovery, data, run/demo and stop instructions. |
| `docs/archive-metadata.md` | Human-readable artifact identities, checksums, provenance, storage and verification. |
| Selected `recovery/` outputs | Useful image exports, API collections, data or supplementary materials when existing paths do not already serve them. |

New free-form names use lowercase kebab case, while conventional names and native format suffixes stay intact. Empty companion files and duplicate copies are not created just to fill a layout.

## Returning to an existing archive

Run archive again to validate saved progress and continue the next incomplete local phase. The command checks source identity, reports and output fingerprints before reusing them; unexplained changes need reconciliation.

A proven prepared payload is reported without replacing files, recommitting or restoring the project again. A completed backup is also preserved; unavailable remote proof is reported as unverified rather than treated as permission to restart. Unsupported bundles block this archive route and remain intact.

Progress and reports remain under `.helm/archive/` after completion. Other commands' ledgers, instruction files, adopted rules and recovery assets are protected from blanket consolidation or cleanup.

## Your result

Archive finishes on the same branch with the actual local payload commit or pending drafts, recovery instructions and known limitations. Deferred checks remain unverified, and partial preservation is labelled accordingly.

It does not push, create PRs or clean up remote refs. When ready, run [ship](ship.html#publish-an-archive-backup) to select and verify a private backup destination, publish the payload and record its completion receipt. That is a separate approval from local preparation.
