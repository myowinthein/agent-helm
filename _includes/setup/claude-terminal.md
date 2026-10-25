## Install

```bash
claude plugin marketplace add myowinthein/agent-helm
claude plugin install helm@agent-helm --scope user
claude plugin list --json | grep -F -A3 '"id": "helm@agent-helm"'
```

Start a fresh Claude session in your project folder. Type `/` and select a Helm workflow, such as `log`, `test` or `ship`.

## Update

```bash
claude plugin marketplace update agent-helm
claude plugin update helm@agent-helm --scope user
claude plugin list --json | grep -F -A3 '"id": "helm@agent-helm"'
```

Check the installed version and enabled state, then start a fresh session.

## Uninstall

```bash
claude plugin uninstall helm@agent-helm --scope user --keep-data
claude plugin list --json | grep -F -A3 '"id": "helm@agent-helm"'
```

Check that the CLI-managed entry is gone. In a fresh session, its workflows should no longer appear unless an account-synced copy is also installed.
