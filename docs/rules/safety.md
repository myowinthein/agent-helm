---
title: safety.md
parent: Rules
nav_order: 2
---

# safety.md

The operational safety reference for a project. Defines which actions always need explicit confirmation, what to scan when bootstrapping a new project, and how to document risk categories so future agents read the same constraints.

Loaded as context so that any agent acting in the project respects the same operational guardrails. It is not a checklist to execute top to bottom: the safety scan runs only when triggered (see When to run a safety scan).

Resolve `{memory_file}`, the existing memory owner, using git.md before documenting findings. In shared setup this is AGENTS.md and CLAUDE.md imports it; preserve legacy owners, bridges and active override precedence. Safety findings belong in the owner, not a host adapter.

## Host capabilities

Copied rules keep these boundaries without Helm's runtime. Verify the selected consumer workspace and required tools/access before acting. Folder access in Claude, Cowork, Codex or a remote sandbox does not establish access to the user's local Git checkout, credentials, Docker, test environment or deployment provider.

Unavailable capabilities, denied permissions or required checks that cannot run stop the affected action and dependent steps. Preserve files/state, report actual completed and pending work, and never claim success or advance a checkpoint on failure.

Tool/sandbox permission is separate from workflow confirmation. If no confirmation UI is available, ask in conversation and wait for an explicit answer. Silence, a timeout, a default or missing tool is not consent. Reuse valid approval for the same concrete action; do not change client settings or credentials automatically to bypass a block.

## Operational Helm state

Configuration and knowledge remain in `{memory_file}`. Operational state lives under root `.helm/` on both hosts, with `.claude/helm/` and the known flat `.claude/{refactor-log,test-log,normalize-log,legal-manifest}.json` paths retained as legacy locations. `.claude/rules/` is shared rule storage, not state to move.

Exclude operational records from ordinary source/safety scans, feature edits and unrelated staging. Loading rules or switching agents never authorizes opening, rewriting, deleting, resetting, merging or migrating those records. Only an explicitly invoked owning Helm workflow may access/update its own filename:

| Workflow | State filename |
|---|---|
| refactor | `refactor-log.json` |
| test | `test-log.json` |
| normalize | `normalize-log.json` |
| legal | `legal-manifest.json` |

Other commands trigger no migration. Archive may preserve state as opaque project files under its own authorized workflow, without interpreting/migrating it.

The owner must load its packaged project-state procedure, validate all candidate locations for its filename, reconcile differing histories explicitly, and migrate only at its eligible authorized write. Verified canonical output and tracked same-file removals belong in one authorized commit. Never automatically prefer a path, dual-write, migrate all commands together or ignore the whole `.helm/` directory. Incomplete/failed migration preserves other commands' state and remaining legacy sources. Without the workflow/procedure available, leave state untouched and report the capability gap; copied rules do not authorize an improvised migration. Resume sequentially across hosts, without concurrent writers.

## Agent Execution Boundaries

These actions always require explicit confirmation, regardless of context or autonomy level:

- `git push`, force-push, tag creation.
- Publishing packages or cutting public releases (`npm publish`, registry uploads, `gh release create`).
- Committing public, legally-binding documents (privacy policy, terms of service, and similar).
- Any deployment command.
- Migrations, seeders, database imports, database resets.
- Infrastructure changes, DNS changes, secret rotation.
- Destructive operations: resets, drops, clears, environment recreation.

A user-invoked command that confirms these actions within its own flow (e.g. `/helm:ship` confirming the version, deploy targets, and release; `/helm:legal` confirming before committing generated documents) satisfies this boundary; do not add a separate prompt on top.

Projects can extend the list, never shrink it. Document any project-specific additions.

## When to run a safety scan

Run at project bootstrap, and re-run whenever the operational risk surface changes: when anything in the Scan Targets or Risk Categories below is added, removed, or reconfigured (e.g. a new production remote, a new background job, a new credential location).

`/helm:log` Full scan mode may surface and propose safety findings for `{memory_file}`'s Hard Safety Rules section, but it does not run this scan or write `.claude/rules` automatically: findings are proposed, never auto-written.

Only document risks supported by evidence in the repository. No assumptions, no speculation.

**Output:** Documented findings (the Risk/Instruction pairs, environment classifications, and any project-specific boundary additions) go into `{memory_file}`'s `## Hard Safety Rules` section as the project's concrete never-do list. Propose the findings first and write them only on confirmation; never auto-write a safety rule without review. They belong in `## Hard Safety Rules` (written by `/helm:log`, loaded through the owner), not the `## Rules` entries managed by adopt. Adopt patches only approved exact Helm pointers while preserving custom entries, unrelated instructions and Skip decisions; it does not replace the whole section every run. Project-specific findings also stay out of the shipped rules, whose approved managed copies adopt can overwrite on update.

## Scan Targets

Bootstrap scan looks at:

- `AGENTS.md`, `CLAUDE.md`, active instruction overrides, `.claude/rules`, README files, project documentation.
- CI/CD pipelines (GitHub Actions, GitLab CI), deployment scripts.
- Composer scripts, package scripts, Makefiles, shell scripts.
- Docker, Dev Containers, Podman, Lando, Laravel Sail configuration.
- Git remotes, branch structure, protected branches.
- `.env.example`, credential files, service account files, private keys.
- Database migrations, seeders, and data/repair scripts.
- Destructive scripts (reset, drop, wipe, restore commands).
- Queue config, scheduler config, background job definitions.
- Deployment platforms (Fly.io, Railway, Render, Heroku, or similar).
- Cloud/infrastructure config (AWS, GCP, Azure, DO, Cloudflare, Supabase, Vercel, Neon, Elasticsearch, Redis, etc.).

## Risk Categories

These are the lenses for documenting what the Scan Targets above surface: one per operational domain.

For each category, scan for evidence and document findings as a pair:

```
Risk: one-line description
Instruction: direct rule for future agents
```

Vague warnings have no value. Every instruction must be actionable.

**Deployment**

Which branches auto-deploy. Whether automatic or approval-gated. Whether tests run before deployment. Which environments are affected.

**Git**

Protected branches. Multiple remotes. Force-push exposure. Mirror repositories. Company-owned or production remotes.

**Database**

Migrations, seeders, bulk scripts, data repair scripts, sync/import jobs that could affect shared environments.

**Queue and Jobs**

Operations that could duplicate, lose, or disrupt background work. Scheduler commands that affect shared state.

**Infrastructure**

Cloud storage, CDN, search indexes, caching systems. Operations that should never be performed automatically.

**Secrets and Credentials**

Where they live: env files, credential files, service accounts, keys, certs, deployment tokens. Never print, commit, copy into docs, or expose in output. Only identify locations and risks; never reproduce values.

**Destructive Operations**

Commands or scripts that delete data, reset environments, recreate databases, destroy infrastructure, or clear storage.

**Project-Specific**

Generated code, vendor-managed code, legacy systems, sync processes, unusual deployment requirements, operational dependencies unique to this repo.

## Environment Classification

For each known environment (local, staging, UAT, production, preview), document:

- Purpose.
- Ownership.
- Whether shared.
- Whether persistent or ephemeral.
- Whether safe for testing.
- Any access restrictions or environment-specific rules.

This block answers the question "if I push here, what breaks for whom?" before the push happens.

## Minimum Evidence Checklist

When stating what the project enforces, infer only from actual CI/hooks/pipelines. Do not claim a check exists unless the project actually runs it.

Examples: unit tests, feature tests, linting, static analysis, frontend build, generated file verification, pre-commit hooks.

Before completing this checklist, verify you have inspected: CI config files (`.github/workflows/`, `.gitlab-ci.yml`, etc.), pre-commit hook configs (`.husky/`, `.pre-commit-config.yaml`), and test/lint scripts in `package.json`, `Makefile`, or `composer.json`. List the files that informed each check.

## See also

- [`git.md`](git.html) - the workflow rules that reference safety boundaries
- [`/helm:log`](../commands/log.html) - the command that surfaces and proposes what belongs in this file
