# Shared runtime

Apply this runtime before the selected Helm workflow in Claude Code, Cowork, or Codex. Run only that workflow; reading another command or a repository document does not invoke it.

## Package and workspace

The package root is the directory containing this runtime, `rules/`, `skills/`, `workflows/`, and `.claude-plugin/plugin.json`. Resolve bundled links from the actual file being read. On Claude, `${CLAUDE_PLUGIN_ROOT}` identifies the loaded package; elsewhere derive the root from the selected SKILL.md's location. Never guess a cache version or substitute another installation when a required resource is missing.

The consumer workspace is the user's selected project and working tree. Keep it as the working directory for Git, builds, tests, and generated output. Read workflow and archive-step instructions from the package; read and write project files, `.claude/rules/`, `.claude/helm/`, `.archive/`, and recovery files in the consumer workspace. A consumer's similarly named `prompts/` or `rules/` directory is not a substitute for packaged workflow resources.

Before Git operations, establish that the host's shell is operating on the selected working tree. Folder access in Cowork or a remote sandbox does not establish access to the user's local Git checkout, credentials, Docker daemon, or installed tools. If a required capability is unavailable, report it and stop the affected step without claiming completion or advancing state.

## Project instructions and configuration

Read the consumer's active project instructions and the bundled [Git rules](../../rules/git.md) and [safety rules](../../rules/safety.md). Respect project-specific instructions and adopted rules; loading a workflow does not install, overwrite, or weaken them. Use the Git rules' **Project memory and configuration** procedure to resolve `{memory_file}`, the single owner of Helm configuration and project knowledge. Do this before a workflow creates or switches a branch. `{instruction_file}` is the current host's active root entry: `CLAUDE.md` in Claude; in Codex, root `AGENTS.override.md` when present, otherwise `AGENTS.md`.

The workflow's `{memory_file}` references mean the resolved owner, including when reached through an instruction bridge. A wrapper is an entry point, not an empty or broken memory schema. Do not rewrite wrappers, move configuration between files, change global client settings, or create a second configuration owner. `log` and `adopt` describe the only writes to memory/entry files; other workflows must preserve this ownership when saving a configuration choice.

For a fresh project with neither file, the proposed owner is the current host's `{instruction_file}`. Resolving that path is read-only; create it only when the chosen workflow calls for it. `adopt` has separate entry-file and rule-installation handling. Existing Claude marketplace references retain their documented behavior.

## Questions and authorization

`AskUserQuestion` blocks in shared workflows describe the question, choices, and whether multiple selections are allowed. In Claude, use AskUserQuestion when available. In Codex or another host, use an available question interface only if it can represent the question faithfully; otherwise show the choices in ordinary conversation and wait for the user's reply. Do not assume a plan-only input tool exists in other modes.

Preserve free-text answers, including the Claude Other response, and an explicit `none` for an empty multi-selection. A missing answer, timeout, default selection, unavailable tool, or ambiguous reply is not consent. Clarify ambiguous selections before dependent work. Do not choose all options to approximate an unsupported multi-select. Retain the workflows' existing option limits and grouping on Claude; plain chat can present those same choices.

Keep every workflow confirmation, cancellation, no-op, and cleanup path. Reuse authorization already given for the same described action; do not add another approval on top of a workflow's own confirmation. Host sandbox/tool approvals are separate technical permissions and do not answer a workflow question. Conversely, a workflow confirmation cannot bypass host restrictions. Do not pre-approve shell, push, history rewrite, publication, or deployment tools through skill metadata.

`Write` and `Edit` refer to full replacement and a targeted patch respectively; use the host's equivalent file tools while preserving those semantics and the workflow's read-back verification.

## Delegation and checkpoints

Use the host's available delegation tools for the read-only scans requested by `refactor` and `test`. The workflow's eight-chunk limit is not a promise of eight simultaneous workers: queue chunks within actual available slots. If delegation is unavailable, perform the same complete scans sequentially and report that fallback. Give each worker the absolute package and consumer paths, exact scope, and required instructions. Fresh context alone is not a filesystem sandbox.

On Codex, the parent owns code edits, Git operations, ledgers, and state writes. Workers return findings; they do not start another workflow, answer user questions, or update aggregate state. Process editing clusters and waves sequentially. Keep Claude's existing wave behavior, but never promise a fresh-session mechanism the host cannot provide; continue from the recorded checkpoint in the current session or report the precise resume point.

Keep `.claude/helm/` as the shared ledger location on every host, with the existing schemas and legacy-path handling. Keep `.archive/` filenames, report contents, and state semantics unchanged. Only advance a checkpoint after the outputs and approvals required by that workflow. Resume sequentially across hosts; concurrent Helm writers in the same working tree are unsupported. Never write consumer results into the installed plugin.
