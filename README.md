---
title: Home
nav_order: 1
permalink: /
---

# agent-helm

Take the helm.

<img src="https://myowinthein.github.io/agent-helm/docs/images/banner.jpg" alt="agent-helm" width="600">

A workflow plugin for Claude and Codex, built for solo developers. Ten workflows and two rule files covering shipping, refactoring, testing, documentation, legal docs, env auditing, commit-history normalization, rule adoption, and archiving your own work.

[Documentation site](https://myowinthein.github.io/agent-helm)

## Install

See the [setup guides](https://myowinthein.github.io/agent-helm/docs/setup/) for Claude Code, Cowork, Codex desktop, and Codex CLI. Use `/helm:<command>` in Claude or select the same Helm workflow from Codex's skill picker.

Claude Code:

```bash
# Register this repo as a marketplace on your machine. Runs once.
/plugin marketplace add myowinthein/agent-helm

# Install the helm plugin from the registered marketplace.
/plugin install helm@agent-helm

# Pull the latest version from GitHub when a new release ships.
/plugin update helm@agent-helm

# Remove the plugin from your machine.
/plugin uninstall helm@agent-helm

# Apply changes after install, update, or uninstall.
/reload-plugins

# Verify installation: type /helm in the Claude Code prompt.
# Commands should appear in the picker. If not, see Known Traps in AGENTS.md.
```

Codex CLI:

```bash
codex plugin marketplace add myowinthein/agent-helm
codex plugin add helm@agent-helm
```

Start a fresh session in your project, open the `$` picker, and select a Helm workflow. Codex entries require explicit invocation.

Upgrading from the old marketplace name requires registering and installing `helm@agent-helm` in each client. Disable the old plugin entry to avoid duplicate workflows. Existing rule copies and references remain supported; keep any old marketplace checkout that projects still reference. See [renaming an existing installation](https://myowinthein.github.io/agent-helm/docs/setup/compatibility.html#renaming-an-existing-installation).

## Usage

### Commands

Links below go to detail pages. Workflow logic lives in `workflows/*.md`; portable entries live in `skills/` and legacy Claude adapters in `commands/`.

| Command | What it does |
|---|---|
| [`/helm:ship`](https://myowinthein.github.io/agent-helm/docs/commands/ship.html) | Cut a release: calculate version, test, tag, push, and create a GitHub Release. |
| [`/helm:test`](https://myowinthein.github.io/agent-helm/docs/commands/test.html) | Assess coverage and write missing tests. |
| [`/helm:refactor`](https://myowinthein.github.io/agent-helm/docs/commands/refactor.html) | Run a project-wide refactor on a dedicated branch. |
| [`/helm:env`](https://myowinthein.github.io/agent-helm/docs/commands/env.html) | Audit and fix `.env` files and `.gitignore`: sync, formatting, missing vars, hardcoded values. |
| [`/helm:log`](https://myowinthein.github.io/agent-helm/docs/commands/log.html) | Set up shared `AGENTS.md` and its Claude adapter, then maintain project knowledge. The captain's log. |
| [`/helm:manifest`](https://myowinthein.github.io/agent-helm/docs/commands/manifest.html) | Sync `README.md` to the current codebase. Requires an existing instruction owner; run log first for fresh setup. |
| [`/helm:legal`](https://myowinthein.github.io/agent-helm/docs/commands/legal.html) | Generate GDPR-aware legal documents from a project scan. |
| [`/helm:normalize`](https://myowinthein.github.io/agent-helm/docs/commands/normalize.html) | Rewrite non-conventional commit messages across full repo history. |
| [`/helm:archive`](https://myowinthein.github.io/agent-helm/docs/commands/archive.html) | Archive an old project for long-term storage and future recovery. |
| [`/helm:adopt`](https://myowinthein.github.io/agent-helm/docs/commands/adopt.html) | Install or update the rule files into the current project. Setup helper, not a workflow command: see below. |

Run `/helm:log` in a project to establish shared `AGENTS.md` instructions and a `CLAUDE.md` importing them. Existing projects receive a reviewed migration proposal; future Claude/Codex sessions then share the same knowledge without rerunning setup when switching agents.

Project state is shared under `.helm/` on both hosts. Existing `.claude/helm/` and flat `.claude/` state migrates one file at a time when its owning command next writes successfully, with validation and explicit reconciliation of conflicting copies. See [compatibility and migration](https://myowinthein.github.io/agent-helm/docs/setup/compatibility.html#shared-project-state). Native Claude rules stay in `.claude/rules/`.

### Rules

| Rule | What it does |
|---|---|
| [`git.md`](https://myowinthein.github.io/agent-helm/docs/rules/git.html) | Git workflow rules covering branching strategy, commit conventions, code quality gates, and environment promotion. |
| [`safety.md`](https://myowinthein.github.io/agent-helm/docs/rules/safety.html) | Operational safety scan covering deployment, git, secrets, and destructive operations. |

## Using the rules

Installing the plugin does not install project-wide rules in either host. Use [`/helm:adopt`](https://myowinthein.github.io/agent-helm/docs/commands/adopt.html) to install the rules into the current project. Claude supports two modes; Codex installs shared copies and explicitly reads them from its active project entry:

- **Copy**: writes the rules into `.claude/rules/` for either host, preserving existing files unless their overwrite is approved. Self-contained and committed with the repo.
- **Reference**: adds rule pointers to the shared owner (`AGENTS.md` after setup), pointing at the installed plugin path. Legacy owners remain supported.

After updating the plugin, copy mode requires re-running `/helm:adopt` to pull the latest files. Claude reference mode follows its stable marketplace checkout automatically. Codex can connect to an existing readable Claude reference installation but does not create cache-based references. See [compatibility](https://myowinthein.github.io/agent-helm/docs/setup/compatibility.html) for memory ownership and cross-host setup.

## Contributing

Run `ruby scripts/test_plugin.rb` for offline package checks, `ruby scripts/check_clients.rb` for native CLI discovery, and `bundle exec rake test` for the package and documentation checks. Native discovery checks do not install Helm or invoke a model. Optional `ruby scripts/smoke_layout.rb codex` and `ruby scripts/smoke_layout.rb claude` checks exercise migration, approvals and shared adoption in disposable projects using signed-in CLI accounts; pass case names to run a subset.

Issues and pull requests are welcome at [github.com/myowinthein/agent-helm/issues](https://github.com/myowinthein/agent-helm/issues). The intent of this pack is opinionated solo workflows, so feature requests that conflict with that scope may be declined politely.

## License

[MIT](https://github.com/myowinthein/agent-helm/blob/main/LICENSE)

<!-- last-reviewed: 2454819f5d375089e8695a96c22b5ad966d0deef -->
