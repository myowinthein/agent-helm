---
title: Compatibility and project instructions
parent: Setup
nav_order: 5
permalink: /docs/setup/compatibility.html
---

# Compatibility and project instructions

Helm has one workflow body per operation in `workflows/`. Portable entries in `skills/` load the shared runtime and that workflow. Legacy `commands/` files remain small adapters. The manifest exposes skills and disables automatic command-directory discovery, preventing duplicate entries while preserving `/helm:<name>` in Claude. Claude's existing invocation policy is retained; Codex's new skill entries disable implicit invocation.

## Keep one memory owner

Helm reads project knowledge and configuration from its existing owner. It does not convert a project just because a different host is running.

| Project layout | Behavior |
|---|---|
| CLAUDE.md only | Keep CLAUDE.md as owner. Codex adoption adds a small AGENTS.md bridge that explicitly reads it. |
| AGENTS.md only | Use AGENTS.md as owner. A fresh Codex project uses this layout. |
| CLAUDE.md imports AGENTS.md | Preserve the wrapper and edit the AGENTS.md owner. |
| Both contain independent instructions | Preserve both. Resolve conflicting Helm settings or ambiguous ownership before Git changes. |

Codex's active `AGENTS.override.md` and nested instruction precedence still apply. Adoption writes the persistent root entry (CLAUDE.md or AGENTS.md), preserving its unrelated content. If a root AGENTS.override.md shadows AGENTS.md without explicitly reading it, Codex adoption stops before writing or branching. Connect the persistent entry from the override or resolve that override before retrying. Adoption never edits or commits override files or the other host's entry.

Recognized configuration includes Helm's `## Project Config` declarations and the existing Compass-style fenced `text` configuration block. When both independent entry files exist but only one declares Helm settings, that file owns configuration; the setting-free entry is preserved and is not a conflict. Identical settings are not conflicts. Invalid or conflicting values, missing bridge targets, and pointer cycles must be resolved before branching. Missing settings retain the existing defaults; a different heading does not silently change a declared strategy.

`log` follows the owner rather than replacing a wrapper. For a customized owner it proposes targeted changes in the existing structure, preserving imports, host-specific instructions, the configuration block, and `## Rules`. The eight-section format remains the generation format for fresh or already-standard Helm memory files. Any removal or restructuring of custom instructions requires an approved diff.

Changing to an AGENTS.md-owned layout is optional. If you do it manually, preserve Claude-specific instructions and use an explicit `@AGENTS.md` import from CLAUDE.md. Helm does not perform that conversion during an ordinary workflow run.

## Shared rules and history

Both hosts use `.claude/rules/git.md` and `safety.md`. The directory name is retained for compatibility; Codex reads these files through explicit entry-file directives. Copied rules include their own configuration-resolution guidance so they can work in a new session without loading a Helm skill.

On Claude, copy and reference modes retain their existing behavior. The stable marketplace checkout remains the preferred adoption source and reference target. A fallback to the loaded package is reported explicitly, and new reference mode is unavailable when that stable source is missing.

Codex installs copies from its loaded package. It does not create references to a versioned cache directory. If a project already uses readable Claude marketplace references, Codex can connect through a bridge to the existing owner without copying marketplace paths into AGENTS.md or changing that installation. If those references are unavailable, stop and use Claude's adoption flow to switch the shared installation to copies; do not create competing copies alongside the old references. Claude reference mode must not delete copies that a separate Codex entry still depends on. Switching to copies also stops if a separate Codex entry directly references marketplace paths; reconnect it through the owner first.

Existing foreign-file review, ahead-version protection, and version markers remain. After a released update changes the bundled rules, rerun `adopt` to update copies; review the shared change because both hosts may read them.

Ledgers stay under `.claude/helm/` on both hosts. Archive checkpoints stay under `.archive/`. Existing schemas and legacy migrations remain. Resume work sequentially across hosts; concurrent writers in one working tree are unsupported.

## Questions, tools, and approvals

Helm retains each workflow's existing questions and approvals. If a host cannot display a picker faithfully, it presents the choices in conversation and waits. Free-text answers and explicit `none` selections remain available. Silence, a timeout, or an unavailable tool never grants approval.

Read-only scans can use available workers or run sequentially with the same coverage. Codex keeps code edits, Git operations, and ledger writes in the parent orchestrator. Missing shell, Git, Docker, network, or authentication capabilities stop the affected step without falsely advancing its checkpoint.

## Verification scope

Contributor checks validate all ten entry points, package-relative links, relocation to a path containing spaces, containment, and real Git-archive exclusions for operational data. Native client checks verify exactly ten entries in Claude Code and Codex's marketplace reader. These structural checks do not prove every workflow outcome or a desktop UI flow.

The legacy marketplace `files` field is retained for compatibility but ignored by current Claude. Git export exclusions are checked through a real archive; a host using a raw checkout can still have contributor files in its installed copy. Consumer runtime instructions must come from the selected skill, not a plugin-root CLAUDE.md or AGENTS.md.
