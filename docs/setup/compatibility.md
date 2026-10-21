---
title: Compatibility and project instructions
parent: Setup
nav_order: 5
permalink: /docs/setup/compatibility.html
---

# Compatibility and project instructions

Helm has one workflow body per operation in `workflows/`. Portable entries in `skills/` load the shared runtime and that workflow. Legacy `commands/` files remain manual/legacy adapters, outside the current discovery path; older-client behavior is not established by source review. The manifest exposes skills and disables automatic command-directory discovery, preventing duplicate entries while preserving `/helm:<name>` in Claude. Claude's existing invocation policy is retained; Codex's new skill entries disable implicit invocation.

## One shared owner and a Claude adapter

Successful `log` setup uses root `AGENTS.md` for shared project knowledge, Helm configuration, adopted Rules, and one review marker. A real root `CLAUDE.md` imports it using a standalone `@AGENTS.md` line, followed by any Claude-specific additions. This import works without relying on Claude's conditional native AGENTS.md discovery. Normal agent switching between sessions needs no log rerun.

| Existing layout | log setup |
|---|---|
| Neither file | A chosen full scan creates AGENTS.md and the Claude adapter. Skip creates neither. |
| AGENTS.md only | Preserve it and propose the missing Claude adapter. |
| CLAUDE.md only | Propose moving shared instructions to AGENTS.md and keeping Claude-specific content in the adapter. |
| Both already connected | Preserve the layout and assess project knowledge. |
| Both independent, partially connected or cyclic | Compare agreements, unique instructions and conflicts; propose a reviewed merge or either source as the baseline. |

A Claude adapter that imports AGENTS.md but still holds shared settings, Rules or a review marker also needs reconciliation. Log can propose repairing a cycle confined to the two readable root files, reading each once and resolving settings before Git actions; other cycles and missing targets still stop.

A baseline does not silently discard unique safety rules or preferences. Existing-file moves/reconciliation require a concrete approved diff. Cancel exits without a layout write or scan. Shared instructions imported with Claude's `@` syntax need explicit read-and-follow directives for Codex; migrations show that conversion rather than silently losing the dependency. Custom sections and fenced configuration keep their existing structure. The eight-section schema is for fresh or already-standard project memory, not a reason to overwrite a custom document.

Layout setup happens before the up-to-date test. Creating an adapter or moving files is a real change even if the user subsequently skips the knowledge scan. Moves preserve the existing review point and are committed separately from knowledge updates when Git is available. Without a repository or HEAD, log does not initialize Git, commit, or invent a review marker. Current-run Git finalization uses the strategy and commit policy resolved at invocation; a newly chosen policy applies on the next run.

Only log migrates existing owners. Other workflows still resolve and preserve legacy CLAUDE.md owners, explicit memory targets and bridges. Legacy Codex adoption may add the existing bridge to a CLAUDE.md owner and recommends log for migration. In the shared layout, adoption writes rule pointers to AGENTS.md from either host, creates a missing Claude adapter as part of the chosen install/connection, and preserves an existing adapter. It does not repeat Rules in CLAUDE.md or migrate an independent owner.

Recognized configuration includes Helm's `## Project Config` declarations and Compass-style fenced `text` project configuration. Setting-free independent entries are not configuration conflicts; identical values agree. Conflicting/invalid values and ambiguous ownership need explicit resolution before Git actions. Migration preserves confirmed settings. Missing values retain the existing defaults.

## Scope and precedence

Root `AGENTS.override.md` and nested instruction precedence still apply. If the override does not explicitly read AGENTS.md, log and adopt stop on either host before branching/writing; they do not claim shared setup or edit/import the override. An explicitly connected override stays intact, and intentional host-specific policy is reported. Conflicting effective Helm settings still require resolution.

Root migration does not flatten nested files, personal CLAUDE.local.md, global instructions, or imported files. Non-root memory owners, `.claude/CLAUDE.md`, and symlinks require an explicit placement decision instead of silently creating competing roots or writing outside the project. A root Claude adapter alone does not give Claude every nested AGENTS.md; those scopes need separate adapters or verified native support. Explicitly disabled instruction loading remains a host setting, not something Helm changes.

Helm checks existing instruction files for uncommitted work before migration. It builds the diff from the actual log branch, rechecks inputs before applying it, and stops if the branch's configuration changed from preflight. Review markers are preserved during moves; ambiguous merged review histories are disclosed rather than stamped as freshly reviewed.

## Shared rules and history

Both hosts use `.claude/rules/git.md` and `safety.md`. In the canonical layout, AGENTS.md explicitly tells either agent to read these files. The directory name is retained for compatibility; Codex reads these files through explicit entry-file directives. Copied rules include their own configuration-resolution guidance so they can work in a new session without loading a Helm skill.

On Claude, copy and reference modes use the stable marketplace checkout as the preferred adoption source and reference target. A fallback to the loaded package is reported explicitly, and new reference mode is unavailable when that stable source is missing. If filtering leaves an in-sync picker with no available action, adopt reports no change instead of showing a one-option question.

Codex installs copies from its loaded package. It does not create references to a versioned cache directory. If a project already uses readable Claude marketplace references, Codex can follow the existing shared owner or connect through a legacy bridge without duplicating marketplace paths or changing that installation. If those references are unavailable, stop and use Claude's adoption flow to switch the shared installation to copies; do not create competing copies alongside the old references. Claude reference mode must not delete copies that a separate Codex entry still depends on. Switching to copies also stops if a separate Codex entry directly references marketplace paths; reconnect it through the owner first.

Adopt manages only exact Helm rule targets, preserving custom pointers and unrelated instructions. Missing rules/directives and mixed installations require per-rule repair decisions; one current file cannot hide a missing companion. Ahead versions take precedence over behind versions, and every rollback requires explicit per-file approval. Codex does not create copies beside existing marketplace references, including when a foreign local file would otherwise disguise reference mode.

Foreign-file Overwrite/Skip decisions are collected before mutation. In reference mode, keeping a conflicting local `git.md` or `safety.md` stops the entire switch without writes or deletions; Claude could load that file natively while Codex reads only the shared marketplace pointers. All-foreign-files Skip creates no entries or adapter. Partial coverage is reported explicitly. Custom local rules are preserved and are not automatically shared with another host without approval.

Adopt rechecks ownership and effective policy after branch changes and verifies all approved rule/entry outputs before committing or publishing. A missing memory file does not bypass Git strategy in an existing repository with HEAD. GitHub Flow honors PR/review, merge-strategy and CI policy; blocked review leaves a branch/PR handoff. Log, manifest, env, legal and test share the same [Git and CI phases](git-and-ci.html), with legal review and each command's state ownership preserved. Solo requires only applicable pre-integration CI, while configured/applicable CI still gates promotion of the published source SHA; no ship override bypasses required results. Main/master is resolved once and used consistently. Failed or declined finalization preserves pending work. See [adopt](../commands/adopt.html) for the full flow.

Copied rules retain version markers. After a released update changes the bundled rules, rerun `adopt` to update copies; review the shared change because both hosts may read them. Adopt owns no ledger and never reads, stages or migrates `.helm/`, `.claude/helm/`, or flat legacy operational state.

## Shared project state

Both hosts write version-controlled project state under root `.helm/`. This is Helm's project directory, independent of client settings or plugin caches. Configuration and knowledge remain in the resolved instruction owner, normally `AGENTS.md`; the JSON files hold operational history.

| Command | Owned state file |
|---|---|
| `refactor` | `.helm/refactor-log.json` |
| `test` | `.helm/test-log.json` |
| `normalize` | `.helm/normalize-log.json` |
| `legal` | `.helm/legal-manifest.json` |

Migration is per command and per file, at the next successful authorized state write. Running legal does not move refactor, test, or normalize history. Other commands trigger no state migration. New projects create only the state they need; do not add `.helm/` to `.gitignore`.

For its own filename, the command checks `.helm/`, `.claude/helm/`, and the original flat `.claude/` location. All existing copies are validated and compared, including when canonical state already exists. Equivalent data can be deduplicated; different histories require explicit reconciliation. An invalid or unsupported file blocks the affected workflow with files preserved. Existing schemas remain, including test's explicit v1-to-v2 conversion; changing a directory never bumps a schema version.

Read-only inspection, Skip, no-op exits, cancellation before writing, and failed/incomplete operations do not migrate files. A completed scan that normally records a checkpoint may migrate its own state. The canonical result is read back and verified before legacy removal. Commit approval follows the command's existing policy; legal still requires explicit review. If a commit is declined, legacy sources remain intact and any canonical draft is reported as pending. A later run must reconcile differing draft/source copies explicitly. An authorized commit includes the canonical result and tracked legacy removals together using exact paths. No dual writing or whole-directory cleanup occurs.

Different filenames can temporarily remain across both directories until their owning commands run. `.claude/rules/` and native client settings are unchanged; archive checkpoints remain under `.archive/`. Update the complete Helm package in both clients and start fresh sessions before switching, because an older workflow can recreate legacy files. Resume sequentially across hosts; concurrent writers in one working tree are unsupported.

## Questions, tools, and approvals

Helm retains each workflow's existing questions and approvals. If a host cannot display a picker faithfully, it presents the choices in conversation and waits. Free-text answers and explicit `none` selections remain available. Silence, a timeout, or an unavailable tool never grants approval.

Read-only scans can use available workers or run sequentially with the same coverage. Codex keeps code edits, Git operations, and ledger writes in the parent orchestrator. Missing shell, Git, Docker, network, or authentication capabilities stop the affected step without falsely advancing its checkpoint.

## Verification scope

Contributor checks validate all ten entry points, package-relative links, relocation to a path containing spaces, containment, and real Git-archive exclusions for operational data. Native client checks verify exactly ten entries in Claude Code and Codex's marketplace reader. These structural checks do not prove every workflow outcome or a desktop UI flow.

The legacy marketplace `files` field is retained for compatibility but ignored by current Claude. Git export exclusions are checked through a real archive; a host using a raw checkout can still have contributor files in its installed copy. Consumer runtime instructions must come from the selected skill, not a plugin-root CLAUDE.md or AGENTS.md.
