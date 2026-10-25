---
title: Rules
nav_order: 3
has_children: true
permalink: /docs/rules
---

# Rules

Three rule files available through [`/agent-helm:adopt`](commands/adopt.html). They guide Git work, operational safety and clear writing for both Claude and Codex. Each approved rule has one shared local copy; AGENTS.md tells both agents to read it and CLAUDE.md imports the shared owner. Helm workflows also load the bundled rules through their shared runtime.

## Rule files

- [`git.md`](rules/git.html): local editing and independent ship-method direct/pr publication, auto-commit, merge policy, Conventional Commits, quality gates, deployment and environment fan-out. Configure ship-method, git-auto-commit and git-merge-strategy in the existing shared AGENTS.md owner (or recognized existing owner); CLAUDE.md imports shared instructions. Legacy git-strategy is compatibility-only.
- [`safety.md`](rules/safety.html): operational safety rules: what to scan on bootstrap, what never to touch without explicit confirmation, and the minimum evidence checklist for risky operations.
- [`writing.md`](rules/writing.html): clear, natural, approachable prose for native and non-native readers, preserving facts, warnings, technical meaning and project voice without filler, excessive formatting or routine em dashes.

New adoption proposes all three rules in the reviewed plan. Existing Git/safety installations remain valid without writing; adding it is a separate, initially unselected choice with the same custom-file and exact-content safeguards. Loading any rule starts no scan, bulk rewrite or approval loop. Plugin updates never silently change adopted copies.
