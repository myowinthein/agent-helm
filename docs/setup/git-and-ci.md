---
title: Git and CI behavior
parent: Setup
nav_order: 6
permalink: /docs/setup/git-and-ci.html
---

# Git and CI behavior

Log, manifest, env, legal and test use the same content-sync Git procedure. Adopt follows the same publication policy with its own setup/verification flow; refactor retains its resumable branch flow. Ship keeps release and chain-promotion behavior, using the same CI gates.

## Setup and ownership

Resolve configuration through the active instruction entry, overrides and bridges. Shared setup uses AGENTS.md as owner and CLAUDE.md as its import adapter. Existing owners remain until log's reviewed migration. Defaults are GitHub Flow, auto-commit off and squash merging.

Resolve the actual main/master base branch and use that name throughout. Start from a clean working tree/index; do not stash, reset or absorb unrelated work. Solo runs on the base without a feature branch. GitHub Flow starts a uniquely named branch from the safely updated base, using an unused suffix when a date-named branch already exists. Re-read destination ownership/configuration after checkout and stop on unexpected differences. Log's approved layout/settings outputs remain expected changes, while its recorded invocation policy governs this run.

An invoked test/legal workflow may preserve its own explicitly reviewed untracked legacy state input through setup only after read-only validation under its packaged state procedure. Re-resolve on the destination and stop before any clobber. This is not permission to absorb canonical drafts, tracked changes, unreviewed histories or another command's state.

## Verify and commit

Each workflow verifies its own outputs before committing or publishing. Stage only exact approved paths and inspect the complete proposed index. Honor auto-commit; legal always requires explicit document review and commit approval, including integration commits. Owned ledger migrations follow their own validation, verification and same-file retirement procedure. This shared Git flow does not access another command's state.

Declined/failed writes or commits leave actual drafts, index and branch intact. Earlier layout/per-file/ledger commits still count as work. Env's local-only edits stay on disk and never enter publication; if they block checkout, stop that action without discarding or committing them. Only a genuine no-write/no-commit run uses empty-branch cleanup, switching back before deletion.

## Review and publication

Solo needs no PR unless explicit project policy requires it. Publishing its verified base commits always has its own push confirmation.

GitHub Flow requires a PR even without provider enforcement. Outstanding review/checks offer **Publish branch and open PR** or **Leave branch local**, describing the exact push. Verify the remote SHA, reuse an existing matching PR or create one through an authenticated supported provider. Missing access, declined publication or PR failure leaves an honest local/published manual handoff. A handoff does not merge, promote or delete the branch.

Once the exact tip's required PR/reviews/CI pass, integrate using the configured squash/rebase/merge strategy through the path allowed by protection. Confirm required integration commits before mutation; provider merging that publishes the base also needs publication approval before its API call. Local base publication has a separate push confirmation. Never implicitly rewrite a shared/pushed branch or bypass protected-branch requirements.

Verify integrated contents and remote SHA before promotion. Saved review/scan IDs remain actual inspected provenance, not invented merge-tip replacements.

## CI gates

Integration checks are those required for that specific action by GitHub Flow, explicit project policy or provider protection. Solo with no pre-integration remote requirement may integrate locally after applicable local checks; a pipeline merely existing does not force a PR or impossible check of an unpublished branch. If remote checks are explicitly required, offer separately confirmed branch publication or a review handoff and wait for that SHA. Local test success never substitutes for a required remote result.

Before promotion, configured/applicable CI must succeed for the exact published source SHA, including each chain hop. Detect CI from project/provider evidence; non-GitHub hosting or missing GitHub Actions files does not establish absence. Inspect all applicable runs, required checks and status contexts with pagination and current attempts. A fixed recent-run sample is insufficient.

Pending, missing, failed, cancelled, inaccessible, unknown, stale or truncated required results block the action. Recheck changed tips. No applicable CI is reported as not applicable with evidence. Wait/recheck or leave promotion pending; there is no **Promote anyway** waiver. A selected environment or host-tool approval never satisfies CI.

## Promotion, cleanup and reporting

Content syncs fan out from the verified published base regardless of release-chain configuration. Gate CI before offering targets. Use at most four options, or Yes/Skip for one target, and describe both merge and push. Recheck each target, stop on failure and report completed/pending targets separately.

Delete a local workflow branch only after verified finalization, with no pending work, its tip inside base ancestry and a successful `git branch -d`. Squash/rebase may leave it outside ancestry; retain it rather than force-deleting. Remote deletion needs its own push confirmation. Return to the original branch only when safe.

Reports distinguish local drafts, verified commits, local integration, PR/review handoff, published base, CI and promotions. Verification comes from the workflow/integration branch, not a different checkout after cleanup.

## Compatibility changes to mention in release notes

- Log, manifest, env and legal now honor GitHub Flow's PR requirement and configured integration strategy instead of always merging locally with `--no-ff`. Test also offers explicit PR publication/handoff. Solo retains its no-PR behavior.
- Required CI cannot be bypassed with ship's former promotion override. Provider-aware checks cover every applicable result for the exact source SHA.
- Main/master resolution, unique branch names and safe branch retention apply consistently. Test's checkpoint records the actually assessed source snapshot so normal squash/provider merges preserve its incremental baseline.

These are source-level changes reviewed with Claude. Runtime and native-client checks remain deferred; this page does not assert that they passed.
