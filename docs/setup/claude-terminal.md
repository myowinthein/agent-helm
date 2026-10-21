---
title: Claude terminal
parent: Setup
nav_order: 1
permalink: /docs/setup/claude-terminal.html
---

# Claude Code terminal

In Claude Code:

```text
/plugin marketplace add myowinthein/agent-helm
/plugin install helm@agent-helm
/reload-plugins
```

Start a fresh session in your project. Type `/helm:` and check that each of the ten workflows appears once. Existing command names are unchanged, including `/helm:adopt` and `/helm:log`.

To update:

```text
/plugin update helm@agent-helm
/reload-plugins
```

Start a fresh session and check the plugin version. If an older cache remains active, inspect the exact loaded path in `/plugin`. Refresh the complete matching package, including the manifest, skills, workflows, prompts, rules, and adapters. Copying only `commands/` no longer works because the adapters load other packaged files. Do not mix versions or guess the latest cache directory by its name.

To remove:

```text
/plugin uninstall helm@agent-helm
/reload-plugins
```

Removing the plugin does not remove adopted project rules or ledgers. Copy-mode rules remain self-contained. Existing reference-mode pointers require the marketplace checkout to remain available; switch to copies before removing that checkout if those projects should keep working.
