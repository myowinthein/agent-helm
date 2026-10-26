# env

Audit environment files, `.gitignore` and relevant project code/configuration, then apply only approved fixes. Preserve intentional differences between services, modes and local overrides.

## Question points

Use [QM](../prompts/shared/question-mechanism.md) at the existing gates below; ask only when their conditions hold.

| Point | QM form |
|---|---|
| Unresolved loader/file role, environment branch or intended key behavior | Input using paths/key names only; Single for evidenced alternatives. Never request secret values. |
| Env files and .gitignore target selection | Multi for both independent targets; Single Work through findings / Skip for one. |
| Coherent redacted fix/template plan | Review; Choose changes → Multi by finding IDs, Revise → Input. |
| Duplicate assignments or existing-key conflicts | Single for exact safe location/action alternatives; Input for missing nonsecret intent. Resolve before the unit's Review. |
| Exact untracking operation | Separate Review preserving local files and explaining history limits. |
| Local commit when invocation policy requires approval | Review of committable paths only; local env inputs remain unstaged. |

## Before starting

Apply the shared runtime's instruction/configuration resolution first. Read effective Helm settings from `{memory_file}` when present, including bridges, overrides and recognized fenced configuration; genuinely absent settings use the Git rules' defaults. Env never creates/migrates an instruction owner, writes settings to AGENTS.md/CLAUDE.md, invokes log, or reads/writes/migrates operational Helm state. It owns no ledger or review marker.

Read `{package_root}/prompts/shared/content-sync.md`, but do not apply **Prepare the current branch** until selected fixes need a write. The initial audit runs on the current checkout with no checkout, fetch, branch, index or file changes. Record branch/HEAD (or unavailable), dirty/staged state and relevant input identities without printing contents. A dirty/staged checkout may be audited; disclose that normal write preparation is blocked. Never commit, unstage, stash, reset or absorb pre-existing work to proceed.

Writes are eligible on the actual current main/master base, an established existing current feature branch or a confirmed current environment branch, under project policy and the helper's role checks. Unresolved or unsupported branch roles block writes with an explanation, never an automatic checkout. Recommend feature/main for shared configuration fixes and an environment branch for its intentional configuration differences or integrated-source problems; the same approved workflow actions remain available on every eligible role. Branch eligibility does not establish a safe runtime target or authorize publication, live provisioning or synchronization to another branch.

### Value-free inspection boundary

Before any potentially secret-bearing read, establish safe local inspection/filtering. Reports, tool output, plans, diffs, errors and completion summaries expose only paths, key names, locations, types and classifications. Never emit existing values, prefixes/suffixes, value hashes, token-bearing URLs or raw source/env snippets. Even apparent placeholders can be misclassified: report the placeholder kind, not its existing text. Newly generated synthetic placeholder literals may be shown.

Filter before output reaches the conversation, including edit-tool echoes and parser errors. Do not source env files, import/boot the application, dump process/resolved configuration, fetch secrets or contact services to validate values. If safe inspection or a required capability cannot be established, mark that scope blocked and continue only independent safe checks. No real-value temporary reports, backups or exported artifacts.

## Step 1: Inventory and read-only audit

### Declare scope and discover actual inputs

At actual audit, read `{package_root}/prompts/shared/investigation-evidence.md`; env keeps its current-snapshot Env files/.gitignore scope, with no invented Full/Gap modes or ledger. Map every scoped service/loader/check to inspected evidence, a justified exclusion or an actual gap. Read loaders and configuration modules in sufficient detail to establish resolution/precedence; cover other consumers with convention-aware searches and context, tracing dynamic access where possible. Use safely filtered value-free projections across all source/configuration, not only env files; a whole-file raw read is never required to satisfy another prompt. Hidden/ignored env paths and relevant templates remain discoverable.

Large independent code-reference investigations may use permitted read-only workers with exact scope/depth and only safely filtered evidence; known sensitive inputs/projections stay with the parent. Never give workers raw env contents, values or secret-bearing source snippets. If safe filtering cannot be established, keep that part blocked, not clean. Parent reconciliation covers exact service/loader/input identities and check applicability, not matching key counts. Keep unresolved/external references explicit and retain the eleven existing check outcomes.

Start with a cheap metadata inventory: first-party services/packages, entry points, loader/task manifests, relevant source/config/scripts, templates, deployment/CI declarations and nested `.gitignore` files. Honor an explicit Env files or .gitignore focus before expensive checks; inspect safety prerequisites read-only even if their fixes are outside scope. Default to both targets. Do not invent a new mode/flag contract.

Discover ignored and hidden `.env*` files intentionally, rather than relying on a source search that omits them. Also follow evidence of custom filenames/paths from loader options, Compose `env_file`/`--env-file`, scripts or project documentation. Do not guess additional files. Exclude vendored/dependency, generated/build, binary and unrelated fixture trees from ordinary source scanning; recognize relevant test configuration as its own scope. Always exclude `.helm/`, `.claude/helm/` and the known flat legacy operational JSON files under the runtime's rules.

Group actual consumers and files by service, loader, mode and role. Record a lightweight invocation-only map of load order/inheritance, configuration access, template ownership and external providers. Keep unknown roles/precedence explicit; no persistent profile/schema framework. Resolve target containment/symlinks before editing. Encrypted, generated, mounted/read-only, outside-project or uncertain-dialect files are report-only pending a safe workflow/placement decision; never replace a mount/link, decrypt files or change permissions to make a fix possible.

Cover every relevant first-party area in the declared scope, using focused searches and supporting context instead of indiscriminately reading every file. Label checks complete, partial, blocked, not applicable or out of scope. A restricted/partial scan cannot support a project-wide clean-audit claim.

### Keep the eleven checks

| Check | Assessment contract |
|---|---|
| 1.1 Detect env files | Discover actual inputs and classify template, ignored local, shared defaults, environment override, generated/encrypted or unknown roles. |
| 1.2 Env sync | Compare keys within the correct service/loader family and its effective layers, not the union of every file. |
| 1.3 Source/config references | Gather literal keys and references through actual configuration conventions, scripts, CI/containers and relevant test setup; disclose dynamic/unresolved access. |
| 1.4 Cross-reference | Distinguish genuinely missing required inputs from visible defaults, optional/conditional features, external provision and keys with no reference found in the scanned scope. |
| 1.5 Secrets/placeholders | Identify credible secret exposure in committable material and unfilled required local inputs, with confidence and role-specific evidence. |
| 1.6 Hardcoded values | Find credible environment-dependent settings or credentials and propose a coherent access/destination mapping. |
| 1.7 Env formatting | Find syntax/duplicate/readability problems under the actual loader dialect, preserving parsed meaning. |
| 1.8 Gitignore missing protection | Check actual Git protection for local files and evidence-backed project artifacts, including shared versus personal exclusion rules. |
| 1.9 Tracked ignore matches | Identify tracked paths and their effective matching rules for a policy decision, never an automatic removal recommendation. |
| 1.10 Harmful ignore rules | Demonstrate a conflict with intended versioned files/policy before proposing minimal rule changes. |
| 1.11 Gitignore formatting | Identify provably redundant patterns or optional readability improvements without changing order, escapes or scope. |

### Keys, roles and confidence

An override may intentionally contain only its differences from a baseline. A key absent from one layer is not missing if supplied by another applicable layer. Separate template omissions from runtime requirements. External shell/CI/secret-manager injection and visible defaults can satisfy a requirement without an env file; inspecting declarations does not verify remote values. Treat built-in-looking names such as `NODE_ENV`, `CI` or `HOME` according to actual consumer evidence, not a blanket exclusion list. Infer optional/required/conditional status only as far as source/schema/config evidence supports it.

Recognize templates consistently across discovery, secret cleanup, placeholder checks, extraction and staging: `.env.example`, `.env.sample`, `.env.template`, `.env.dist`, service-specific examples or other explicitly verified template paths. A suffix alone is not enough to classify an encrypted/generated file as a template. Safe shared/test defaults and intentionally fake fixtures are not automatically secrets or broken runtime configuration. Preserve verified useful defaults in templates; do not replace every value with a sentinel.

Empty values, ordinary defaults and publishable identifiers are not automatically failures or credentials. Distinguish confirmed/credible secret findings, likely required unfilled inputs, and informational/unknown cases. Report uncertainty without adding it to confirmed issue counts. For confirmed or credible exposed secrets, explain that moving/untracking them does not revoke access or remove history; recommend developer review and revocation/rotation as appropriate. Never rotate, rewrite history or publish a credential automatically.

Use **No reference found in scanned scope**, not an assertion that a key is dead. Consider infrastructure, scripts, loaders, dependencies and dynamic access before suggesting deletion; similar names alone are weak evidence. Keep unresolved/external keys outside confirmed missing/stale totals. With no env files, explain external configuration evidence/uncertainty instead of listing every access as an error. Do not invent unnecessary env files.

### Hardcoded and formatting evidence

Exclude genuine environment-independent constants, fixtures and mock data from extraction recommendations. Severity follows credential sensitivity and operational impact, not merely a string literal or public key name. Follow the project's existing access convention: configuration indirection/cache behavior, browser/server boundary, build-time versus runtime availability, prefixes, types, empty-versus-absent behavior and defaults. Do not expose a secret by choosing a client-public prefix or retain it as a source fallback.

Identify the real parser/loader before proposing env formatting. Preserve quote/escape semantics, multiline values, comments, expansion/assignment order, meaningful whitespace, encoding and file permissions. Never apply a generic keep-last duplicate policy. Resolve differing assignments by an explicit key/line choice; remove even identical duplicates only when redundancy is established under that loader's semantics. Unknown dialect means report-only. Group headings are optional, normally template-only; absence of identical groupings everywhere is not a correctness issue.

### Git-native ignore assessment

Use Git's matching semantics, not a second glob implementation. Collect tracked paths with `git ls-files -z`; for relevant paths use read-only `git check-ignore --no-index --verbose --stdin -z` or an equivalent Git-native query. Interpret the winning rule and negation, including nested files, escaped characters and excluded parents. Handle literal/NUL-delimited paths and check failures; an unavailable Git query leaves the check unknown, not passed. Output rule source/line and only a safely filtered pattern.

Read applicable project rules and account for `.git/info/exclude` and `core.excludesFile` without changing those personal/global files. A local env file protected only there still lacks shared project protection; report that distinction. Suggest stack artifacts only with project evidence, not a generic checklist. `dist/`, `vendor/`, lockfiles, compiled `*.js`, safe tracked defaults and partially local config directories may be intentionally versioned or excluded. A tracked match alone proves neither that untracking is right nor that the rule is harmful.

Preserve pattern order, anchoring, escapes, meaningful trailing spaces, comments, nested scope and negations. Remove only provably redundant patterns. For example, within the same file an earlier byte-identical pattern may be redundant under last-match-wins semantics; removing the later copy can change the result around intervening exceptions. Never sort/regroup patterns just for appearance. Protect verified template paths when adding env exclusions, accounting for excluded-parent rules rather than blindly appending a negation.

Do not suggest blanket exclusions of canonical `.helm/`, shared AGENTS.md/CLAUDE.md, shared rules or protected unsupported Helm state directories. Preserve legitimate client-local exclusions. Env may assess `.gitignore` protection without opening operational ledgers or modifying instruction/rule files.

## Step 2: Report and select work before Git mutation

Present an `ENV AUDIT REPORT` grouped by the eleven checks, with:

- Exact checkout/HEAD and dirty state; no remote-freshness claim or implied merged-base assessment.
- Declared services/targets, files and roles, effective-layer assumptions and coverage limitations.
- Invocation-stable finding IDs, locations/key names, confidence, impact, evidence and recommended action. Count unique confirmed problems separately from informational, uncertain, stylistic, partial and blocked checks.
- Proposed committable template/source/gitignore changes, local-only work, report-only tracked/managed files and any external provisioning or exposure follow-up.

If no actionable findings exist and no template creation was requested, report the scoped audit result and finish without questions, writes or branch creation. Unknown/blocked coverage stays visible; do not claim the whole project is clean. Skip/none also exits without mutation.

For both targets with findings, offer **Env files** and **.gitignore** as the existing multi-select; honor an explicit target choice already made. For one target, use **Work through findings** / **Skip**, not a one-option picker. Choosing a target only selects planning scope, not every fix. Keep all pickers at two to four options; group larger lists behind finding IDs/free text rather than silently truncating. Preserve Other and explicit none.

If a dirty/staged tree or missing Git capability prevents normal fixes, explain that before collecting dependent write approvals. Keep the audit usable, leave files/index untouched and stop the write route. No automatic stash, owner setup or repository initialization.

Template maintenance/creation is optional, never a missing-file error by itself. A request to create a missing template may continue to planning even with no correctness findings. Do not manufacture a secret or runtime-error finding to make it selectable.

## Step 3: Prepare and approve a concrete plan

For selected writes, recheck staged inputs and require **Prepare the current branch** from `{package_root}/prompts/shared/content-sync.md`: clean eligible state on the actual current main/master base, an established current feature branch or a confirmed current environment branch. Unresolved/unsupported roles and other prerequisite failures block writes while retaining the audit. Preserve ignored/untracked local inputs and secret files; never stash, copy secrets to backups, replace local files or absorb unrelated work to prepare. Record the actual current `{branch}` and local commit policy. There is no checkout/update or log-specific policy overlay.

On the same validated current branch, re-resolve instructions/configuration and rescan affected services, input roles, key/reference sets and ignore outcomes on the actual destination. If the advisory snapshot differed, reassess its findings against this actual current source; never transplant them. Refresh broader coverage when needed; do not apply stale recommendations or carry approvals to changed inputs.

Capture actual source HEAD and relevant source/template/ignore/local input identities using safe local comparison without exposing values or value hashes. Unexpected source/HEAD/ownership/input changes stop dependent work for refreshed evidence/approval. Expected approved edits are tracked separately. Ignored local env files are worktree-local inputs, not branch-versioned outputs; switching branches later does not merge or synchronize them.

Present one consolidated redacted plan, grouped into coherent dependency units. Each unit lists finding IDs, exact paths/keys and action, minimal source/template/ignore patches, local or external requirements, dependency order and verification. Generated placeholders are safe to show; removed/replaced real values are never printed. Show new files as **Create** with exact path/key list and placeholder structure.

On an environment branch, identify shared versus intentionally environment-specific fixes, or unresolved scope, in that same plan. Preserve intentional differences. Note when a shared fix may need deliberate application upstream or may be overwritten by later integration; never copy, merge or back-propagate it automatically. Resolve only material missing decisions through the existing approval, without a new per-run branch confirmation. Ignored local env inputs remain worktree-local, not branch-synchronized artifacts.

Use **Apply plan**, **Choose changes**, **Revise**, or **Skip** (maximum four). Choose changes accepts IDs/groups/free text and produces an explicit bounded selection. Resolve differing duplicate assignments and existing-key conflicts with exact key/line/location choices. Ask only for missing decisions; reuse approval of the same concrete unit. Never treat silence or a selected target as approval. Untracking retains its separate confirmation below.

A selected subset can be a valid outcome. Apply no dependency unit halfway: if a required destination, template decision, ignore protection or key conflict is unresolved, leave that unit pending and proceed only with independent approved units. No fixed finding-count threshold or per-file commit requirement.

### Optional template maintenance and creation

For an existing recognized template, propose adding only approved, relevant key names in its existing structure/placeholder style. Keep supported safe defaults and comments; never copy real values. Do not add every local experiment or unrelated service key. Do not generate instructions about obtaining credentials without existing authoritative project guidance.

If the relevant service has no template, offer explicit **Create template** / **Skip** with the proposed path and content structure. Default to that service's `.env.example` only when appropriate; ask about ambiguity. Approval of the concrete creation in the consolidated plan also satisfies this choice, without another identical question.

Verify that no competing template exists and that the path is safe and intended for tracking. Assess effective ignore rules first; any required minimal exception needs its own approved `.gitignore` patch. If protection cannot be safely established, leave creation pending; never force-add or create a real env file instead.

Bootstrap from evidenced keys with newly generated, dialect-compatible placeholders, including required/optional/unknown status in the report. Do not copy current values or guess credentials/defaults. Preserve role boundaries when multiple services need separate templates: create only the explicitly chosen paths, never a repository-wide template set. No env file is created implicitly by scanning or extracting a value.

## Step 4: Apply coherent units and verify

### Edit eligibility and commit boundary

- Recognized, explicitly approved templates may be edited/created and committed only after their entire resulting contents are verified free of real credentials. This includes verified alternative templates, not only exact `.env.example`. Skipped/unresolved secret cleanup prevents staging that template.
- Non-template operational env contents are never staged, including safe shared defaults, even if already tracked. Tracked non-template env files are report-only for edits under this workflow; do not untrack them just to bypass that restriction. Intentionally tracked safe files are not automatically anomalies. Managed/encrypted/unknown targets remain report-only as described above.
- Eligible local env edits are confined to explicitly approved, existing, ignored and untracked files with a known loader and safe local tooling. Real values stay local. Otherwise the developer performs entry through their normal local/provider tooling; never request credentials in conversation.
- Approved credential-free source and project `.gitignore` patches are committable. A separately confirmed untracking index deletion is allowed while preserving its local file. No instruction files, client settings, global/info excludes, ledgers or unrelated paths enter the write set.

### Manual input, extraction and key removal

For sync/missing/placeholder issues, show the relevant keys and destinations under effective-layer rules. Let the developer enter real values locally or provision them externally. Do not insert empty `KEY=` lines merely to make a matrix look complete: empty may differ from absent. Recheck locally after Done using value-free key/syntax/sentinel results. Report verified present, still missing/unfilled, blocked or developer-attested external setup; do not equate key existence with valid credentials or a working connection.

For hardcoded extraction, approve the exact access expression, key name, service/load phase, any type conversion/default behavior and local/external destination before editing. Do not silently reuse a conflicting existing key/value or overwrite an existing setting. Never copy one real value into development, staging, production or other services indiscriminately. Templates receive compatible synthetic placeholders or retain verified safe existing defaults; no real value enters them.

When local transfer is approved, use safe local operations that do not echo the secret, only to the approved existing ignored/untracked destination. Otherwise require developer entry. Apply/verify needed approved ignore protection and template/destination setup before the dependent source patch.

External provisioning requires explicit developer attestation; if readiness is unresolved, keep the dependent source edit pending. Do not keep a credential literal as a fallback or move a server secret into a client bundle. Include newly required key names and pending environment provisioning in the handoff; neither a local edit nor CI proves deployment values exist.

For keys with no reference found, keep by default. Removal needs explicit key-and-file IDs and dependency evidence, including any original feature-snapshot usage. Explain that deleted local values may have no Git recovery. A free-text delete-all answer covers only the exact disclosed set; ambiguity needs clarification. Never delete a whole env file or remove infrastructure/dynamic/externally managed keys based only on a search miss.

Formatting uses minimal, approved edits under identified loader/Git semantics. Preserve unaffected bytes and existing structure. Optional group headings belong in approved template edits, not forced rewrites of every operational env file. Unknown dialect or changed source inputs stops that edit instead of guessing.

### Gitignore patches and explicit untracking

Apply only the minimal approved pattern changes, creating a missing project `.gitignore` only when its proposed path/content was reviewed. Re-evaluate actual Git outcomes after any change: relevant local files remain protected, intended templates/source files remain eligible and previously reported matches have not changed. Treat newly discovered tracked matches as new decisions.

For each bounded untracking group, list its exact paths/count, winning rule and why policy may warrant removal. Offer **Untrack listed paths** / **Skip** with this explanation: `git rm --cached` retains local files, but the committed removal may delete clean copies in other clones/deployment checkouts when updated; modified copies may block update. It does not revoke secrets or erase history. Environment fan-out can propagate that deletion. Default intentional shared artifacts to keeping them tracked unless the developer approves the demonstrated change.

On that explicit approval only, use literal pathspecs with option separation/NUL-safe lists as needed for `git rm --cached`; no shell/glob expansion, force, whole-index rebuild or worktree deletion. Verify the exact index deletion and that local files are unchanged/present before continuing. Keep approved deletions in the index without re-adding local contents. Decline/failure preserves actual files/index and blocks dependent operations; do not undo someone else's work automatically.

### Readback and input drift

Before each unit, recheck its source HEAD and relevant input identities against the approved baseline or expected earlier outputs. Track the expected current HEAD separately from the audited source snapshot; advance that expectation only to verified commits made by this run. After each unit, perform safe static readback: key presence/absence, syntax, intended source access/types, preserved parsed meaning for formatting, template credential freedom, Git ignore outcomes and exact untracking effects. Keep raw parser/error output and secrets out of the conversation. Re-evaluate dependent sync/reference/protection findings and update their statuses rather than using the stale initial matrix.

Do not run application/service probes, installs, migrations, builds or tests merely to audit/draft a fix. Static verification and developer attestation are separate from runtime checks. Required later publication checks still apply; unavailable required checks are blocked, not passed. A failed/incomplete unit stops its dependents and any finalization of unresolved drafts; preserve actual work and report partial status.

## Step 5: Commit, finalize and report

Track exact approved outputs and actual run commits. Before every logical-unit commit, inspect the complete proposed index through safe filtering: only this run's approved paths/hunks and confirmed untracking deletions may be present; no operational env content, real credentials or unrelated work may enter it. Verify entire resulting source/template/gitignore contents, not only new lines. Never use broad `git add -u`, `git add -A`, `git commit -a`, force-add or silently unstage unexpected changes. Literal exact-path staging applies. If a check fails/cannot be completed, stop commit/publication and report paths/key names and reason only.

Honor invocation auto-commit and existing scope conventions with an accurate logical-unit message, such as `fix(env): correct configuration loading` or template/ignore-specific wording. Replace the old greater-than-ten-findings rule with dependency-coherent commits. Earlier verified commits still count if the final stage has nothing new. Declined/failed commits preserve drafts/index/branch and stop dependent finalization.

Keep approved local-only edits on disk and outside commits. Never reset, stash, discard or commit secret-bearing inputs to make work look complete. No checkout, integration or cleanup occurs. Local-only edits without a safe commit are a valid separate outcome; report them and external provisioning/exposure dependencies without querying values or claiming deployment/rotation. A no-write/no-commit exit changes no branches.

After verifying eligible local outputs/commits, apply **Finish verified local work** from `{package_root}/prompts/shared/content-sync.md`. Finish on the current permitted branch. No push/PR question, integration, environment promotion, branch creation/switch/return or cleanup follows. Preserve drafts and failed/declined commits honestly; publication is a later explicit ship action. A verified local result needs no remote/provider availability or published-source dependency.

Report audit scope and fixes separately:

- Outcome: scoped audit complete/partial/blocked, no actionable findings, fixes complete/partial/skipped or pending. Never label skipped/manual/incomplete work simply ENV COMPLETE.
- Actual snapshot/coverage, services and file roles; no fetched-remote or runtime claims without evidence.
- Finding IDs grouped by the eleven checks: verified resolved, retained/intentional, skipped, still missing, uncertain, developer-attested or blocked. Count actual verified file/key edits, not Done answers.
- Templates updated/created and exact paths; report-only tracked/managed files, preserved local-only edits, exposure/provisioning/manual follow-up and dependency units still pending, with values omitted.
- Static checks actually performed versus unrun runtime checks; commit eligibility and any blocked safe inspection.
- Actual local drafts/verified commits, current branch, preserved local-only edits and remaining checks/dependencies. Publication, PR, integration, promotion and checkout were not performed; invoke ship separately when ready.
