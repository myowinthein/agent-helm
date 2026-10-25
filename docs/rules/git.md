---
title: git.md
parent: Rules
nav_order: 1
---

# git.md

Shared Git policy for Claude and Codex: ownership/configuration, local editing and independent direct/PR shipping, scoped Conventional Commits, quality gates and exact publication. The copied git.md/safety.md pair works without a loaded Helm plugin. Loading rules performs no action and supplies no approval.

## Configuration owner

Resolve the owner and applicable settings before dependent mutations, integration or publication. Independent labelled local inspection can report missing/conflicting configuration without resolving it first.

- Start from the applicable CLAUDE.md or AGENTS.md entry, respecting nested instructions and AGENTS.override.md precedence. Follow real imports/read directives relative to their referring file, not quoted examples.
- `{memory_file}` is the actual knowledge/settings owner, not a wrapper. If one host's entry is absent, inspect the other. With neither file, the proposed owner is AGENTS.md; do not create it just to apply defaults.
- Shared layout uses AGENTS.md plus a real CLAUDE.md importing `@AGENTS.md`, optionally with Claude-specific additions. Shared settings/Rules stay only in AGENTS.md. Preserve existing owners and wrappers until log's reviewed shared onboarding.
- Independent entries with only one settings owner are not automatically a configuration conflict; read and preserve the setting-free entry too. Identical values agree, but ambiguous knowledge ownership still blocks a memory write. With neither declaring settings, preserve the current host's knowledge owner unless a bridge selects another.
- Recognize standalone Project Config declarations and Compass-style fenced `text` introduced as project configuration. Heading customization does not discard a valid block. Quoted examples are not declarations. Invalid relevant values, ownership conflicts and conflicting duplicate keys block dependent actions. Publication-only invalid values block shipping/migration, not independent local edits; retired keys supply no active values, and missing ship-method with git-strategy blocks dependent shipping. Identical duplicates remain untouched.
- Apply active override precedence before comparing owners. Preserve overrides; never regenerate host-specific policy. Defaults apply only to absent keys. Authorized saves patch the owner's existing block, without duplicated settings or a whole-file rewrite.

| Key | Values | Default |
|---|---|---|
| `ship-method` | `direct`, `pr` | `pr` for genuinely absent settings |
| `git-auto-commit` | `true`, `false` | `false` |
| `git-merge-strategy` | `squash`, `rebase`, `merge` | `squash` |
| `readme-style` | `standard`, `custom` | Resolved by manifest; no style is invented during Git resolution. |

`environment-promotion` is retired. Preserve existing declarations without using them to select behaviour or treating their values as active-setting errors. There is no chain-selection setting or conversion flow.

Only log migrates/reconciles existing layouts. Cycles/missing targets block branching/writes, with log's sole read-only exception for a readable root two-file CLAUDE.md/AGENTS.md cycle: read each once, resolve settings before mutations and propose removing the reverse bridge. That log cycle exception covers no other/external cycle or missing target. Separately, explicitly invoked packaged adopt may replace an established unavailable terminal Helm rule pointer after surviving owner/settings resolution and review of the complete proposed local body/exact pointer changes. Missing/cyclic owner bridges, unknown imports and active policy remain blocks; external imports are never written.

Log may collect explicit choices for absent settings before Git mutations and freeze local commit policy; publication choices never cause branching. Unanswered keys retain defaults; existing-setting changes apply next run. Revalidate destination raw declarations/owner/overrides before reusing a pending overlay. Other workflows preserve their existing resolution, and no policy silently changes halfway through a run.

## Host capabilities and operational state

Check the actual selected tree and only capabilities required by the proposed action. Folder access is not Git/provider authentication, Docker access or a working test environment. Verify operation results before claiming commit, merge, publication or checkpoint success. See [Safety host capabilities](safety.html#host-capabilities).

[Operational Helm state](safety.html#operational-helm-state) is excluded from ordinary source scans, edits and unrelated staging. Only an explicitly invoked owner accesses its file through its available validated state procedure. Explicit ship archive narrowly continues its selected bundle; explicit ship normalize reads identified private rewrite evidence, never the live ledger. Plain ship discovers/loads no state. Loading copied rules or changing agents causes no access/migration; without the owner/procedure, preserve records and report the gap.

### Read-only scope

Local status/history/source observations can inspect dirty/staged/untracked work, detached or no-HEAD states and unresolved owner/base/settings. Label the exact snapshot and unknowns without claiming unresolved scope is current or ready. Suppress executable diff/textconv, pagers/filesystem-monitor helpers, optional index refresh and lazy fetch where supported; unavailable evidence remains unknown.

Static inspection does not fetch, check out, create branches, write files/index/refs, execute hooks, tests, builds, installers or live operations. No ship-method/default question is required just to inspect. Ordinary development may coexist with unrelated local changes while protecting them. Specialized workflows retain their own clean-state requirements.

## Local work and ship method

Team size and branch topology do not select a Git mode. Ordinary coding and Helm editing commands work locally on their current permitted branch. Log/manifest/legal/adopt require the actual main/master base for Git-backed writes, retaining their documented read-only/bootstrap exceptions. Env/test also permit established current feature branches and confirmed current environment branches; test additionally permits established current maintenance branches. Confirm non-base roles from actual project/deployment evidence or developer classification, not name prefixes alone; unresolved or unsupported roles block dependent writes. Branch eligibility proves neither ownership nor safe runtime targets; existing script/hook/service effect checks remain required. Stronger project policy still applies. Commands requiring base block elsewhere with a reason; never auto-checkout/update base, create a workflow branch, merge, push, open a PR, promote environments or clean up branches to finish them. Preserve each command's own scope, clean-state, review, verification and checkpoint requirements. `refactor` may record/apply on base, an established existing current feature branch or an existing current `refactor/*` branch, with confirmed non-base environments source-inspection/report only even if their names match that prefix. Establish non-base roles from project/deployment evidence or developer classification, never names alone; no branch creation/selection follows. `normalize` may coordinate explicitly approved rewrites of affected existing local branches. `archive` prepares locally on its confirmed source branch, showing its HEAD/exclusions and obtaining Proceed/Cancel before normal pending phases. Read-only archive Audit/Plan and proven prepared/completed report-only exits need no new branch confirmation. Invoke ship separately when publication is wanted.

Configure ordinary shipping in the resolved owner's existing Project Config section or recognized fenced block:

```text
ship-method: direct
# or
ship-method: pr
```

- **direct:** ordinary ship first pushes/verifies the reviewed current branch, then offers explicitly selected independent source-to-target integrations and pushes. Main may select environments; features may select main/environments; environments may select main/other environments except themselves. No selection means source publication only. Explicit ship release alone prepares version/tag publication on integrated main/master. Actual project/provider requirements can block an action; never bypass them or silently change the method.
- **pr:** ordinary ship publishes/verifies its source, then creates/reuses and reads back matching PR/MR handoffs. A feature is its own source and selects main/environment PR targets optionally, with no self-PR or mandatory main target. Main/environment work uses one established ship/* helper into its own hosted branch and the same helper into every selected optional target; never a same-ref self-PR or helper per target. Reuse/prove existing helper/request identity before creation or fast-forward update; names alone are insufficient. Reviews are independent and an environment may accept pending changes before main. Source pushes update all open requests sharing that ref, while merged requests need a new selected request for later changes. No auto-merge, future review/CI wait, source deletion or automatic release follows. Explicit release metadata may need its own PR; only verified integrated main/master is tagged.

Use a valid explicit `ship-method`; genuinely absent settings default to `pr`. Invalid explicit values block dependent shipping. Retired `git-strategy` does not map to a method: if present without ship-method, stop with [upgrade guidance](../setup/upgrading.html) rather than silently changing publication preference. `environment-promotion` selects no behavior. Current promote/fan-out operations remain available.

Change a setting only through its approved exact owner/block diff. Preserve unknown settings, overrides and adapter ownership. The one-time upgrade procedure handles old declarations; ordinary workflows perform no opportunistic cleanup. Copied rules are independent policies and need explicit reviewed updates when their obligations differ.

`git-auto-commit` (default false) governs local commit authorization independently. `git-merge-strategy` (default squash; `squash`, `rebase`, `merge`) governs eligible ship integrations independently of ship method. Squash creates one reviewed integration commit; merge preserves topology through a merge commit; rebase replays only an explicitly reviewed private/unpushed branch before eligible fast-forward integration. A shared/published branch is never implicitly rewritten by this setting. Branch names, deployment mapping and team size remain project facts, not settings inferred from these values.

State the relevant invocation policy once and revalidate it before dependent actions. A base-dependent action resolves `{base_branch}` to the actual main/master from instructions, default branch and refs; ambiguity blocks that action, never guesses/creates/renames a base. Read-only work can report unresolved facts. Ordinary local tasks need not resolve a publication destination or contact a provider to finish.

Rewritten-history publication and private archive backup publication are ship's separately approved specialist routes, not third `ship-method` values. A PR cannot replace published commit IDs. With the package loaded follow ship's verified rewrite/backup procedures; copied rules alone grant neither state access nor a reconstruction of those protocols.

---

## Auto-Commit

`git-auto-commit: true` permits committing a completed coherent unit without another question. False/absent requires the exact commit's approval. Read-only work, no-ops, explicit commit deferral and incomplete/gated work create no automatic commit. An independent source task may finish while its commit remains pending.

Requested targeted editing, including in uncommitted/untracked files, follows [Safety's effect-based boundaries](safety.html#agent-execution-boundaries); destructive discard, stash/reset/restore and ref/index/worktree changes are not automatic cleanup or clean-tree workarounds. Preserve each named workflow's own prerequisites.

Inspect the full index and intended diff. Stage literal exact approved paths, for example `git --literal-pathspecs add -- {approved_paths}`; do not blindly stage directories or `git add -A`. Preserve unrelated staged, unstaged and untracked work, including user hunks in the same file. If safe separation is impossible, leave the commit pending without reset, stash, cleanup or absorbing changes. Review the staged result and verify the actual commit's contents.

A logical unit is one coherent, independently reviewable change. The word “and” in a subject does not itself require splitting a commit. Commit approval never implies publication approval.

Safety's bounded commits, including generated legal documents and their integration commits, retain explicit content/commit approval regardless of auto-commit. Reuse the same known concrete approval rather than asking twice; the setting alone cannot supply it.

## Universal Rules

- Local commits use the current permitted branch under actual project instructions and commit approval; ship-method does not impose a blanket main-commit ban.
- Rewritten-history publication requires explicit approval and the fixed-lease contract below.
- Never delete main/master, confirmed environment branches or published tags in a public repository. Never delete unmerged branches without explicit approval.
- No automatic branch cleanup follows local work or ship handoff. For separately requested cleanup only, after verified integration/required publication and with no pending work, leave the branch safely and delete locally only when its tip is in base ancestry and `git branch -d` succeeds. Squash/rebase may leave the original tip outside ancestry; retain it rather than substituting `-D`. A separately reviewed destructive cleanup is not automatic permission. Remote deletion needs its own publication approval. Failed/pending work never triggers cleanup.
- Every base commit must leave working code; verify and report evidence honestly. Use coherent, independently reviewable commit units.

**Workflow boundaries** preserve all unrelated project/provider protection, signing, approval and check requirements:

- Editing commands finish locally without branch creation/switching, push/PR prompts, integration, promotion or cleanup.
- Refactor uses current base, an established existing current feature branch or an existing current refactor/* branch; confirmed non-base environments remain source-inspection/report only, including any matching prefix. Normalize coordinates approved existing local refs and records on its current permitted branch without a bookkeeping PR.
- Archive prepares/commits only its reviewed local payload. Ship archive alone publishes the private payload and receipt, with narrow bundle access and optional explicitly reviewed post-backup cleanup.
- Ordinary ship publishes current work and optional same-source targets. Explicit ship release alone versions/tags integrated main/master with no automatic fan-out. Existing-source promote and specialist history/archive publication remain separate. No source PR is tagged before integration, and no normal PR substitutes for replacing published commit IDs.

### Publication

All pushes, remote-ref deletions and provider merges that publish code require concrete authorization under [Safety](safety.html#agent-execution-boundaries). User approval and provider review are distinct requirements.

1. Resolve one actual push destination, including push URLs/fork mappings, exact refspec/source SHA, observed remote ref and actual effects. Show credential-redacted identity, commits/diff and deployment consequences. Never assume `origin` or a fetch URL, or publish to multiple URLs incidentally. Material changes invalidate affected approval.
2. Ordinary pushes use bounded explicit refs and `--no-follow-tags`. Explicit tag publication uses its approved exact release refs. Do not incidentally mirror, prune, push all/extra refs or submodules, set upstream with `-u` or edit configuration. A directly authorized configuration/tracking task may perform its exact requested change, without waiving other gates.
3. A confirmed rewrite uses fixed `--force-with-lease=refs/heads/{branch}:{expected_remote_sha}` with reviewed old history accounted for in the plan. The lease alone does not protect unseen existing work. No plain force, leading `+`, or replacing a rejected expectation to overwrite newer remote work. Ship normalize retains the verified private recovery/graph/map and exact-ref publication safeguards; normalize itself stays local.
4. Recheck tips, approvals, quality, CI, signing and protection before publication. Provider merge publication approval precedes its API call; do not push an already published result again. Read back the actual destination/ref after success or uncertainty before claiming results or retrying. Unavailable/mismatched proof leaves dependent promotion/cleanup pending, preserving prior successes.

After verified destination/ref readback, do not repeat an already published approved result. A safe retry with unchanged destination, refspec, source SHA, expected remote state and effects reuses the same concrete authorization. Unexpected movement or changed content requires reconciliation and any missing approval; never change the expected lease, force blindly or infer that a timeout had no effect. This clarification preserves all existing publication/tag/content-review gates.


## Conventional Commits

Helm requires the scoped format:

```text
type(scope): description

[optional body]

[optional footer]
```

| Type | Meaning |
|---|---|
| feat | Feature |
| fix | Bug fix |
| refactor | Code change that is neither feature nor fix |
| revert | Revert earlier work |
| test | Add/update tests |
| docs | Documentation |
| chore | Maintenance, tooling or dependencies |
| style | Formatting, without logic changes |
| perf | Performance |
| ci | CI/CD configuration |
| build | Build system |

Scope identifies the changed module/folder/domain, never a workflow's report category or priority. Use lowercase words/hyphenated scopes. Prefer one dominant scope; inseparable equally affected areas can use a short comma-separated scope. Broad cross-cutting work uses `project`/`core`, rather than an arbitrary long list.

```text
fix(payment): resolve stripe timeout
refactor(log,manifest): merge recommendation blocks
```

Scope is required by Helm, while the [external specification](https://www.conventionalcommits.org/en/v1.0.0/) makes it optional. A historical/upstream unscoped commit may be specification-valid but Helm-noncompliant. Rule loading never authorizes history edits; normalization needs its separate reviewed task.

Use `!` after any type/optional scope, or an uppercase `BREAKING CHANGE:` / `BREAKING-CHANGE:` footer. Either signal suffices. Explicit ship release reads complete messages: breaking proposes major for stable versions with explicit 0.x policy; nonbreaking feat proposes minor, fix/perf patch. Other types have no automatic bump but may get an explicit release. Review mixed history/reverts contextually; empty ranges create no release, and no history rewriting is needed to calculate a version.

## Code Quality

Before publication by either ship method, inspect native configuration and actual changed-package/consumer relationships. Do not infer shared/core impact from a filename, install tools automatically, repair unrelated code or run a repository-wide formatter as an incidental step.

- **Lint/format:** fix required errors within approved/policy-required scope. Format before the unit's commit, review its actual output and check the final affected content. Later formatting normally gets a separate scoped commit. No implicit amend, hook disabling or signing bypass; a directly requested amend remains possible under reviewed scope, without automatically rewriting shared/published history.
- **Tests:** run configured tests for changed files and affected consumers. Genuine shared/core effects still require the full suite unless the user/project explicitly authorizes another coverage plan. Unrelated monorepo suites are not triggered by a filename. Required failures, including baseline failures, block publication; report them without calling them passed/unconfigured or silently fixing unrelated code.
- **Evidence:** distinguish ran/passed, failed, configured-but-unavailable, not configured with repository evidence, and user-deferred. Deferred checks block only the gates that require them, not independent source work or every local commit. Relevant changed bytes/formatting/scope invalidate affected local evidence; reuse unchanged evidence only if policy permits. Exact-SHA CI must match the new tip. Never claim an unperformed check passed.

CI remains meaningful in a copied-only session:

- Integration requires checks/reviews for the exact intended commit under actual project/provider policy. Direct shipping with no pre-integration remote requirement may integrate after applicable local checks. A pipeline existing alone does not create that requirement; required remote CI is never replaced by local success. Separately approve publication for checks or leave a handoff, without forcing a Helm PR in direct shipping.
- Promotion requires configured/applicable CI for the exact published source SHA before target mutation or ship's pr promotion-PR creation. The PR's later target-result checks/review remain pending/not awaited; opening it does not satisfy them. Not applicable needs evidence.
- Inspect complete applicable provider results/current attempts, not a fixed recent sample. Missing, unavailable, pending, failed, cancelled, stale, truncated or unknown required results block the action. Recheck changed tips. The packaged CI helper adds provider details when present; its absence does not waive copied-rule gates.

## Deployment

Determine actual push/tag/manual triggers and targets from repository/provider evidence; rules or branch/tag names alone do not establish that a pipeline exists. Inaccessible evidence is unknown, never absence or safety. Push may deploy base/other configured branches, matching tags may deploy through ship, both or neither may apply. Preserve project-specific deployment approvals.

## Environment Branches (optional)

Independent of ship method. Names such as staging/stage/uat/preprod/production/prod are candidates, not proven deployments. Confirm each role through project deployment configuration, supported provider mapping or explicit developer classification. Maintenance/release/bot refs are not automatically environments; unknown roles block dependent actions without probing deployments. The actual main/master base retains its base role even if it deploys production.

**Explicit source and target rules:**

- Preserve permanent environment/base refs; never delete them as cleanup.
- Ordinary ship publishes the current branch's reviewed work first (or its main/env PR helper), then optionally sends that same published source independently to selected targets.
- Base can select environments; a feature can select base/environments; an environment can select base/other environments except itself. Main is not mandatory for feature shipping. None finishes after core publication/handoff.
- Helm no longer imposes blanket upstream-first or forbids feature→environment, environment→base or selected environment→other-environment actions. These edges require explicit per-target diff/effect review and valid approval, not inference from names or a default selection. Never chain one selected target's result into another.
- Real project/provider prohibitions, required review and deployment/CI gates remain binding. Do not silently change source, method or targets to evade them. In direct, required PR policy blocks the affected target and offers only a separately reviewed alternative.
- All target actions use the same reviewed source SHA. In pr, a main/env helper is also the optional PR source, not the older hosted main/env. Independent reviews may let an environment accept changes before main; disclose that possibility and the full source-to-target delta, including environment-specific configuration/history.
- Configured/applicable source CI must pass for that exact published source/ref before environment integration or its PR handoff. Source green does not certify a target merge result, review or deployment. Future PR CI/review/merge is pending/not awaited.

PR heads remain moving refs: pushing fixes updates all open PRs sharing the feature/helper, and later commits do not automatically reach an already merged target. Verify observed head identity and do not promise an immutable snapshot. Reuse matching open requests, preserve partial successes and retain branches. Main/env helpers need proven association and safe fast-forward updates, never prefix-only guessing, force or a new helper every run.

Explicit ship promote remains an existing published base/release→selected-env operation, separate from current-branch shipping. It never publishes current env/feature work or silently widens an older exact snapshot to newer main. Ship release has no automatic promotion stage. Ordinary optional merges/PRs create no version/tag/release, even when integrating into main. Retired environment-promotion declarations remain preserved/inert; no chain order is restored.

Env and test permit approved local work on confirmed environment branches under their own scope, clean-state and runtime-safety gates. Refactor keeps confirmed non-base environments source-inspection/report only. A local fix never synchronizes branches automatically; shared fixes may need deliberate upstream application, and ignored env inputs remain worktree-local. Flexible ship targets do not bypass command or project policy. Other local Helm commands never publish or promote.

Other workflows finish locally on their permitted current branch, without publication/PR, integration/promotion or branch cleanup. Source/record checkpoints retain actual local provenance. Ship later applies exact source/target checks, approvals and deployment protections. See [Git and CI behavior](../setup/git-and-ci.html).

## References

- [Git push](https://git-scm.com/docs/git-push): refspecs, fixed leases and follow-tags.
- [Git configuration](https://git-scm.com/docs/git-config): push URLs and configured effects.
- [Safety rules](safety.html): approvals, state ownership and static risk discovery.
