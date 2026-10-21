---
title: Rules
nav_order: 3
has_children: true
permalink: /docs/rules
---

# Rules

Rule files installed into projects via [`/helm:adopt`](commands/adopt.html). They govern git workflow and operational safety for both Claude and Codex across projects that use Helm.

## Rule files

- [`git.md`](rules/git.html): git workflow rules: Solo Mode, GitHub Flow, branch naming, Auto-Commit, Conventional Commits, code quality gates, deployment triggers, and environment branch promotion. Activate features in the resolved project-memory owner's configuration (`git-strategy: solo`, `git-auto-commit: true`, `git-merge-strategy: squash`). Shared setup uses `AGENTS.md`, which `CLAUDE.md` imports for Claude; existing legacy owners remain supported.
- [`safety.md`](rules/safety.html): operational safety rules: what to scan on bootstrap, what never to touch without explicit confirmation, and the minimum evidence checklist for risky operations.
