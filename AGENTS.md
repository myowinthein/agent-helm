# claude-helm

Project instructions and Helm configuration live in [CLAUDE.md](CLAUDE.md). Read and follow that file before project work; it remains the single memory owner. Do not duplicate or migrate its configuration here.

Read and follow [rules/git.md](rules/git.md) and [rules/safety.md](rules/safety.md). Do not inspect or edit `.claude/helm/*-log.json` during feature work; these are operational ledgers, not source.

When consulting Claude for a review or discussion, use `claude --model claude-opus-5-5 --effort high`, verify the returned model metadata, and do not substitute a model or effort without the user's approval.
