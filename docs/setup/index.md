---
title: Setup
nav_order: 4
has_children: true
permalink: /docs/setup/
---

# Setup

Agent Helm packages the same ten workflows for Claude and Codex. The repository and marketplace are named `agent-helm`; the plugin remains `helm`.

| Client | Install guide | Invoke a workflow |
|---|---|---|
| Claude Code | [Terminal](claude-terminal.html) | `/helm:ship`, `/helm:log`, and the other existing names |
| Claude Cowork | [Desktop](claude-desktop.html) | Select the Helm command from the `/` picker |
| Codex CLI | [Terminal](codex-terminal.html) | Open the `$` skill picker and select the Helm workflow |
| Codex desktop | [Desktop](codex-desktop.html) | Select a Helm skill from the skill picker |

Start a fresh session after installing or updating. Existing conversations can retain older workflow instructions. All ten workflow names and descriptions are shared, but tool access depends on the host.

Read [Compatibility and project instructions](compatibility.html) before adopting rules or using the same project from both hosts. Plugin installation makes workflows available; rule adoption is a separate project setup step.

For an existing installation under the old name, see [Renaming an existing installation](compatibility.html#renaming-an-existing-installation).
