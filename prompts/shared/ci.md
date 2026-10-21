# Shared CI gates

Apply only to the action requested by the invoking workflow. Reading this procedure does not run checks or authorize publication.

## Determine the applicable gate

Record the action, source branch and exact source SHA. Inspect project CI configuration, active instructions and applicable provider protection/review requirements. Absence of `.github/workflows/`, or a non-GitHub remote, does not establish that CI is absent. Unknown policy/access is a capability gap, not a successful or not-applicable check.

Apply that uncertainty to the gate actually required for the action. Lack of provider access alone does not invent a pre-integration remote gate for a Solo local merge when no project/known applicable policy requires one. Provider requirements that constrain remote publication remain enforced at that publication; a permitted local merge is never permission to bypass them or claim CI passed. If a declared/applicable requirement itself cannot be resolved or verified, keep that action pending.

- **Integration:** require remote checks that project policy or provider protection requires before this integration. GitHub Flow retains its PR requirement and its configured pre-merge CI policy. Solo does not acquire a pre-integration remote gate merely because a pipeline exists: when no policy requires that gate, applicable local checks may permit local integration. An explicit required remote gate in either mode must pass; local tests never substitute for it.
- **Promotion:** configured/applicable CI must succeed for the exact published source SHA before any environment merge/push. This includes content syncs, release fan-out, and each chain hop. Check the current source environment when advancing a chain. No applicable/configured CI is recorded as not applicable, with evidence, never as a fabricated pass.

## Verify required results

Use an authenticated supported provider interface. On GitHub, verify repository access and inspect all applicable workflow runs, required check runs and commit status contexts for the exact SHA, with pagination. Do not use a fixed recent-run limit as proof of complete coverage. Other providers require equivalent pipeline/check evidence. Git transport access alone does not establish API access; do not install tools, change credentials, or alter client settings automatically.

Every applicable required result must be complete and successful. Failed, cancelled, pending, missing, unknown, stale or truncated results block the action. A skipped check is acceptable only when policy establishes it is not required. Ignore results for another SHA and superseded attempts. Recheck the branch tip and required results immediately before the gated mutation; a changed tip invalidates prior evidence.

An unpublished branch may have no remote results. If remote CI is required, offer a separately confirmed branch push (describing the exact ref and consequences) or a review/manual handoff, then wait for that exact SHA's checks. Reuse a caller's concrete publication question/approval for this same exact branch push rather than asking twice; a content-sync PR-publication choice can supply it. Publishing for checks does not require creating a PR in Solo. Respect branch-trigger filters: a push alone does not prove the required pipeline will run. If checks cannot be obtained on the supported path, leave integration pending rather than bypassing the policy.

When a gate is blocked, report the source SHA, non-secret reason, completed operations and pending targets. Stop/skip the affected action, or offer exactly two choices such as `Wait and recheck` and `Leave pending`. Only a later verified success unblocks it; timeout, host approval, environment selection, or a `Promote anyway` answer cannot waive required CI. A post-publication block leaves the published source intact, with no environment mutation or branch cleanup.
