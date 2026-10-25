## Install

```bash
codex plugin marketplace add myowinthein/agent-helm
codex plugin add agent-helm@agent-helm-marketplace
codex plugin list --marketplace agent-helm-marketplace
```

Start a fresh Codex session in your project folder. Type `$` and select a Helm workflow, such as `log`, `test` or `ship`.

## Update

```bash
codex plugin marketplace upgrade agent-helm-marketplace
codex plugin add agent-helm@agent-helm-marketplace
codex plugin list --marketplace agent-helm-marketplace
```

Check the installed version and enabled state, then start a fresh session.

## Uninstall

```bash
codex plugin remove agent-helm@agent-helm-marketplace
codex plugin list --marketplace agent-helm-marketplace
```

Check that Helm is absent from the installed list. In a fresh session, its workflows should no longer appear. An older chat may retain loaded instructions.
