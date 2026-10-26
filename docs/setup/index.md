---
title: Setup
nav_order: 2
has_children: true
permalink: /docs/setup/
---

# Setup

Agent Helm works with Claude and Codex. For either platform, you can install, update and uninstall the plugin through the desktop app or terminal.

The desktop guides were tested on macOS. The steps should be similar on other supported operating systems, though menus and buttons may move as the apps are updated. The terminal examples use a Bash-compatible shell with `grep` available.

## Run a command

Type the prefix in the chat input, then select an Agent Helm command.

| Client | Prefix | Example |
|---|---|---|
| Claude desktop and terminal | `/` | `/agent-helm:log` |
| Codex desktop and terminal | `$` | `$log` |

Elsewhere, command names appear without prefixes, such as `log`. Bare command blocks identify workflows rather than copy-and-run examples. Use the prefix above in your client's chat input, not your shell.

## Plugin names

The guides use these names to identify the source, marketplace and plugin.

| Name | Value | Purpose |
|---|---|---|
| Repository | `myowinthein/agent-helm` | GitHub source used to add the marketplace. |
| Marketplace | `agent-helm-marketplace` | Catalog containing the plugin. |
| Plugin | `agent-helm` | Package containing the ten workflows. |
