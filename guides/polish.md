# polish

Discover the consumer project's Writing, Design and Interaction rules and relevant custom standards, agree which optional standards to use, then review the requested interface or user-facing content. Explain meaningful issues and concrete fixes, then apply only the changes the developer approves. Preserve the project's voice, visual identity and intentional behavior.

## Before starting

Apply the shared runtime first. Polish owns no ledger, review marker, dates, Full/Gap scan or persistent assessment. Do not access operational Helm state, invoke another workflow, install/update rules or change their loading. Git and Safety govern execution; they are not review subjects. Create no helper, probe or orchestration programs during this workflow.

Read [the shared local-edit Git procedure](../prompts/shared/content-sync.md). For a normal invocation, perform its read-only eligibility checks before substantive target investigation, rule comparisons, findings or plans. Require a clean index/worktree, no in-progress Git operation and the actual current main/master base, an established existing feature/maintenance branch or a confirmed environment branch, subject to stronger project policy. Unresolved roles or failed prerequisites stop the workflow. Do not stash, commit pending work, initialize Git or create/switch branches to proceed.

Only an **explicitly requested read-only review** uses the Git rules' static inspection route, which may inspect dirty/staged/untracked, detached/no-HEAD or non-Git inputs within the requested scope. Resolve applicable rules even on that route. It offers no Apply choice and performs no writes, commits or project-code execution. Never enter it as a fallback from a blocked normal invocation; a later request for fixes starts fresh normal eligibility.

## Step 1: Discover rules for the requested scope

Reuse a supplied page, component, document, directory or defined change set. Ask for scope only when it is materially unclear or too broad to investigate meaningfully; do not silently scan the whole project. Confirm the intended project, target containment and applicable nested/path-specific instructions using minimum permitted metadata before substantive target investigation.

Follow active project instructions, real imports/read directives, connected Rules references and evidenced host-loaded rules. Resolve references relative to their declaring file and respect host precedence. Also inspect existing project rule locations, such as `.claude/rules/` or a maintained `rules/` directory, and custom-standard locations identified by project instructions or the request, such as `docs/standards/`. Read candidate guidance enough to establish its role and relevance, not every Markdown file or implementation body. A descriptive link, filename or disconnected copy is only a discovery lead, never selection or authority. Direct project-maintained rules need no Adopt provenance. Track paths, applicability and decisions only in invocation context, without a manifest, cache or saved configuration.

Separate **Helm rules** (Writing, Design and Interaction) from **custom standards** relevant to the requested content/interface. Determine their actual role from instructions and content, including customized copies; do not classify by filename alone. Exclude Git, Safety and other operational guidance from audit candidates even if found in the same locations. A document uses relevant editorial provisions, not interface-only checks. Consult authoritative online resources only when a specific uncertainty warrants it; research does not silently add a new standard or replace project decisions.

Relevant standards required by active project instructions remain binding and are included automatically. Optional candidates need selection in Step 2. A required or explicitly selected missing/unreadable rule, unresolved import or cycle stops the workflow, even when another rule is valid; do not silently substitute a copy. An unreadable optional candidate is reported unavailable and excluded from the suggested set. Resolve ambiguous identity, relevance or conflicting instructions before dependent review, without treating a rule-selection answer as authority to override project policy.

Use actual consumer versions and authorized customizations. The bundled Writing rule loaded by the runtime governs workflow prose but does **not** establish a consumer audit standard; installed package copies alone are not candidates. If no valid, applicable consumer Writing, Design or Interaction rule is available, stop before target investigation and explain the existing requirement for at least one. Do not install rules, invoke Adopt or substitute a package version.

## Step 2: Present candidates and choose optional standards

Before reviewing target bodies, show a compact candidate table with stable invocation-local IDs, file paths, group, suggested use and a short reason. Distinguish **Required**, **Suggested**, **Not relevant** and **Unavailable** where applicable; do not enumerate unrelated files just to fill the table. Explain the scope of discovered locations rather than claiming an exhaustive repository-wide rule search. Required standards are already included; declined or irrelevant optional candidates stay out of the review.

Say before asking: **You can also type file names, numbers, exclusions or another rule path to customize this review.** These choices select review standards for this invocation; they neither install/connect rules nor approve edits. Supplied paths remain subject to containment, readability, relevance and instruction precedence. Add no installation, rule-loading or configuration writes.

Ask up to two **Single** questions with exactly **Yes / No** choices, naming the actual optional suggested paths/IDs in each question:

1. **Use the suggested Helm rules for this review?** Yes includes the whole shown optional Helm set; No declines that set.
2. **Also use the suggested custom standards?** Yes includes the whole shown optional custom set; No declines that set.

Batch independent questions through QM when supported. Skip empty groups and reuse an explicit supplied selection; do not ask merely to reconfirm it or standards already required by project instructions. Do not use Multi, per-file Yes/No questions, a third Customize choice or a custom picker. Keep custom text available through QM; typed IDs, exclusions or paths refine the selection rather than implying the highlighted Yes. Ask Input only for an actual ambiguity or missing fact, and validate new candidates before using them. An unanswered group remains pending, not No; wait before the target review.

Summarize the resulting standards briefly. A No/custom exclusion never disables required instructions. Keep the existing minimum: at least one valid, applicable consumer Writing, Design or Interaction rule must remain included, whether required or selected. If the answers leave none, explain that limit and stop without target investigation; custom standards supplement that foundation. Broken newly selected references retain their stop. No answer or rule selection authorizes a fix.

## Step 3: Review the requested experience

Read the scoped first-party sources and enough related consumers, shared components/styles and existing checks to understand their actual effect. Follow relevant references without expanding into unrelated cleanup. Exclude dependencies, generated/build output and protected operational/recovery evidence from ordinary source review. Generated output is inspected only as an authorized result; corrections belong in its authoritative source.

Use selected rules as the standards rather than reproducing their bodies in a checklist. Preserve custom outlines, terminology, branding, layout choices, meaningful differences, accessibility intent, supported locales, data/behavior contracts and existing test guarantees. A different aesthetic or a repeated word alone is not evidence of a defect. Distinguish a demonstrated issue, a conditional risk, an unknown and an optional improvement. Recommend a change only when its benefit justifies its disruption, regression risk, complexity and maintenance cost in this project; use no scores, tiers or mandatory per-factor report.

Where applicable, inspect rendered content and relevant interaction states using an available preview/browser and existing safe checks within the task's authorization. Inspect entrypoints, wrappers and targets before any permitted execution. Do not install tools, boot services, contact external systems or create a probe program merely to complete the review. Read-only review stays static. If rendered/runtime checks are unavailable but not required to continue, identify the limitation and leave those claims unverified. A required unavailable check stops the workflow. Source inspection cannot prove visual quality, keyboard behavior, clipboard success or accessibility compliance.

Preserve actual producer boundaries under Safety's output-maintenance map. For a proposed README, AGENTS.md, legal or other command-maintained document edit, read its applicable owner authoring instructions and project standards before preparing the change; unavailable instructions leave that fix pending. Polish grants no broad rewrite, layout reconciliation, rule change, legal commitment, assessment closure or marker/provenance advancement. The ordinary fix review can carry sufficiently specific content authority; exact legal-content/commit approval remains independent of auto-commit.

## Step 4: Present findings and review ready fixes

Lead with the scoped result, applicable rules and material coverage limits. Use one numbered finding per actual problem, merging overlaps across the rules. Explain the location, what the reader/user experiences, the relevant selected guidance and why the remedy is worthwhile. Keep optional suggestions and uncertainty distinct from demonstrated issues. For each ready fix, show the concrete before/after or a fenced `diff` with literal `-`/`+` lines and enough context to understand the change without color. Identify paths, dependencies, intended behavior and relevant verification; do not repeat the same explanation in another long plan. Do not invent exact code for a fix still needing investigation or a decision.

Keep all findings visible. Large reports may start with a compact numbered index and show full proposed fixes in manageable batches, identifying what remains undisplayed. Approval covers only the shown ready fixes; keep dependencies together or pending. Numbers are invocation-local selection IDs, not persisted finding records. No findings means a scoped report and completion without questions, writes or commits. Explicit read-only review ends with findings and verification limits, without an Apply menu.

When fixes are concrete, proceed directly to one Review for that proposal:

- **Apply recommended — {IDs}** selects the ready set whose expected benefit justifies its tradeoffs.
- **Apply all proposed fixes — {IDs}** includes other ready, worthwhile options.
- **Leave unchanged** makes no changes for the current review.

List actual IDs in each Apply choice. If recommended and all are identical, show only Apply all proposed fixes; omit empty Apply choices. Leave unresolved fixes out of both sets and explain the needed decision. Accept typed IDs/ranges, exclusions and exact corrections through ordinary text; add no Apply some, Revise or automatic rewriting branch. Check subsets for dependencies without silently adding work. Clarify only missing intent, refresh the affected proposal and obtain any missing approval; sufficient approval for an unchanged exact result remains valid. Skipping a later batch preserves earlier verified work.

Under auto-commit false, the shared procedure may combine an already exact diff/paths/subject with Apply and commit / Apply without committing. An implementation plan does not approve unknown later bytes or legal commits. Do not add a preliminary Continue question or another approval for an already authorized result.

## Step 5: Apply, verify and finish locally

Refresh relevant source, instructions/rules, policy, branch/HEAD and index/worktree before mutation. Drift invalidates dependent proposals/approval; do not absorb concurrent edits. Apply only the approved coherent fixes and necessary approved companions, preserving unrelated content, contracts and protected markers. No ledger, review timestamp, state flag or new rule setup follows.

Read back the result and run applicable existing safe checks for the changed scope, including rendered/interaction verification where needed and authorized. Preserve test protection rather than updating snapshots to hide an unexplained failure. Distinguish source review, passed checks, failed checks and unperformed verification. A required failure stops the workflow with actual files/index and prior successes preserved; never call an unverified fix complete.

Use the shared procedure's **Finish verified local work** and Git commit policy. Stage only exact eligible approved paths, obtain any still-missing commit authority and verify the actual commit. Finish on the same branch without publication, branch operations or automatic invocation of Test, Refactor or other workflows. Report the reviewed scope, selected rules, verified changes/commit, remaining findings and relevant limitations. Deferred or declined findings may reappear in a later invocation because Polish keeps no assessment record.

## Question points

Use the shared [question mechanism (QM)](../prompts/shared/question-mechanism.md). Reuse sufficient supplied answers and ask only where a decision is actually missing.

| Point | Kind and behavior |
|---|---|
| Unresolved eligible branch role, candidate identity/relevance or target scope | Input, before dependent investigation; a known blocker stops rather than becoming a choice to bypass it. |
| Suggested optional Helm rules | Single; Yes / No for the whole named set, with ordinary text for exact IDs, exclusions or paths. Skip an empty/already-answered set; required rules remain included. |
| Suggested optional custom standards | Single; Yes / No for the whole named set, with the same custom-text behavior. Batch with the independent Helm question when supported; no Multi or per-file membership sequence. |
| A finding needs intent before a concrete fix | Input for the material missing decision; it does not approve edits. |
| Ready fixes | Review with actual IDs, recommended/all only when distinct, and Leave unchanged; ordinary text accepts exact subsets/corrections. |
| Missing local commit authority | Review of now-known exact diff, paths and subject, or the shared procedure's eligible combined content/commit review. Preserve stronger legal approval. |
