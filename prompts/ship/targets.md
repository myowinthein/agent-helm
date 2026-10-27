# Ship optional targets

Ship-only supporting procedure. Load for applicable optional target selection/actions or an explicitly requested published-source promotion; not for an already supplied None with no remaining target work. Step numbers refer to [ship](../../workflows/ship.md). Use [source preflight](../../workflows/ship.md#step-1-establish-scope-capabilities-and-core-publication) for any missing core preflight, applicable [CI gates](../shared/ci.md) and only relevant provider identity/host/action sections. Do not repeat proven source publication or release assessment.

## Step 6 — Optional targets and an explicitly selected published source

### Select optional targets after core publication

After Step 1 core publication/handoff is verified (or its already-published no-op is proven), offer one QM Multi with explicit **None / Finish**. Do not start target work before this choice. Preserve prior explicit selection of the same reviewed plan without asking again. No candidates means no question; one uses QM Single Yes/Skip, 2–4 use native Multi when supported, more use QM's complete-list fallback. Never truncate or preselect production/main as consent.

| Original current role | Optional targets |
|---|---|
| Actual main/master | Confirmed environments only |
| Feature | Actual main/master and confirmed environments |
| Confirmed environment | Actual main/master and other confirmed environments, excluding itself |

Discover roles from actual configuration/provider/developer evidence, not names alone. Do not offer arbitrary feature/bot refs as destinations. For fork mappings, verify each target's intended repository, refs and policy; a source push/PR target binding never authorizes a second Git destination. Actual project prohibitions still block an edge. Helm itself no longer imposes mandatory main-first or forbids selected feature→env/env→main/env→other-env edges. Local-edit eligibility remains independent: env/test permit approved confirmed-environment work, while refactor keeps confirmed non-base environments source-inspection/report only; ship routing bypasses neither command nor project policy.

Every choice describes **merge the reviewed source into this target and push** for direct, or **create/reuse a source-to-target PR** for pr. Before dependent writes show exact source/ref/SHA, each target's fresh tip/repository, complete commit range/diff (including source-only environment configuration/history), known deploy effects, method/checks/protection and concrete action approval. Counts/diffstat are summaries, not substitutes for content review. Explicitly label routes that bypass main and independent pending-main reviews. Selection alone is consent only when those exact actions/content/effects were already presented; otherwise review the concrete plan once. None skips target updates and proceeds to release eligibility; it does not undo source publication or known updates to existing source-sharing PRs.

Use **one** `{source_sha}` independently for every target, with the verified published existing feature/helper/current branch as PR source. Never use a newly merged target as the next source, switch to old hosted main/env after a helper PR, or silently broaden/move the source. PRs track refs and can include later pushed commits: revalidate the observed source SHA at every handoff and disclose future movement, never promise an immutable snapshot. Each target's approval/review is independent and never waits for another PR to merge.

### A published source identified during the conversation

When the developer identifies an existing published base/release as the source for environment updates, confirm that exact source-and-target plan instead of publishing unrelated current work. Verify the exact existing source's provenance through the intended published base, pin `{source_sha}` to that commit and bind its actual repository/publication identity. Then borrow this selector's confirmed-environment discovery, explicit none and exact action review, irrespective of the invocation branch's role. It performs **no core current-branch push or own-target PR**, even when invoked from an environment, and creates no version/tag/release. Unlike ordinary optional routing, it never substitutes unpublished current feature/env/helper work for the requested published release.

For direct promotion integrate the exact published tag/SHA. For PR promotion retain the published base ref as source, with no snapshot helper; its current head must equal the requested SHA. An older exact snapshot cannot silently become a newer-main PR: show the extra range and leave that action pending, or accept a separately approved current-main promotion. Do not introduce a helper just to change this explicit route's exact-source contract. A release never selects these targets automatically. Continue an older target plan only from its proved source/scope and still-valid explicit selection; an existing-source-only task finishes its target work without proposing an unrelated new release.

### Target gates and no-ops

Require clean safe workspace, no in-progress operation, verified source publication and fresh source/target identities throughout. Check affected worktrees before checkout/ref changes. Apply **integration** gates for main and **promotion** gates for environments using the actual published feature/helper/base/env source SHA/ref; configured/applicable source CI must pass for environment actions, even if the source ref is a helper. Filters may mean its checks cannot run: leave that action pending rather than treating an older base's green result as source evidence. Later PR/merge-result review/CI remains pending/not awaited; source green does not test a future merged target or prove deployment.

Verify inclusion/equivalence in the **published target** before deciding a no-op; local containment alone cannot skip a missing target push. A merged historical PR cannot receive new commits: when a new reviewed source delta remains, offer a new matching target request only under its explicit selection/approval. Reuse one exact open PR rather than create duplicates. No-op targets get no empty merge/PR/repush. Unresolved target evidence blocks that action, never the truth of earlier core success.

### direct — integrate and push each selected target

Recheck policy, source SHA, target/worktree safety and fresh remote tip. Safely checkout/synchronize an eligible behind-only clean target; divergence or unrelated local commits block rather than being absorbed, reset or stashed. Integrate the **same pinned source SHA** using the project-permitted configured method, with appropriate merge/commit approval. A source just published by core shipping is shared: rebase must not rewrite it. If configured rebase cannot be honored without rewriting a published source, offer a separately approved permitted merge/squash or leave pending, never silently change the strategy. Use `--no-ff` only where policy permits; verify full resulting content and source inclusion or reviewed squash/rebase equivalence.

Run applicable result/integration checks before target publication; source CI alone is insufficient. Required provider review/remote checks get their valid reviewed path, not a direct bypass or an invented remote gate on an otherwise permitted local integration. Push only the exact approved target result/ref with `--no-follow-tags`, then read back its actual remote SHA. Refresh expected snapshots only for verified own actions. No target merge invokes SemVer/version metadata, a tag or hosted release, including a feature/env merge into main.

A failed check/push can leave this run's unpushed target integration. Preserve it and report original source, target-before/remote expectations, exact local result, complete reviewed diff and remaining action. A later explicitly identified partial run may prove parents/equivalence, source contents, fresh remote and required checks, then offer only the missing approved push. Never infer ownership from a message/local-ahead state alone, merge again, reset or manufacture a ledger. Unproven/drifted work remains for manual reconciliation.

### pr — independent handoffs from the shared published source

For each approved target, use the exact `{published_source_repository}`/`{published_source_ref}` at observed `{source_sha}` as head and the selected target as base. A main/env helper is shared by its core own-target request and every optional target request; a feature keeps its existing source. Do not create helpers per target, push/merge a target, update a source from a target, request auto-merge/source deletion or wait for later CI/review/merge. Source publication fixes update all open requests sharing that ref. Check the full per-target diff and actual provider/project restrictions before the handoff.

Use the provider guide to search/create/reuse/read back the exact PR/MR pair, actual repositories/refs/open state and head SHA. A source change during handoff leaves the real request preserved but the result pending reassessment. Known conflicts/forbidden merge methods leave an honest pending handoff, never auto-resolution or an extra source branch. Verify every selected request, report later review/merge checks as pending/not awaited, then finish even if merge-ready. PR handoff alone is not release readiness; only the integrated-main release decision can authorize the later release stage.

### Partial results and finish

Stop at the first failed/blocked selected action and list remaining selections as not attempted. Keep verified core publication and earlier target results, helpers, feature/base/environment refs and real drafts/conflicts intact. Never undo source publication to make the optional stage look atomic. A supported abort is allowed only for this run's own merge when prior work/recorded clean baseline stay intact; verify it without reset/stash/force, otherwise leave manual recovery. Apply Step 8's independent safe return. CI/manual/artifact deployments receive a precise handoff, not invented job triggers or a deployment-success claim.
