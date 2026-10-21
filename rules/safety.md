# Operational Safety Rules

Loaded as context so agents respect the same operational guardrails throughout the project. It is not a checklist to execute top to bottom — the safety scan runs only when triggered (see When to Run a Safety Scan).

Resolve `{memory_file}` using git.md's Project memory and configuration procedure, including when these rules were copied into a project without the plugin. It is the existing memory owner, not necessarily the current host's entry file.

## Host capabilities

Apply these boundaries even without Helm's runtime loaded. Verify the selected consumer workspace and the actual tools/access needed for the proposed action. Folder access in Claude, Cowork, Codex, or a remote sandbox is not proof of access to the user's local Git checkout, credentials, Docker daemon, test environment, or deployment provider. A missing capability, denied permission, or unavailable required check stops the affected action and its dependent steps; preserve existing files/state and report the precise pending work without claiming success or advancing a checkpoint.

Tool/sandbox approval is a technical permission, separate from the workflow confirmations below; neither bypasses the other. If a confirmation interface is unavailable, ask in ordinary conversation and wait for an explicit answer. Silence, a timeout, a default selection, or unavailable tooling is not consent. Reuse valid approval for the same concrete action rather than asking again, and do not change credentials or client settings automatically to bypass a block.

## Operational Helm state

Helm configuration and project knowledge belong in `{memory_file}`. Operational records live in root `.helm/` on both hosts; `.claude/helm/` and the known flat `.claude/{refactor-log,test-log,normalize-log,legal-manifest}.json` files are legacy locations. `.claude/rules/` remains shared rule storage and is not a state directory to relocate.

Exclude these operational records from ordinary source/safety scans, feature edits, and unrelated staging. Do not open, rewrite, reset, delete, merge, or migrate them just because these rules loaded or the coding agent changed. Only the explicitly invoked owning Helm workflow may read/update its own state: refactor owns `refactor-log.json`, test owns `test-log.json`, normalize owns `normalize-log.json`, and legal owns `legal-manifest.json`. Other commands do not trigger migration. Archive may preserve records as opaque project files under its own authorized workflow, without interpreting or migrating them.

An owning workflow must load its packaged project-state procedure before state access: validate all candidate locations for that filename, explicitly reconcile differing histories, and migrate only at that workflow's eligible authorized write, with verified output and same-file tracked removals committed together. Never prefer a path automatically, dual-write, migrate every command at once, or ignore the entire `.helm/` directory. Preserve other commands' state and all remaining legacy sources on incomplete/failed migration. If the workflow or procedure is unavailable in a copied-rules-only session, leave state untouched and report that capability gap; these rules do not authorize an improvised migration. Resume sequentially across hosts, not with concurrent writers.

## Agent Execution Boundaries

These actions always require explicit confirmation regardless of context:
- git push, force-push, tag creation
- publishing packages or cutting public releases (npm publish, registry uploads, gh release create)
- committing public, legally-binding documents (privacy policy, terms of service, and similar)
- any deployment command
- migrations, seeders, database imports, database resets
- infrastructure changes, DNS changes, secret rotation
- destructive operations (resets, drops, clears, environment recreation)

A user-invoked command that confirms these actions within its own flow (e.g.
`/helm:ship` confirming the version, deploy targets, and release; `/helm:legal`
confirming before committing generated documents) satisfies this boundary — do
not add a separate prompt on top.

Projects can extend this list, never shrink it. Document any project-specific additions.

## When to Run a Safety Scan

Perform this scan at project bootstrap, and re-run it whenever the operational
risk surface changes — when anything in the Scan Targets or Risk Categories below
is added, removed, or reconfigured (e.g. a new production remote, a new
background job, a new credential location).

/helm:log Full scan mode may surface and propose safety findings for {memory_file}'s
Hard Safety Rules section, but it does not run this scan or write
.claude/rules automatically — findings are proposed, never auto-written.

Only document risks supported by evidence in the repository — not assumptions.

**Output:** Documented findings — the Risk/Instruction pairs, environment
classifications, and any project-specific boundary additions — go into {memory_file}'s
`## Hard Safety Rules` section as this project's concrete never-do list. Propose
the findings first and write them only on confirmation — never auto-write a safety
rule without review. Keep them in `## Hard Safety Rules` (project-owned, written by
`/helm:log`, loaded with {memory_file}), not the `## Rules` entries managed by adopt.
Adopt patches only approved exact Helm rule pointers, preserving custom entries,
unrelated instructions and Skip decisions; it does not replace that whole section
on every run. Do not put project-specific findings in the shipped `git.md` /
`safety.md`, whose approved managed copies adopt can overwrite on update.

## Scan Targets

Review for operational risks:
- CLAUDE.md, AGENTS.md, active instruction overrides, .claude/rules, README files, project documentation
- CI/CD pipelines, GitHub Actions, GitLab CI, deployment scripts
- Composer scripts, package scripts, Makefiles, shell scripts
- Docker, Dev Containers, Podman, Lando, Laravel Sail configuration
- Git remotes, branch structure, protected branches
- .env.example, credential files, service account files, private keys
- Database migrations, seeders, and data/repair scripts
- Destructive scripts (reset, drop, wipe, restore commands)
- Queue config, scheduler config, background job definitions
- Deployment platforms (Fly.io, Railway, Render, Heroku, or similar)
- Cloud/infrastructure config (AWS, GCP, Azure, DO, Cloudflare, Supabase, Vercel, Neon, Elasticsearch, Redis, etc)

## Risk Categories

These are the lenses for documenting what the Scan Targets above surface — one per operational domain.

For each category, scan for evidence and document findings as:
  Risk: one-line description
  Instruction: direct rule for future agents

Avoid vague warnings. Every instruction must be actionable.

**Deployment**
Which branches auto-deploy. Whether automatic or approval-gated.
Whether tests run before deployment. Which envs are affected.

**Git**
Protected branches. Multiple remotes. Force-push exposure.
Mirror repositories. Company-owned or production remotes.

**Database**
Migrations, seeders, bulk scripts, data repair scripts, sync/import jobs
that could affect shared environments.

**Queue & Jobs**
Operations that could duplicate, lose, or disrupt background work.
Scheduler commands that affect shared state.

**Infrastructure**
Cloud storage, CDN, search indexes, caching systems —
operations that should never be performed automatically.

**Secrets & Credentials**
Where they live (env files, credential files, service accounts, keys, certs,
deployment tokens). Never print, commit, copy into docs, or expose in output.
Only identify locations and risks — never reproduce values.

**Destructive Operations**
Commands or scripts that delete data, reset environments, recreate databases,
destroy infrastructure, or clear storage.

**Project-Specific**
Generated code, vendor-managed code, legacy systems, sync processes,
unusual deployment requirements, operational dependencies unique to this repo.

## Environment Classification

For each known environment (local/staging/UAT/production/preview/etc) document:
- purpose
- ownership
- whether shared
- whether persistent (or ephemeral)
- whether safe for testing
- any access restrictions or environment-specific rules

## Minimum Evidence Checklist

Infer from actual CI/hooks/pipelines — only checks the project enforces.
Examples: unit tests, feature tests, linting, static analysis, frontend build,
generated file verification, pre-commit hooks.

Before completing this checklist, verify you have inspected: CI config files (`.github/workflows/`, `.gitlab-ci.yml`, etc.), pre-commit hook configs (`.husky/`, `.pre-commit-config.yaml`), and test/lint scripts in `package.json`, `Makefile`, or `composer.json`. List the files that informed each check.
