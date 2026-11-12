---
title: Git
description: Guide agent work with project Git settings, scoped commits, quality checks and separately approved publication while preserving unrelated changes.
parent: Rules
detailed: /docs/rules/git/detailed.html
nav_order: 1
---

# Git

{% include guide-depth.html %}

Keep local work, commits and publication consistent across Claude and Codex. Install with [Safety](safety.html) through [adopt](../commands/adopt.html); Helm commands already load both.

## Configuration owner

Shared settings normally live in `AGENTS.md`, imported by `CLAUDE.md`. Actual imports, nested instructions and overrides determine the policy. Conflicts block dependent actions; [log’s shared setup](../commands/log.html#shared-project-instructions) handles reconciliation.

| Setting | Default | What it controls |
|---|---|---|
| `ship-method` | `pr` | Direct pushes or PR/MR handoffs. |
| `git-auto-commit` | `false` | Whether completed local work can be committed without another question. |
| `git-merge-strategy` | `squash` | Squash, merge or rebase of reviewed private, unpushed work. |

Defaults apply only when a setting is absent. Team size does not select a mode. New configuration uses Markdown bullets; supported existing formats are preserved.

## Local work

Edits stay on the current permitted branch, subject to each command’s preparation requirements. The agent preserves unrelated changes, including staged work, without automatic resets, stashes or cleanup. Static inspection does not authorize code execution or access to operational records.

## Auto-commit

When enabled, completed coherent work can be committed after required checks unless you defer it. Otherwise the agent asks. It reviews the content and index, then stages only intended paths and hunks.

Public legal-document commits still need exact content and commit approval. **Auto-commit never approves publication.** New commits name the committing agent in a `Co-authored-by` trailer.

## Conventional Commits

Helm uses scoped messages, with project or user policy taking precedence:

```text
fix(payment): handle expired cards
feat(auth)!: replace sessions with JWT
```

Use `feat` for features, `fix` for bugs and suitable types such as `docs`, `test` or `refactor` for other work. Helm requires a lowercase module/domain scope; [Conventional Commits 1.0.0](https://www.conventionalcommits.org/en/v1.0.0/) makes scope optional. Mark breaking changes with `!`, a `BREAKING CHANGE:` footer or both, and explain the break.

## Quality checks

Use configured checks for changed code and affected consumers. Shared changes require the full suite unless another plan is explicitly authorized. Report passed, failed, unavailable and deferred checks accurately. Required checks and reviews must match the intended commit; failures block publication.

## Publication

[Ship](../commands/ship.html) handles reviewed pushes, optional target updates and separately approved releases on ready, integrated main/master. Each push needs concrete authorization for its destination, source, refs and effects, including deployment triggers.

Results are read back before claiming success. Branches stay intact by default; base/environment branches and public published tags remain protected. Normalized history and private archive backups follow ship’s specialist procedures. Without original rewrite proof, ship can instead review an explicit [history replacement](../commands/ship.html#publish-normalized-history), backed by a verified copy of the current remote history and fixed leases.
