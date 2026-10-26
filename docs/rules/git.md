---
title: Git
parent: Rules
nav_order: 1
---

# Git

Gives Claude and Codex a consistent way to handle local changes, commits and publication. It keeps local work separate from shipping, protects unrelated changes and uses scoped Conventional Commits by default.

Use [adopt](../commands/adopt.html) to install it together with [Safety](safety.html) for everyday sessions. Helm commands already load the bundled rules during their runs.

## Configuration owner

In the shared layout, settings live in `AGENTS.md`, while `CLAUDE.md` imports it. The agent follows actual imports, nested instructions and applicable overrides rather than assuming every root file owns the settings. Conflicting or invalid settings block the actions that depend on them.

New `## Project Config` sections use one `- key: value` bullet per setting for readable Markdown. Existing plain declarations and recognized fenced configuration remain supported and keep their format. All three formats resolve the same settings and conflict checks.

| Setting | Default | Purpose |
|---|---|---|
| `ship-method` | `pr` | `direct` pushes reviewed work; `pr` creates or reuses PR/MR handoffs through ship. |
| `git-auto-commit` | `false` | `true` allows local commits of completed, coherent work without another question. |
| `git-merge-strategy` | `squash` | Chooses `squash`, `rebase` or `merge` for eligible ship integrations. Rebase is limited to reviewed private, unpushed work. |

These choices are independent of team size and branch layout. Defaults apply only when a setting is genuinely absent. Approved changes update the existing configuration block; [log](../commands/log.html) handles shared instruction setup and layout reconciliation.

## Local work

Ordinary editing stays on the current permitted branch. Helm editing commands finish locally; they do not switch to main, create a workflow branch or ask to publish. Each command keeps its own branch and preparation requirements. See the [Commands guides](../commands) for those limits.

Requested edits can include uncommitted or untracked files. The agent preserves unrelated work and never resets, stashes or cleans it away just to make progress. Read-only inspection does not authorize hooks, tests, builds or other execution. [Safety](safety.html#operational-helm-state) also keeps operational records outside ordinary source work.

## Auto-commit

With `git-auto-commit: false` or no setting, the agent asks before committing. With `true`, it can commit a completed unit after the required review and verification. An explicit commit deferral still applies; read-only, unchanged or incomplete work creates no automatic commit.

Before committing, the agent reviews the full changed content and index, then stages exact intended paths and hunks. Unrelated staged, unstaged and untracked changes stay out. If they cannot be separated safely, the commit remains pending.

Generated legal documents and their integration commits always need concrete content and commit approval. Auto-commit never approves a push, tag or release.

## Conventional Commits

Helm's default format is:

```text
type(scope): description
```

For example:

```text
fix(payment): handle expired cards
docs(setup): clarify installation steps
```

Common types include `feat`, `fix`, `refactor`, `test`, `docs`, `chore`, `style`, `perf`, `ci`, `build` and `revert`. Scope identifies the changed module or domain. Helm requires it, although the [Conventional Commits specification](https://www.conventionalcommits.org/en/v1.0.0/) makes it optional. Explicit project or user commit policy takes precedence.

Use `!` or a `BREAKING CHANGE:` / `BREAKING-CHANGE:` footer for breaking changes. [Ship](../commands/ship.html) uses complete messages when proposing a version; loading this rule does not rewrite existing history.

## Quality checks

The agent uses the project's configured formatting, lint, type and test checks for the changed code and affected consumers. Genuine shared changes require the full suite unless another coverage plan is explicitly authorized. Formatting happens before final verification and commit review.

Results distinguish passed, failed, unavailable, not configured and explicitly deferred checks. Required failures, including pre-existing failures, block publication. Deferred checks remain unverified and block gates that require them. Unrelated repairs or tool installations do not happen automatically.

Required CI and reviews must match the exact intended commit. Configured, applicable source CI must pass before promotion or its PR handoff; that does not prove the target merge or deployment will succeed. Project and provider protections remain binding.

## Publication

[Ship](../commands/ship.html) handles approved pushes or PRs, optional independent target updates and separately approved releases on ready main/master. It does not wait for later PR review or merge. Push and tag triggers may deploy code, so the agent checks actual configuration rather than inferring effects from branch names.

Publication requires a reviewed destination, source commit, refs and effects. Ordinary pushes use bounded refs without incidental tags. Results are read back before success is reported or a retry is attempted. No automatic branch cleanup follows.

Normalized histories use ship's separate verified procedure and fixed force-with-lease expectations; a PR cannot replace published commit IDs. Prepared archives use ship's private backup procedure. Neither route is an extra `ship-method` value. Permanent base/environment branches and published tags in public repositories are protected from deletion.
