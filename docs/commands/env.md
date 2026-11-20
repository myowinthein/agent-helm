---
title: Env
description: Review environment configuration, credible secret exposure and Git ignore rules, then choose scoped fixes or a safe environment template.
parent: Commands
detailed: /docs/commands/env/detailed.html
nav_order: 3
---

# Env

{% include guide-depth.html %}

Use env when environment settings or Git ignore rules have become hard to trust. It checks how configuration is used, reports problems and lets you choose fixes or a safe template.

## Flow

```mermaid
flowchart TD
  Gate{"Ready for the requested route?"} -->|No| Stop["Report the blocker and stop"]
  Gate -->|Yes| Audit
  Audit["Review configuration and ignore rules"] --> Plan["Review fixes or a template"]
  Plan --> Approve{"Apply the shown plan?"}
  Approve -->|Yes| Apply["Apply and verify selected changes"]
  Approve -->|Not now| Report["Keep findings for follow-up"]
```

## Start the command

```text
Codex → $env    Claude → /env
```

Use your client's [command prefix]({{ '/docs/setup/' | relative_url }}#run-a-command). Normal env starts on a clean, eligible **main/master, feature or confirmed environment branch**, checked before the audit. An explicitly requested read-only audit can inspect pending edits.

If a prerequisite is missing or safe inspection cannot be completed, env reports the blocker and stops. Findings already collected remain available. Resolve the blocker and rerun env for further checks or fixes.

## What gets checked

| Area | Typical questions |
|---|---|
| Configuration use | Which keys are required, missing or apparently unused? |
| Values and syntax | Are there credible exposures, hardcoded settings or loader-specific problems? |
| Git protection | Are private files protected, or are ignore rules hiding files the project needs? |

The audit follows actual services and configuration layers. An override need not repeat every baseline key, and externally supplied settings need not appear in an `.env` file. Existing safe templates are also checked for stale, duplicated or misleading guidance. The report shows numbered issues with short explanations and readable diffs, rather than a checklist of passed checks. Paths, key names and uncertainty remain visible without exposing values.

## Choose the fixes

Review the proposed environment and `.gitignore` fixes, then choose **Apply recommended**, **Apply all proposed fixes** or **Skip**. Each apply choice lists its issue numbers; when recommended includes every ready fix, only Apply all proposed fixes is shown. You can type a subset such as `1–3, 6` or request a revision without a separate menu option.

Recommendations weigh the issue's current or conditional impact, expected benefit and tradeoffs in this project. Short- and long-term effects matter when they differ; an important issue can still need a decision before its fix is ready. Large reports use a compact index and detailed batches, with approval covering only the fixes shown for that review.

A separate scope question is needed only when the plan depends on your answer. Source/templates, local-only work and external setup stay distinct; templates use placeholders and edits preserve configuration meaning. Skip makes no changes for the current review and preserves any earlier verified work.

Template cleanup is proposed before editing and preserves useful comments and safe defaults. A missing source reference alone does not prove a key can be removed; optional wording improvements stay separate from runtime and secret findings.

**Untracking needs separate approval.** It keeps the local file, but other clean copies may disappear when collaborators update. Moving or untracking a secret does not revoke it or erase its history.

## Your result

You get verified changes and remaining follow-up. Operational env contents are never staged; tracked or managed env files remain report-only. Approved ignored, untracked env edits stay local.

The audit does not start the app or contact services. Static checks cannot prove credentials work or a deployment is ready. Work finishes on the same branch; use [ship](ship.html) separately to publish source changes.
