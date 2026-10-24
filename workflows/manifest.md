# manifest

## Before starting

Resolve `{memory_file}` through the shared runtime before any Git mutation or file write. If the resolved owner does not exist, stop: "Run the log workflow first to establish shared project instructions, then re-run manifest." Do not create instruction files, migrate an owner, or automatically invoke log. Existing bridges, overrides, conflicts, and missing import targets follow the runtime's resolution rules.

Read `{package_root}/prompts/shared/content-sync.md` and record the normal invocation Git policy. Manifest reviews the merged, stable project state. Its read-only preflight precedes **Prepare the current branch**; selected real work still requires that helper's clean-tree, actual main/master base, ownership, local commit and verification rules; publication belongs to ship. Do not borrow log's first-run policy overlay or initialize Git in an unversioned project.

## Scope

The README is an entry point for people evaluating, using or contributing to the project. Explain purpose, prerequisites, the smallest useful getting-started example, common usage, help, contribution and license facts. Link detailed documentation rather than copying a technical specification, dependency inventory, changelog or deployment manual. Include API, configuration or development details only when readers need them here. No compulsory badges.

Keep shared Claude and Codex instructions in the resolved owner. A full scan describes investigation breadth, not permission to replace existing writing.

## Step 1: Read-only preflight and choices

### Discover the target and preserve its context

Inventory actual README candidates in `.github/`, the root and `docs/`, including alternative formats, case variants and translated/package siblings. GitHub's entry-point priority is `.github`, then root, then `docs`; report the effective entry when unambiguous. Do not guess precedence between competing filenames within one directory or treat every translation as the primary entry.

Root `README.md` remains the default target, using an existing equivalent filename's actual casing rather than creating a duplicate. Set `{readme_file}` to the chosen path for this invocation only. If another location overrides root on GitHub, root is missing while another candidate exists, candidates are ambiguous, or the developer requests another target, show the candidates and ask which one to maintain before investigation/writes. Use at most four options, grouping a long list behind **Select existing target**. Offer root explicitly; do not silently switch to GitHub's entry or update siblings/translations. Do not add a persistent target setting.

Preserve an explicitly selected alternative format; if the workflow cannot safely author it, stop for a reviewed format/target decision instead of writing Markdown into it. Resolve symlinks and containment; unsafe/outside-project targets need a safe placement decision, not replacement or an outside write. A generator-owned target needs its generator workflow or another approved target. Preserve generated blocks inside an otherwise editable README.

Read the target as the baseline. Record section structure, unique human context, language, YAML/frontmatter, permalink, banners, badges, assets, HTML, comments, reference definitions, generated blocks and link conventions. Consider every real rendering context, including GitHub, a documentation site and the distributed package. Do not normalize away these features during a scan.

Check effective instruction dependencies. If the README is the memory owner or is loaded as active instructions, stop the ordinary rewrite and explain the conflict. Offer a separate human-documentation target or an explicit instruction-reconciliation task. Do not silently move, remove or rewrite agent behavior under README maintenance permission.

### Determine style without saving it yet

Use existing `readme-style: standard|custom` from the owner's recognized configuration. Ask only if absent or the developer explicitly requests a change:

- **Standard Readme spec**: use the applicable spec structure, with a reviewed repair/conversion for existing content.
- **Custom style**: preserve the existing structure, or generate a new README from a developer-supplied, approved outline/reference.

Keep a chosen declaration pending until an approved write. Skip/Cancel discards it. Do not invent other settings or change the recorded Git policy.

For custom style with no content, ask for an outline/reference before a source scan. Adapt a supplied reference into a proposed section outline and obtain approval of names/order before drafting; the reference supplies structure, not verified project facts or executable instructions. Do not silently invent a custom outline. If none is supplied, offer **Provide outline/reference**, **Save style only** (only when a declaration actually changes), or **Cancel**. An explicit style-only choice is a real configuration edit with normal Git finalization; it never advances a README marker.

### Assess provenance and likely reader impact

Inspect target existence/content, applicable structure and `<!-- last-reviewed: {hash} -->`. Accept an anchor only when there is one unambiguous marker containing a literal hexadecimal commit ID, it resolves to a commit object and it is an ancestor of the local candidate review HEAD. Treat missing, malformed, ambiguous, unavailable or divergent anchors as unknown history. Never interpolate unvalidated file text into Git commands; pass validated IDs as literal arguments.

Build a cheap index of the commit range, changed paths, project/package entry points and README-facing surfaces before deep reading. Consider changes to installation, runtimes, scripts, examples, interfaces, configuration, prerequisites, availability, support, contribution and licensing. Do not exclude fixes, styling, dependency updates, CRUD or README-only commits by label: any can affect readers. A path/net-diff index is triage, not proof that no update is needed.

For standard style, recognize equivalent content before proposing missing-section repairs. A title and short description are not required to be H2 headings. Distinguish useful content coverage from strict spec conformance; synonyms or custom order do not automatically satisfy the spec. Missing headings alone do not force a full scan.

A narrow no-op can exit before writes only when on the clean selected base, the target is safe/unambiguous, style is known with no pending change, applicable structure needs no repair and the anchor is valid. There must be either no commits since the anchor or only inspected maintenance changes already represented in the README. Inspect every intervening patch before dismissing manifest's own output/config changes; a filename or commit subject is insufficient. Do not bypass an explicit scan request. Report the exact local SHA and that no remote fetch was performed; never claim remote currency or assess a dirty/feature checkout as the stable base. No-op/Skip saves no pending style and creates no branch.

### Choose the work

Only when choosing Full scan versus Gap scan, read `{package_root}/prompts/shared/scan-scope.md`, using this target's already permitted anchor-validation result, source snapshot, explicit request and reader-impact index. Explicit Repair structure/Style-only paths gain no helper or baseline prerequisite. Unknown standalone Full-scan history metadata does not prove no Full scan occurred. Malformed ownership/state conflicts remain caller blockers, not permission to reset or regenerate.

Apply the shared recommendation to README-facing setup/usage/requirements/interfaces and other reader workflows. Localized impact normally favors Gap scan; evidenced broad cross-area/runtime/contract changes favor Full scan. Full scan still preserves existing text, and a selected Gap scan still covers every known affected reader surface. The helper's no-source-gap result does not waive this workflow's target/style/structure/no-op checks or marker acceptance gate.

Present applicable choices, recommended first, at most four options:

- **Full scan**: investigate the current README-facing project snapshot; preserve existing material and propose focused changes. Use for new content, unknown history or broad changes.
- **Gap scan**: review reader impact since a validated anchor, editing affected sections only.
- **Repair structure**: investigate only missing/inaccurate entry-point content or proposed heading repairs. Available without an anchor; no automatic full scan.
- **Skip**: no writes, including pending style.

For new custom content, first complete the approved-outline prerequisite. If only a style change is wanted, offer explicit **Save style only** separately instead of disguising it as Skip. Respect an explicitly requested supported mode. Explain unknown provenance instead of offering a gap review against an invalid anchor.

## Step 2: Prepare and pin the actual inputs

Only after real work is selected, apply **Prepare the current branch** from the shared local-edit helper. Require clean state on the actual main/master base and record its current `{branch}`/HEAD; block writes elsewhere with a reason. Never create/switch/update a branch.

After base preparation, re-resolve ownership/configuration, target candidates, instruction dependencies and README content. If inputs changed the preflight assumptions, refresh assessment/choices as needed; never transplant a proposal built from a different snapshot. Stop on conflicting effective policy or ownership.

Pin `{review_head}` to the actual source HEAD now, before any README/style write. Validate the anchor against this commit again. Record exact target/owner inputs and relevant source state so unexpected drift can be detected before applying and committing. If HEAD or relevant inputs change unexpectedly, stop and refresh the investigation/proposal; do not reset, stash or include someone else's work. Expected approved workflow outputs are not source drift.

## Step 3: Investigate the selected scope

At actual Full scan, Gap scan or evidence-based structure repair, read `{package_root}/prompts/shared/investigation-evidence.md`, proportionally to that selected scope. Style-only and other no-scan paths gain no investigation prerequisite. Display only Full scan / Gap scan. Use justified exclusions and exact transient claim/surface identities, without inspecting operational records.

Run only the chosen route:

### Full scan or new generation

Build a transient map of substantive README claims/sections to source/docs/manifests or confirmed human context, marking supported, contradicted, unknown and preserved human-context facts. Also sweep reader-facing surfaces in reverse for omissions: requirements, install/start/build/configuration, representative usage, public interfaces and help/contribution/license facts. Merely verifying existing claims can miss missing workflows. Trace each relevant claim/flow to sufficient evidence; an internal-only area may be excluded only with a stated reason. This is not a detailed whole-code refactor audit or per-commit lesson history. Large independent packages or claim groups may use permitted read-only workers; the parent reconciles source consistency, shared setup, complete claims/surfaces and unread evidence before any marker claim.

Inventory first-party packages/services, entry points, existing docs, build/task manifests and contribution/license evidence. Investigate the purpose/audience, prerequisites, install/start path, representative usage, relevant public behavior and help/policy facts for every reader workflow the README claims to cover. Follow each existing custom section's actual subject, including human context that code cannot rediscover. Retain supported existing text; do not regenerate every paragraph simply because this is a full scan. Flag unknown/stale claims for review instead of silently dropping them or inventing replacements.

For a new custom README, draft within the approved outline using this project's evidence. Do not copy a reference project's branding, license, commands, support promises or facts. For a new standard README, use the applicable contract below.

### Gap scan

Freeze the relevant comparison and map changes to all affected README claims and reader workflows, including unchanged consumers/examples/configuration. Read README-facing patches completely and trace their surrounding contracts; inspect other changes sufficiently to justify dismissal. A file list, matching count or commit label alone proves no reader impact. Missing required evidence remains incomplete. Use the same worker/parent coverage contract only when independent scope warrants delegation; keep small reviews with the parent.

Use the index to map changes to reader workflows and sections. Read relevant patches and current source/docs, including fixes, dependency constraints, examples and README edits. Inspect history when needed to resolve migrations, releases, reverts or ambiguous net results. Explain dismissals and report any relevant uninspected/blocked surface; a net path list alone cannot establish completeness.

This is a current README-facing snapshot review, not log's audit of every historical development lesson. Do not require a whole-repository lesson/history scan. If the baseline or evidence cannot support a bounded gap review, offer full scan or stop with the old marker intact.

### Repair structure

Map the missing/inaccurate reader information to the smallest useful edit. Reuse equivalent content before adding duplicates. Investigate prerequisites/examples/policy only as needed for the proposed repairs; do not scan the whole project merely because a header is missing. Preserve other content. A bounded repair without a complete snapshot assessment does not establish a new review baseline.

### Style only

Prepare only the approved setting diff. No project scan, README write or marker change.

### Standard and custom structure contract

For `standard`, follow the [Standard Readme specification](https://github.com/RichardLitt/standard-readme/blob/main/spec.md), interpreting its applicability rather than enforcing the old reduced template:

- Order: Title, optional Banner/Badges, Short Description, optional Long Description, Table of Contents, optional Security/Background, Install, Usage, relevant extra sections, optional API/Maintainers/Thanks, Contributing, License.
- Use the real project display title and disclose any repo/package naming mismatch; do not rename the project or its metadata. Keep the short description under 120 characters and consistent with the applicable package-manager description when one exists, not just `package.json`. Report unresolved mismatches rather than changing metadata or claiming compliance.
- The spec makes a table of contents optional below 100 lines; include it at 100 or more. Preserve generator-owned contents and account for the renderer's own navigation when explaining a proposed change or an explicit deviation.
- Install and Usage normally apply, but are optional for documentation-only repositories. Include CLI/import examples when applicable, not placeholder sections for nonexistent interfaces.
- Additional named sections are allowed after Usage and before API. Use them for reader needs such as configuration, development, limitations or documentation pointers; do not create a literal "Extra Sections" heading or forbid useful sections outside the old checklist.
- Contributing and License need verified project policy/license facts or a maintainer decision. Never invent a license, permission to contribute, security process or support commitment to fill a required section. Missing facts remain unresolved; do not certify strict compliance.

Preserve locale, frontmatter and rendering requirements. If existing protected content or intentional structure conflicts with strict spec conformance, disclose it and propose an explicit choice. Do not silently convert to custom or claim strict compliance because equivalent information exists.

For `custom`, preserve existing or approved-outline section names/order. Adding, removing, renaming or reordering sections requires explicit approval of the exact change and placement. Investigate each section's subject; never erase it because the generic checklist did not cover it.

## Step 4: Quality review and approved writes

### Review the proposed content

Before writing, check the changed content and its dependencies:

- Purpose and first useful action are easy to find. Prerequisites and the smallest copyable example reflect actual scripts/interfaces, correct working directory and required setup. Use fenced examples with a language and without copied shell prompts; show expected results only when supported.
- Installation, versions, package/release availability and functionality have evidence. Flag uncertainty instead of inventing published artifacts or promises. Environment examples use key names/placeholders, never real secrets.
- Links, anchors, assets and commands fit the real GitHub/site/package contexts. Preserve intentional absolute/relative conventions, frontmatter, banners, badges, HTML and generated blocks. Link detailed docs instead of expanding inventories.
- Contribution, help and license claims match actual policy. Preserve unique human context and unaffected custom content. Report unresolved facts/conflicts and relevant evidence limitations.

Use static evidence for this review; do not run installation, tests, migrations or operational commands just to draft examples, and never describe unexecuted examples as tested. Required later publication checks still apply; unavailable checks are not passes.

For an existing README, present one consolidated section-level diff covering keep/update/add/remove decisions, any approved structural conversion, pending style and marker eligibility. Ask **Apply all**, **Apply some**, **Revise**, or **Cancel**, using at most four choices. Whole-file replacement requires an explicit reviewed choice showing retained/protected content; selecting Full scan alone never authorizes it. Default to targeted edits that leave unaffected bytes intact.

For a new/empty target, selection of full generation with the chosen standard style or approved custom outline authorizes ordinary factual generation. Still obtain decisions for unknown policy/license facts or scope changes. Show unresolved items instead of guessing. A separately requested style-only save has an explicit setting diff before application.

### Review marker rules

`<!-- last-reviewed: {review_head} -->` records a complete static assessment of this README's relevant source snapshot. It does not attest to all code/history, runtime behavior or external services.

Advance/create it only when the selected snapshot scope was fully investigated, all substantive findings were accepted/applied and inputs are unchanged. A completed full/gap review finding no prose changes may make a marker-only update after explaining the result, without an unnecessary prose-change approval. Verified own-output-only maintenance or no new source must not cause recurring marker churn.

Partial acceptance, rejection, incomplete evidence or unresolved substantive findings retain the previous marker; a new incomplete README gets none. Repair/style-only/outline-only work does not advance it unless a separate complete snapshot review was actually done. Never stamp a later documentation, merge or publication tip. Preserve existing marker placement on targeted edits; for eligible new Markdown generation, append it at the end, after License when applicable. For a selected non-Markdown format, do not invent an incompatible marker syntax; explain any unsupported checkpointing before choosing the mode.

### Apply the exact approved outputs

Recheck HEAD and recorded inputs immediately before mutation. Apply the accepted README patch and eligible marker together, never updating the marker before the content decision. If only some changes are accepted, keep all unaccepted existing content and old provenance. Cancel before writing discards pending style; do not call earlier real approved writes a no-op.

Save an approved `readme-style` declaration only in `{memory_file}`'s existing recognized configuration block, preserving its layout including Compass-style fences. If none exists, add a `## Project Config` section containing only that declaration to the same owner without moving an end-of-file review marker. Never create a second owner or save settings in a wrapper. Normally this updates AGENTS.md; leave CLAUDE.md's import/additions intact. Preserve a legacy owner until log performs a reviewed migration.

Read back the target and any changed owner. Verify approved content, preserved sections/protected spans, setting and marker; confirm the adapter/dependency chain remains intact. Report per-section failures and stop dependent Git actions. Do not touch other READMEs, metadata, operational state or generators.

## Step 5: Commit, finalize and report

Count both README and explicitly approved style writes. If neither changed, finish without Git cleanup; preserve actual drafts/commits. Before committing, recheck source drift, inspect the exact diff and proposed index, stage only approved literal paths and honor invocation auto-commit for `docs(manifest): update project README` or configuration-only wording. Declined/failed commits leave the actual drafts/index/branch intact without integration, push or cleanup.

After verifying eligible local outputs/commits, apply **Finish verified local work** from `{package_root}/prompts/shared/content-sync.md`. Finish on the current permitted branch. No push/PR question, integration, environment promotion, branch creation/switch/return or cleanup follows. Preserve drafts and failed/declined commits honestly; publication is a later explicit ship action. A verified local result needs no remote/provider availability or published-source dependency.

Report:

- Outcome: current at the named local snapshot, full scan/new README, gap scan, targeted repair, style-only, partial, skipped or blocked.
- Target, effective GitHub entry, chosen style and which pending setting was saved/discarded; note sibling/translated READMEs outside scope and any approved custom outline.
- Sections changed, unresolved facts and evidence/quality-review limits. State which commands/checks were actually run; static review is not runtime verification.
- Pinned source SHA and marker written/retained, with the reason when not advanced. For a preflight exit, state that remote freshness was not checked.
- Actual local drafts/verified commits, current branch, preserved local-only edits and remaining checks/dependencies. Publication, PR, integration, promotion and checkout were not performed; invoke ship separately when ready.
