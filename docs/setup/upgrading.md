---
title: Breaking changes and one-time upgrade
parent: Setup
nav_order: 9
permalink: /docs/setup/upgrading.html
---

# Breaking changes and one-time upgrade

This clean break prepares the next major Helm release. It is not a published release, version bump or automatic migration command. Current workflows accept only their current formats and canonical paths. Update complete packages on both clients and start fresh sessions after preparing existing projects; an older loaded workflow can recreate unsupported files.

## Breaking behavior

| Area | Current contract |
|---|---|
| Settings | `ship-method: direct|pr` replaces `git-strategy`. Default is `pr` only when genuinely absent; an old key without the new one blocks shipping. `environment-promotion` no longer selects behavior. |
| Local commands | Editing commands finish on their permitted current branch without workflow branches, push/PR prompts or remote cleanup. Branch eligibility and content approvals remain command-specific. |
| Shipping | Ordinary ship publishes code and optional selected targets. Explicit `ship release` alone owns SemVer/metadata/tags; `ship promote` remains available. `ship normalize` and `ship archive` own their specialist publication protocols. |
| Instructions | AGENTS.md owns shared project instructions; CLAUDE.md imports it. Log still handles first-time existing-file reconciliation through reviewed diffs. |
| Rule adoption | Shared local copies under `.claude/rules/`; no external-reference conversion or recovery. Only `agent-helm` rule markers are managed. Other markers/files require ordinary foreign-file review. |
| Ledgers | Only `.helm/refactor-log.json` schema 2 with native evidence, `.helm/test-log.json` schema 3, `.helm/normalize-log.json` schema 1 and `.helm/legal-manifest.json` schema 1. No old reader, converter, path migration or automatic reset. |
| Archive state | Only current schema-1 `.helm/archive/` bundles can resume. Old `.archive/` bundles remain protected historical evidence and stop archive routes with manual guidance. |
| Scan requests | Use Full scan / Gap scan. Old Deep/Quick/Catch Up/Gap update aliases are removed; clarify unsupported requests without changing literal paths. |
| Package discovery | The ten skills are the only entry points. The plugin remains `helm`; the repository/marketplace is `agent-helm`. |

`base-branch-role` and `development-branch` were never implemented and are not removed features. `.claude-plugin/` and `.claude/rules/` are active formats, not obsolete state directories. Database migrations and normal client compatibility remain supported. Git history, existing tags and old release records are not rewritten to relabel changes.

## One-time project preparation

Keep an exact private recoverable copy of affected files and the current working package before resets. Inventory only approved project roots; Helm filenames or a `.claude/` directory alone do not authorize deletion. Recheck actual ownership, symlinks, collisions, mixed copies, tracking and pending edits before each change. Preserve archives, recovery assets and private normalize bundles/maps. Close other writers, not the session doing the work.

1. Materialize the intended `ship-method` in the existing owner block: old `solo` becomes `direct`, `github-flow` becomes `pr`; an existing valid new preference wins. Remove retired declarations only through the reviewed diff, preserving other settings and deliberate project policy.
2. Replace approved external Helm rule pointers with verified local copies from the current source. Copied policies do not update when the plugin updates. Preserve custom instructions and explicitly connect both host entries; existing writing is retained, while a new writing rule stays opt-in.
3. For a chosen fresh start, back up and remove the exact old refactor/test ledgers, including canonical copies if selected. This forgets recorded findings and skip/defer/accepted-risk choices. Do not create empty replacements; the next owning run performs a fresh assessment.
4. Move legal/normalize records unchanged only after proving their ownership, valid current schema and safe destination. Conflicting/malformed/unsupported copies require explicit handling. A location change does not establish fresh compliance or legal review.
5. Keep AGENTS/CLAUDE project knowledge, README/legal text, review markers and custom templates. Request Full scans later rather than restamping markers. Preserve custom/lawyer-reviewed clauses through reviewed updates.
6. Update both complete client installations through their documented update process, disable duplicate old marketplace entries and begin fresh sessions. No global client-setting changes or cache deletion are part of project cleanup.

Use exact-file before-images and readback, never a whole-home backup or blanket `.claude/`/`.helm/` deletion. Stage only authorized paths under the actual local commit policy, preserving unrelated work. Failed actions retain actual drafts and the exact retry plan; do not invent rollback or completion.

## Existing archives and recovery assets

Completed historical snapshots remain where they were created. A move does not erase an old Git receipt, but it can break current literal-path/fingerprint/checkpoint validation. Do not rewrite reports, fabricate new receipts, push a cosmetic relocation or rerun restoration just to adopt a new path.

Finish or explicitly park interrupted/prepared old runs with the preserved matching workflow. A fresh restart needs its own exact preservation/output-collision plan; old `docs/archive-metadata.md` or known alternate metadata remains prior-run evidence even without a state bundle. The ordinary `archive/` folder often holds SQL dumps, images, Postman files, supplementary docs or other real assets; it is not `.archive/` workflow state and must not move to `.helm/archive/` merely for naming consistency.

The one-time cleanup is maintenance outside ordinary commands. Their exists-only guards stop unsupported leftovers without reading, converting or deleting them. The archive guard runs only on archive routes; unrelated workflows leave historical archives opaque.

## Release and verification status

A breaking release should use a major version, for example the planned 3.0.0, and scoped Conventional Commits with `!` or a `BREAKING CHANGE:` footer. Release metadata, tag creation and publication still belong to explicit ship release. This implementation does not assert a release or change published identities.

Testing remains deferred. Source/diff readback and verified file moves are not plugin tests, native loading, runtime recovery or remote backup verification. Package, documentation and relevant client checks must be considered when testing is resumed; do not claim this change has passed them.
