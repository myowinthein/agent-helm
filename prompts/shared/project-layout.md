# Shared project layout for log

Apply this procedure only as part of `log`. Other Helm workflows resolve and preserve the existing memory owner; they do not invoke a migration.

## Destination

Successful shared setup has two real root files:

- `AGENTS.md`: the single owner of shared project knowledge, Helm configuration, adopted `## Rules`, and the review marker.
- `CLAUDE.md`: a standalone `@AGENTS.md` import outside code fences, followed by clearly Claude-specific additions when needed. Do not duplicate shared configuration, Rules, or the review marker here.

The import loads shared instructions in Claude without relying on its native AGENTS fallback. Use explicit read-and-follow directives for shared resource dependencies in AGENTS.md; Codex does not expand Claude's `@` syntax. Do not claim that arbitrary other agents implement the same discovery, imports, or precedence.

## Read-only preflight, before Git changes

Inspect both root entries and follow their explicit memory chains with visited-file tracking. Record original contents and resolved configuration. Compare independent or partially connected files even if general resolution found a conflict. A cycle confined to the readable root CLAUDE.md and AGENTS.md is a reconciliation case for log: read each once, identify the two links and propose removing the reverse bridge; do not follow the cycle indefinitely. Missing targets, external cycles and other unresolved chains still stop. Read-only comparison does not authorize choosing configuration values or changing branches. Invalid or conflicting Helm settings need an explicit user choice per key before Git actions. A content baseline is not implicit approval to change configuration values.

Check root `AGENTS.override.md` on either host. If it does not explicitly read AGENTS.md, stop before branching or writing: shared setup cannot be claimed while Codex's persistent entry is shadowed. Never edit, migrate, or import the override. An override that reads AGENTS.md may remain, but report any intentional host-specific configuration difference; resolve incompatible effective Helm values before Git actions. Respect nested instructions too.

Do not fold personal `CLAUDE.local.md`, global files, or nested instruction files into the migration. List nested entries and shared imports that need separate adapters; a root CLAUDE.md does not ensure Claude loads every nested AGENTS.md. If `.claude/CLAUDE.md`, an explicit non-root memory target, or symlinks complicate the layout, show the actual paths and resolve their placement with the user first. Do not follow writes outside the workspace, replace a symlink silently, or create a competing root owner. An existing CLAUDE.md symlink to AGENTS.md is readable, but conversion to the requested real-file adapter requires a reviewed diff.

In a repository, check the instruction files and any migration targets for uncommitted changes, including untracked existing instruction files. Stop rather than absorb those edits into a migration commit. A missing destination is expected, not an untracked edit. Do not reset, stash, or overwrite the user's work. With no repository or no commits, preserve existing files through the normal proposed-diff approval instead.

Resolve the run's existing Git strategy and auto-commit policy now, without changing them. Record `{run_git_strategy}` and `{run_auto_commit}`. When configuration is absent, use the existing defaults. Finish this invocation using these recorded values even if Project Config Check later saves a different policy; that choice applies to the next invocation. A layout move itself preserves confirmed Helm values.

## Plan on the actual working files

After `log`'s branch setup, re-read both files and compare their raw configuration declarations with the recorded preflight inputs, then reapply any explicit per-key choices already made. Do not mistake unresolved original declarations for a new change merely because the user chose one value. If the underlying configuration changed, stop before writing, clean up an empty temporary branch and suggest rerunning from main; do not continue under a stale strategy. Compute the proposal from these actual files, not a feature branch's earlier snapshot. Recheck contents immediately before applying an approved diff; changed inputs require a fresh proposal.

| Existing layout | Action |
|---|---|
| Neither root file | Defer both creations until the chosen full scan generates AGENTS.md. Skip writes neither file. |
| Only AGENTS.md | Preserve it byte-for-byte; propose creating CLAUDE.md containing only `@AGENTS.md`. |
| Only CLAUDE.md | Propose moving shared content to AGENTS.md and replacing CLAUDE.md with the import plus its Claude-specific additions. |
| Both correctly connected | No layout edits; continue the knowledge assessment. |
| Both independent, partially connected, or AGENTS.md points back to CLAUDE.md (including a root two-file cycle) | Compare and propose reconciliation as below. An adapter importing AGENTS.md but still holding shared settings, Rules or a review marker is partially connected; propose moving those shared items to AGENTS.md. |

Correctly connected means the root Claude adapter actually imports AGENTS.md, AGENTS.md has no directive back to CLAUDE.md, and shared configuration, Rules and review markers belong only to AGENTS.md. Merely mentioning the other filename in prose or an example is not this import. Custom headings in the owner are valid. Check the files' actual contents, not their names alone.

For independent files, first summarize agreements, unique durable instructions, conflicts, and clearly host-specific material. Recommend a reconciliation. Offer at most four choices: `Reviewed merge (Recommended)`, `Use AGENTS.md as baseline`, `Use CLAUDE.md as baseline`, `Cancel`. A baseline supplies structure and preferred shared wording; carry unique instructions forward unless their removal is explicitly approved. Do not silently discard safety rules, preferences, or configuration. After a baseline/merge choice, still show the concrete diff for approval.

## Preserve meaning in the proposed diff

- Keep shared content in AGENTS.md. Keep only clearly Claude-specific instructions in CLAUDE.md after the import. When uncertain, preserve the instruction in the shared owner and flag its scope for review. Label Codex-specific additions conditionally so Claude is not told to perform Codex-only mechanics.
- Preserve custom section names/order, recognized fenced configuration blocks, every confirmed Helm setting, and existing rule dependencies. This stage is a layout change, not a full scan or schema conversion. Do not rewrite durable knowledge just to make the file fit eight headings.
- Preserve the adopted Rules section and paths when moving a root owner. Do not copy, update, delete, or switch rule installations. For a move from another directory, show any necessary relative-path changes explicitly.
- Classify each Claude `@` import. Keep Claude-only/personal imports in CLAUDE.md. Convert shared in-project dependencies to explicit read-and-follow directives in AGENTS.md, preserving their targets and showing the syntax change in the diff. Do not silently leave shared imports available only to Claude. Flag unresolved scope or missing targets before applying. Do not inline imported files, create new import cycles, or expose personal content.
- Remove the old Helm-generated reverse bridge (`Project instructions and Helm configuration live in CLAUDE.md ... do not duplicate or migrate ...`) only as part of the approved migration. It is superseded by that specific approval, including when it came from an older adopted Helm rule. Preserve user-added instructions alongside it. Never leave AGENTS.md reading CLAUDE.md while CLAUDE.md imports AGENTS.md.
- Move an unambiguous `last-reviewed` hash unchanged; creating an adapter or moving text is not a review. If two hashes exist, explain their provenance and propose the older ancestor of the retained content's review points. If they cannot be ordered or validated, propose removing the ambiguous marker and requiring full investigation; show this explicitly for approval. Never stamp HEAD merely because files were rearranged.
- Show the complete proposed changes across both files, including removals and any host-scope changes. Offer `Apply`, `Revise`, or `Cancel`. For an adapter-only addition, show its full contents and offer creation or cancel. Prior approval suffices only when the computed changes match the concrete transformation already approved. A generic request to run log is not approval to reconcile existing instructions.

Cancel exits this invocation without a layout write or scan; use `log`'s empty-branch cleanup and report shared setup as cancelled. Do not silently continue in a legacy layout and report cross-agent setup complete.

## Apply and verify before knowledge assessment

Apply only the approved changes. Read both files back, follow their dependencies, and verify that retained instructions survived, no reverse bridge/cycle remains, and both host paths resolve to the same shared owner and agreed Helm settings. Report host-specific overrides separately. A failure stops the scan and finalization; report actual changed files for recovery without claiming completion or automatically discarding them.

Set `{memory_file}` to root AGENTS.md. Track layout writes separately from knowledge writes. In an existing repository, a layout-only commit is separate from any later scan commit and follows `{run_auto_commit}`; if commit approval is declined, stop with the actual files left for review. Do not commit unrelated files. With no HEAD, create no commit or review marker and do not initialize Git automatically.

Continue `log`'s knowledge assessment even when layout alone changed. Up-to-date knowledge or a later scan Skip still finalizes and reports the layout changes. If a full scan was selected for a genuinely fresh project, generate AGENTS.md first and the real CLAUDE.md adapter alongside it; never leave an adapter pointing at a missing target. Report setup, knowledge updates, commits and pushes separately.
