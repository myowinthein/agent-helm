---
title: Codex desktop
parent: Setup
nav_order: 4
permalink: /docs/setup/codex-desktop.html
---

# Codex desktop

Open the desktop plugin directory, choose the action to add a marketplace, and enter `myowinthein/agent-helm`. Find `helm` in that marketplace and install it. Check the installed version and that all ten skills are enabled.

Start a fresh task in the consumer project. Open the skill picker and select the Helm workflow you want. Picker labels and plugin-directory navigation can vary by desktop version. If the plugin does not appear, inspect the configured marketplace and installed state with the [terminal commands](codex-terminal.html).

Use the plugin directory's marketplace update action to refresh Helm, then reopen its details and start a fresh task. Uninstall through the installed plugin's menu. A previous task can retain already-loaded instructions even after uninstalling.

The optional `scripts/check_clients.rb` check verifies the marketplace reader and actual session catalog through a temporary Codex installation. These guides cover desktop and terminal use. OpenAI also documents plugin support in IDE extensions, but Helm has not been verified there. Native discovery checks do not verify desktop UI flows or complete workflow outcomes. See [OpenAI's plugin documentation](https://developers.openai.com/plugins/build/plugins).
