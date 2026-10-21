---
title: Codex terminal
parent: Setup
nav_order: 3
permalink: /docs/setup/codex-terminal.html
---

# Codex CLI

Run in your terminal:

```bash
codex plugin marketplace add myowinthein/claude-helm
codex plugin add helm@claude-helm
codex plugin list --marketplace claude-helm
```

Start a fresh Codex session in the consumer project. Type `$` and select the Helm skill by name, such as `ship`, `log`, or `adopt`. Native Codex discovery namespaces these entries as `helm:<name>`. Use the picker to distinguish Helm's `archive` workflow from Codex's built-in session-archive command.

Helm's Codex skills require explicit invocation. Selecting a skill starts its workflow; it does not pre-approve a push, release, history rewrite, or other gated action.

To update:

```bash
codex plugin marketplace upgrade claude-helm
codex plugin add helm@claude-helm
codex plugin list --marketplace claude-helm
```

Check the installed version and enabled state, then start a fresh session. To remove:

```bash
codex plugin remove helm@claude-helm
```

Adopted rules and project ledgers remain in the project after removal. Read [Compatibility](compatibility.html) for the shared AGENTS.md owner, Claude adapter, and shared rule storage.
