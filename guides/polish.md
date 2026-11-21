# polish

Review a requested interface or piece of user-facing content against the consumer project's selected Writing, Design and Interaction rules. Explain meaningful issues and concrete fixes, then apply only the changes the developer approves. Preserve the project's voice, visual identity and intentional behavior.

## Before starting

Apply the shared runtime first. Polish owns no ledger, review marker, dates, Full/Gap scan or persistent assessment. Do not access operational Helm state, invoke another workflow, install/update rules or change their loading. Git and Safety govern execution; they are not review subjects. Create no helper, probe or orchestration programs during this workflow.

Read [the shared local-edit Git procedure](../prompts/shared/content-sync.md). For a normal invocation, perform its read-only eligibility checks before substantive target investigation, rule comparisons, findings or plans. Require a clean index/worktree, no in-progress Git operation and the actual current main/master base, an established existing feature/maintenance branch or a confirmed environment branch, subject to stronger project policy. Unresolved roles or failed prerequisites stop the workflow. Do not stash, commit pending work, initialize Git or create/switch branches to proceed.

Only an **explicitly requested read-only review** uses the Git rules' static inspection route, which may inspect dirty/staged/untracked, detached/no-HEAD or non-Git inputs within the requested scope. Resolve applicable rules even on that route. It offers no Apply choice and performs no writes, commits or project-code execution. Never enter it as a fallback from a blocked normal invocation; a later request for fixes starts fresh normal eligibility.

## Step 1: Resolve selected rules and scope

Determine which of **Writing**, **Design** and **Interaction** the consumer actually selects through its active project instructions, real imports/read directives, connected Rules references or evidenced host-loaded rules applicable to the target. Respect host precedence and nested/path-specific instructions. Resolve references relative to their declaring file, and read the applicable selected bodies. A descriptive link, filename, installed package or disconnected copy alone does not establish selection. Directly maintained project rules are valid; Adopt provenance is not required. Ambiguous selection needs only the missing clarification, not an automatic installation or substitution.

- With at least one selected, valid, readable rule, use that subset. Missing unselected rules are normal and stay skipped.
- With none selected, explain that at least one of these rules must be selected and stop before substantive target investigation. Do not run Adopt or offer to copy rules as part of this invocation.
- A selected missing/unreadable target, unresolved import or cycle stops the workflow, even when another selected rule is readable. Report the exact broken reference without silently dropping it or substituting the package version.

The bundled Writing rule loaded by the runtime governs workflow prose; that automatic load does **not** establish the consumer's selection of Writing as an audit standard. Use the consumer's actual selected versions, including authorized customizations. Do not compare or upgrade them against bundled rules.

Reuse a supplied page, component, document, directory or defined change set. Ask for scope only when it is materially unclear or too broad to investigate meaningfully; do not silently scan the whole project. Confirm the target belongs to the intended project and resolve containment, actual source ownership and relevant nested rules before dependent reads/edits. Report briefly which selected rules apply and the review's scope; irrelevant provisions are not applicable, not missing requirements. A prose document need not satisfy interface-only provisions.

## Step 2: Review the requested experience

Read the scoped first-party sources and enough related consumers, shared components/styles and existing checks to understand their actual effect. Follow relevant references without expanding into unrelated cleanup. Exclude dependencies, generated/build output and protected operational/recovery evidence from ordinary source review. Generated output is inspected only as an authorized result; corrections belong in its authoritative source.

Use selected rules as the standards rather than reproducing their bodies in a checklist. Preserve custom outlines, terminology, branding, layout choices, meaningful differences, accessibility intent, supported locales, data/behavior contracts and existing test guarantees. A different aesthetic or a repeated word alone is not evidence of a defect. Distinguish a demonstrated issue, a conditional risk, an unknown and an optional improvement. Recommend a change only when its benefit justifies its disruption, regression risk, complexity and maintenance cost in this project; use no scores, tiers or mandatory per-factor report.

Where applicable, inspect rendered content and relevant interaction states using an available preview/browser and existing safe checks within the task's authorization. Inspect entrypoints, wrappers and targets before any permitted execution. Do not install tools, boot services, contact external systems or create a probe program merely to complete the review. Read-only review stays static. If rendered/runtime checks are unavailable but not required to continue, identify the limitation and leave those claims unverified. A required unavailable check stops the workflow. Source inspection cannot prove visual quality, keyboard behavior, clipboard success or accessibility compliance.

Preserve actual producer boundaries under Safety's output-maintenance map. For a proposed README, AGENTS.md, legal or other command-maintained document edit, read its applicable owner authoring instructions and project standards before preparing the change; unavailable instructions leave that fix pending. Polish grants no broad rewrite, layout reconciliation, rule change, legal commitment, assessment closure or marker/provenance advancement. The ordinary fix review can carry sufficiently specific content authority; exact legal-content/commit approval remains independent of auto-commit.

## Step 3: Present findings and review ready fixes

Lead with the scoped result, applicable rules and material coverage limits. Use one numbered finding per actual problem, merging overlaps across the rules. Explain the location, what the reader/user experiences, the relevant selected guidance and why the remedy is worthwhile. Keep optional suggestions and uncertainty distinct from demonstrated issues. For each ready fix, show the concrete before/after or a fenced `diff` with literal `-`/`+` lines and enough context to understand the change without color. Identify paths, dependencies, intended behavior and relevant verification; do not repeat the same explanation in another long plan. Do not invent exact code for a fix still needing investigation or a decision.

Keep all findings visible. Large reports may start with a compact numbered index and show full proposed fixes in manageable batches, identifying what remains undisplayed. Approval covers only the shown ready fixes; keep dependencies together or pending. Numbers are invocation-local selection IDs, not persisted finding records. No findings means a scoped report and completion without questions, writes or commits. Explicit read-only review ends with findings and verification limits, without an Apply menu.

When fixes are concrete, proceed directly to one Review for that proposal:

- **Apply recommended — {IDs}** selects the ready set whose expected benefit justifies its tradeoffs.
- **Apply all proposed fixes — {IDs}** includes other ready, worthwhile options.
- **Leave unchanged** makes no changes for the current review.

List actual IDs in each Apply choice. If recommended and all are identical, show only Apply all proposed fixes; omit empty Apply choices. Leave unresolved fixes out of both sets and explain the needed decision. Accept typed IDs/ranges, exclusions and exact corrections through ordinary text; add no Apply some, Revise or automatic rewriting branch. Check subsets for dependencies without silently adding work. Clarify only missing intent, refresh the affected proposal and obtain any missing approval; sufficient approval for an unchanged exact result remains valid. Skipping a later batch preserves earlier verified work.

Under auto-commit false, the shared procedure may combine an already exact diff/paths/subject with Apply and commit / Apply without committing. An implementation plan does not approve unknown later bytes or legal commits. Do not add a preliminary Continue question or another approval for an already authorized result.

## Step 4: Apply, verify and finish locally

Refresh relevant source, instructions/rules, policy, branch/HEAD and index/worktree before mutation. Drift invalidates dependent proposals/approval; do not absorb concurrent edits. Apply only the approved coherent fixes and necessary approved companions, preserving unrelated content, contracts and protected markers. No ledger, review timestamp, state flag or new rule setup follows.

Read back the result and run applicable existing safe checks for the changed scope, including rendered/interaction verification where needed and authorized. Preserve test protection rather than updating snapshots to hide an unexplained failure. Distinguish source review, passed checks, failed checks and unperformed verification. A required failure stops the workflow with actual files/index and prior successes preserved; never call an unverified fix complete.

Use the shared procedure's **Finish verified local work** and Git commit policy. Stage only exact eligible approved paths, obtain any still-missing commit authority and verify the actual commit. Finish on the same branch without publication, branch operations or automatic invocation of Test, Refactor or other workflows. Report the reviewed scope, selected rules, verified changes/commit, remaining findings and relevant limitations. Deferred or declined findings may reappear in a later invocation because Polish keeps no assessment record.

## Question points

Use the shared [question mechanism (QM)](../prompts/shared/question-mechanism.md). Reuse sufficient supplied answers and ask only where a decision is actually missing.

| Point | Kind and behavior |
|---|---|
| Unresolved eligible branch role, rule selection or target scope | Input, before dependent investigation; a known blocker stops rather than becoming a choice to bypass it. |
| A finding needs intent before a concrete fix | Input for the material missing decision; it does not approve edits. |
| Ready fixes | Review with actual IDs, recommended/all only when distinct, and Leave unchanged; ordinary text accepts exact subsets/corrections. |
| Missing local commit authority | Review of now-known exact diff, paths and subject, or the shared procedure's eligible combined content/commit review. Preserve stronger legal approval. |
