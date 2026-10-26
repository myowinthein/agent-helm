---
title: env
parent: Commands
nav_order: 3
---

# env

Review environment configuration and Git ignore rules as the project changes. Env finds mismatches, exposed secrets and misleading ignore rules, then lets you choose which fixes to apply.

## Start the command

```text
env
```

Use the prefix for your app or terminal from [Setup]({{ '/docs/setup/' | relative_url }}#run-a-command).

The initial audit can inspect the current checkout even with pending edits. Writes require a clean, eligible **main/master, feature or confirmed environment branch**. The command stays on that branch and preserves intentional environment differences.

## Flow

```mermaid
flowchart TD
  Start(["Start env"]) --> Audit["Inspect configuration usage,<br/>env files and Git ignore rules"]
  Audit --> Findings{"Actionable findings or<br/>a requested template?"}
  Findings -->|No| Report(["Report the scoped audit"])
  Findings -->|Yes| Select["Choose Env files,<br/>.gitignore or both"]
  Select --> Plan["Review exact fixes,<br/>local-only work and dependencies"]
  Plan --> Choice{"Apply the plan?"}
  Choice -->|Revise| Plan
  Choice -->|Skip| Finish(["Finish locally"])
  Choice -->|All or selected changes| Apply["Apply approved changes<br/>and verify their effects"]
  Apply --> Finish
```

## What gets checked

The audit follows the project's actual services, loaders and configuration layers. An environment override does not need every key from its baseline, and externally supplied configuration does not automatically need an `.env` file.

| Area | Checks |
|---|---|
| Files and usage | Discover env files, compare related key sets, find source/configuration references and identify missing or apparently unused keys. |
| Values and syntax | Detect credible secret exposure, unfilled required inputs, hardcoded environment-dependent values and loader-specific formatting or duplicate problems. |
| Git protection | Find missing shared ignore protection, tracked files matching ignore rules, harmful patterns and provably redundant formatting. |

These cover eleven checks in total. Reports show file paths, key names, evidence and uncertainty, with existing values omitted. A key with no reference found is not automatically unused, and a tracked ignored file is not automatically wrong.

## Choose the fixes

You first choose the target area, then review one concrete plan. It separates committable source/template/ignore edits, local-only env work and manual or external provisioning. You can accept a subset, revise or skip; dependent changes stay together.

Optional template work can update an existing example or create an approved service-specific template such as `.env.example`. New placeholders are generated without copying real values. Formatting follows the actual loader; ignore fixes use Git's matching rules rather than sorting patterns for appearance.

Removing a file from tracking needs a separate exact-path confirmation. Its local copy remains, but the committed removal may delete clean copies in other checkouts when they update. Untracking or moving a secret does not remove it from history or revoke it.

## Your result

You get the audit findings, verified changes and remaining manual work. Credential-free source, approved templates and project `.gitignore` edits may be committed under your policy.

Real operational env contents are never staged. Eligible edits to existing ignored, untracked local env files stay local; tracked operational, encrypted or managed env files remain report-only.

Static checks verify key usage, syntax and ignore behavior. They do not prove credentials work or deployment values exist. The command neither starts the app nor contacts services merely to audit configuration.

Env creates no ledger and does not edit `AGENTS.md` or `CLAUDE.md`. It finishes on the same branch. Shared fixes made on an environment branch may need deliberate upstream application; ignored local env files are not synchronized by merging branches. Use [ship](ship.html) separately for publication.
