## Install

```bash
codex plugin marketplace add myowinthein/agent-helm
codex plugin add helm@agent-helm
codex plugin list --marketplace agent-helm
```

Start a fresh Codex session in your project folder. Type `$` and select a Helm workflow, such as `log`, `test` or `ship`.

## Update

```bash
codex plugin marketplace upgrade agent-helm
codex plugin add helm@agent-helm
codex plugin list --marketplace agent-helm
```

Check the installed version and enabled state, then start a fresh session.

## Uninstall

```bash
codex plugin remove helm@agent-helm
codex plugin list --marketplace agent-helm
```

Check that Helm is absent from the installed list. In a fresh session, its workflows should no longer appear. An older chat may retain loaded instructions.
