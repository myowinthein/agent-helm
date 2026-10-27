# ship

Publish reviewed work through one workflow: inspect pending work, use verified history-replacement or private archive procedures when applicable, handle selected branch targets and offer an approved release on ready main/master. Never publish registry packages or upload release assets automatically.

## Question points

Use [QM](../prompts/shared/question-mechanism.md) at the existing gates below and in the selected publication/provider helpers; ask only when their conditions hold.

| Point | QM form |
|---|---|
| Missing source, role, destination, product/public API, stream, version or required private-evidence facts after local handoff discovery | Input or Single for actual candidates; never infer scope from divergence or a branch prefix. |
| Conflicting special routes or prepared-candidate status/resume | Single; archive inspection itself uses its existing Review before bundle access. |
| Base preparation commit, exact source push/helper/PR creation and target action | Review of each concrete operation, reusing only sufficient same-action approval. |
| Optional targets | Multi with None / Finish; Single Yes/Skip for one target. Target selection precedes exact action Review when not already concrete. |
| Release / Skip / Choose another version / relevant Use 1.0.0 | Review of the shown release plan; custom/initial version → Input, then refresh Review. |
| No configured test framework, supported sequential publication or hosted release | Review with the existing explicit proceed/leave-pending choices; failed/unavailable required checks remain blockers. |
| History publication and archive payload/receipt publication | Separate Review of the exact selected protocol, fixed expectations and effects. |
| Archive destination/privacy facts, preservation/cleanup, portable copy | Input for safe identity/paths; Single for retention route, Multi for independent candidates, then Review of exact effects. |
| CI wait/recheck versus pending and missing resume operations | Single for wait/pending; Review only for missing mutations lacking valid approval. |

## Publication rules

Apply throughout this workflow and its selected supporting procedures:

- Source publication, PR handoff, integration, release and deployment are separate outcomes. An open PR is a review handoff: do not merge it, await future review/CI or tag its unintegrated work. Release-metadata PRs stop at that handoff until independently integrated.
- PR heads are moving refs. Before approving a source push, disclose its effects on **all open PRs sharing that source**. Reuse matching open requests without duplicates. Merged requests receive no later commits; new target work needs an explicitly selected new request/action.
- Verify actual destination refs and provider results after success or uncertainty, before continuation/retry. Reuse completed work rather than replay it. Unresolved outcomes and deferred/unavailable/failed required checks block dependents, preserving earlier successes.

## Before starting: policy and permissions

Apply the shared runtime and resolve effective instructions and `{memory_file}`. Resolve only the settings/capabilities needed by the selected work: `ship-method` (`direct`/`pr`, default pr; retired-key leftovers follow the Git rules' stop guard), independent `git-merge-strategy` (default squash), applicable base identity and provider policy. Freeze/recheck invocation policy; never write settings or migrate instruction ownership. Read `{package_root}/prompts/shared/ci.md` before an applicable check/integration/promotion gate. Load only the relevant identity and host/action sections of [provider procedures](../prompts/shared/release-providers.md) when provider inspection or a provider write is needed; do not load unrelated recipes. Independent optional targets have no tier ordering. Pass developer requests and answers unchanged, never as shell code.

Initial assessment uses safe local Git and authenticated read-only provider evidence, plus the exact read-only local handoff discovery below. It performs no fetch, optional index refresh, checkout, project hooks/checks, commits, file/ref writes or publication. Suppress executable Git helpers and lazy fetching where supported; unavailable reads remain unknown. A request to run ship approves inspection, not pushes, history replacement, backup, metadata changes or tags. Present concrete effects at the existing approval gates and reuse still-valid same-action approval. Ship creates no setting, tracked state, ledger, locator or recovery writer.

## Step 0 — Identify pending work and choose the safe publication procedure

Inspect the actual repository/current branch, relevant local/remote refs, existing PRs, known release candidates and explicitly identified retained work. Build a transient per-action assessment: new source work, existing handoff, selected target work, pending history publication, prepared archive backup, unreleased product changes, unfinished release or proven no-op. Unknown remote/history/provider evidence is not absence of work. Use Step 7's evidence and continuation rules before creating a helper, release commit or tag.

### Detect special publication work without reading unrelated state

- **Normalization:** probe only `{git_common_dir}/agent-helm/normalize-handoffs/`, resolving the actual common directory through Git. When present, load [local handoff discovery](../prompts/shared/normalize-handoff.md) and read its bounded private locators before asking for a path. Match and verify identified runs or a proven sequence under [history publication](../prompts/shared/history-publication.md); automatically reuse uniquely established evidence across sessions. Reconcile a conversational/explicit handoff with discovered candidates. Locators, Git-native filter-repo markers, ref/reflog hints and divergence prove neither run ownership nor publication scope. Missing, invalid or conflicting required evidence needs the existing path/reconciliation question; never pick the newest folder, scan private roots, reconstruct proof or open normalize's live ledger. An unexplained divergence still blocks ordinary publication. Ship never creates locators for older runs.
- **Archive:** probe only no-follow path metadata for the canonical `.helm/archive/` and protected unsupported `.archive/` roots, never their contents during generic discovery. A candidate is not proof of preparation. Offer **Inspect this archive for backup / Leave pending** before opening its bundle, reusing explicit known backup intent. After selection, load [archive publication](../prompts/shared/archive-publication.md) and its canonical validation/old-root stop guard. Only this selected continuation may read/update that one bundle's journal/receipt. An incomplete or invalid selected archive returns to archive preparation or remains pending; never publish its payload through ordinary shipping as a shortcut. A proven completed backup reports its result without replay. Archive publication is terminal: no ordinary push, branch fan-out, version or tag follows it.
- If archive and rewrite evidence both apply, or their source/destination/provenance conflicts, show the candidates and resolve the intended independent work before opening additional inputs or publishing. Never silently chain backup and source publication. A deliberately unrelated candidate can remain pending only after the ordinary included history is independently reviewed and safe; ignoring a trace never waives a publication gate.

After a selected history publication is fully verified, retain its exact published refs, deliberate local-only refs and proven old/new release correspondence in working context. Do not push that history again through the ordinary path. Offer optional targets only from a specifically reviewed verified published current source under Step 6; then assess release eligibility. A failed/blocked selected history action stops dependent targets/releases while preserving successes. No PR can substitute for replacing published IDs.

### Ordinary work, existing candidates and completion

For ordinary work, reuse proven existing source/helper/PR identities and perform only missing actions through Steps 1/6. Detect a pending or integrated release-metadata candidate before routing its metadata-only delta as application work. A uniquely proven candidate uses Step 7's same-version continuation. Ambiguous identity or unrelated ahead application work requires reconciliation, not another bump or code PR.

An already-published current tip still permits Step 6's optional targets: selected environments may be behind even when the source needs no push. Do not treat an optional target's different tip as authorization; show only applicable concrete actions and obtain selection/approval. An unchanged proven selection is reused. After verified ordinary publication/targets or a proven source no-op, assess release eligibility. A core PR may be followed by explicitly selected independent target PRs.

- Work successfully published on ready main/master: offer the release plan with **Release / Skip release**, including changes with no automatic version bump; version choice remains explicit.
- No source push needed, but published main has unreleased product changes or a proven incomplete release: offer the new release plan or only missing same-version actions. A previous tag need not exist: assess a first release from complete scoped history. A published tag by itself is not a new release opportunity; already-complete/skipped optional hosted output is not automatically recreated.
- No source publication, applicable selected target update, unreleased product work or required incomplete release: report **Nothing to publish or release** and exit without a question, empty PR/commit/tag or state write. Open review handoffs are reported as pending, not as nothing to do. Unknown evidence is a pending limitation, not this no-op result.

## Step 1 — Establish scope, capabilities and core publication

Perform a read-only inventory first. Resolve the actual repository, base and current branch role from project/developer evidence, not prefixes. Confirmed roles are base, feature and environment; detached, unconfirmed environment candidates, ambiguous or unsupported maintenance/release/bot roles block ordinary publication writes rather than being routed to main. A branch that is the actual base uses the base route even when it also deploys production. Record `{original_branch}`, current attached branch/HEAD, index/tree, ongoing Git operations, shallow/missing history and required capabilities. No repository/HEAD or ambiguous base blocks dependent writes, never initializes Git. Product/stream selection is required for release, not speculative versioning of every ordinary source push.

Resolve actual fetch and **push** URLs, upstream/configured push behavior and credential-free host/repository/ref identity. Do not assume origin/fetch URL or an ambient provider repository. Bind exactly one source push destination; ambiguous/multiple push URLs need resolution. Bind each optional target's actual repository/destination separately in its reviewed action, never infer authorization to push to another remote. A fork feature PR additionally verifies the intended upstream target and its actual main/environment refs, access and policy; source publication grants no upstream push. Unavailable provider access is not proof of absent protection, CI or PRs.

Inspect applicable project checks/signing/protection, branch/tag/PR-preview deployment triggers and CI-owned version/tag/release behavior. Respect real restrictions on bypassing main or publishing environment branches even though Helm now permits explicitly chosen edges. A required PR blocks direct target publication and offers a separately reviewed PR alternative, never silently switches method or bypasses protection. Unknown required policy blocks the affected gate. Source/target publication grants no release approval and must not duplicate CI-owned version/tag/release automation.

### Safe worktree, remote baseline and publication evidence

When assessing publication diffs/history, read `{package_root}/prompts/shared/investigation-evidence.md` for the existing exact scope only; no-investigation paths gain no prerequisite. Default to parent review for ordered publication work. Unusually large independent read-only history analysis may delegate when permitted, returning exact reviewed commit IDs, full-message/needed-diff evidence and unresolved remainder; parent alone handles provider operations, ref/source decisions, approvals and execution. Reconcile exact required IDs/changes with the pinned publication/release range, never just counts or a recent sample; do not add a full-code audit, generic Full/Gap choices or an operational ledger.

Every mutating route requires clean safe index/tree and no in-progress merge/rebase/cherry-pick/revert before dependent actions. Inspect path metadata first: pending operational Helm state blocks without opening it; secret-bearing/non-template env/private-key changes and unverifiable content block publication without unsafe diffs. Never stash, reset, discard, absorb unrelated staged work or merely exclude unsafe paths and continue dirty.

On base only, retain the existing explicit **Commit reviewed safe changes / Stop here** preparatory logical-unit choice, with exact staging/content verification; it grants no publication/tag/PR approval. Feature/env edits must be safely committed through normal development first. Committed work can still be unfinished: review the entire included range/diff, not just today's changes, and stop unready/excluded work.

For writes, describe needed narrow fetch/history completion before performing it. Preserve tags, unrelated refs and remote configuration; no pruning/forced tag replacement. Compare actual advertised source/target refs. No ordinary force, automatic divergent merge/rebase, reset or conflict repair. A behind-only clean branch may be safely fast-forwarded under policy and reassessed; otherwise leave manual reconciliation. Detect reviewed squash/rebase equivalence before calling old IDs new work: do not republish equivalent patches or create another PR to fix local divergence. Pin `{source_sha}` to the complete reviewed current tip after preparation and capture remote expectations. Recheck before every dependent mutation; later target results never replace this source.

Before core publication show the source SHA, exact destination/refspec, full included changes, applicable checks and known triggers, and obtain concrete approval or reuse same-action approval.

### Collect and refresh the source snapshot

Batch independent permitted local reads: repository/current branch and HEAD, safe index/worktree path status, in-progress operations, relevant refs/upstream and credential-free destination/configuration identities. Once the actual host/repository/ref is bound, batch independent authenticated policy, open-request and required-check queries, with complete relevant pagination. Return decision-critical fields, not raw provider/configuration blobs. Stop dependent work at a discovered blocker; do not investigate an unrelated publication route to fill the report.

Bind complete reviewed messages/diffs and other immutable evidence to exact object IDs and reuse them. Immediately before each approved mutation, batch fresh checks of local HEAD/index/worktree, relevant effective settings, destination, actual remote refs, applicable protection/checks and request state. Reuse content only while those identities still match. Fresh observations never replace a rejected fixed lease or authorize a changed plan. A single batch is not a lock; material drift stops dependent execution.

### Core direct publication

For base, feature and confirmed environment alike, publish only the exact reviewed current branch tip to its intended same-role remote ref with `--no-follow-tags`, after applicable pre-publication checks/approval. Never merge into main, merge main into the current environment or push another branch merely to finish the core. An already published matching tip needs no duplicate push; verify and report it. Remote-ahead/divergent or unrelated local-ahead work requires reconciliation, never force. Verify the actual remote ref against the approved SHA/containment plan. A new ref needs its creation/triggers described explicitly.

After core success, bind `{published_source_repository}` and `{published_source_ref}` to that verified current-branch destination at `{source_sha}`, then offer Step 6 optional targets. Selecting none skips target writes; an original-main invocation still assesses release availability, while a feature can finish at verified branch publication without integration into main. Source push/deployment effects remain explicit; a push is not verified deployment. Core failure or unresolved publication outcome blocks dependent target work.

### Core PR publication and helper reuse

For a **feature**, the existing feature ref is the source: approve/push/verify it exactly as above under source-publication policy. No helper or self-PR is needed, and a main PR is not automatic. Proceed to optional main/env target selection; none still means the feature was published successfully. `ship-method: pr` controls integration-target updates, not the source push needed to propose them.

For **base or confirmed environment**, propose the reviewed current work through one `ship/*` source ref into the hosted current branch. Never open same-repository same-ref main-to-main/env-to-itself PRs, push that permanent target directly, or reset/rewind/rebase/cherry-pick the original branch to move work. The original branch stays at its current tip.

Resolve the complete target diff and whether work is already integrated before creating anything; reviewed inclusion/equivalence creates no empty own-target PR or new helper. Inspect retained optional requests below before concluding a helper is unnecessary. Only if no established applicable helper/optional handoff remains may an already-published current branch bind its verified repository/ref/SHA as the optional source. Unreconciled squash/rebase divergence still blocks dependent publication; equivalence does not authorize silently changing `{source_sha}`.

Before making a helper, inspect applicable open requests and explicitly identified retained run/source evidence with complete pagination. Reuse a uniquely established helper for this original branch/work and exact own-target repository/ref; its name prefix alone is not ownership. Verify actual PR identity, graph/content, source/target tips and all open requests sharing that helper. An existing source at `{source_sha}` needs no repush.

Updating it for review fixes requires its observed published tip/history to be fully included in the reviewed current source and a normal fast-forward; show the entire delta and effects on every shared-source PR. Helper-only reviewer commits absent from local source, conflicting work, multiple/uncertain candidate helpers, denied lookup or a closed-unmerged request require reconciliation/identification, not a new helper, overwrite, force or silent reopening. A source already integrated with different IDs needs deliberate original-branch reconciliation before another publication.

If the own-target PR merged but associated optional PRs remain open, keep that proven shared helper for the still-applicable reviewed work; do not replace it with hosted main/env and create parallel same-work target PRs. Verify the old source/scope against the current plan, review any eligible fast-forward helper update and its shared-PR effects, and skip the already-integrated own-target request. A changed/ambiguous scope needs explicit reconciliation, not an automatic source swap. Historical merged/closed requests alone never establish a new pending helper.

Only when the absence of a matching pending helper/request is established may ship create an unused `ship/changes-{YYYYMMDD-HHMMSS}` at the exact reviewed tip, with a numeric suffix on collision. Keep enough reviewed original-branch/source context in its PR proposal to support later identification without a new ledger. Do not reuse an unrelated name or create helpers per target. Obtain approval, run applicable checks, push/verify this exact source ref, then create/reuse/read back the matching own-target PR/MR through the provider guide unless its reviewed content is already integrated. A failure after source publication preserves it and reports missing PR/API work; later runs recover that identified source rather than duplicating it.

Freeze `{published_source_ref}`, `{published_source_repository}` and `{source_sha}` for optional targets. For a new/pending helper, every optional PR uses **that same helper**, not the older hosted current branch.

Example: local main has C above remote P; helper(C)→main and helper(C)→staging both propose C, independently. Staging may accept it before main or even if main rejects it. Show this in the plan and obey stronger project restrictions; do not silently substitute P or wait for main's PR to merge.

After an own-target PR handoff, proceed only to selected independent Step 6 actions, then report. Never update a source from its target or delete branches.

## Steps 2–5 — Assess and publish an optional release

Read [release](../prompts/ship/release.md) only for an identified candidate, an explicit release assessment/question or ready integrated main/master's release assessment. Initial discovery still identifies incomplete metadata/tag/PR candidates before misrouting them as application work. Feature/environment invocations do not acquire a release offer. Ready main includes no-push reruns and first releases; do not skip them as ordinary source no-ops.

Where already relevant, collect cheap version/tag/candidate identities with the source snapshot and reuse pinned history. Do not speculate about product versions or build notes for an ineligible/unselected source. Revalidate release eligibility after selected publication/targets; read-only preparation never supplies release or hosted-write approval. Reuse an incomplete version rather than bumping again.

## Step 6 — Optional targets and an explicitly selected published source

After verified core publication/handoff (or a proven already-published source), load [targets](../prompts/ship/targets.md) when applicable candidates need selection or a selected target needs action. An existing applicable None/Finish skips targets without loading their procedure or asking again. No candidates means no question. Preserve the source role's choices and independent same-source routing; never infer a target from a different tip. An explicitly requested existing published source uses that procedure directly without publishing unrelated current work or proposing a release.

## Step 7 — Assess current results and continue only missing work

For ordinary branch status, inspect current/identified source and remote refs, established helper/PR identities, source/target inclusion/equivalence and explicitly selected partial actions. No tag is required. An identified partial ordinary resume freshly validates that source/ref/observed tip, original role/target set, complete diffs and prior successful operations, then offers only missing source push/own PR or selected target work through Steps 1/6. Without recoverable provenance ask for the exact source/request rather than guessing a helper or new target plan. The entry assessment reuses these established source/PR facts and assesses any separately proven same-version candidate without a new bump or duplicate helper.

For an identified release candidate, load the continuation in [release](../prompts/ship/release.md). Reuse completed results and sufficient approval; inspect uncertain outcomes before retrying. Targets continue only their explicitly selected pinned source/scope, never an inferred newer source.

## Step 8 — Report actual outcomes

On mutating routes, return to recorded `{original_branch}` when independently safe. If already on that branch, verify/report the actual checkout without a redundant switch or cleanup.

A needed checkout requires clean index/tree, no ongoing Git operation, an existing original branch not occupied by another worktree and no incoming tracked-path collision with ignored/untracked inputs, including local env files. Inspect safe path/status metadata without exposing secret contents; clean status alone is insufficient. No force, reset, stash, discard, secret backups, automatic pull/merge or committing drafts to force checkout. Verify the actual resulting branch.

Unsafe/missing/occupied target or checkout failure preserves actual work and reports the pending return and non-secret reason. A clean partial publication/manual handoff may still return safely; return does not make a failed handoff successful. Retain helper/feature/base/environment branches locally and remotely. Read-only/no-op/cancel paths never check out for a cosmetic return.

Report assessed work, chosen publication procedure, release offered/skipped/pending/not applicable and resolved original/current role and base, original/actual checkout and safe-return status, source repository/ref/SHA/helper when applicable and the actual source push/core own-target PR result. Report every optional target separately: selected/none, exact source/target/destination, bypass-main effects, merge/commit/push or PR URL/head identity, verified/no-op/pending/failed/not-attempted result, checks and concrete continuation. Capture result verification before return.

For an accepted or pending release also report product/stream, prior/exact version/tag rationale, actual integrated release SHA, metadata PR/commit, local/remote tag, hosted URL/channel and missing same-version actions. Source/target publication alone reports **release not performed** until the optional release stage actually succeeds. Main-only release requires its reviewed approval after integration/reconciliation; no new code PR is needed merely to tag ready integrated content, while genuinely new metadata may require its own reviewed PR.

A source/PR URL or preflight cannot certify deployment; report package/registry/asset actions as not performed or independently observed CI behavior with evidence. List exact pending manual work; never invent a tag for ordinary resume, recalculate a release to recover partial publication, overwrite published refs or claim unperformed tests/provider support passed. Read-only/no-op/cancel creates no state or cosmetic cleanup.
