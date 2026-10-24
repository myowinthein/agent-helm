# test

Assess important project behaviors, review existing and missing tests, and write or maintain approved cases using the project's actual stack and conventions. Gap scan and Full scan share this workflow on Claude and Codex. Assessment currency, executed verification, remaining gaps, and Git publication are separate outcomes.

## Before starting: scope and boundaries

Read the shared runtime and resolve `{memory_file}`, instruction bridges/overrides, recognized configuration and `git-auto-commit` (default false) before dependent local writes. Publication settings do not select this workflow's branch or completion. Never create, migrate or edit instruction entries or Helm settings.

Test/setup and eligible ledger writes use the same current attached branch: actual main/master, an established feature/maintenance branch or a confirmed environment branch under the shared local-edit helper and project policy. Unresolved or unsupported roles block writes until classified. Recommend tests for related changes alongside a feature or against the environment branch's integrated snapshot, and base for project-wide Gap scan/Full scan, without restricting scan depth by branch role. Eligibility never creates/selects a branch, transfers a checkpoint to base or establishes a safe runtime target; actual test/service effects retain their existing approval and isolation requirements.

Start with static inventory, then offer Gap scan, Full scan or Skip using the baseline and coverage evidence below. Assess the selected scan, report findings and propose exact cases, expected results/evidence, paths, setup changes and verification commands before the approved write/checkpoint path. Pass developer answers unchanged and never interpret them as shell code. Both hosts follow this same workflow.

Initial source inspection is read-only, including on dirty or detached checkouts. Label exactly what was inspected: selected worktree/staged/untracked inputs or a committed snapshot, current branch/SHA when available, and exclusions. A worktree review is advisory, not write/checkpoint provenance. Without usable Git HEAD, static source review remains available but no ledger access, helper execution, runtime-setup question, Git initialization, writes or state migration occur. Use `GIT_OPTIONAL_LOCKS=0` for Git inspection that might refresh the index. Suppress executable diff/textconv, pagers, filesystem-monitor helpers and lazy object fetching with supported capabilities; unavailable local-only reads leave explicit coverage limits.

Static source inspection never runs package scripts, hooks, dynamic config, test collection/discovery, imports, coverage, installers, builds, tests, services or backend dry-runs. For example, collection can execute conftest/config code even without running a test. It performs no checkout/update/fetch, branch/index/ref/file/report write or ledger mutation. Keep output in conversation, with no default report/config artifact. Step 2 alone permits the parent's read-only ledger validation/retrieval. Later writes require a fresh validated prepared snapshot and the missing approvals.

## Pending work and cancellation

Honor invocation auto-commit for every local setup, cluster and ledger commit. Reuse approval already covering the same concrete work; present exact changes when confirmation is required. Declining a commit or a failed write/readback/commit stops subsequent writes and finalization: preserve the actual branch, drafts, index, earlier commits, and preserved inputs. Go to Step 8 without merge/rebase/push/promotion, branch deletion, checkout, or an uncommitted checkpoint advance. Never stash, reset, or absorb unrelated work to continue. No branch cleanup occurs even when earlier clusters succeeded.

A scope-level Skip or plan cancellation before writes creates no checkpoint. After real setup/test work, cancellation preserves that work and reports a handoff, not a no-op. Never push failing tests or treat unavailable required verification as passed.

## Step 1: Static inventory and cheap preflight

Before working-branch preparation, inventory the actual project by package/service/workspace and test layer, including libraries, CLIs, applications, plugins, scripts, and data/configuration surfaces when present. Detect languages, manifests, real lockfiles/package-manager declarations, module/build systems, existing tests/fixtures, runner commands, validators, CI expectations, coverage tools/reports, and runtime/service needs. Exclude vendor/generated output unless it is itself an approved contract target. Exclude all operational Helm state from source discovery; Step 2 alone owns test-log access. Other workflows' state stays opaque even when its paths changed.

Honor effective user/project policy, then establish the intended project command for each selected package/layer from instructions, documented wrappers, package scripts, CI, runner configuration and existing tests. Resolve evidence according to the question: a CI command identifies that job's context, while manager declarations, manifests, lockfiles and workspace configuration establish dependency ownership. No evidence source is conclusive for every tooling question. Explain contradictory or stale evidence and resolve material ambiguity before dependent setup/execution; do not guess a runner or migrate tooling to settle it.

Keep a compact working inventory of each selected area's command, working directory, runtime, runner/config/adapter, package/environment manager and owning dependency/lockfile paths. Identify shared workspace install roots separately from package execution directories; unit, integration and E2E layers can legitimately use different runners. A frontend runner does not establish backend coverage. Reuse project-native or existing tools and conventions before proposing new ones. Native support can avoid adding a framework without proving that the runtime, dependencies or execution environment are ready.

Use this evidence guide as examples, not framework defaults, installation recipes or version pins:

| Stack | Evidence to reconcile |
|---|---|
| JavaScript/TypeScript | Package scripts, manager declaration, actual lockfile/workspace root, runner configuration and separate unit/browser/E2E packages. |
| Python | Project metadata, requirements/constraints, actual environment/lock tooling, runner configuration, CI and existing unittest/pytest conventions. `requirements.txt` is not a universal lockfile. |
| PHP | Composer manifest/lock, scripts, dev dependencies and test configuration; resolve the actual vendor/project runner context. |
| Ruby | Gemfile/lock, Bundler context, project wrappers/Rake tasks and existing test configuration. |
| JVM | Maven/Gradle modules, wrappers, configured plugins/tasks and profiles; distinguish unit from integration-test lifecycle steps. |
| .NET | Solution/project scope, SDK selection, test host/framework/adapter and runner-specific configuration. |
| Go/Rust | Modules/workspaces, toolchain declarations, build tags/features and existing native test commands. |
| Native/mobile | Build system, target/scheme/variant, SDK/device/simulator requirements, platform-specific wrappers and CI execution context. |

Describe readiness from available evidence: declared but unverified, dependency restore needed, missing/incompatible runtime, missing configuration/adapter, or CI-only/another execution context. Mark unknowns rather than diagnosing absence from a directory alone. Cached executables or environment directories do not prove compatibility with the current project/lockfile, and CI evidence does not prove local readiness. Respect intentional CI/container/platform contexts: propose scoped approved execution there or report it pending rather than forcing local installation. Inventory is static: no version/help probes, imports, dynamic configuration or test/task collection. Keep this inventory in the conversation and working context only; do not add tool records to `test-log.json`, a new profile/config file or the ledger schema.

Within the requested scope, also inspect documented requirements, supported runtime/platform/browser matrices and existing property/fuzz, benchmark/load, visual/accessibility, mutation, migration or other specialist tooling/configuration. These are selection evidence, not instructions to run discovery or install tools. Code surfaces can suggest a risk but do not establish a performance target, supported platform or human acceptance criterion.

If a suitable runner is already declared, propose restoring or repairing that setup as needed, not replacing it because dependencies are unavailable locally. If none exists for a selected area, consider suitable native support first, then propose a stack-specific option and at most two meaningful alternatives plus Skip (maximum four choices). Static assessment remains available without installation. An unknown stack yields a bounded manual recommendation, not a generic JavaScript install. Record the setup operation, compatible dependencies and their basis, configuration/scripts, owning manifest/lockfile paths, exact commands/working directories and possible lifecycle/network effects in the plan. When choosing/changing tooling, check official compatibility guidance for the project's actual runtime/build/runner versions rather than defaulting to latest; unavailable evidence leaves that decision pending. Setup waits for Step 4's approval and preparation. Missing capability blocks its affected execution, not independent planning.

Identify the current advisory snapshot, its branch role and actual main/master `{base_branch}` separately. The intended write destination is the same eligible current branch; do not assess a feature and silently write against unrelated base code. Note explicitly identified retained work; branch names alone do not establish role, ownership or resume permission. Do not automatically select/reuse an old `test/*` branch.

## Step 2: Resolve the case ledger read-only

With usable Git HEAD, follow `{package_root}/prompts/shared/project-state.md` and load `{package_root}/prompts/shared/ledger-helper.md` for `.helm/test-log.json` only. The parent prefers packaged Python `ledger-check` for complete schema-3 structural validation, then digest-bound `ledger-view` for bounded indexes/full relevant cases across all states. If Python/execution is unavailable, offer/reuse Set up Python / Continue without Python / Stop once for this run. Approved available equivalent tools may satisfy the same complete validation, safe-path, resource, digest/retrieval and preservation checks, including canonical readback. Without equivalent evidence, keep ledger-dependent edits/writes pending and continue only independent source assessment/planning. Invalid/unsupported input, drift and helper/package defects still block dependent work with files preserved; fallback bypasses none of these. An absent file means no history, not permission to create an empty ledger. Both methods retain the same exists-only unsupported-path guard, without reading or converting old files. Structural success proves no current semantic/source/ancestry/approval or runtime result. No helper writer is added; existing approved persistence still preserves the complete original. Disclose the actual method/unperformed automation in the existing report.

### Schema 3: project anchors and individual findings

Use one current-state ledger, not a per-run journal or an inventory of every existing test. The packaged structural contract, reached through the helper reference, defines the existing schema's field shapes/enums; the following tables and lifecycle rules define meaning. One case represents an independently actionable behavior gap, concrete test-maintenance need or required manual check. One gap can span files and need several tests; one test can protect several gaps. A file can have many cases with different priorities and states. Preserve unknown fields on every read-modify-write; never reconstruct a document from helper pages or index rows.

| Root field | Meaning |
|---|---|
| `schema_version` | Exactly `3` for this structure. |
| `assessed_commit` | Complete Full scan / Gap scan source baseline, or null/absent when none exists. Never test success. |
| `full_scan_commit` | Latest complete whole-project source assessment, or null/absent. Replaces the old boolean. |
| `cases` | All recorded findings, including resolved and obsolete ones. Derive summaries from these records. |

Do not store per-file priorities, scan counters, branch identity, tool inventory, repeated run summaries or root test results. Recommend Full scan from actual impact/uncertainty rather than a fixed number of Gap scans or Git commit distance.

| Case field | Required meaning |
|---|---|
| `id` | Stable unique opaque ID, for example `g-` plus a random UUID. Never derive identity from priority, filename or title. |
| `expected`, `basis` | Concrete expected behavior/maintenance result and an array of actual document/contract/test/code references or owner decisions. When intent is unknown, describe the unresolved question instead of inventing its answer. An enum such as docs alone is insufficient; code-only intent remains explicitly inferred. |
| `paths` | Related project-relative source, configuration, fixture and consumer paths. Never execute path/reference text as code. |
| `priority`, `reason` | high/medium/low/unknown and the project evidence or missing information behind that judgment. |
| `action` | add/improve/consolidate/replace/remove/manual. Optional `layer` identifies the fitting test layer. Keep alone is not a finding. |
| `state` | open/resolved/obsolete. Selection, deferral and execution failure are not lifecycle states. |
| `assessed_commit` | Actual source of this case's last judgment. Reuse does not acquire fresh provenance. |
| Optional `tests` | Array of actual existing/protecting file-and-case references. Planned output paths remain in the plan until they exist. |
| Optional `blocker` | `{kind, note}` for clarification/execution/verification, last observed while open. Revalidate it; never use it as a tool/version inventory or a global claim about host readiness. |
| Optional `decision` | `{type, note, date, commit}` for an explicit human deferred/accepted-risk decision. Keep its exact context, including after closure; never infer it from nonselection. |
| Optional `closure` | Required for resolved/obsolete: `{reason, refs, method, outcome, commit}`, plus `command` and `scope` for runtime evidence. See Step 6. |

A dummy structural example, not live records or executable inputs:

```json
{
  "schema_version": 3,
  "assessed_commit": "aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa",
  "full_scan_commit": "aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa",
  "cases": [
    {
      "id": "g-b79901f4-445a-49cb-a072-22eecbbf4b71",
      "expected": "Retrying an order cannot create a second charge",
      "basis": ["docs/orders.md#idempotency"],
      "paths": ["api/orders.ts"],
      "priority": "high",
      "reason": "The documented one-charge contract lacks retry protection after a handler change",
      "action": "improve",
      "layer": "integration",
      "state": "open",
      "assessed_commit": "aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa",
      "tests": ["api/orders.test.ts::retry"]
    }
  ]
}
```

Validate required fields/types/enums, unique IDs, safe references and state/closure consistency before dependent use. Serialize cases deterministically by ID without changing identity or dropping fields. Store secret-free evidence/commands, never credential values, raw environment dumps or uncontrolled runner logs. A resolved case needs evidence that its identified need was addressed; obsolete needs current contract/consumer evidence. Neither claims all current tests pass. Do not automatically prune closed records, collapse them to a file priority or create cases for already adequately covered behavior merely to fill the ledger.

### Contextual validity

Only schema 3 is supported. No old-shape reader, case conversion or automatic reset is available. Preserve unsupported inputs and direct the developer to the one-time upgrade guide before another recorded assessment.

Resolve stored anchors as commit identities only, not revision expressions or shell arguments. Records use full literal commit IDs; unavailable local objects remain unknown evidence. Check availability/ancestry against the relevant inspected snapshot and revalidate after preparation/history changes. When recording closures, validate code/evidence commit B against the actual accepted lineage including approved setup/test overlays; B need not be an ancestor of the earlier frozen assessment source A. Disable lazy fetching for these reads. Failed comparisons are errors, not empty diffs; never fetch missing history, guess HEAD~1 or replace old anchors with an uninspected merge tip.

- Missing/unavailable/non-ancestor root baseline: offer Full scan or Skip. Preserve it until an eligible complete Full scan establishes the new baseline.
- Stale/unavailable case judgment or closure context: reassess within scope. Code, tests, fixtures, requirements, dependencies, configuration and consumers all matter; unchanged source bytes alone prove nothing. Historical closure remains historical evidence, never a current pass or an instruction to reopen automatically.
- Human decisions remain actual human facts. Apply a prior deferral/accepted-risk choice only to its demonstrated unchanged context; changed context requires renewed review, not a file-wide skip or automatic permission to edit.

Match existing IDs to their actual meaning, then reconcile semantically by expected behavior, evidence, layer and related code. Preserve identity through demonstrated continuity, including moves; path/title equality or fuzzy rename detection alone is insufficient. Surface uncertain duplicates or same-ID/different-meaning conflicts for explicit reconciliation. Never auto-union branch histories, overwrite another case's decision or create a new ID for every repeated report. Keep out-of-scope cases intact. Reopen only on evidence that protection was lost or the required guarantee changed, explaining the reason and retiring the active stale closure while Git retains prior versions.

Earlier scans cover only their actual scope and techniques. New plugin guidance neither certifies additional coverage nor by itself forces a rescan. Reassess relevant changed/requested context and report unknown prior coverage honestly.

## Step 3: Assess scope, behavior, and proposed cases

### Full scan / Gap scan

At actual assessment, read `{package_root}/prompts/shared/investigation-evidence.md`; keep this workflow's own state, static-inspection, branch and approval boundaries. Use Full scan / Gap scan in choices/reports. Inventory and assign every scoped component independently of prior findings, with evidence-based exclusions and exact identity reconciliation.

With valid baseline/comparison, inspect the diff through the advisory snapshot, then revalidate it through `{assessment_head}` after preparation. Use name/status information and relevant diffs for additions, modifications, deletions, possible renames, and consumer effects. Tests, fixtures, configuration, schemas, dependencies and shared utilities can create actionable risks even without production-file edits. Follow evidenced callers/contracts; unchanged callers can be affected by internal semantic changes too. Bounded reference searches provide evidence, not a fixed-hop guarantee. Unknown/broad impact recommends broader review or Full scan, with limitations explicit.

If the advisory scope includes staged/worktree/untracked inputs, inspect those selected changes in addition to committed-range evidence; a baseline-to-HEAD diff cannot describe them. Keep their provenance separate and never use dirty/untracked input as a committed assessment checkpoint.

Gap scan assesses complete impacted logical behaviors, existing cases and evidenced consumers, with sufficient surrounding implementation/configuration context rather than only diff lines. It does not require a refactor-style full-file audit of every unchanged file. Small scopes normally stay with the parent; large independent areas may delegate under the same read-only evidence contract. Gap scan assesses the complete diff-derived impact scope, including affected existing cases and new-gap discovery through relevant test/configuration/dependency/consumer context. Also expose every retained open finding, grouped/count-summarized when large, including unchanged unselected cases. Reassess a retained case before proposing current work on it; an unrelated older backlog item need not trigger a fresh whole-project review or block the diff-derived assessment anchor. Never strand it behind that anchor. Case selection does not pull unrelated backlog into edits. Deletion alone does not prove obsolescence; follow Step 2 identity/evidence rules.

Full scan inventories and assesses every scoped component's behaviors and all relevant existing tests in detail. Read protecting tests, assertions, discovery and fixture responsibilities; trace behavior-bearing implementation, configuration and cross-component paths against the intended contracts. No fixed list of security/payment/parser hotspots substitutes for coverage of other domain behavior. Executable glue or declarative behavior settings are not metadata-only by name; context-only reads need evidence of their limited role. Test counts/coverage percentages, grep hits and a representative sample alone prove no adequate protection. Cite the actual cases when claiming behavior is protected, with runtime success separate.

Split coherent areas into bounded read-only chunks, with at most eight chunks per batch and never more concurrent workers than the host permits; queue further batches until the intended scope is covered. This batch ceiling never caps coverage. Prefer permitted subagents for substantial Full scans; otherwise cover the same queue sequentially and report fallback. Give workers exact paths/behaviors, snapshot, package/workspace paths, applicable instructions, required depth and safety restrictions. Workers return findings plus inspected identities/depth, no-finding areas, unresolved cross-component edges and unread remainder. The parent reconciles exact assignments, duplicate findings and cross-cutting behavior/test flows, with risk-based rereads of important claims. All code/Git/ledger writes remain with the parent on Codex; writing stays sequential on both hosts. Unmet required inspection remains partial under schema-3 checkpoint rules, never a complete source assessment.

When this workflow reaches a Full scan / Gap scan depth choice, read `{package_root}/prompts/shared/scan-scope.md` using only its already permitted request, source/anchor-validation result, impact evidence and prior-coverage facts. The helper grants no additional state access or execution permission.

Default choices remain Gap scan / Full scan / Skip when the incremental baseline is usable. Preserve the existing Full scan recommendation for no tests, no established prior Full scan, unusable baseline or insufficient/broad impact evidence. The separate Full-scan anchor is this workflow's prior-coverage fact, not a shared schema invariant or a reason to interpret log/manifest's unknown Full-scan history as proof no Full scan occurred. A local unknown may instead need clarification or case reassessment. No counters, fixed file counts or Git-distance thresholds are introduced. Malformed/conflicting state still blocks dependent work under Step 2; Full scan never bypasses its reviewed rebuild/reset rules. Retained backlog, schema-3 case selection and assessment/closure checkpoints keep their existing contracts. Keep native questions within four options, with runtime's faithful fallback.

When no relevant changes are found, say "No new relevant changes found since {snapshot}; {retained open findings and evidence limits}." Offer relevant backlog work, reassessment or Skip when findings remain. Never say "tests are up to date" merely because a diff is empty or a prior Full scan ran. A genuine no-op exits without preparation, refreshed provenance, migration or an empty ledger commit.

Before declaring that no-op, account for an explicit new technique or existing-test maintenance request, or changed requirements, support matrix or risk context even if production bytes are unchanged. Such work remains within its selected scope; a plugin update alone triggers no forced review or checkpoint write.

### Behavior/risk assessment

Judge the residual risk left unprotected by the missing/weak test, not a module's reputation or the mere existence of code. Explain expected behavior, consequence, credible regression likelihood/exposure and actual missing protection for every proposal. Adequately protected behavior needs no additional proposal.

| Priority | Criteria |
|---|---|
| **High** | Evidenced exposure to severe consequences, even if rare; or meaningful consequences with credible high regression likelihood/exposure. |
| **Medium** | Meaningful but recoverable failure of supported behavior, without evidence warranting High. |
| **Low** | Useful protection against minor consequences or limited edge cases. Do not invent filler cases. |
| **Unknown impact** | Important intent/impact is unconfirmed. Store `unknown`, name the missing information and use the Clarity Check; never silently downgrade or claim confirmed severity. |

Use concrete project consequences, not numeric scores or fixed category severity. An auth/API/money label, silent wrong output, test layer, LOC or coverage percentage alone cannot determine the tier. Escalation needs evidence. Existing strong protection is not another High gap. Cost/setup readiness stays separate: blocked/expensive High remains High. Pure consolidation/removal is labelled cleanup and excluded from the default risk recommendation unless explicitly requested or needed to restore meaningful verification; its real evidence determines priority, not the action label.

Apply these perspectives only when the project exposes the behavior or requirement:

| Perspective | Evidence and useful cases |
|---|---|
| Main flows and contracts | Core calculations, command/API/library outputs, compatibility and supported inputs. |
| Boundaries and invalid inputs | Actual validation rules, empty/missing/limit values, malformed data and documented invariants. |
| Errors and dependency failures | Observable error contracts, timeouts/retries, partial failures and recovery paths. |
| Access and data isolation | Authentication/authorization boundaries, roles/tenants and sensitive-data handling. |
| Persistence and state | State transitions, transactions/rollback, serialization and lifecycle behavior. |
| Integration and user flows | Real component/service contracts and critical cross-module journeys; UI/accessibility where applicable. |
| Time, concurrency and idempotency | Evidenced asynchronous ordering, duplicate events, races and repeat-operation guarantees. |
| Performance/resource requirements | Defined constraints or observed regression risks, with appropriate bounded checks. |

Choose the lowest fitting unit/component/integration/contract/E2E layer that can prove the behavior. Check existing assertions and cross-module coverage before adding tests. Prefer targeted extensions to useful existing cases; do not create tests for every file or every lens, mirror implementation, or multiply trivial assertions to increase counts.

### Maintain existing tests within scope

Keep useful tests unchanged by default, regardless of author or generator. Review existing tests connected to the selected behavior and affected dependencies; do not expand Gap scan work into whole-project cleanup or require a disposition for every case in Full scan. Keeping a test after static inspection does not certify that it passes. Distinguish reviewed-kept, unclear/deferred and out-of-scope/unassessed cases.

Where there is a concrete maintenance need, propose a case-level action:

| Action | Evidence and intended result |
|---|---|
| **Keep** | The test protects a current contract or past regression, or evidence is insufficient to change it. Preserve the case; route unresolved intent to the existing clarity check. |
| **Improve** | The purpose remains valid but assertions, input coverage, fixtures, isolation, cleanup or reliability need a targeted change. Correct a stale expectation only from established intended behavior, never merely to match current code. |
| **Consolidate** | Related cases can share clearer structure or parameterization while preserving every relevant input, assertion and required guarantee, with identifiable cases. Similar-looking code alone is not a reason. |
| **Replace** | The mechanism needs a different approach, but required protection remains. Map each old responsibility to the replacement and explain any proposed change of layer or lost guarantee before approval. |
| **Remove** | Authoritative evidence confirms the behavior is obsolete with no remaining supported contract, or established remaining tests provide equivalent protection at the required layer/environment. No unique required guarantee may be lost. |

Compare behavior/assertions, fixtures, layers, environments/support targets and regression purpose, not just names, file size, test counts or shared line coverage. Unit and integration cases exercising the same lines may protect different guarantees. Failing, flaky, slow, skipped/xfail, generated or unknown-provenance status does not establish obsolescence; investigate within scope or preserve and defer. Do not remove a test to hide a live product regression or invent intended behavior to make it pass.

For each proposed change, put exact paths and case names/IDs, action, reason/evidence, relevant issue/history references, preserved guarantees and verification commands in the existing plan. Consolidation/replacement needs an old-to-new mapping of scenarios/assertions and relevant fixture/snapshot responsibilities; removal names the confirmed obsolete contract or exact remaining coverage. Check CI selectors/tags, case-ID filters, shared fixture consumers and documented references before proposing renames/deletions. Unknown consumers or uncertain equivalence leave the affected change pending. Only remove fixtures/support files when their lack of remaining consumers is established and their exact paths are approved. Preserve meaningful regression/issue context in surviving cases or the reviewed commit description, without adding another tracking artifact.

The existing concrete plan approval covers its listed edits, consolidation, replacement and removal; no five-option/per-case picker or extra universal approval is needed. Include the detailed maintenance proposal before approval and reconfirm material scope or mapping changes. These actions do not authorize production fixes or redesign.

### Select techniques that fit the project

Keep the eight behavior perspectives above. Levels, purposes and techniques overlap: an API abuse case may be both an integration and security test. Recommend a specialist technique only when relevant project evidence or an explicit developer need identifies the risk and a meaningful expected outcome can be established. Choose the lowest layer that demonstrates that particular risk; a unit substitute cannot establish browser compatibility or a visual result. Reuse suitable native/existing tooling first, and route any justified missing tooling through the existing setup proposal and approval, without a separate install path.

Use this guide as examples, not a mandatory checklist or an exhaustive list. Consider all evidenced needs within scope, without inventing cases for every row or hiding important risks behind a fixed recommendation limit:

| Evidence or need | Candidate techniques | Useful expected outcome |
|---|---|---|
| Parser, serializer, calculations or complex inputs with meaningful rules | Property-based tests, fuzzing | Defined invariants, semantic results or relevant robustness/error guarantees over constrained generated inputs |
| User interface/design components and supported browsers | Accessibility checks, visual regression, browser/device checks | Applicable accessibility behavior, reviewed visual references and confirmed supported targets |
| Library/CLI with declared runtime/OS support or packaged distribution | Compatibility, installation and upgrade tests | Public contracts and supported installation/upgrade behavior on selected declared targets |
| APIs, roles, untrusted input or tenant boundaries | Contract, negative and security abuse cases | Correct responses and enforced access/data boundaries under applicable adversarial inputs |
| Queues, jobs or distributed operations | Concurrency, retries, idempotency, controlled failure/recovery | Agreed ordering, duplicate handling, recovery and preserved state guarantees |
| Database migrations or versioned data | Migration, upgrade and backward-compatibility tests | Expected schema/data transformations and promised compatibility on synthetic old/new fixtures |
| Defined latency/throughput/resource needs or evidenced hot-path regressions | Benchmarks, bounded load; stress/soak when justified | Agreed measurements and limits under a specified workload and environment |
| Critical code with potentially weak assertions | Scoped mutation testing | Evidence that relevant artificial faults are detected, with surviving/equivalent/inconclusive cases reviewed |
| Business acceptance or ease-of-use questions | Acceptance scenarios and human usability review | Owner-agreed acceptance criteria and separately evidenced human findings/sign-off |

Include recommended techniques and their reasons in the existing case plan: evidence/risk, layer and scope, expected outcome and its source, proposed paths/tooling, execution limits and any manual requirements. Describe material exclusions or prerequisites without a separate all-types picker or new configuration. An unsupported stack or missing criterion yields a bounded recommendation or the existing clarity/defer choice, not a generic install or invented requirement. An identified but unselected technique remains a reported gap where applicable, not unfinished selected work or an invented human skip.

Use technique-specific checks when applicable:

- **Property/fuzz:** derive meaningful properties/input domains from contracts or clarified requirements, rather than duplicating the implementation. A round trip or absence of crashes proves only that stated property. Plan replayable failure examples/corpus and seed/settings when the tool provides them; retain only reviewed synthetic regression fixtures in approved paths, never secrets or uncontrolled generated output.
- **Visual/compatibility/accessibility:** use the agreed supported matrix and controlled rendering conditions. Initial or changed image references need review against intended output, reusing valid supplied approval; generating or accepting a baseline is not itself a regression pass. Automated accessibility checks cover only their tested rules/surfaces. Identify needed keyboard, assistive-technology, real-device, usability or business acceptance work separately; an automated result cannot supply human sign-off.
- **Performance/recovery:** source workloads and thresholds from actual requirements, established comparable evidence or explicit agreement. Do not invent an SLO or claim a pass without a defined criterion. Where only measurement is possible, offer clearly labelled characterization under the existing clarity choice. Recovery/migration cases need meaningful before/after invariants and applicable supported upgrade paths, not merely a command exiting successfully.
- **Mutation/security:** inspect surviving mutants rather than rewriting assertions to chase a perfect score; equivalent, uncovered and timed-out outcomes are not interchangeable. Mutants run in isolated tool-owned copies and must never enter production edits or commits. Security cases prove their specific boundaries, not a penetration-test or security certification; intrusive scanning/pentesting requires its own concrete reviewed scope and target authorization.

### Behavior Clarity Check, selection and approval

Establish intended results from explicit contracts, documentation, existing tests, relevant code evidence and developer clarification. Code demonstrates current behavior and may contain a bug; a visible validation branch can support a real boundary case without inventing requirements. Compare contradictions rather than silently encoding one side as correct.

Batch related unresolved cases into the plan. Offer **Clarify and proceed / Characterize current behavior / Defer this case**. Characterization requires an explicit current-behavior choice and clear labeling of limitations/known contradictions; it does not replace the intended contract or authorize a production fix. An unclear finding remains open with a clarification blocker; record a deferred decision only when the developer actually defers it. Accepting risk is likewise an explicit contextual decision, not resolution or edit authorization.

Separate adequately protected/covered-elsewhere behavior (cite the protection), kept useful tests (no automatic adequacy/pass claim), unknown intent, execution blockers and required manual work. Do not disguise blocked/unclear/manual work as no-test-needed or fill Low with redundant proposals. Record meaningful findings, not every kept/passing test.

For each proposal show the durable finding ID when present, expected result/evidence, priority/reason, action, layer, paths and prerequisites. New report proposals may use aliases P1/P2 that map unambiguously to stable IDs at the assessment checkpoint; aliases never encode priority or persist as another ID system. Group display by module/behavior; categories, layers, techniques and priorities are overlapping filters, not exclusive queues. Count one finding once across views. For large reports, summarize by module/tier with reasons and expand/page details without hiding proposed edits or truncating independent choices.

Use the same selection semantics for Full scan and Gap scan. For a small clear set, go directly to its concrete proposed plan and existing approval, accepting free-text refinements. For a larger set, offer one scope question:

1. **Recommended**: exact listed ready proposals and reasons. Full scan normally starts with actionable High; Gap scan also includes relevant Medium in its changed surface. Adjust from actual evidence, never silently broaden scope. If empty, say so and omit this option rather than inventing work.
2. **All ready proposals**: explicitly listed ready ordinary work, including labelled cleanup.
3. **Choose cases or groups**: IDs, module/behavior/category or tier filters, exclusions, supported independent picker pages or chat. Do not force whole-module selection or assume native multi-select exists.
4. **None**: no test/setup edits; gaps remain recorded if an assessment-only write is authorized. This is not Cancel or permission to write the ledger.

Keep blocked, unknown-intent and expensive/intrusive work visible separately. Include it only through explicit selection and concrete reviewed setup/limits/manual requirements, not silently through Recommended/All. A recommendation/default is never selection or authorization. Follow runtime's faithful-interface/chat fallback; silence, timeout, missing answer or unsupported multi-select never means all.

Before approval, resolve prerequisites and coherent replacement/fixture mappings. List required dependent edits as required by the selected IDs; do not silently add independent unselected cases. Each case keeps its own priority; sequence an indivisible unit by its highest-priority member without relabelling the others. If a prerequisite is excluded, explain and revise/defer dependents. Explicit maintenance requests remain eligible even when ordinary risk recommendations omit cleanup.

Show the complete selected plan: source snapshot/destination, cases and expected results, exact paths, action/mappings, remaining gaps, setup, safe execution commands/targets, coverage, commit units and the assessment/closure ledger writes described in Steps 4/6. Ask **Write or maintain selected tests and approved setup / Cancel** before the selected test/setup writes. Reuse existing exact authorization; custom scope selection alone is not approval. For ledger-only work use **Record assessed findings / Cancel** only when that concrete write lacks authorization. None/silence is never a ledger approval. The existing Git commit policy still applies; do not add per-case/per-stage prompts for already approved work.

## Step 4: Prepare selected writes and safe execution

Only now apply **Prepare the current branch** from `{package_root}/prompts/shared/content-sync.md` for selected test/setup or meaningful checkpoint writes. Require clean eligible state on current actual main/master, an established current feature/maintenance branch or a confirmed current environment branch. Unresolved/unsupported roles block writes without switching/updating/creating one. Re-resolve effective instructions and the canonical own-state file on this branch before dependent work.

Immediately pin clean source HEAD as `{assessment_head}`, before setup/framework/test/ledger commits. If it differs from the advisory plan's SHA or source branch, show the difference and reassess/reapprove affected work before writing; do not rely on filename intersection or silently transfer feature-branch assumptions to main. A changed plan's policy/settings require reconciliation. Preserve this source baseline throughout the run, through all approved local units. Approved setup/test changes are identified outputs/overlays, not permission for unrelated source drift. Re-read affected context after setup, but never replace the source baseline with an install/test commit just for convenience.

### Save assessed findings before implementation

Before test/setup edits or execution, apply Step 6's assessment checkpoint on this clean eligible branch. Reconcile all actually assessed findings, generate/validate stable IDs for new ones and show their report-alias mapping. Save every meaningful in-scope finding, including unselected, blocked and unknown-impact cases, not only those selected for work. Preserve out-of-scope and closed records. Include contextual human decisions only when actually given. Old-schema replacement requires its separately established concrete rebuild/reset authorization, reused when already part of the approved plan.

A complete Full scan sets both root anchors to `{assessment_head}`. A complete Gap scan of the entire diff-derived scope advances only `assessed_commit`, retaining older backlog and its actual case provenance. A missing/invalid baseline requires complete Full scan for global replacement. Partial assessments may save supported cases but leave both anchors unchanged/null; omitted/unreadable components do not become complete via a blocker label. No dirty advisory input becomes a committed checkpoint without fresh matching source assessment.

Use the normal exact-path ledger write/readback/commit procedure, with meaningful-change suppression. A prior valid identical checkpoint needs no repeat commit. A declined/failed write or commit stops later setup/test writes, preserving drafts/sources. Once accepted, this checkpoint survives later test failure/cancellation: source assessment is separate from implementation success. An authorized assessment-only checkpoint is valid with no test edits selected or execution deferred. No-op, unapproved and pre-write Cancel paths create nothing.

### Review execution effects

Before any installation, collection, test, coverage, build or service command, inspect its actual scripts/configuration and targets. Identify required runtimes, credentials without values, network/service/container/database/filesystem effects, resource/time expectations and owned cleanup. Use isolated synthetic fixtures, temporary resources and explicit test environments; no real user data, secrets in output, assumed disposable DB, or implicit production/external actions. Reuse safety.md's confirmations for evidenced destructive/migration/deployment/external effects; ordinary approved safe tests do not need a duplicate permission gate. Unknown safety or missing capability blocks affected execution and dependent actions, not static planning.

For selected specialist execution, make relevant limits concrete in that same plan: fuzz/input size and iteration/time limits; load rate, concurrency, duration and stop conditions; mutation modules/operators and timeout; selected platform/browser targets; and fault/migration resources, recovery and owned cleanup. State target identity, approved test environment, expected costs/network effects and artifact paths where applicable. Expensive stress/soak, operational fault injection/recovery drills and intrusive scans are never implied by Full scan or a general test approval. Do not create infrastructure, alter CI/deployment matrices, use shared/live targets or upload artifacts as an incidental setup step; those effects need their own reviewed scope and authorization. Missing criteria or capability leave the affected execution pending without expanding scope or relabelling it passed. Ordinary approved bounded tests, including simulated failures in isolated fixtures, use the existing gate, not an extra universal confirmation.

### Restore, add, repair or upgrade setup

Name the actual operation before executing it; missing local dependencies do not authorize a new framework:

| Operation | Reviewed scope |
|---|---|
| Restore | Recreate the declared dependency environment with existing selections and project policy. It is not a dependency update. |
| Add | Introduce a justified missing runner/adapter or test dependency, including compatible versions, scripts/configuration and affected dependency files. |
| Repair | Correct an evidenced setup/configuration fault with the smallest explained change, preserving legitimate runners and layers. |
| Upgrade | Deliberately change selected versions/toolchain requirements, with compatibility and affected dependency/configuration changes explained. Never infer this from a failed restore. |

Use the actual package/environment manager and dependency policy, including reviewed shared workspace ownership and dev/test dependency groups. Show exact commands/working directories, expected dependency/configuration/lockfile changes, downloads, lifecycle/pre/post hooks and cleanup. Inspect implicit restore, build or provisioning effects in test commands and wrappers too; a command named test is not necessarily read-only. One existing concrete plan approval can cover its setup, known effects and verification; changed scope/effects require updated review, not duplicate prompts for unchanged work.

Do not create a lockfile, switch managers/registries, refresh unrelated dependencies, install globally, replace/provision runtimes or fetch credentials as incidental recovery. Runtime/toolchain provisioning needs its own reviewed scope and authorization, which may be included explicitly in that same plan. Offline/private-registry/auth failures remain blockers, without bypassing project/security policy. If restore unexpectedly changes dependency selections or other files, stop dependent work and review the actual diff; preserve drafts and never reset/delete files to force a clean result. Stop on setup failure, reporting completed steps and affected pending work.

After approved setup, read back exact changes and re-resolve the intended project command/configuration. Within the approved scope, verify the actual runtime/runner and relevant configuration/adapter using safe command output and real discovery/execution evidence. Installation success, an executable's presence, version output or exit zero alone does not prove that the intended tests ran. Do not invent a smoke fixture, weaken filters/assertions or force unrelated cases just to obtain a pass. Zero cases is limited evidence; when no cases exist, keep execution verification pending until approved real cases are available, without blocking independent planning/authoring. A genuine test failure can show the runner executed while test verification remains failed; distinguish configuration/discovery/harness failures from behavior failures. Reuse suitable baseline/cluster results instead of repeating runs merely for setup verification.

Commit an accepted setup logical unit separately only when it has reviewed tracked changes and its required checks passed, under invocation policy. A restore with no tracked changes needs no empty setup commit. Deferred/unavailable required verification leaves setup drafts pending and uncommitted; later Skip/cancel preserves actual earlier work and accepted commits.

Run an appropriate safe existing-test baseline for selected modules/layers after execution approval, once per relevant snapshot. Record exact commands, exit/collection/outcomes, pre-existing failures, environment/tool errors and verification scope. No existing cases is a disclosed baseline, not successful proof. A pre-existing failure is not automatically caused by new tests and never authorizes a production fix or bypasses required checks. A whole-suite baseline is needed only when impact or project policy requires it.

### Coverage evidence

Use an existing report only with known source/command/scope provenance, labeling stale or partial evidence. Run an available appropriate coverage tool only through the approved execution plan. Record tool/command, selected packages/files, relevant inclusion/exclusions (including whether untouched files are absent), and measured metrics actually produced. Unknown coverage is unknown, never zero or an invented static percentage. Respect existing thresholds; do not install instrumentation, change exclusions or lower thresholds without an explicit reviewed change. No coverage tool or unsafe/unavailable coverage execution does not prevent useful static assessment/test design.

Full scan means complete static assessment, not compulsory full-project runtime coverage. Every component must actually be reviewed to advance both root anchors; partial assessment saves only supported cases without global advancement. Runtime-blocked execution can coexist with complete static assessment, never with a false verification claim. Selected unfinished work remains open and blocks completion/closure, not an already accepted assessment checkpoint.

## Step 5: Write and verify coherent clusters

Group approved cases into bounded coherent domain/module units with the reviewed prerequisites/mappings, then process sequentially by priority. Unrelated features do not share a commit just because both are High; a shared fixture alone does not merge a whole module graph. Every member retains its own priority and explicit selection. Preserve project naming/placement conventions. Large units can use coherent sequential batches with an actual completed/pending list.

Write tests that assert meaningful observable results, errors or invariants and would detect the intended regression. Use realistic controlled fixtures and mocks at actual external boundaries without mocking away the behavior being tested. Keep cases independent; control time/randomness and await actual conditions instead of arbitrary sleeps. Include cleanup on failure. Avoid tautologies, implementation duplication, fragile internal-call assertions, blindly accepted snapshots and accidental real side effects. Parameterize when shared setup/assertion shape remains clear with useful case IDs; there is no rigid three-case requirement.

For each cluster:

1. Write or improve only the approved cases/setup adaptations, preserving old protections while replacements are developed and verified where compatible; re-confirm material behavior or scope/mapping changes. Production bug fixes/refactors require a separate reviewed plan, not an automatic "make green" edit.
2. Run focused relevant tests, inspect collection and actual assertions/outcomes, and compare against baseline. Verify new/improved cases and relevant old cases together where their contracts remain valid and the harness permits it. Repair generated tests, approved existing-test weaknesses or harness mistakes within scope. Never weaken valid expectations, mark cases skipped/xfail, delete regressions or bless snapshots merely to pass. A passing replacement alone does not establish equivalent protection. Stop on unresolved failures, capability/safety gaps or unrelated source drift; keep earlier verified commits and actual pending work.
3. Retire only approved old cases after the mapped replacement or established remaining coverage is verified. A genuinely superseded expectation need not pass first: show authoritative contract-change/obsolescence evidence independent of current implementation, owner approval naming the affected case, and that its failure/irrelevance belongs to that exact assertion rather than setup or other live guarantees. Record the old baseline failure and reason for supersession; do not report it as passed. Corrected expectations must remain specific and preserve other required assertions. Pure removal has no invented replacement: verify its contract/consumer evidence and relevant remaining cases. Check actual discovery, selectors and expected scenario/assertion preservation after retirement; explain removed/renamed/parameterized cases using reporter evidence rather than raw count or coverage equivalence. Run required affected checks on the final cluster tree before its commit; unrelated required failures remain blockers.
4. Review the complete proposed diff/index and commit only exact verified cluster paths, including approved removals, under invocation policy, for example `test({scope}): maintain tests for {feature}` or `test({scope}): cover {priority}-priority {behavior}`. Infer domain scope from the changes, not the priority label. Do not absorb user work or other operational state. A failed final check leaves actual edits pending under the existing failure policy, without claiming rollback or successful maintenance.

If execution is unavailable, an explicit **Draft unverified tests / Leave pending** choice may authorize drafts only. Label them unverified and retain them uncommitted, without case closure, final completion, integration or publication; a supported accepted assessment checkpoint remains. Do not convert unavailable checks into passes. When the user already explicitly deferred execution, honor that constraint and offer only the permitted static/draft path.

When verification is deferred/unavailable, preserve existing protecting cases, assertions and required fixtures. Approved additive drafts can proceed under that draft-only rule; describe consolidation/replacement/removal that retires protections in the plan as pending verification instead of applying the destructive step. Do not weaken an existing assertion or change discovery so that an unverified draft silently substitutes for the old test. If interruption/failure occurs after an approved retirement edit, preserve/report the actual partial tree under the existing pending-work policy; never claim original tests remain intact or automatically reset user work.

After coherent clusters, run the justified affected/regression checks needed to validate their combined final tree, including shared fixture/config effects and required project checks. Reuse still-applicable baseline/results; do not run full suites or coverage repeatedly per file without a reason. Changed inputs, failures or remaining concerns justify renewed checks. Distinguish discovered/collected/executed cases, skips/todo/xfail/unexpected outcomes and possible flakiness using actual reporter evidence; a successful process alone does not prove all relevant tests executed.

For specialist work, inspect its actual evidence as well: exercised input domain/replay details, visual reference approval and actual comparisons, tested matrix entries, measured workload/results against agreed criteria, mutation outcomes, or before/after recovery assertions. Distinguish harness failure, incomplete/aborted runs and findings requiring human review from a tested success. Do not broaden "no failure found in this bounded run" into a universal guarantee. Selected unresolved baseline approval or required manual acceptance remains pending under the existing completion gate; optional unselected human follow-up is reported separately.

After a coherent accepted unit and its required checks, apply Step 6 to the specific findings actually addressed. Adding one test never closes other cases in its file. Multiple findings may cite the same real test only when its assertions prove each guarantee. Deferred/unavailable verification leaves findings open; preserve existing protecting tests and actual drafts. A code commit without a completed ledger closure is an honest pending handoff, not permission to infer runtime success later.

## Step 6: Persist assessments and supported case closures

This procedure is called for Step 4's pre-implementation assessment and for later accepted case updates. It does not require test success to remember a completed assessment. Test/setup failure never retroactively invalidates a committed assessment; it leaves affected cases open. After a declined/failed write/commit, execution failure or unresolved source drift, stop subsequent writes and report the actual state. Never advance a closure from unfinished work or rewrite earlier accepted checkpoints to hide failure.

### Case lifecycle and evidence

- **Open:** an identified need remains. Unselected, blocked, unknown-impact, explicitly deferred/accepted-risk and pending-verification cases remain open. Selection is run intent, not a durable decision field or standing authorization. Do not persist selected/not-selected flags, display aliases, install inventories, full command logs or draft/failure histories.
- **Resolved:** the specific protection/maintenance/manual need was addressed with supported closure evidence. Require `closure.reason` tested/equivalent-protection/static-contract/manual-signoff, concrete `refs`, method runtime/static/manual, actual scoped `outcome` and the relevant accepted code/evidence `commit`. Runtime closure additionally records the actual `command` and `scope` (including relevant target/platform/context). Static equivalent protection or a changed expectation is labelled static, never a passing test. Manual sign-off must be real and attributable, not inferred from automation or plan approval. Preserve guarantee/mapping requirements for test consolidation/replacement/removal.
- **Obsolete:** current contract and consumer evidence establishes that this finding no longer applies. Require an obsolete closure with refs, method, outcome and evidence commit. Absence from a report, a deleted filename or unavailable tooling is insufficient. Keep the record rather than automatically pruning it.

Keep each case's evidence, priority/reason, action and last actual judgment after closure, preserving contextual human facts and unknown fields. A `blocker` describes an open case's last-observed limitation; clear it when it is actually overcome or the case closes, without treating changed local tooling as project-wide readiness. On meaningful context change reassess the decision/blocker; preserve its human history through Git rather than silently turning accepted risk into resolved. Do not stamp reused cases with a fresh assessed commit merely because another case was fixed.

For runtime proof, first verify the actual relevant tests/assertions and required final checks, then accept their exact-path code/test commit B under invocation policy. Confirm B contains the same executable inputs/tree that produced that evidence; account for any environment/config/fixture and later edit effects. Reuse matching evidence without rerunning solely because committing changed the SHA; changed inputs require the affected checks again. A later ledger-only commit C records `closure.commit = B`, never its own not-yet-known SHA or an identity guessed from blame. Closure may reference an existing accepted commit when no code change was needed, with actual corresponding evidence. Batch closures after coherent accepted work where appropriate; no empty code commit is required for static/manual findings.

A past tested closure proves its recorded snapshot/scope only. Unavailable/rewritten anchors and missing reporter evidence require reassessment, not invented IDs/current-pass claims. If interruption leaves real tests with an open record, inspect them next time and establish current closure evidence; do not replay old authorization or claim a lost runtime result. Reopen only from demonstrated loss/change of protection, remove the active closure and explain the new open judgment; Git preserves prior closure history. No automatic cross-branch case/state synchronization or union follows.

### Meaningful changes and safe persistence

Before each write require the same clean eligible current branch and no in-progress operation. Confirm actual lineage and expected accepted setup/test/ledger overlays. Pending unverified drafts or unrelated source/index changes block further persistence; never stage them into a ledger-only update or stash/reset them to proceed.

Write only supported in-scope assessments, actual human decisions and evidenced lifecycle updates. Preserve all other cases/unknown fields. Gap scan's assessment anchor covers its fully assessed diff-derived scope, not a claim that all old backlog was freshly reviewed; expose retained backlog with its own judgment context. Partial assessments never alter either root anchor. Root commits identify source before generated setup/test/ledger commits, not the latest bookkeeping tip. An assessment checkpoint is never a test-pass certificate.

Compare meaningful data before serializing. A date/order/default-only change, migration opportunity, own ledger commit changing HEAD or identical reused judgment cannot justify a repeat write. Identify exact own setup/test/ledger overlays before ignoring bookkeeping in subsequent diffs; real user tests/configuration/fixtures remain actionable, and other workflows' operational state remains opaque. Keep the existing anchor/provenance when no new actual assessment needs recording.

Recheck the canonical file against its expected bytes/existence and the shared unsupported-path tripwire immediately before each write. Unexpected drift stops dependent persistence. Validate schema 3, unique IDs, semantic continuity, evidence/state consistency and complete preservation of untouched cases/unknown fields. Follow the shared procedure for canonical write/readback and commit verification; no alternate-file read, reset or retirement occurs.

Stage only the exact canonical result, never all `.helm/`. Commit assessment changes as `test(log): record assessed findings` and later case closures as `test(log): record verified case updates`, or the project's compliant equivalents. Apply invocation auto-commit; otherwise obtain required commit approval, reusing a concrete authorization already covering it. A declined/failed commit preserves drafts/sources, stops subsequent writes and never claims migration/checkpoint completion. Refresh own-source snapshots after successful persistence before another update.

A genuine no-op and cancellation before any authorized write create nothing. A supported authorized partial checkpoint may record cases without a complete project anchor. A previously committed assessment or case update remains valid historical evidence after later failure/cancellation; report unresolved selected work without fabricating an all-or-nothing rollback or final success.

## Step 7: Finalize only verified eligible work

Require the declared assessment scope complete, intended setup/test commits and combined checks verified, supported case closures/checkpoints accepted, no declined/failed writes or commits, no unfinished selected work/drafts and clean state before finalization. A completed assessment-only run needs no invented runtime pass. Unselected open backlog does not mean selected work is unfinished. A partial scan remains a partial handoff even when its findings were saved; it does not claim completed assessment. When repeated work has no meaningful ledger delta, do not manufacture one or advance root anchors to satisfy the helper; report actual local outputs/handoff. The shared helper and other commands' approval policy remain unchanged.

After verifying eligible local outputs/commits, apply **Finish verified local work** from `{package_root}/prompts/shared/content-sync.md`. Finish on the current permitted branch. No push/PR question, integration, environment promotion, branch creation/switch/return or cleanup follows. Preserve drafts and failed/declined commits honestly; publication is a later explicit ship action. A verified local result needs no remote/provider availability or published-source dependency.

Preserve actual assessment/judgment/decision provenance through local commits and later history rewrites; never invent source IDs to make ancestry checks pass. Verify the actual current tree under the test contract. A no-op writes/migrates nothing. Retain drafts, checkpoints and pending work without cleanup or switching branches.

For continuation, use only explicitly identified retained work. Inspect actual branch/commits/diffs, source baseline, approved overlays, current policy, the canonical own-state file and remaining drafts before reusing any result/approval. Do not trust `test/*` names, rerun successful clusters automatically or create parallel duplicate work. If provenance/safe preparation is unavailable, report exact completed/pending steps and leave a manual handoff; do not improvise a resume engine or advance a partial checkpoint.

## Step 8: Report actual outcomes

Report evidence, including no-write/Skip and pending paths:

- Full scan / Gap scan depth and actual scope, actual inspected/prepared branch and source SHA, resolved base identity and branch eligibility; packages/layers and relevant perspectives assessed, omitted or incomplete. A feature or environment-branch assessment does not claim merged-base or deployed-runtime currency. Report any relevant manual upstream follow-up without performing branch synchronization.
- Stable finding IDs and report-alias mapping; new/reassessed/reopened, open/resolved/obsolete cases, per-case priorities/reasons, actual human decisions and last-observed blockers. Show recommended/selected versus unselected/blocked/cleanup/manual groups, with counts derived from actual assessed records and scope. Distinguish adequately covered, reviewed-kept and unassessed behavior. Use "none found/recorded at {snapshot}" only within evidence, never a universal "up to date" certificate.
- Recommended/selected techniques and evidence-based reasons, actual layers/targets/matrix entries, expected criteria, material exclusions and unassessed prior technique coverage. Separate automated results, unrun/unavailable checks and required versus optional human review/sign-off; do not certify accessibility, usability, security or business acceptance from automation alone.
- New/extended test paths and behavior covered. Declaration blocks and collected/executed parameterized cases are distinct; use reporter counts when available, otherwise mark unknown rather than inventing volume.
- Existing-test maintenance: reviewed-kept versus out-of-scope/unassessed cases; proposed/selected versus applied improve/consolidate/replace/remove actions, reasons, preserved or superseded guarantees and old-to-new/remaining-coverage mappings. Distinguish declined proposals, unresolved intent and draft/pending-verification work. Explain actual case/fixture/selector changes and verification; no inventory of every existing test or new report artifact is required, and static Keep is not a test-pass claim.
- Tooling per relevant package/layer: intended command/working directory and dependency owner, declared versus restored/added/repaired/upgraded setup, actual readiness/evidence or blocker. Distinguish install success, runner verification and passing tests; report unexpected changes and restore-only work without a setup commit. Tool inventory stays transient; a case blocker or closure command is not a tooling cache/profile.
- Verification as **command → outcome and scope**, or **not run: reason**; baseline versus new failures, skips/todo/xfail/unexpected/flaky results as known, required checks pending, measured versus static/unknown coverage and report scope.
- Specialist evidence where produced: generator settings/domain/replay examples, reviewed visual references and comparison outcomes, workload/duration/metrics/thresholds, mutation outcomes and before/after recovery evidence. Use actual tool output, noting incomplete runs and provenance limits; do not invent measurements, per-type pass counts, thresholds or human approval. Keep sensitive data out of reports/artifacts and introduce no default report/profile file or per-technique ledger.
- Actual setup/test commits versus drafts, assessment-only checkpoint versus later case updates, and closure methods/commands/scopes/evidence commits versus historical or missing proof. Include own-ledger loaded paths, canonical destination, schema-3 or pending reviewed rebuild, root anchors unchanged/advanced, migration/commit status and unresolved cases. No claims about other workflows' state.
- Local outputs/commits/checkpoints, actual current branch, retained drafts, performed/deferred checks and exact continuation action. Publication is not performed; invoke ship later. A local checkpoint or partial assessment never certifies passing tests or remote integration.

Never run missing checks, create commits, migrate state or publish merely to improve the report's appearance.
