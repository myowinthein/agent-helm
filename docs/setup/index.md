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
| Installation identifier | `helm@agent-helm` | Plugin and marketplace names used together in terminal commands. |

## Start using Helm in a project

Open or connect your project folder, then:

1. Run [log](../commands/log.html) to create or update shared project instructions in `AGENTS.md`, with `CLAUDE.md` pointing to them.
2. Run [adopt](../commands/adopt.html) if you want to add the shared Git, safety and writing rules to that project.

Installing the plugin makes its commands available; it does not set up project instructions or install project rules automatically. Once the shared instructions are connected, you can switch between Claude and Codex without repeating setup. Removing the plugin leaves project files and adopted rules in place.

Python 3.11+ is preferred for recorded test/refactor work, but it is optional. See [Python ledger helpers](python-helpers.html) for requirements and fallback options. Desktop sessions also need access to the Git checkout and local tools required by the selected work.

If your project used an older Helm version, read the [upgrade guide](upgrading.html) before running the current commands.

## More help

- [Project instructions and compatibility](compatibility.html)
- [Git and CI behaviour](git-and-ci.html)
- [Scan investigation and coverage](investigation.html)
- [Documentation site maintenance](documentation-site.html)
