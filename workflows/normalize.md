# normalize

Before reviewing history, display the coordination notice and wait for readiness. Then discover agreed branch updates, review commit messages with code-assisted mechanical checks and semantic assessment, reusing proven schema-2 coverage when compatible, and present exact replacements and their complete impact together for one final rewrite approval. Optionally rewrite all affected local branches together. Readiness, branch preparation, message-review scope and rewrite authorization are distinct. Preserve tags, stashes, notes and excluded refs; approved branch preparation precedes the rewrite's remote-tracking snapshot. This command never publishes; invoke ship separately when ready.

## Question points

Use [QM](../prompts/shared/question-mechanism.md) at the existing gates below; ask only when their conditions hold.

| Point | QM form |
|---|---|
| Coordination before any history review | Display the complete notice, then Single: Team ready / Review only / Stop. Wait for an answer; reuse an explicit applicable answer. |
| Newly pushed branches after readiness | Input only for missing agreed branch/remote identities; Review for exact fetch/local-branch preparation when needed. Reuse concrete preparation approval; readiness alone grants no writes. |
| Missing named review refs, policy/intent facts or required recovery evidence after automatic handoff discovery | Input; Single for evidenced interpretations. No routine branch-scope picker. |
| Optional wording/subset decisions when requested or needed to settle intent or selection | Single for Accept / Edit / Keep / Defer beside complete before/after messages; Input for exact wording or IDs. Preserve independent decisions; no routine preliminary wording-approval gate. These decisions alone authorize no rewrite. |
| One final all-affected-branch rewrite and disclosed ledger-anchor maintenance | Review of the exact messages and complete impact together: Apply reviewed rewrite / Edit or change selection / Cancel/keep review only. No subset picker for affected branches. |
| Meaningful no-rewrite checkpoint, changed invalidation or missing local commit approval | Review of the actual record delta/subject; no question or write for bookkeeping-only no-ops. |
| Identified partial-run continuation | Input for missing provenance, then Review only for the missing actions lacking valid approval. |

## Before starting: scope and policy

Read the shared runtime, resolve `{memory_file}`, active overrides and local `git-auto-commit` (absent means off), signing and ref-update policy before dependent actions. Never edit instruction entries or Helm settings. The current attached branch is the eligible local ledger destination, whether base, feature or environment, under actual project restrictions. Ship method and merge strategy neither choose the rewrite set nor require a bookkeeping branch.

Record the invocation's `{original_branch}` and starting HEAD before any rewrite or checkout; keep that branch identity through bookkeeping. On resume, preserve the saved original branch rather than substituting the resume checkout. A coordinated rewrite may legitimately change its tip. Returning later means the same original branch at its verified current tip, not restoring its old SHA. Initial read-only review never checks out a branch.

Review committed messages, prepare exact correction proposals and the affected-branch impact report, then offer one final Apply decision or a no-rewrite checkpoint when eligible. Optional earlier wording/selection exchanges need no separate approval of their own. Invocation alone never approves rewriting or pushing. Pass developer requests and answers unchanged, never as shell code.

Honor explicit read-only/Stop choices from the outset. Review only, including the readiness choice below, permits the scoped investigation and report but no history, index, ledger, locator, recovery-file or commit writes, regardless of auto-commit. Stop ends the run preserving existing work. Keep readiness in the invocation context, not a new setting, ledger field or standalone receipt.

### First gate: before history review

After only loading instructions and checking the repository identity, current branch/HEAD and basic eligibility, display the complete notice below as chat prose, then ask the readiness choice. This precedes commit-message reads, history/diff investigation, mechanical checks, ledger/helper access, remote discovery and worker delegation. Do not inspect history to decide whether the gate is needed: ordinary runs show it even for private history or a scan that later finds no corrections. An explicit read-only/formatting-only request bypasses the choice and goes directly to its read-only assessment; an identified report-only completed-run continuation needs no new readiness question.

> **Normalize may change commit IDs across multiple branches.**
>
> Corrected commits and their affected descendants will be rewritten across local branches.
>
> Before continuing:
>
> - Inform your team about the upcoming normalize process.
> - Push any unpublished branches you want included before continuing.
> - Pause pushes, merges and creating new branches until normalize and ship finish.
> - Run normalize, then ship straight away in the same terminal and project folder.
> - Make sure affected branches allow rewritten history to be pushed.
> - After ship, sync local branches with the rewritten history before resuming. Do not merge the old history back.

Keep the paragraph and all six plain, non-bold bullets visible; do not replace them with a short picker title, bold labels alone or a reference to this file. Add no per-bullet explanations or emergency-work paragraph to this first notice. Then offer **Team ready / Review only / Stop** once. Team ready acknowledges coordination and permits discovery/review, not fetch/local-ref writes, rewriting or publication. Review only permits the scoped local assessment/report without writes, remote preparation or a later Apply prompt. Stop ends without further investigation or writes.

An unanswered question pauses the whole review: do not continue even independent read-only history investigation, helpers or workers while waiting. With an asynchronous question tool, leave the choice pending and yield; with the chat fallback, end the turn at the question. Never loop/sleep, assume readiness from silence or relabel the pending answer as cancellation. Reuse an explicit applicable readiness answer; display the notice once without asking again. Rewrite approval, branch selection and bare invocation are not readiness answers.

The notice is coordination advice, not proof of teammate activity or a new device restriction. Same terminal/folder is a plain-language recommendation to keep normalize and ship in the same clone with retained recovery evidence; another session in that clone remains supported. Private work need not be published. Existing policy, complete-history, recovery, worktree and publication safeguards remain binding. Do not repeat this gate for unchanged scope or in ship; clarify only materially broadened coordination needs.

### Discover newly pushed branches after readiness

For Team ready, refresh branch discovery now, after the team's preparation and before freezing Step 1's review inventory. Honor an explicit no-remote/local-only request. Resolve the relevant configured remotes and agreed branch identities from project facts and the developer's request; ask only when those are ambiguous. Read fresh branch advertisements from those remotes using safe read-only access, then compare their exact refs/tips with the current local branches and known tracking mappings. No remote, denied/offline access or incomplete results is an explicit discovery limit, not proof that every teammate's branch is included. Never guess from names or inspect other clones/private branches.

Detect new remote-only branches and changed published tips, not just cached tracking refs. Do not import every remote branch, create an unrelated feature branch or silently fast-forward/overwrite an existing local branch. If agreed branch membership is unclear, settle that missing scope first. For an agreed remote-only branch needing local objects/a branch ref, review the exact remote/source ref and advertised SHA, absent local destination, fetch/object/ref effects and any invoked helpers/hooks before preparation. Obtain **Prepare listed branches / Review local history only / Stop**, or reuse sufficient concrete approval; Team ready alone is insufficient. Stronger project prohibitions still block preparation. If the developer prepares branches outside the workflow, verify their actual result and continue this invocation rather than requiring a new normalize run.

Approved preparation uses only explicit selected refs, without tags, pruning, configured wildcard refspecs, recursive submodules, automatic maintenance or checkout. Preserve existing local branch tips, working tree/index, tags, unrelated refs, upstream/configuration and user work; a local-name collision, remote movement, unexpected effects or incomplete objects stops dependent preparation. Read back fetched tips against the reviewed advertisements and verify each new local ref at that exact commit. An existing branch missing agreed remote work needs deliberate reconciliation; do not silently review an obsolete tip or merge/reset to resolve it. Preserve successful preparation if later work stops; no automatic rollback or cleanup follows.

Re-enumerate and freeze the actual local branches after preparation, including branches pushed while the readiness question was pending. Discovery/preparation grants no broader message audit: keep current/requested review scope, while every affected prepared local branch joins the later consistency rewrite. Recheck missing/unprepared agreed branches before Apply, reporting unresolved remote-only histories explicitly rather than claiming coordinated completeness. If the developer selects local-only review, retain its no-write/no-Apply outcome. No extra configuration, ledger field or saved preparation receipt is introduced.

For a resume request, use [local handoff discovery](../prompts/shared/normalize-handoff.md) or explicitly identified prior evidence, then inspect the verified own record branch/commit and current local/remote facts as applicable. Offer only missing actions under Step 8. A rewrite continuation still requires its private recovery evidence; a locator proves no completion and never authorizes rerunning the filter.

History review after readiness/branch preparation is read-only, including on dirty or detached checkouts. Freeze committed objects; staged/untracked/worktree changes remain outside the message review and dirty policy inputs are disclosed. Use `GIT_OPTIONAL_LOCKS=0` where needed. Outside the specifically approved preparation above, do not fetch/hydrate, start filtering or a backend dry-run, execute project configuration/hooks/checks, create files/branches/bundles, write refs/index/state or migrate records. Read-only installed-tool capability/version checks for the impact plan require prior static effect review and authorize no setup or filtering. At Step 1's explicit owning-state entry only, normalize may validate its own canonical record for baseline reuse under the shared state procedure; other state stays opaque. The packaged pure read-only checker is permitted there. Missing evidence leaves explicit incomplete coverage, never permission for dependent mutations.

Require an accessible repository and explicit committed snapshot for inspection; an empty repository reports no committed history without initializing Git or creating state. Use raw object reads and diffs with external diff/textconv disabled; suppress configured pagers, filesystem-monitor execution, and lazy fetching with supported Git capabilities. If local-only inspection cannot be guaranteed, stop the affected read rather than invoking project code or network hydration.

Only Apply or an authorized ledger write requires an attached branch, a clean index and worktree including untracked project files, no in-progress merge/rebase/cherry-pick/revert, and safe affected worktrees. Never stash, reset, or commit user work to satisfy those prerequisites. Check every affected local branch, including branches added for shared-history consistency, for another worktree before rewriting refs. If any affected branch cannot safely be included, block the coordinated rewrite rather than altering another checkout or silently rewriting a subset. Read-only review remains available when mutation prerequisites fail.

## Step 1: Freeze policy, inventory, and scope

### Effective message policy

Resolve explicit project/user instructions first, then statically inspect existing commitlint or equivalent configuration for additional compatible rules, then use Helm's scoped Conventional Commits default only for gaps. Conventional Commits itself allows optional scopes, custom types, and its defined case variations; Helm's required scope is a project preference, not a universal specification rule. Do not execute JavaScript configurations, load arbitrary `extends`, install tooling, or change config to discover policy. If static evidence cannot resolve a material rule/conflict, summarize it once for the plan and ask before dependent proposals/apply. Report that uncertainty without certifying compliance.

Classify full messages as **accepted**, **spec-valid but outside project policy**, **spec-invalid**, or **unresolved**. Do not rewrite accepted messages for stylistic perfection. Use the project's accepted types, scopes (including multi-scope when supported), language, length, and case rules rather than imposing a new convention. Bind the plan to the exact policy inputs; changed policy invalidates affected approvals.

### Code-assisted checks and reusable semantic coverage

Read `{package_root}/prompts/normalize-review.md` for the pure helper interface and authoritative schema-2 baseline contract. Resolve the complete effective policy, including non-mechanical rules/owner directives, into its canonical policy snapshot. At this owning-state entry, read `{package_root}/prompts/shared/project-state.md`, then validate only `.helm/normalize-log.json` as schema 2 using that contract. Missing state means no baseline. Unsupported/malformed state blocks reuse and dependent checkpoint/rewrite actions, while independent full committed-message review remains possible; never convert, reset or silently omit invalid records. No other ledger is opened.

Use `helpers/normalize_check.py check` with complete committed messages for deterministic supported-rule checks, paged by exact IDs. Its pass is mechanical only, not acceptance; resolve unsupported rules/exceptions manually. Batch local Git object reads where available, without dumping the entire history to the model. The pure helper takes structured JSON stdin and has no Git, file, network or mutation access. Do not execute arbitrary commitlint configs or install dependencies to speed up inspection. Unavailable Python/helper execution permits equivalent bounded checks and conservative manual review, never fabricated results or automatic setup.

After freezing audit refs and their complete parent graph below, use `plan` with the validated own record and current policy. A compatible semantic baseline selects only newly reachable IDs for model review, including new merge-side history. Missing/non-ancestor/policy-changed/review-contract-changed baselines select full reachable history. Pass newly identified concerns as recheck IDs; a concern under an old prefix invalidates its reuse. A deliberately requested full-history review ignores baselines for selection; an explicitly bounded range reports older unreviewed history. Keep the actual record intact until an eligible approved write. No routine mode/scope picker or new settings are introduced.

The model still reads every full raw message/metadata in the new semantic set, with supporting diffs where needed, regardless of mechanical pass. Do not replace that with subject-only cards or syntax-failure filtering. Reconcile helper pages/digests and exact syntax, new-semantic, reused and unreviewed sets. A baseline is recorded prior assessment, not a guarantee of correctness; contrary evidence requires reassessment. Honor an explicit formatting-only request with mechanical results and clearly unreviewed semantics, without a checkpoint. No format-only or heuristic-only work advances semantic coverage.

### Committed-object scope

At actual investigation, read `{package_root}/prompts/shared/investigation-evidence.md`. Units are exact unique IDs in the frozen requested audit set. Separate new semantic review (full raw messages/metadata and supporting diffs where intent needs them), proven reused per-branch prefix coverage and explicitly unreviewed IDs. Reconcile that entire set, including accepted/no-change/unresolved messages; counts, samples, subject-only cards or syntax passes are insufficient. Reuse only the schema-2 contract's verified reachable prefix, never a date/first-parent shortcut, another branch's negative revision or rewrite-only unique messages.

Large independent message batches may use permitted read-only workers given exact IDs, effective policy, relevant source context and required evidence; the parent reconciles shared-SHA decisions, unresolved intent and the complete audit set. All graph/ref decisions, confirmations, backend execution and own-state writes stay with the parent. This contract adds no generic Full/Gap mode and does not widen the separate all-affected rewrite graph.

After the first gate and any approved branch preparation, inventory and freeze fully qualified local branches/tips with `git for-each-ref --format='%(refname) %(objectname)' refs/heads/`. Use the current local branch as the **message-review scope**, unless the developer explicitly requests another named set or all local branches. Do not present a routine current/chosen/all branch picker. On detached HEAD require explicit named refs or an explicitly requested detached commit for read-only review; never invent a current branch. A detached-commit-only review cannot authorize Apply without named local branch refs. Remote-only branches need the reviewed preparation above or developer preparation before freezing a fresh plan in this same invocation.

Separate the **audit graph** from the **rewrite graph**. Audit may inspect complete requested histories while proposing message corrections only within an unpublished tail, an explicitly confirmed product/stream release boundary or a full-history migration. Resolve that message-edit boundary to exact object IDs, showing older findings left outside it. Full-history audit does not authorize full-history rewriting.

Use Step 2's exact proposals and any explicit selections to derive the affected branches and exact descendant graph below. The final Apply accepts the displayed replacements and authorizes their exact ref changes; an earlier wording decision or choice of message-review branch does not. Do not combine unrelated per-branch watermarks as global negative revisions.

Walk unique required semantic IDs once in bounded batches; locally check supported mechanical rules over the selected history without re-sending valid reused messages to the model. Freeze refs/tips, audit/rewrite membership, boundaries, tags and peeled IDs, symbolic/excluded refs and remote configuration. No unbounded `--all`, `--branches`, `--tags`, wildcard or fresh enumeration may widen execution scope. Exclude proven old bookkeeping-only branches from default message review using complete diff/provenance, never names alone. That exclusion never exempts affected-branch detection or authorizes branch deletion.

### All affected local branches form the rewrite scope

From Step 2's exact non-identical proposals, derive provisional `{changed_original_shas}` within the established message-edit range. Use explicit selections when already known; otherwise preview the full proposed set without claiming the user has selected or approved it. Freeze that set with its complete impact for the final Apply, then revalidate it before execution. With an empty set, do not run the backend or ask a rewrite-scope question.

Against the frozen local branch inventory, a branch is **affected** exactly when at least one changed original SHA is reachable from its tip, including a tip equal to that SHA. Include **every** such `refs/heads/*` branch in the one coordinated rewrite, regardless of name, role, default scan exclusions, `ship-method` or `git-merge-strategy`. Main/master is included only when affected; a feature-only correction does not automatically rewrite main or sibling branches. Sharing only earlier unchanged ancestors does not make a branch affected.

No routine narrower-scope/multi-select option is offered. Explicit human exclusions or contradictory scope instructions must be reconciled before approval; never silently override them or silently fall back to a subset.

Affected-set detection must prove both inclusion and exclusion across the **entire local branch inventory**. A shallow boundary or unavailable parent anywhere in that inventory blocks Apply, not only on requested/already-known affected branches. In a partial/promisor clone, prove complete commit-parent ancestry locally without lazy fetch; configuration alone establishes neither completeness nor absence of changed ancestors. Deduplicate parent walks without auditing every unique message. Existing `refs/replace/*` or effective grafts block Apply until resolved outside normalize; never rewrite/remove those refs or change graph interpretation to proceed. Report incomplete read-only coverage and require a fresh plan after the developer resolves these blockers.

For the frozen affected tips, derive `{rewrite_graph}` as commits reachable from those tips that are equal to or descendants of a changed original commit. Its boundary is **every parent of a graph commit that is outside the graph**, including merge second parents and parents of changed roots. Freeze the exact affected tip refs plus exclusions of those outside-parent IDs, proving that their revision union equals the graph; merely excluding parents of changed commits is insufficient for imported side-history. Keep boundary parent objects unchanged.

Do not reuse incompatible per-branch exclusions, drop affected descendants, or widen to unchanged earlier history merely to simplify the backend. Unsupported or incomplete graph/range evidence blocks Apply. All occurrences of the same original commit must use one SHA-keyed message decision and the same verified old-to-new mapping across affected branches.

Branches added only for consistency receive necessary parent/ID remapping. Their unique messages remain byte-identical unless the developer explicitly broadens message review and accepts those additional corrections. This does not claim their messages were audited/compliant. Reading/verifying their graph/metadata is required; finding new possible message issues there does not recursively expand the replacement set. An explicit broader audit produces a fresh plan and affected-set calculation.

Use Step 3's single final review to show and approve the exact messages, complete affected list and graph together. The early readiness acknowledgement is separate; add no further warning screen, branch picker, configuration flag or ledger field. Recheck the whole frozen local inventory before execution: new/deleted/moved branches require fresh affected-set/graph assessment and refreshed approval where the plan materially changes. If any affected local branch is unavailable, checked out elsewhere, unsupported or forbidden by applicable policy, report the blocker and stop the coordinated rewrite; do not quietly omit it. The developer resolves a worktree/policy/history blocker outside normalize and returns for a fresh plan; normalize never deletes an old bookkeeping branch or changes protection to unblock itself.

Remote-tracking refs, unprepared remote-only branches, tags, notes/stashes and other clones are not auto-rewritten/materialized. Preserve remote-tracking refs as observed after any specifically approved preparation. Use available local ref/worktree and post-readiness discovery evidence to disclose known old-history holders, including detached other worktrees, and unresolved remote/clone coverage; never move/reattach another worktree. A changed commit reachable through another branch's available remote-tracking ref is not an unpublished change merely because the review branch has no upstream; unknown remote coverage is not proof of unpublished history. Local coordination does not establish remote consistency. Tags remain fixed under the existing ancestry warning. Separate publication approval, leases, protection, signing and check gates still apply; a publication-only blocker leaves remote coordination pending, not permission to skip a locally affected branch or promise safe future merges everywhere.

Missing objects, shallow boundaries, replace refs/grafts, unsupported encodings/headers, or ambiguous graph interpretation must be disclosed. Incomplete read-only review may report available findings; mutation requires a separately resolved complete approved graph. No automatic fetch/prune, object cleanup, or removal of existing recovery data.

## Step 2: Inspect messages and infer intent

Inspect full original messages/metadata first, using no-patch reads rather than bare `git show <sha>`. When intent needs supporting parent-relative diffs, inspect changed names/status first and render only relevant allowed source patches under runtime's protected-state exclusions, including historical paths. File extensions are evidence, not a type classifier: Markdown can implement this plugin's behavior, a new test is not automatically `feat`, and a dependency correction may be `fix`. Infer `feat`, `fix`, `refactor`, `test`, `docs`, `chore`, `style`, `perf`, `ci`, `build`, or a project-specific type from actual intent. Performance intent does not require running a new benchmark. Do not run tests or project code to infer a message.

Use the primary domain/module as scope, a supported multi-scope for inseparable equal areas, or `project`/`core` for genuinely cross-cutting changes. Preserve original language. Review merges against the relevant parents without inventing one ordinary change from combined stats; keep generated merge messages when the effective policy allows them. Recognize reversions, fixup/squash messages, generated commits, opaque changes, and binary-only diffs explicitly. Preserve existing target/issue references. Unclear intent stays unresolved with evidence and a focused question, never a fabricated explanation.

Recognize formal breaking markers only: `!` immediately before the header colon on any type/optional scope, or an uppercase `BREAKING CHANGE:` / `BREAKING-CHANGE:` footer. Words such as "avoid breaking links" and unrelated punctuation do not establish a break. Preserve genuine breaking information without inventing or duplicating a footer. A newly inferred incompatibility requires evidence and explicit approval in the message plan. Show how accepted changes could affect `ship`'s future version proposal, including a changed type or newly formalized breaking marker; this is part of message review, not a separate approval system.

Default to **subject-only** changes. Preserve the body, trailers, issue references, sign-offs, existing coauthors, Change-Id, language, and message bytes/newline structure outside the exact approved edit. Never invent attribution or expand a body from guesses. A necessary footer/body repair must appear explicitly in the complete before/after plan. Retain original encoding declarations; if the replacement cannot be represented/preserved by the supported backend, block that item rather than silently recoding it. Bind each replacement to the full original SHA and exact original message bytes, not message text or an abbreviated hash.

For each reviewed commit, record classification, original message, evidence/confidence and known shared refs. Prepare each proposed correction as an exact complete replacement for Step 3's final action review; do not require a preliminary Accept for every message or batch. When the user requests edits/subsets, or intent/selection genuinely needs clarification, use **Accept / Edit / Keep / Defer** with exact IDs and visible messages. Resolve those choices before costly impact analysis when possible. Such an exchange selects wording only; never reinterpret it later as rewrite permission. Edit revalidates the entire resulting message. Coherent batches are allowed, preserving independent decisions. Keep/Defer leaves the message unchanged and the noncompliant finding visible; never certify it as compliant.

Resolve uncertainty in the proposed execution set before offering Apply, then derive Step 1's all-affected scope from that set. Unresolved or held messages remain visible outside it. Shared commits receive one consistent SHA-keyed proposal across every affected branch. Discard byte-identical proposals; an empty replacement set never runs the backend.

## Step 3: Present one final message and impact review

Only reach this step after the first gate is resolved and required agreed-branch preparation is verified. Team ready is not rewrite approval. Review only exits with proposed corrections and actual coverage limits, skipping Apply and all checkpoint writes; an unanswered readiness question pauses all history review, not just Apply. Preserve the existing single final rewrite decision below, without repeating the coordination notice/question or adding a separate wording-approval gate.

Finish the read-only scope, capability, worktree and policy checks needed for the concrete plan before offering Apply. Known blockers affecting that execution set leave Apply unavailable while independent message review remains possible; its required evidence cannot be approved away. Present the exact messages and complete impact together, leading with a compact summary of changed messages versus commit IDs, affected branches, tag ancestry, signatures and checkpoint/commit effects. A proposal alone authorizes no rewrite or ledger write. Do not create a saved plan merely for a review-only outcome.

For nonempty corrections, reuse Step 1's own-ledger validation and Step 6's maintenance rules before the final Apply plan to identify affected anchors and proposed maintenance. This is required even when no new full-coverage checkpoint is expected; missing state means no existing anchors, not permission to invent consistency-only entries. After a verified rewrite, revalidate own state/anchor outcomes before the final report. Unavailable, malformed or unsupported state blocks Apply and checkpoint writes while leaving independent read-only review available. With no proposed replacements left in the execution set, skip rewrite gates and consider only a meaningful truthful checkpoint under Step 6.

Before offering a rewrite, show:

- Exact policy, requested message-review refs/tips/ranges versus the complete automatically detected affected local branch list/tips, graph/boundaries, all proposed full-message edits and Keep/Defer/out-of-range findings. Identify branches added for consistency and their unaudited unique messages. Explain that shared originals become the same new commits across this set. Show up to five message examples in the existing confirmation, with the entire plan available; never truncate the branch list to fit a picker.
- Number of messages proposed for change separately from the exported graph and descendant IDs potentially changed. Disclose signature loss on exported commits even when their message is kept. Preserving the message does not promise preserving its SHA/signature.
- Unaffected/excluded refs and known old-history holders outside local branch updates, including remote-only/tracking refs and other clones; unchanged notes refs that may still target old IDs, and potential stale SHA anchors in other Helm records, submodule pins, or external systems. Do not label a local branch unaffected if it contains a changed original, even when it is old bookkeeping. Do not inspect/rewrite other workflows' operational state or external pins to fix them. Consistency is scoped to the approved local branch graph, not a guarantee about all future merges or remote/clone histories.
- Every relevant tag's current ancestry from every affected branch and the expected ancestry effect of the exact graph, including product/stream release boundaries. Existing tag objects will stay fixed; rewriting their ancestors can disconnect release history so ship may no longer find a previous reachable release. A mapped old ID alone does not prove a tag will become unreachable; actual verification follows.
- Supported backend/capabilities, metadata/signature effects, external private recovery location and Git-local handoff registration, ledger destination/dependencies and each proposed affected-entry anchor remap (through the verified map, date retained) or exact reviewed invalidation/reason. Surface this maintenance in the existing plan regardless of auto-commit; it is not new compliance. State that this run is local-only, with later publication through ship and possible remote-history effects. Applicable protection, required signing, CI, or review requirements remain binding.

Offer **Apply reviewed rewrite / Edit or change selection / Cancel/keep review only** against this complete current plan. Apply accepts its displayed messages and authorizes its exact affected branch set/graph and declared metadata effects in one decision. A clear response such as "apply all" to this action review supplies that approval; do not relabel it as wording-only and ask again. Earlier selection-only replies still authorize no rewrite. Explain that local history changes can disrupt other clones when published and that all existing tags/excluded refs stay fixed. Preserve separate checkpoint commit policy and any stronger required approvals; no push is included.

Edit or change selection returns to Step 2 without executing anything. Refresh the final text and exact original-ID/message bindings, version implications and checkpoint effects. Recompute affected membership/boundaries when the changed-original set, edit range or ref inventory changes; refresh any predicted new IDs/mappings after a message edit even when the graph membership proof can be reused. Show the resulting current plan before Apply, without a separate approval merely for selecting or editing wording.

After Apply, revalidate the approved content, policy, refs/graph, metadata and checkpoint effects immediately before dependent actions. Unchanged inputs proceed to Step 4 without another confirmation or repeated risk summary. Changed replacement bytes or other material changes invalidate only dependent approval: show the concrete delta and revised complete plan, then obtain its missing approval. Changing only the summary's presentation supplies no reason to ask again. Cancellation writes/migrates no ledger and creates no recovery artifacts. Keep/Defer findings need not block unrelated selected edits, but they block any checkpoint that would hide them. A meaningful no-rewrite assessment retains Step 6's independent eligibility and commit policy; cancellation is not permission to record it.

## Step 4: Apply preflight and verified recovery

Require the mutation prerequisites above. Use **git filter-repo and Python only**; verify installed capabilities for this plan. If unavailable/unsupported, retain the review and provide a manual installation/handoff, without installing or falling back to filter-branch. Do not execute an unavailable backend just to audit. Preserve trees, parent topology/order, author/committer identities and dates, message encoding, and all metadata outside approved edits and explicitly disclosed supported signature loss. Unsupported extended headers (for example unsupported `mergetag` handling) block the affected graph before rewriting. Never silently drop metadata or invent/re-sign signatures.

After the separate branch-preparation stage, do not contact a remote or require a publication destination to complete the local rewrite. Preserve configured remote identities and available remote-tracking/old-history evidence privately as context, without claiming it is still current. Keep exact original local tips and their complete committed history so later history publication through ship can prove containment of a freshly observed remote tip. Remote/protection publication blockers do not waive local ref-update requirements or prevent an otherwise authorized local rewrite. No push question, lease or PR occurs here.

Recheck the entire frozen local branch inventory, exact affected/excluded refs, policy, configuration, canonical state when loaded, every affected worktree, clean state, and reviewed original messages. Reprove the affected-set/descendant-graph match before execution. Changed inputs invalidate dependent approval; do not broaden or silently shrink refs, skip a blocked branch or overwrite user changes. Capture every exported original commit's raw message/metadata/tree/ordered parents, full graph membership, tag ancestry, exact ref/symref snapshots, and remote configuration. Recovery covers every affected old local tip, including consistency-only branches.

Create a unique private directory outside the checkout, restricting access to the user (directory mode 0700, files 0600, or equivalent). Create and verify a **self-contained Git bundle** of all approved old branch tips and all existing tag refs, without exclusions or prerequisite ranges in the bundle. Inspect bundle heads and prerequisites and run bundle verification; merely verifying against the source repository does not prove it is self-contained. Stop before filtering if required history is absent, bundle verification fails, or recovery inputs cannot be retained.

Keep the invocation's original branch/starting HEAD, exact reviewed policy/plan/decisions, original snapshots, bundle inventory, and local ledger plan and later-publication context there. Record sensitive remote configuration privately without exposing credentials in output; the bundle alone does not back up config, index, or worktree.

Read [local normalize handoff](../prompts/shared/normalize-handoff.md). Identify the run's bounded private JSON data entrypoint and register/read back its immutable locator in the actual Git common directory **after recovery verification and before filtering**. This is part of the existing approved rewrite plan, without another prompt. Registration failure retains recovery and stops before rewriting. A pre-filter locator remains a pending hint until this run's actual full verification; preserve it through interruption and later publication. Never register a no-rewrite run or modify another run's locator.

Retain private evidence throughout verification, local ledger handling, later ship publication and resume. It is a per-run recovery record, not a new tracked ledger/schema. Do not delete prior filter-repo metadata or recovery data to reset a run. Rewriting already-filtered history is possible only when this run's independent correspondence can be verified; a prior `.git/filter-repo/already_ran` may cause its commit-map to compose older A→C mappings rather than this invocation's B→C mapping.

## Step 5: Rewrite and verify the complete approved graph

Write a private SHA-to-complete-replacement JSON map bound to the original message snapshots. The shown UTF-8 callback applies only when approved replacement bytes are UTF-8; other supported encodings require an explicitly reviewed byte-preserving representation/callback or the affected rewrite stops. No message interpolation into shell code, newline trimming, or message-text keys. Load the map once per callback process, not once per commit:

```sh
git filter-repo --force --preserve-commit-hashes --preserve-commit-encoding \
  --prune-empty never --prune-degenerate never --commit-callback '
import json, os
global _helm_normalize_map
if "_helm_normalize_map" not in globals():
    with open(os.environ["HELM_NORMALIZE_MAP"], encoding="utf-8") as stream:
        _helm_normalize_map = json.load(stream)
replacement = _helm_normalize_map.get(commit.original_id.decode("ascii"))
if replacement is not None:
    commit.message = replacement.encode("utf-8")
' --refs {frozen_revision_arguments}
```

Set `HELM_NORMALIZE_MAP` to this run's absolute private map path. In one filter operation, pass revision arguments individually with safe quoting, using the complete approved affected branch refs and frozen object-ID boundary exclusions/ranges. Filter-repo supports range-limited refs; verify that their complete union matches the reviewed affected descendant graph and every intended branch update before execution. Never expand a tail message-edit plan into extra message corrections or whole-history filtering. Consistency-only unique messages stay unchanged while their affected parent IDs remap. No tags, ref-renaming callbacks, broad selection, pruning, message-hash substitution, automatic cleanup, or additional ref updates.

`--refs` implies partial mode, preserving origin, excluded refs, and recovery history; `--force` bypasses only the fresh-clone check after approval and verified backup, not any project/provider restriction. No importable filter-repo SDK is required merely to cache the map.

Backend failure stops checkpointing/publication. Preserve actual local results and all private evidence. Do not retry with broader flags, delete metadata, reset refs, reconstruct remotes, or claim rollback occurred.

After filtering, independently derive an unambiguous **current-run old→new map** from the captured graph and actual objects, matching approved complete messages/bytes, trees, ordered mapped parents, identities/dates/encoding, and declared signature effects. Walk the graph consistently and verify every exported commit, boundary parent, selected branch tip, unique commit count, and unselected message. Ambiguous matches, collisions/coalescing, missing objects, unsupported metadata effects, or count/topology mismatches block completion; never guess correspondence from sequence or subject. Cross-check backend metadata against this verified map, accounting for prior composed maps rather than treating them as current-run truth.

Verify every affected branch tip against the current-run map and confirm that each shared original has the same mapped commit across all affected branches. Recheck that no excluded local branch from the frozen inventory was actually affected. Verify **all** existing ref names and exact object IDs/symrefs outside the approved branch updates and all remote configuration are unchanged. Separately verify every tag name/object ID, including annotated/signed tag objects, with no additions/deletions/replacements. Compute actual old/new per-branch tag ancestry and compare with the plan. Report lost release ancestry even when tag identity is intact. Unexpected ancestry effects, missed affected branches or any unapproved change stops ledger/publication; never repair it by moving tags, adding refs or editing other state.

Persist the verified current-run mapping, results, post-filter tips, actual changed branches, tag ancestry, and verification status in the private record. Only a complete match reaches the next steps. Retain this evidence with the bundle for recovery/resume; samples and branch-tip trees alone are insufficient proof.

## Step 6: Plan and record truthful checkpoints

Review only and Stop from the readiness gate authorize no checkpoint or commit, including after a complete assessment or with auto-commit enabled. Do not enter this write path for those outcomes.

### Load only this workflow's state

Reuse Step 1's complete schema-2 validation and baseline snapshot under `{package_root}/prompts/normalize-review.md` and the shared project-state procedure. Recheck `.helm/normalize-log.json` before dependent actions; never open another owner's record. Schema 1 and older shapes are unsupported, with no reader, migration or automatic reset. An absent file means no prior coverage, not an empty checkpoint. The native branch shape is:

```json
{
  "schema_version": 2,
  "branches": {
    "main": {
      "last_checked_commit": "<full lowercase commit ID>",
      "last_checked_date": "YYYY-MM-DD",
      "review_kind": "semantic",
      "review_contract": 1,
      "policy_fingerprint": "<64 lowercase hexadecimal characters>"
    }
  }
}
```

Require full native IDs, valid dates and complete semantic/policy/contract evidence. Resolve real objects and prove full reachable ancestry before reuse; matching format/ancestry alone is insufficient. Record current policy fingerprints only after actual complete semantic assessment under that policy, never merely after mechanical checks. Preserve unknown fields and untouched records. No hook, config profile or persisted syntax cache is introduced.

### Avoid false coverage and bookkeeping churn

Advance only a fully accepted reachable prefix, using compatible proven prior coverage plus complete new semantic assessment and fully verified rewrites where applicable. A bounded suffix without older proof, syntax-only/heuristic work, Keep/Defer or unresolved policy cannot certify a full tip. Existing coverage must remain proven safe; map it through the verified current-run correspondence when needed. If no safe anchor remains, explicitly review removal of the affected entry under the existing invalidation procedure, preserving original data in available private evidence; no null/partial coverage or exception field replaces it. A new retained finding invalidates reuse below that prefix. Treat merge DAGs by reachable-set proof, not a linear earliest-bad shortcut.

Keep unresolved original/mapped IDs in the report and any existing private run evidence. A no-rewrite review does not need a new private recovery record. Retain unaffected branch entries and unknown fields; remove only explicitly reviewed deleted-branch entries, never rebuild the ledger from rewrite refs alone.

A consistency-only branch receives no new/full-tip coverage entry or later date just because it was rewritten. If its existing coverage is still proven valid under the policy, remap only its existing anchor through the verified map when necessary and retain its coverage/date; otherwise apply the existing reviewed invalidation rule without inventing coverage.

Show affected-entry deltas and reasons in the existing pre-commit review/report even with auto-commit. It cannot hide invalidation or turn non-reusable historical records into today's coverage. Reuse disclosed maintenance scope, refresh materially changed actions and retain the separate commit policy without another routine confirmation screen. Only the defined schema-2 coverage fields are added; no shipping or syntax-only ledger follows.

Historical ledger blobs inside rewritten commits remain unchanged; their old anchors require ancestry/coverage revalidation before future use. Failed verification/cancellation never advances state.

Capture the verified source tip before the bookkeeping commit. A subsequent run must recognize a tail consisting solely of this workflow's own bookkeeping by its complete diff, state transition, message/policy, and provenance; do not trust branch names/subjects alone. When it adds no source work or newly proven coverage, keep the existing meaningful anchor/date. Do not write merely because today changed, the ledger commit changed HEAD, a bookkeeping branch exists, JSON formatting differs. If provenance cannot establish such a no-op, revalidate messages but do not serialize identical checkpoint data. Do not recursively add prior bookkeeping branches to default message review or new full-coverage checkpoints; their required consistency-only rewriting/anchor maintenance is not a new audit.

### Local ledger destination

Record the invocation's actual attached branch before rewriting and keep that same branch, at its verified current tip, for an eligible local ledger commit. Do not require main/master, create/select a bookkeeping branch, checkout, push or open a PR. Actual project-specific restrictions still apply; a forbidden current-branch commit leaves bookkeeping pending rather than silently switching destinations. Never expand the rewrite merely to carry a record.

An eligible partial-result ledger may update fully covered message-reviewed branches while preserving/invalidation-handling others honestly; no full-tip claim for retained findings. A checkpoint may refer to proven local source IDs without remote reachability/publication. If no meaningful change is eligible, skip the file/commit/migration path.

Recheck current policy, canonical bytes/existence and the unsupported-path tripwire before writing. Write/read back and strictly validate the reviewed schema-2 result, preserving unknown fields and untouched coverage. Stage only that authorized file; no alternate-path read or retirement occurs. Honor `git-auto-commit`; rewrite approval is not commit approval. Use `chore(normalize): update ledger after {scan / rewrite}` or a compliant equivalent, verify its actual diff and retain source/commit identity in existing private evidence. Failed/declined commits preserve drafts/inputs; no PR or remote dependency completes local work.

## Step 7: Finish locally and retain publication evidence

Finish on the invocation's same branch, never restoring its old pre-rewrite tip. Record the verified old-to-new map, complete old/new affected tips and graphs, bundle inventory, policy/recovery snapshots and actual local ledger commit/parent in the existing private run directory. Refresh evidence only for verified own outputs. Explain which refs remain local and that committed unfinished work on a future pushed branch would also be published. Never push, open a PR, create/switch/delete a branch, tag, promote or prompt for publication.

Report the exact private recovery path, registered local handoff and old/new affected tips. A later `ship` discovers the evidence across sessions in this clone; remembering or copying the path is not required. Ship freshly verifies mappings/destinations and obtains publication approval. Keep explicit paths as the fallback for older runs, moved evidence or another clone/machine.

No tracked publication ledger/schema is introduced. A clean scan or record-only run needs no recovery directory merely for handoff; its ordinary local commit can be shipped normally. Existing unrelated branches and private recovery evidence remain untouched unless included in the exact approved rewrite; publication is a separate ship action.

## Step 8: Resume and report actual state

For local resume, validate the identified private plan, complete frozen affected-branch inventory/graph, verified bundle/map/results, current local refs and eligible record commit against actual source dependencies. Reuse only still-applicable approval. New/moved/deleted branches or ambiguous/incomplete evidence require reconciliation, not rerunning filtering, resetting refs, replacing tags or inventing coverage. Complete only missing local verification/checkpoint work on the same eligible current branch. Remote publication uses ship's independently approved history procedure; no remote capability is required to finish locally.

For a record-only continuation, verify the identified current-branch diff, source baseline, state transition and policy without inventing rewrite evidence. Never adopt another branch from a name/subject, repeat completed filtering/commits or migrate unchanged state just to finish a handoff.

Report:

- Exact committed snapshot, reviewed scope, policy/coverage limits and outcome: review only, clean scan, rewritten locally, cancelled, blocked or verification failed.
- Readiness when applicable: acknowledged/reused, Review only or pending; it is developer coordination context, not proof that other clones are synchronized. Publication and its approval remain with ship.
- Fresh branch discovery, explicitly approved preparation and actual new local refs, unavailable/unprepared agreed branches and any preserved preparation when later work stops. Do not claim remote-only branches were included merely because they were pushed.
- Exact syntax-checked IDs/count, newly semantically reviewed IDs/count, reused compatible prior coverage and explicitly unreviewed IDs/ranges; helper availability/unsupported rules and baseline fallback reasons. Distinguish mechanical pass from accepted/spec-valid nonpreferred/spec-invalid/unresolved message classifications. Report actual message changes versus descendant IDs/signatures, Keep/Defer and out-of-range findings, with up to five before/after examples.
- Message-audited refs/ranges versus the complete affected/rewrite branch set, consistency-only additions and unaudited unique messages, shared-ID verification, excluded/old-history refs and actual per-branch release-tag ancestry/ship implications. A local-only result never claims remote/other-clone reconciliation.
- Own-ledger loaded paths, canonical/migration status, proven branch checkpoints versus pending findings, destination and dependency, committed/draft/pending status. No claims about other workflows' state.
- Exact local old/new affected tips, record commit/drafts, bundle/private evidence paths and actual unchanged branch name. Publication was not performed; report `ship` and the exact private evidence path as the later handoff, with remote/other-clone histories still unchanged.

Preserve local work and coordinate deliberate reconciliation in other clones after publication. Provide recovery steps tailored to the verified bundle/refs and user's work; never prescribe a generic `reset --hard`, branch deletion, or tag replacement. Unchanged tags intentionally retain original objects/history. A local-only rewrite has not altered other clones. Never report a proposal, partial scan, backend exit code, or unverified push as completed work.
