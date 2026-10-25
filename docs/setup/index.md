---
title: Setup
nav_order: 4
has_children: true
permalink: /docs/setup/
---

# Setup

Agent Helm works with Claude and Codex. For either platform, you can install, update and uninstall the plugin through the desktop app or terminal.

Choose [Claude](claude.html) or [Codex](codex.html), then use the **Desktop app** or **Terminal** tab. Desktop menus can vary by app version and operating system. The terminal examples use a Bash-compatible shell with `grep` available.

## Run a command

Start a fresh session in your project after installing or updating. Type the prefix in the chat input, then select a Helm command.

| Client | Prefix |
|---|---|
| Claude desktop and terminal | `/` |
| Codex terminal | `$` |
| Codex desktop | `/` or `$` |

For example, select `log`, `test` or `ship`. In Claude Code, you can also type the full command, such as `/helm:log`. In Codex, choose the Helm skill from the picker to distinguish it from similarly named built-in actions.

## Plugin names

The guides use these names to identify the source, marketplace and plugin.

| Name | Value | Purpose |
|---|---|---|
| Repository | `myowinthein/agent-helm` | GitHub source used to add the marketplace. |
| Marketplace | `agent-helm` | Catalog containing the plugin. |
| Plugin | `helm` | Package containing the ten workflows. |
