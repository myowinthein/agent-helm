---
title: Git and CI behavior
parent: Setup
nav_order: 6
permalink: /docs/setup/git-and-ci.html
---

# Git and CI behavior

Helm separates local editing, publication method, actual branch topology and team size. Both Claude and Codex resolve the same configuration owner, normally AGENTS.md with CLAUDE.md importing it. Project/provider instructions and stronger safety/review requirements remain binding.

## Current configuration

| Setting | Values and default | Purpose |
|---|---|---|
| ship-method | direct / pr; default pr | Ordinary ship integration/push versus terminal verified PR/MR handoff |
| git-auto-commit | true / false; default false | Local commit authorization, independently of publication |
| git-merge-strategy | squash / rebase / merge; default squash | Eligible ship integration method, independently of team size or ship method |
| readme-style | standard / custom | README style under manifest |

Use a valid explicit ship-method; genuinely absent settings default to pr. Retired git-strategy has no mapping: if present without ship-method, dependent shipping stops with [upgrade guidance](upgrading.html). Invalid explicit active values block their dependent actions. Environment-promotion selects no behavior; optional targets and explicit ship promote remain active.

A reviewed settings edit changes only the actual owner/block, preserving other values, overrides and adapter ownership. Ordinary commands do not clean up retired keys. One-time project maintenance materializes the intended method before removing old declarations.

Older adopted git.md copies may still require workflow branches/PRs. Review/update their actual bodies through adopt, or explicitly reconcile active project instructions before affected writes. Updating the plugin/config alone does not silently overwrite copied policies. Existing local/remote branches and unfinished runs are not automatically renamed, deleted, integrated or migrated to a new branch.

## Local editing commands

| Command | Recommended starting branch and reason | Write eligibility |
|---|---|---|
| log, manifest, legal, adopt | Main/master for canonical project knowledge, documentation and shared-rule setup against integrated code | Current actual base; log/adopt retain their explicit no-Git/no-HEAD bootstrap |
| env | Feature/main for shared fixes; environment branch for intentional differences or integrated-source problems | Current actual base, established current feature or confirmed current environment branch |
| test | Feature/maintenance for related tests; targeted environment checks; main/master for whole-project Gap scan/Full scan | Current actual base, established current feature/maintenance or confirmed current environment branch, including eligible same-branch ledger writes |
| refactor | Targeted cleanup alongside a feature; base or an existing refactor/* branch for general changes | Current actual base, established current feature or existing current refactor/*; confirmed non-base environments remain Audit/Plan only even with that prefix |
| normalize | Branch containing the history to review, preferably before publication | Current attached eligible branch; every local branch affected by accepted message changes is rewritten together |
| archive | Intentional complete project snapshot, usually integrated main/master | Current attached source branch after explicit branch/snapshot confirmation |
| ship | Current branch for code publication, integrated main/master for explicit release | Classified current base/feature/env publication plus optional eligible targets; explicit release/promotion/specialist routes remain separate |

Recommendations do not add mode restrictions: env/test allow the same approved actions on eligible roles, and targeted feature refactoring is a recommendation rather than a hard limit. Establish non-base roles from actual project instructions, deployment evidence or developer classification; names alone prove neither role, ownership nor runtime safety. Reuse known evidence, resolving unknown roles before dependent writes without a new per-run branch confirmation. Refactor's confirmed non-base environment restriction takes precedence over a refactor/* prefix. Actual base remains eligible even when it deploys production. Keep clean-state, scope, verification and actual script/hook/runtime-effect approvals; stronger project policy still applies. On an environment branch, distinguish shared from intentional environment-specific changes. Shared fixes can be stranded or overwritten by later integration and may need deliberate upstream application, never automatic back-propagation. Ignored local env inputs stay worktree-local. Feature/environment checkpoints describe their actual inspected snapshot, not main or deployed currency.

Wrong branches block writes and explain why; read-only paths retain each command's documented scope. Log/adopt preserve their explicit no-repository/no-HEAD bootstrap without git init. Normalize coordinates all affected existing local branches after its existing warning/confirmation. Archive never selects a different source on the developer's behalf.

The non-ship commands never create/select/switch/update branches to finish, ask to push/open a PR, integrate, promote environments or clean up/return branches. Normalize's approved existing-ref rewrite retains its own contract; ship retains its publication routes below. Preserve each workflow's clean-state, safe legacy-input exception, stronger review and verification requirements. No broader blanket clean-tree restriction is added to ordinary coding or read-only assessment.

Shared local preparation records actual branch/HEAD and resolves effective local policy. Shared completion verifies outputs and source checkpoints, stages literal approved paths, obtains required commit approval and reports local results. It requires no publication remote, provider access or published source SHA merely for local completion. A local checkpoint is neither a test pass nor remote consistency proof. No-op/cancel creates no synthetic commit/migration. Failed/declined writes/commits preserve drafts/index/refs and earlier successful work.

## Commits, reviews and safe staging

Honor git-auto-commit independently; true approves completed eligible local coherent units, not unfinished work or publication. Legal canonical content/commits and archive payloads retain explicit review even with auto-commit. Inspect the complete index and exact literal paths/hunks, preserving unrelated user changes. No directory-wide staging, git add -A, incidental secrets/state or automatic stash/reset/cleanup.

Local commands retain truthful inspected source IDs and own-state coverage on the branch they actually reviewed. A source anchor does not inherently require main/master or certify another branch/deployment. After integration or history changes, revalidate ancestry/context; squash/rebase may make an anchor unusable even when work began on local main. Reassess under the owning workflow rather than replacing it with an uninspected merge tip or merging conflicting ledgers automatically. Preserve schema/history/unknown fields and per-file eligible migration. Required failures/deferred/unavailable checks stay explicit; do not pretend they passed or advance unsupported checkpoints. Verification deferral never approves an otherwise gated publication.

## Ordinary ship routes

Ordinary ship publishes the current work first, then offers optional same-source targets. No code push, PR completion or target integration triggers versioning/release. `ship release` is explicit and main/master-only; no new configuration key or separate release skill is required.

| Current role | direct core | pr core | Optional targets |
|---|---|---|---|
| Actual main/master | Push/verify main | Push/reuse one established ship/* source, PR into hosted main | Confirmed environments |
| Feature | Push/verify feature | Push/verify the same feature; no helper/self-PR/mandatory main PR | Main/master and confirmed environments |
| Confirmed environment | Push/verify current env | Push/reuse one established ship/* source, PR into that hosted env | Main/master and other envs, excluding current |

Optional direct actions merge the pinned source into each target and push after required checks; optional pr actions create/reuse source-to-target PRs. The feature remains its source, while main/env uses the SAME helper as its own-target PR. Never substitute the older hosted current branch for pending helper work, create a helper per target or propagate a selected target's result into the next. Target reviews are independent: env may accept pending source changes before main. Show the full diff/history, including env-specific configuration and deployment effects. None finishes after core publication/handoff.

Helm's previous blanket main-first/no-env-to-env rules are replaced by explicit eligible target selection, with actual project/provider prohibitions still binding. A required PR blocks direct publication and offers a separately reviewed alternative, never bypass. Local command eligibility remains separate: env/test allow approved confirmed-environment work, while refactor keeps confirmed non-base environments Audit/Plan only. Branch names alone do not establish role or deployment safety.

Before creating a helper, inspect established original-branch/work/request identity and complete provider evidence. Reuse a unique proven pending helper; fast-forward updates need all existing source history/content included in the reviewed new source. Unknown/multiple candidates, reviewer commits absent locally or closed-unmerged requests require reconciliation, not a new helper/force/overwrite. Prefixes alone are insufficient. Push fixes to the existing feature/helper: all open PRs sharing it update automatically, while an already merged target needs a new selected action for new changes. Reuse exact open source/target requests rather than duplicate them.

PRs are moving source refs: verify observed source SHA at creation/readback and disclose later source changes. Never auto-merge, await future PR review/CI/merge, update sources from targets or request source deletion. Core handoffs may be followed only by expressly selected independent optional targets; metadata PR handoffs remain terminal. Preserve verified core publication/earlier targets on later failure, mark remaining targets not attempted and return only when independently safe. Local main/env stays unmoved when a helper is made. After squash/rebase integration, reconcile old local IDs deliberately, never reset or republish equivalent work.

### Explicit release and promotion

`ship release` retains SemVer, canonical/companion version edits, notes, exact annotated tag and optional hosted release. Require verified integrated main/master before preparation/tagging; application code still unpublished or awaiting PR integration belongs to ordinary shipping first. New direct metadata may be committed/published within the release plan. New metadata under pr needs its reviewed metadata PR first; after merge, resume the same version using actual integrated source proof. Detect pending/merged original or metadata PR/version candidates before proposing another bump, and create no empty/new code PR merely to tag ready content. No optional target selector follows release.

Explicit `ship promote <tag-or-published-SHA>` keeps existing published base/release→selected-env routing and skips current-branch core publication. Direct integrates that exact source; PR uses published main only if its head matches the selected source, never silently widens an older snapshot or adds a snapshot helper. Report mismatches or accept a separately approved current-main action. No version/tag/hosted release is created by promotion. Status and identified partial resume retain exact-source proof without a new ledger; a release does not automatically resume or introduce target work.

## Exact publication and CI

A concrete human instruction/workflow approval authorizes only its described source SHA, destination/refs, contents and effects; reuse it while unchanged. Auto-commit, tool permission, picker defaults/timeouts and provider review are separate. Revalidate material changes and actual applicable signing/review/protection/checks. Ordinary pushes use bounded explicit refs and no-follow-tags; tag publication needs its own described approval. Read back actual refs/API objects after success or uncertainty before claiming/retrying.

Configured local checks cover changed scope/real consumers; no automatic installation, unrelated repairs or repository-wide formatting. Integration checks are those actual project/provider policy requires for the intended exact commit. A permitted direct local integration acquires no remote gate merely because CI exists. Required remote evidence cannot be replaced with local success. Local-only commands leave remote dependencies pending without offering a push; ship can publish for checks only under explicit scope and must not claim those later checks already passed.

Promotion requires configured/applicable CI success for the exact published source SHA before a target mutation or PR handoff. Source green does not certify target merge-result checks/deployment. Later PR checks/review stay pending/not awaited. Inspect complete applicable results/current attempts with pagination; missing/pending/failed/cancelled/stale/unknown/truncated evidence blocks required actions. No Promote anyway waiver. No configured/applicable CI is not applicable only with evidence.

## Normalize local rewrite and later publication

Normalize reviews exact messages and rewrites all affected existing local branches together with one verified old-to-new map after its existing warning/confirmation. Keep graph boundaries, signatures/metadata, worktree checks, self-contained recovery bundle, tags/excluded refs and schema-1 truthful local records. Unique unaudited messages remain unchanged. Local records use the current permitted branch without a bookkeeping branch/PR or published-anchor dependency. No publication occurs and no extra tracked ship ledger is introduced.

Later explicit ship normalize with the identified private evidence validates the old/new graph/map/bundle, all affected tips and included later work. It never loads/migrates the live normalize ledger or infers a run from divergence. Show all branches' publication/local-only status and exact remote mappings; prove fresh remote histories are accounted for in preserved original history before approval. Unseen remote work or a blocked intended ref stops the set; a smaller set needs explicit review of related histories left old.

Replacing published IDs requires explicitly approved fixed force-with-lease expectations regardless of ordinary ship-method; a PR cannot do it. Only-unpublished corrections may permit normal updates. Prefer an atomic exact-ref transaction with no-follow-tags and fixed expectations; separately approve sequential fallback/partial effects, never refresh rejected leases. Read back every remote, preserve successes/recovery and complete only missing valid actions on continuation. No tag/release/promotion or ledger PR follows.

## Archive local preparation and later private backup

Archive preserves its selected root/schema/reports and creates only the reviewed local payload. Before normal pending phases, show the actual current branch/full HEAD, unmerged work and known exclusions, and obtain Proceed/Cancel for same-branch edits/local payload. Reuse explicit approval only for the unchanged snapshot/scope or proven approved continuation; unexpected drift requires reconfirmation. Audit/Plan and proven prepared/completed report-only exits need no new branch question. New runs use .helm/archive/; existing runs stay at their original root including .archive/. No confirmation file/schema field, source branch switching, remote dependency, push/PR question or cleanup follows. The fifth local report states prepared locally, not backed up remotely. Cursor 4/phase prepared may have null remote/payload IDs; exact committed source/archive-ID/report/manifest proof identifies local completion without a post-commit tracked write. Reruns do not replay or replace proven local preparation.

Only explicit ship archive continues the validated bundle's publication protocol. Its narrow state access covers that bundle's journal/receipt and no unrelated ledger. Verify the already prepared payload, one private destination, normal fast-forward policy, all checks/privacy/secret/history/object limits and actual recovery/LFS bytes. Obtain new backup approval, publish/verify payload, perform only opted-in bounded post-backup cleanup, then commit/publish/read back the receipt with exact ancestry. Keep names/remotes by default; no ordinary release tag/PR/environment route.

A proven pending own journal/receipt diff has a narrow continuation exception; unrelated pending work blocks. Preserve verified interrupted current-format progress and complete only missing verified phases. Replace the local fifth preparation report with the expressly reviewed receipt, retaining its historical version in Git. Cursor 5/receipt_prepared alone proves no remote seal; final remote proof supplies actual completion without another tracked write. Verified completed runs replace nothing. Optional portable copies remain separately approved external exports after verified receipt.

## Reporting and implementation verification

Reports distinguish local drafts, verified commits/checkpoints, actual checks, source publication, PR handoff, release, backup seal and deployment. Local-only workflows finish on the same branch. Ship alone attempts its safe original-branch return when independently safe, preserving ignored/untracked inputs and refusing force/stash/reset or draft commits to enable checkout. Partial publication never becomes success merely from a return.

This lifecycle/configuration change has source/document review only. Tests, builds, packaging/native-client verification and workflow/provider execution remain deferred; no runtime compatibility or publication success is claimed.
