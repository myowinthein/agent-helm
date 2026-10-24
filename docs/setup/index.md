---
title: Setup
nav_order: 4
has_children: true
permalink: /docs/setup/
---

# Setup

Agent Helm packages the same ten workflows for Claude and Codex. The repository and marketplace are named `agent-helm`; the plugin remains `helm`.

## Install

| Client | Install guide | Invoke a workflow |
|---|---|---|
| Claude Code | [Terminal](claude-terminal.html) | `/helm:ship`, `/helm:log`, and the other existing names |
| Claude Cowork | [Desktop](claude-desktop.html) | Select the Helm command from the `/` picker |
| Codex CLI | [Terminal](codex-terminal.html) | Open the `$` skill picker and select the Helm workflow |
| Codex desktop | [Desktop](codex-desktop.html) | Select a Helm skill from the skill picker |

Start a fresh session after installing or updating. Existing conversations can retain older workflow instructions. All ten workflow names and descriptions are shared, but tool access depends on the host.

Read [Compatibility and project instructions](compatibility.html) before adopting rules or using the same project from both hosts. Plugin installation makes workflows available; rule adoption is a separate project setup step.

Normal recorded refactor/test paths prefer the shared Python 3.11+ read-only ledger helper. When Python/execution is unavailable, offer Set up Python / Continue without Python / Stop once per run; approved available equivalent tools must satisfy the same full validation, retrieval and preservation checks. Without them, dependent work stays pending. Source-only Audit/Plan needs no Python or ledger access. See [Python ledger helpers](python-helpers.html) for fallback, bounds and failure handling; Helm never installs the runtime automatically.

For an existing installation under the old name, see [Renaming an existing installation](compatibility.html#renaming-an-existing-installation).

See [Scan investigation and coverage](investigation.html) for Full scan / Gap scan names, command-specific depth, evidence-based exclusions and read-only worker limits.

See [breaking changes and one-time upgrade](upgrading.html) before using current workflows in an older project.

For site contributors, see [documentation site maintenance](documentation-site.html) for Jekyll preview, GitHub Pages Actions deployment and the theme switcher.
