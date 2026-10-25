## Install

```bash
claude plugin marketplace add myowinthein/agent-helm
claude plugin install agent-helm@agent-helm-marketplace --scope user
claude plugin list --json | grep -F -A3 '"id": "agent-helm@agent-helm-marketplace"'
```

Start a fresh Claude session in your project folder. Type `/` and select a Helm workflow, such as `log`, `test` or `ship`.

## Update

```bash
claude plugin marketplace update agent-helm-marketplace
claude plugin update agent-helm@agent-helm-marketplace --scope user
claude plugin list --json | grep -F -A3 '"id": "agent-helm@agent-helm-marketplace"'
```

Check the installed version and enabled state, then start a fresh session.

## Uninstall

```bash
claude plugin uninstall agent-helm@agent-helm-marketplace --scope user --keep-data
claude plugin list --json | grep -F -A3 '"id": "agent-helm@agent-helm-marketplace"'
```

Check that the CLI-managed entry is gone. In a fresh session, its workflows should no longer appear unless an account-synced copy is also installed.
