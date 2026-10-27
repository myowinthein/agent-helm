# Shared runtime

Apply this runtime before the selected Helm workflow in Claude Code, Cowork, or Codex. Run only that workflow; reading another command or a repository document does not invoke it.

## Package and workspace

The package root is the directory containing this runtime, `rules/`, `skills/`, `workflows/`, and `.claude-plugin/plugin.json`. Resolve bundled links from the actual file being read. On Claude, `${CLAUDE_PLUGIN_ROOT}` identifies the loaded package; elsewhere derive the root from the selected SKILL.md's location. Never guess a cache version or substitute another installation when a required resource is missing.

The consumer workspace is the user's selected project and working tree. Keep it as the working directory for Git, builds, tests, and generated output. Read workflow and archive-step instructions from the package; read and write project files, `.claude/rules/`, `.helm/`, `.archive/`, and recovery files in the consumer workspace. A consumer's similarly named `prompts/` or `rules/` directory is not a substitute for packaged workflow resources.

Exclude `.helm/`, `.archive/`, `.claude/helm/` and `.claude/{refactor-log,test-log,normalize-log,legal-manifest}.json` from source discovery and history/diff rendering under the safety rules' **Operational Helm state** policy. Read messages/metadata and changed names/status first; exclude protected paths before rendering supporting patches. Owning-workflow access and the narrow exceptions below do not authorize state migration.

The Git rules' **Local work and ship method** section owns branch eligibility and local/publication boundaries. Follow the selected workflow's preparation, completion and exceptions; use the [local-edit Git procedure](content-sync.md) when directed. Verify workspace and action capabilities under the safety rules' **Host capabilities** section before dependent operations.

**Narrow publication-state exception:** ship may probe no-follow metadata for exact canonical/unsupported archive roots and relevant Git-native rewrite metadata. For normalize evidence, the [local handoff procedure](normalize-handoff.md) permits bounded read-only discovery in the actual Git common directory's exact `agent-helm/normalize-handoffs/` location, then only identified private recovery inputs; trusted conversation and explicit paths remain fallbacks. Normalize alone registers immutable per-run locators during its approved pre-filter preparation. These hints grant no live-ledger access, broad private search, force update or backup. Before opening an archive bundle obtain its explicit inspection selection, then use only the packaged canonical root/schema/seal procedure and update only that selected bundle's publication journal/receipt. A normalization continuation reads only identified private recovery/graph/map evidence and relevant committed bookkeeping delta as opaque provenance; never its live ledger. Conflicting required candidates need reconciliation rather than silent precedence/fallthrough. Other ledgers remain opaque. Missing procedures/evidence block dependent work. Source maintenance and agent switching grant no locator, recovery or operational-state access.

**Narrow review-anchor exception:** only log/manifest validating an invalid marker may load [review-anchor recovery](review-anchor.md). It permits bounded read-only locator/map/object evidence for that marker, never live normalize state or publication. This is lazy caller-owned recovery, not runtime discovery; other workflows and source maintenance gain no access.

## Project instructions and configuration

Read the consumer's active project instructions and the bundled [Git rules](../../rules/git.md), [safety rules](../../rules/safety.md) and [writing rules](../../rules/writing.md). Respect project-specific and adopted rules. Loading them installs or weakens nothing and adds no writing dependency to an existing copied Git/safety pair.

Use the Git rules' **Project memory and configuration** procedure before dependent writes. `{memory_file}` means its resolved knowledge/configuration owner, not an importing wrapper. `{instruction_file}` means the active host root entry: `CLAUDE.md` in Claude; `AGENTS.override.md` when present, otherwise `AGENTS.md`, in Codex. A package's contributor instructions are never consumer memory. Do not change global client settings.

Only log/adopt perform their declared instruction-layout writes. Follow their owner reconciliation, bootstrap, override, source-project/installation and external-reference guards; resolving a missing owner does not create it. Other workflows preserve ownership when saving an authorized setting. Log does not convert rule installations; adopt installs only reviewed local copies, with writing separately accepted in existing setups.

## Output maintenance

Apply the safety rules' [Maintaining workflow outputs](../../rules/safety.md#maintaining-workflow-outputs) policy and output map. The selected workflow retains its narrower write scope, review gates and provenance requirements.

## Questions and authorization

Before the first human question, read [Question mechanism (QM)](question-mechanism.md) once: use its form/routing/answer contract and the current host's relevant capabilities; load detailed alternatives/recovery or other-host/MCP reference material only if needed. Each workflow's Question points map owns when to ask, prerequisites, exact choices, approval scope and exits. QM grants no state access, execution, new approval stage or permission to change client modes/settings. No question means no QM setup question or capability probe.

Preserve workflow confirmations and exits under the safety rules' **One authorization standard** and QM answer rules. Do not pre-approve execution/publication tools through skill metadata.

`Write` and `Edit` refer to full replacement and a targeted patch respectively; use the host's equivalent file tools while preserving those semantics and the workflow's read-back verification.

## Execution and evidence reuse

Use one transient invocation snapshot: the facts already gathered, not a script/report/profile to create. Load the selected route and needed references only; batch independent permitted local/provider reads using existing tools once prerequisites are known. Return complete decision-critical fields and bounded source sections instead of oversized blobs. Retrieve an explicit unread remainder after truncation; neither batching nor a summary proves complete requested coverage.

Reuse unchanged packaged instructions, resolved facts and complete content bound to immutable object IDs. Do not repeatedly read the same bytes or re-derive pinned diffs. Before dependent writes, recheck relevant local HEAD/index/worktree, effective instructions/configuration, destination, remote refs, protection/checks and request state. Changed/unknown evidence invalidates its dependents; a fixed rejected lease is never refreshed into permission. Readback after success/uncertainty remains mandatory. No reuse crosses an unresolved source, policy, package or approval change.

Run required checks on their actual inputs and reuse established results only while those inputs and applicable policy match. Keep development validation proportional to the change; do not repeat passed suites or run model/site/client checks merely because another phase or file was visited. A required exact-SHA check still needs that SHA. Preserve review gates, state boundaries, requested scan depth and verification; add no speed mode, automatic model/effort change, timing promise or extra question.

## Delegation and checkpoints

Workflows that explicitly name delegation, or a user's explicit delegation request within the caller's existing scope, may use the host's available read-only workers when invocation and active instructions permit. Substantial refactor/test Full scans and large log investigations benefit from bounded assignments; other named independent investigations may delegate proportionally. Small/ordered work, especially ship and adopt, defaults to the parent; this is not a blanket ban on permitted unusually large independent read-only work. Queue within actual available slots and any caller ceiling, never using concurrency as a total coverage cap. Without delegation cover the same scope sequentially or report incomplete. Pass actual package/consumer paths, source identity, exact scope/depth, applicable instructions/overrides, policy context and safety restrictions explicitly; workers may not inherit them. Follow the investigation contract only when the caller loads it, not as runtime autoloading or a no-scan prerequisite. Fresh context is not a filesystem sandbox.

On Codex, the parent owns code edits, Git mutations, provider operations, ledgers, and state writes. Permitted read-only local Git object/metadata inspection is investigation, not mutation; caller/tool restrictions still apply. Workers return findings plus inspected identities/depth, unresolved edges and unread remainder, not a finding count as proof of coverage. They do not execute project code, perform Git mutations or provider operations, read operational state, start another workflow/worker, answer user questions or update aggregate state. Parent reconciliation uses exact identities and permitted own history; available read evidence cannot prove semantic understanding. Process editing clusters and waves sequentially. Keep Claude's existing wave behavior, but never promise a fresh-session mechanism the host cannot provide; continue from the recorded checkpoint in the current session or report the precise resume point.

Refactor/test's normal owning-state steps lazily load `prompts/shared/ledger-helper.md` for the parent's preferred packaged read-only Python 3.11+ ledger validation/retrieval. Resolve `helpers/` from this same loaded package. Missing Python/execution uses that reference's once-per-run Set up Python / Continue without Python / Stop choice; available equivalent tools must satisfy the same complete validation, bounded retrieval and preservation checks. Without them only dependent work stays pending. Do not load/invoke helpers or offer runtime setup during shared-runtime setup, refactor's source-only preview and its report-only exit, source investigations or unrelated commands. They add no writer, migration, permission grants or rule dependency; invalid data and package defects retain their blockers.

Refactor/test/normalize/legal load the [project-state procedure](project-state.md) only at their eligible owning-state entry. Archive and ship's selected archive backup use the [canonical bundle procedure](../../workflows/archive.md#resolve-one-archive-root). The safety rules' **Operational Helm state** section owns canonical paths, owner-only access, unsupported-input preservation and sequential writers; each workflow owns checkpoint evidence and approvals.

Update complete client packages and start fresh sessions. Never write consumer results into the installed plugin.
