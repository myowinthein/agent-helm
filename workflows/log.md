# log

## Ownership, scope and preservation

Recognize an explicit Status request before preflight so it remains report-only, with no questions or mutations. Read `{package_root}/prompts/shared/project-layout.md` and perform its read-only preflight. Resolve both hosts' effective entries, chains, overrides, existing configuration and any conflicts before Git mutations; Status only reports unresolved inputs. Shared setup uses root AGENTS.md as owner and a real CLAUDE.md importing `@AGENTS.md`. A pointer-only entry is not an incomplete knowledge document. Preserve personal/global/nested instructions and external targets; an unconnected root override stops setup on either host. Never bypass these boundaries to record a lesson.

Use existing memory as the baseline. Preserve durable knowledge, confirmed settings and fenced configuration, imports, adopted Rules, host-specific additions and review-marker provenance. Failure to rediscover a fact does not justify deleting it. A removal, contradiction, restructuring or scope conversion needs evidence and approval of its exact diff; retain uncertain entries and report them for follow-up. Layout preserves instructions according to the layout procedure; scan proposals use the post-layout contents as their baseline.

AGENTS.md contains project orientation and durable working agreements. Adopted `.claude/rules/` files own reusable detailed rules. Keep them consistent: project-specific safety instructions belong in the owner's Hard Safety Rules, proposed for explicit approval. Do not install, update or switch rule files here. Preserve the adopt-managed `## Rules` section and its pointers verbatim, in place. Log owns no operational ledger; never read, stage or migrate `.helm/`, `.claude/helm/` or known flat legacy state.

## Eight-topic checklist

Use these topics to assess useful knowledge and as the default order for new memory. They are not eight mandatory headings. A standard-format owner uses a subset of these headings plus optional `## Rules`; extra/custom headings or a recognized Compass-style configuration layout make it customized, not broken. Preserve customized structure. Missing headings alone never force investigation or prevent an up-to-date result.

| Topic | Useful content |
|---|---|
| Project Identity | Purpose, stack and blast radius; avoid a second README. |
| Project Config | Confirmed Helm declarations in one existing recognized block; preserve all unrelated settings and explicit false. |
| Dev Commands | Essential setup/run/build, focused test, migration and diagnostic commands with prerequisites and evidence. Discoverability does not disqualify useful startup commands. |
| Architecture Pointers | Important entry points and boundaries with their purpose; use task-conditional references for occasional detail instead of a file-by-file walkthrough. |
| Domain Rules | Non-obvious business, permission and lifecycle constraints that application changes could violate. |
| Behavior Rules | Project-specific development agreements, autonomy and verification requirements; avoid restating configuration or rules already loaded. |
| Hard Safety Rules | Concrete project hazards and restrictions beyond inherited rules; distinguish verified absence from unknown risk. |
| Known Traps | Evidence-backed gotchas, historical rationale and developer-confirmed lessons, including recurring corrections. |

For fresh generation omit optional topics with no useful content; do not pad with empty headings or `None`. Keep existing empty sections/placeholders unless their removal is part of an approved diff. Add a useful missing topic during an already-approved update, without renaming/reordering custom sections or moving protected Rules/imports. A heading repair alone is not a source review.

## Step 0 — Read-only assessment and mode choice

First interpret invocation arguments and visible user answers:

- **Status** (`status`): inspect and report only. Never ask configuration questions, write files, create/checkout branches, fetch, commit or publish. Report blockers without requiring their resolution for this read-only result.
- **Remember** (`remember: {lesson}` or an explicit request to record a lesson): propose a focused knowledge patch under Step 4. If no lesson was supplied and none is explicit in the visible conversation, ask what to remember. Never silently substitute a full scan.
- **Full scan / Gap scan:** honor an explicit mode; otherwise use the cheap index below to recommend one. Visible developer corrections may be proposed as lesson candidates, but require the same review as other additions and must not be lost on the no-source-change path.

Remember skips the history index, marker-validation prerequisites and currency decision: read an existing marker only to preserve it. An explicit settings-only request selects a configuration-only proposal without a source review; combine its pending values with any selected lesson/scan path. These focused paths still resolve ownership, check write prerequisites and use the frozen policy. Status reports an invalid marker without offering a scan question.

With a repository and HEAD, resolve `{base_branch}` to the actual main/master using instructions/default branch/refs, without guessing or creating it. Capture current branch, local base SHA, index/working-tree status and visible untracked input paths. Do not read secrets or operational state to classify paths. A dirty tree yields status only and a precise block on writes/reviews; do not commit, stash or discard unrelated work. An unresolved base/owner can still be reported as unknown in Status mode, never treated as current. Without a repository or HEAD, skip base/history commands and currency claims; use the workspace and Full scan/Skip or the explicit focused mode, with Step 2's non-Git rules.

For a history index, extract the owner's `last-reviewed` marker as a literal hexadecimal commit ID, validate the commit object and ancestry to the inspected tip before constructing a range. Reject malformed, missing-object or unrelated markers; never interpolate arbitrary document text as shell code or Git options. On a clean selected base, inspect through its HEAD. Else report the actual checkout and clearly label any read-only local-base comparison as preliminary, not a review of the workspace or remote.

Collect only cheap commit counts, changed paths/rename status, approximate churn and affected first-party packages before asking for scan depth. These are an index, not proof of significance or completed review. Preserve instruction paths in the index. Do not inspect the entire historical patch range just to offer Full scan or Skip. If marker history is invalid/unavailable, report why and offer Full scan or Skip; a history rewrite such as normalize may explain lost ancestry.

### Read-only no-op and status

Exit without Git mutations only when the tree is clean on the selected base, both entries are already connected, applicable configuration is complete, no scan/lessons/settings changes were explicitly requested, the marker is valid, and no source gap remains. An empty range establishes no new commits. If intervening commits only maintain instruction outputs, inspect every relevant patch, including their setting/safety meaning, and verify that current memory represents the durable content before treating them as maintenance. Never exclude instruction paths by name or trust commit labels. Any uncertain/source change instead goes to mode selection.

Report `up to date at local {base_branch}@{sha}; remote not fetched` and leave the marker unchanged. Missing optional headings are informational. Do not claim live environment/remote currency. Status mode on a dirty or feature checkout names that checkout, local base SHA, known gap and pending differences; it does not call the workspace current, advance a marker or claim patch coverage from an index.

### Select work

| Assessment | Choices and recommendation |
|---|---|
| Fresh owner, Rules-only bootstrap, no marker or invalid marker | Full scan (preserve custom memory through targeted edits) or Skip. |
| Valid marker with a possible source gap | Gap scan, Full scan, or Skip. |
| No source gap but explicit lessons | Remember or Skip; an already-requested Remember needs no extra mode question. |
| Only missing configuration remains | Collect the missing settings for a configuration-only proposal, or Skip. |
| Only layout connection/reconciliation remains | Propose the layout-only action or Cancel; do not force an otherwise unnecessary scan. |

With an existing owner and explicit lesson candidates, Remember may also be offered beside Full scan/Skip when no valid review marker exists. This does not establish source currency. An explicitly selected work mode takes precedence over the generic recommendation table.

Only when choosing Full scan versus Gap scan, read `{package_root}/prompts/shared/scan-scope.md`. Supply the already permitted marker-validation result, inspected snapshot, request and cheap impact index; do not load it as a prerequisite for Status, Remember, settings-only or layout-only work. Caller input/ownership blockers remain blockers; a missing review anchor does not authorize bypassing them.

Use its impact-based recommendation with log's existing scope: added/removed first-party packages/services, major runtime/framework replacements and cross-area change are relevant breadth evidence; localized changes normally favor Gap scan. Counts, age and missing headings alone do not determine depth. Absent separate Full-scan history metadata means unknown, not proof no Full scan occurred. Explicit Full scan is honored even with no source gap; an explicit valid Gap scan must still meet the complete per-commit patch contract below. This is a depth recommendation, never a category filter or permission to omit affected lessons. A custom owner receives targeted edits in either mode; this adds no targeted-scan mode. A Rules-only bootstrap is fresh knowledge, not an excuse to replace its Rules. Log alone retains its no-op, marker and acceptance gates.

A selected Skip with no layout work writes nothing, drops pending choices and exits before branch setup. Layout repair/adapter creation may still be separately proposed and finalized when the scan is skipped; cancelling layout approval ends the invocation without a scan. With neither entry, Skip creates neither. Remember requires an existing owner or an approved migration of one; with neither entry, offer Full scan or Cancel and carry the supplied lesson into a chosen full-scan proposal rather than inventing project knowledge.

## Step 1 — Missing settings and frozen run policy

Before any Git mutation on a selected write path, retain explicit setting-change requests and collect missing applicable choices once in `{pending_config}`, recording which keys were originally absent. Batch questions when the host can faithfully represent them; otherwise ask the same small set sequentially, retaining answers. Do not ask existing valid values again, infer consent from a default, or overwrite unrelated settings such as readme-style or unrelated declarations. Do not collect/reintroduce the retired `environment-promotion` setting.

| Setting | Question and values |
|---|---|
| ship-method | For future ship only: Direct integration/push (`direct`) or PR/MR handoff (`pr`, default). No team-size/branch-layout question. Offer this during setup or an explicit configuration request; it never gates local editing. |
| git-auto-commit | Commit completed tasks automatically (`true`), or ask before committing (`false`, default). Publication remains separately approved in ship. |
| git-merge-strategy | For eligible future ship integrations: Squash (`squash`, default), Rebase (`rebase`), or Merge commit (`merge`), independently of ship method. |


Record `{run_config_baseline}` from actual raw declarations/owner/overrides. Freeze `{run_auto_commit}` from existing effective policy plus an explicit answer for an absent key (default false); changed existing values apply next invocation. Publication/merge settings are future ship preferences, never branching permissions for this run. Missing answers use documented defaults without treating them as consent to persist a declaration. No unresolved publication-only choice prevents independent local knowledge work.

Answers are pending configuration, not permission to write an unseen diff. Persist only accepted choices in the existing recognized block, retaining fenced wrappers. If none exists, show a minimal Project Config addition before inserting it. Never place shared settings in a wrapper, create a second owner or reask during generation. Cancel drops pending values; explicit settings-only acceptance may save them without a knowledge review. A genuinely fresh file receives settings only when its selected full scan writes it.

## Step 2 — Prepare and connect the shared layout

With a repository and HEAD, apply **Prepare the current branch** from `{package_root}/prompts/shared/content-sync.md` under the frozen commit policy. Require clean state on the actual main/master base; otherwise block writes and explain without changing branches. Revalidate actual entries, owner/chains, raw declarations and overrides against `{run_config_baseline}`. Overlay only approved values for keys absent in both snapshots. Stop unexpected drift; pending configuration is not persisted policy.

For scan paths, recheck the cheap index against the unchanged current base snapshot. Reuse a selected scan only when its prerequisites still hold; invalid/new history or a materially different scope needs a revised recommendation, not stale approval. Remember/settings-only paths instead recheck their actual inputs without requiring a history index or valid marker. Then pin `{review_head}` to actual HEAD before layout writes. It identifies the source snapshot investigated on scan paths, never a later layout, knowledge or integration commit.

Without a repository or HEAD, skip Git branch restrictions and all commits/merges/pushes/promotion, do not initialize Git and do not generate a review hash. Investigate/recheck the actual workspace inputs on selected scan paths. Existing markers retained by layout/Remember/partial work are provenance, not evidence of currency; a completed accepted full scan without HEAD omits a marker.

Apply the layout procedure's exact-diff approval, application and read-back on actual destination files. Resolve cycles/independent roots as it prescribes, preserve confirmed settings and adopted rule paths, and verify both host paths reach the same shared owner. Fresh files wait for a selected full scan and are created together. A layout-only change is real work even if the scan is skipped/current. Commit a completed layout migration separately before scanning under the frozen commit policy, retaining its old marker. Declined/failed layout approval or commit stops dependent work with actual pending files preserved. Capture the resulting instruction contents as the knowledge baseline.

Route only to the selected work: scans use Step 3 and then Step 5, Remember uses Step 4 and then Step 5, and configuration-only uses Step 5 directly. Layout-only/scan Skip goes to Step 6 for already-approved outputs, or Step 5 first if a separate settings-only proposal was explicitly selected. Do not run an unselected investigation or ask for lessons just because its section follows below.

## Review evidence and marker contract

These conditions apply to scan paths and their finalization; Remember and configuration-only paths never advance the source-review marker.

- With HEAD, a full scan reviews the project at `{review_head}`; a gap review covers the validated saved marker through that snapshot. Full-scan currency attests to the snapshot, not every intermediate historical commit. Inspect history needed for specific rationale. A completed gap review accounts for every commit's changed paths and relevant patches, including merge results against relevant parents, renames, deletions, reverted work and affected callers/tests/config/docs. Commit subjects/types navigate; never filter out fixes, styling, dependencies, CRUD or refactors wholesale. Net diffs and messages alone cannot establish complete gap coverage.
- Inventory relevant first-party source/config/scripts/tests/docs and visible untracked inputs, respecting exclusions. A committed review stops on inputs outside the pinned snapshot; expected approved layout outputs are the sole instruction-output exception. Never absorb, auto-commit, stash or discard the user's changes to get a clean review. Without HEAD, record inspected workspace inputs directly.
- Keep a working coverage summary by package/topic with evidence paths and reasons for absent/excluded areas. Full scans meet Step 3 across every first-party package. Gaps account for every commit/path; reuse prior inspection rather than rereading unchanged evidence. Inaccessible or unfinished relevant inputs mean incomplete review, not no change. Keep detailed coverage in the proposal/report, not in always-loaded memory or a new ledger.
- Recheck original instruction contents and relevant inputs before applying a proposal and before commit. HEAD must remain `{review_head}` or this run's recorded layout commit. Any unrelated tip/input change requires refreshed investigation and approval of the new diff. Never apply stale approval.
- Advance the marker only when investigation is complete and every proposed substantive knowledge change is accepted and successfully written. Rejected, partial, cancelled, skipped or incomplete work retains the prior marker and reports outstanding findings. Invalid/ambiguous-marker removal also needs exact-diff approval; a fresh incomplete review has no marker.
- A complete gap review finding no durable changes may apply confirmed settings and an eligible marker-only update without another knowledge-diff question. No new source commits, verified instruction maintenance, layout-only work, Remember or settings-only work never advance it. Write an eligible marker with the accepted knowledge, verify together and retain that original source SHA after later commits/merges. Do not chase log's own output with repeated marker commits.
- A fresh/default generated document puts an eligible marker last, after preserved Rules. Targeted updates preserve custom non-final placement; when already final, insert additions before it. Partial work does not move or invent the marker for style.

If investigation is blocked/incomplete, retain the old marker. Finalize only separately approved layout/configuration/partial-knowledge outputs whose read-back is sound and which contain no pending unapproved drafts. Report incomplete coverage; never integrate/delete a branch carrying unapproved changes. A no-write/no-commit exit performs no cleanup; no workflow branch was created.

## Step 3 — Investigate the selected scan

At an actual Full scan or Gap scan investigation, read `{package_root}/prompts/shared/investigation-evidence.md`; Status, Remember and settings/layout-only work gain no source-scan prerequisite. Use only the standardized Full scan / Gap scan labels. Apply exact transient inventory, justified exclusions and proportional read-only delegation without operational-state access.

Run only the selected subsection. A scan may also include approved developer-stated lessons using Step 4's evidence rules; standalone Remember's no-review-marker restriction does not replace the scan's complete-coverage/acceptance contract.

### Full scan

Inventory every first-party package/service and its entry points at the reviewed snapshot, excluding only evidenced out-of-scope material. Assign every package/topic, independently of existing memory or familiar findings. Trace representative primary workflows through real business logic, persistence and integrations, plus applicable setup/configuration/CI and representative tests. Investigate additional distinct flows when needed to cover the package's knowledge topics; one flow is not proof all independent responsibilities are covered. Full scan is representative source tracing across every relevant package/topic, not refactor's detailed full-file audit. Inspect each applicable topic across those packages:

| Topic | Minimum evidence when present |
|---|---|
| Purpose/scope | README/project docs, metadata, exposed routes/commands/UI and prior memory/shared dependencies. |
| Stack/setup | Manifests, relevant locks/runtime/config, example env key names and install/run/build scripts. |
| Architecture/workflows | Major modules' entry points and representative implementations, tracing primary flows through business logic, persistence and integrations. |
| Domain constraints | Schema/migrations/models, validation/permissions, state transitions, business services and lifecycle tests. |
| Development | Contributor docs, lint/format/type settings, test setup and representative tests/fixtures, hooks and CI; distinguish preferences from enforced checks. |
| Operations/safety | Deployment/container/task/CI config, destructive scripts, jobs, environment ownership and integrations. Read commands, do not execute operational actions. |
| Traps/prior lessons | Existing entries, warnings, failure paths, developer-confirmed lessons and history needed to reconcile contradictions. |

Folder names or a README-only sample do not establish implementation coverage. Representative reading across every major package/topic is already allowed; a sample of one package does not stand for an entire monorepo. Disclose restricted relevant areas; never read credentials or operational ledgers to fill coverage. A completed scan needs the coverage contract above, without new per-package markers, automatic nested files or resumable state.

Assess every existing durable entry: retain, propose an evidence-backed update/removal, or retain pending clarification. Preserve historical rationale and operational knowledge code cannot prove. For a default-format owner assemble the accepted candidate in its useful existing/default sections; customized owners receive targeted patches. Whole-file replacement is a writing technique, not deletion by omission. Merge pending settings once and preserve Rules/imports verbatim in place.

### Gap scan

Freeze the validated interval's exact commit IDs and account for each commit's changed paths/relevant patches, including merges, reverts, renames and deletions. Label patch/context investigation and any unreviewed relevant material; dismiss noise only with actual knowledge-impact evidence. Reconcile covered commit IDs with the complete frozen set, never just matching counts or a final net diff. Large independent commit batches or Full-scan packages may use permitted read-only subagents; preserve ordered history meaning and have the parent reconcile shared topics/decisions and cross-package flows. Workers return evidence and coverage, including no-lesson batches, not only proposed additions. Unmet relevant investigation keeps the review incomplete and its old marker intact.

Use the cheap index to organize the full per-commit relevant-patch investigation defined above. Reuse assessment evidence while inputs remain unchanged. Follow architecture, conventions, domain/lifecycle/permission rules, operations and traps affected by the commits. A change is noise only after evidence shows it adds, invalidates or changes no durable knowledge. Do not persist a commit-by-commit changelog. This run's layout commit is outside the reviewed source range; other layout/maintenance commits count as noise only after verifying unchanged instruction meaning/settings or knowledge already represented.

Use targeted edits in affected existing sections; leave unrelated content exactly intact. Prefer improving/merging existing entries to adding duplicates. Ordinary additions must improve future decisions and be durable for weeks/months, and should capture knowledge difficult to rediscover quickly. Essential evidenced setup/run/build/focused-test commands are exempt from that discoverability condition: they are valuable startup context even if present in scripts. Developer-stated lessons use Step 4's evidence rules in either scan mode. Temporary task status/completed work alone is not useful memory.

A fully inspected range with nothing durable to change uses the marker-only outcome in the contract. Otherwise describe what was learned, why it matters and the exact proposed patch; continue through Step 5. Stale adopted rules may be reported for follow-up, never edited here.

## Step 4 — Remember developer-confirmed lessons

Use explicit lessons in invocation arguments or developer corrections/agreements in the current visible conversation as evidence, alongside inspected code/config/docs. You may suggest candidates from that visible context, but obtain approval of their concrete wording/scope before writing. Never mine hidden transcripts, prior sessions, host-private auto-memory or personal files, and never turn an inferred preference into confirmed policy.

Filter for project relevance, lasting value and improved future decisions. Show provenance in the proposal (for example, stated by the developer this session), not dates, transcripts or a session changelog in memory. Record the lesson as an actionable instruction, including its rationale when useful. Shared lessons belong in the owner; clearly Claude-only additions may go after the adapter's import, and Codex-only mechanics need an explicit condition in shared memory. Do not duplicate configuration declarations as prose. An explicit setting-change request uses the pending-config rules and the frozen invocation policy.

If a desired policy conflicts with observed implementation, show that discrepancy. Let the developer choose Record as policy, Record as trap/known violation, or Drop, unless their explicit instruction already unambiguously selects one. Do not assert the desired state is implemented, silently erase the lesson, or silently change code to satisfy it. Resolve conflicts with existing guidance through a reviewed diff. New safety rules always require explicit approval.

Remember performs only the local evidence checks needed for that patch, then Step 5's quality/approval and Step 6's verification. It never requires a whole-project/history scan and never advances, removes or regenerates a review marker, even if it happens to read all recent commits. Preserve its value/placement (or absence) exactly. Report lessons recorded and source coverage as not reviewed. A later source review treats the actual resulting instruction-maintenance diff conservatively; no automatic marker churn. Preserve the supplied lesson across any approved owner migration.

## Step 5 — Memory-quality audit and concrete approval

For every proposed knowledge/configuration write, check the following before applying it. A layout-only write uses the layout procedure's preservation audit instead; Status/no-op performs no curation write.

- **Accuracy:** trace commands to actual scripts/task runners/config and required runtime/prerequisites; check named input/reference paths. This is inspection, not running commands or tests. Identify intentional placeholders/future outputs and external/unavailable dependencies rather than claiming existence. Distinguish documented policy, observed implementation and developer-confirmed lessons; flag unsupported claims and unresolved contradictions.
- **Consistency:** compare with the actual effective configuration, loaded rules/imports and retained instructions. Show duplicate or conflicting spans and their source. Propose removing redundant restatements only when the rule is actually inherited; keep necessary standalone/project-specific safeguards. Ambiguous scope or uncertain knowledge stays unchanged pending review. Never weaken mandatory eager safety reads as a context optimization.
- **Portability:** verify shared guidance works on both hosts, keep host-only actions conditional/in the adapter, and preserve memory ownership, imports, Rules and overrides.
- **Context value:** keep concrete commands, critical boundaries and lessons; avoid generic language advice, code tours, task logs and repeated policies. For occasional details prefer a conditional pointer to an existing document. Splitting text into eagerly loaded imports does not reduce context. Do not automatically generate support files, nested entries or a second owner.
- **Footprint:** report current/proposed owner lines and UTF-8 bytes, with adapter/additional mandatory reads separately when known. Retain the soft under-150-line goal, not an invented byte/token limit or permission to truncate. Codex's discovered-file byte budget and later explicit file reads are different costs; disclose unknown effective limits. Never auto-prune protected/durable content to meet a size goal.

For an existing owner, show one consolidated diff per completed phase, grouped by section and including pending settings, any marker change and concrete removals. Offer at most four faithful choices: Apply all, Apply some (explicit selected changes), Revise, Cancel. Ask once for that actual phase, not per section; reuse approval only when it covers the exact resulting transformation. Re-audit revisions and preserve unaccepted existing content. Partial acceptance blocks marker advancement. Safety changes require explicit approval even in fresh generation.

For a genuinely fresh owner or Rules-only bootstrap, choosing Full scan authorizes ordinary descriptive content and the fresh adapter; disclose the proposed content/coverage and any unresolved findings, and get explicit approval for new safety instructions before writing them. Existing Rules/settings remain protected. Only create both entries together with a valid target. Custom or existing knowledge always requires the reviewed diff above. Cancel discards that phase's pending choices; an earlier approved layout change still finalizes separately. Explicit settings-only acceptance writes only its reviewed settings and leaves the marker unchanged.

## Step 6 — Verify, commit and finalize

Apply only accepted output using a complete replacement only when accepted as such, otherwise targeted edits. Recheck inputs first, then read outputs back: retained entries and settings (including false), exact accepted edits, Rules/imports, adapter/host-only additions, shared owner resolution, footprint and marker eligibility/value/placement. Verify both host paths without claiming native-client execution. On failed write/read-back stop dependent operations, report actual files and leave work recoverable.

With no HEAD report verified changes as uncommitted and skip Git entirely. Otherwise commit remaining knowledge/configuration/Remember outputs separately from any earlier layout commit using the frozen run policy. Stage only exact approved instruction paths with literal pathspecs and inspect the staged diff. Use an accurate scoped message, such as `docs(log): record project lessons` or `docs(log): update project knowledge`; do not recommit layout outputs. When auto-commit is false, require concrete approval for each now-known commit. An explicit Apply and commit reply may cover the one shown exact diff/paths/message; it cannot authorize an unknown later knowledge commit. This commit grants no future publication approval; do not offer push, PR/integration or promotion here.

After verifying eligible local outputs/commits, apply **Finish verified local work** from `{package_root}/prompts/shared/content-sync.md`. Finish on the current permitted branch. No push/PR question, integration, environment promotion, branch creation/switch/return or cleanup follows. Preserve drafts and failed/declined commits honestly; publication is a later explicit ship action. A verified local result needs no remote/provider availability or published-source dependency. Scan Skip/current never erases earlier approved writes/commits. Keep incomplete review and unchanged marker status explicit.

## Step 7 — Report actual outcomes

Use output verification captured on the same actual current branch. Distinguish verified local knowledge/setup, commits and pending drafts; publication is a separate later ship action. Summarize:

- Outcome: local status/up to date, full/gap review written, lessons recorded, configuration only, partial/incomplete review, or skipped; actual owner/adapter and setup/migration result.
- Snapshot/coverage: local base and whether fetched for Status; actual pinned source SHA/range and topic/path evidence for scans; Remember/settings only are not source reviews. List exclusions and unresolved/unaccepted findings, including uncertain retained knowledge.
- Marker: accepted original snapshot, unchanged with reason, or absent; missing optional topics are informational. Do not label partial/incomplete coverage a completed review.
- Content: sections/lessons/settings changed, preservation/read-back and memory-quality findings, owner lines/bytes and relevant loaded-reference costs/limits when known; stale rules worth revisiting without changing them.
- Git: current branch, separate verified layout and knowledge/configuration/Remember commits or uncommitted paths, and actual checks/limits. Publication was not performed; ship is a separate later action. No branch creation, return, PR or deployment claim.
