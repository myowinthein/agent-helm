---
title: Git
parent: Rules
nav_order: 1
---

# Git

Keep local changes, commits and publication consistent across Claude and Codex. Install it with [Safety](safety.html) through [adopt](../commands/adopt.html); Helm commands already load both.

## Configuration owner

Shared settings normally live in `AGENTS.md`, imported by `CLAUDE.md`. Actual imports, nested instructions and overrides determine the effective policy. Conflicts block dependent actions.

New Project Config sections use Markdown bullets. Existing plain or recognized fenced declarations remain supported.

| Setting | Default | Purpose |
|---|---|---|
| `ship-method` | `pr` | Push directly or create/reuse PR/MR handoffs through ship. |
| `git-auto-commit` | `false` | Allow completed local commits without another question when true. |
| `git-merge-strategy` | `squash` | Use squash, merge or rebase of reviewed private, unpushed work for integration. |

Defaults apply only to absent settings. Choices are independent of team size. [Log](../commands/log.html) handles shared setup and layout reconciliation.

## Local work

Local edits stay on the current permitted branch. Each [command](../commands) keeps its own preparation requirements and finishes locally.

Requested edits may include uncommitted files. The agent preserves unrelated work rather than resetting, stashing or cleaning it away. Static inspection does not authorize executing project code or opening operational records.

## Auto-commit

With auto-commit off or absent, the agent asks before committing. With it on, completed coherent work can be committed after required checks, honoring explicit deferral. The agent reviews the full content and index, staging only intended paths and hunks.

Public legal-document commits always need exact content and commit approval. Auto-commit never approves publication.

## Conventional Commits

Based on [Conventional Commits 1.0.0](https://www.conventionalcommits.org/en/v1.0.0/), with project or user policy taking precedence over Helm defaults.

```text
fix(payment): handle expired cards
feat(auth)!: replace sessions with JWT
```

Helm requires a lowercase module or domain scope; the external specification makes scope optional. Prefer one dominant area, short comma-separated scopes for inseparable changes, or `project`/`core` for broad work.

Bodies and footers are optional, separated by blank lines. Mark breaking changes with `!`, an uppercase `BREAKING CHANGE:` footer, or both. With `!`, explain the break in the description.

Use `feat` for features and `fix` for bugs. Helm also uses `refactor`, `revert`, `test`, `docs`, `chore`, `style`, `perf`, `ci` and `build`. [Ship](../commands/ship.html#optional-versioned-release) interprets complete messages when proposing releases. Loading rules never authorizes rewriting history.

## Quality checks

The agent uses configured checks for changed code and affected consumers, formatting before final verification. Shared changes require the full suite unless another plan is explicitly authorized.

Results distinguish passed, failed, unavailable, unconfigured and deferred checks. Required failures block publication; required CI and reviews must match the intended commit. No automatic unrelated repairs or tool installs follow.

## Publication

[Ship](../commands/ship.html) handles reviewed pushes, optional independent target updates and separately approved releases on ready main/master. Every push needs concrete authorization for its destination, source, refs and effects, including deployment triggers.

Publication uses bounded refs and verified readback, preserving branches by default. Normalized history uses recovery evidence and fixed force-with-lease expectations. Archives use a separate private backup procedure. Permanent base/environment branches and public published tags remain protected.
