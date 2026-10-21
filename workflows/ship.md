# ship

## Before starting

Resolve effective memory/configuration through the shared runtime and record invocation Git strategy. Resolve `{base_branch}` to the actual main/master branch and use it consistently. Check the actual current branch. Read `{package_root}/prompts/shared/ci.md` before any promotion; configured/applicable CI must pass for the exact published source SHA, with no implicit override.

**GitHub capability preflight ({base_branch} and environment branches):** before committing pending work, editing release files, tagging, or pushing, inspect origin to determine whether this is a GitHub repository. On GitHub, check `gh --version` and, only if installed, `gh auth status` for the origin's host. Record whether the CLI is available/authenticated and a non-secret reason if unavailable; do not expose credentials, install tools, or log in automatically. Inform the user up front if GitHub CI inspection or GitHub Release creation is unavailable on this host. Git transport credentials are separate; a successful Git push does not establish GitHub API access.

Missing CLI/authentication does not imply CI passed or that no CI exists. A separately approved Git release may proceed, but configured/applicable CI still blocks promotion when unverified, and GitHub Release creation must be skipped with manual instructions. Later API/network/permission failures receive the same unavailable handling even if preflight passed. Non-GitHub repositories do not require gh for this workflow.

If on {base_branch}:
  Check for a clean working tree: `git status --porcelain`.

  If clean → proceed normally, full ship flow including version tagging.

  If not clean, first inspect path/status metadata only, without opening operational state. Pending operational `.helm/`, `.claude/helm/`, or known flat legacy ledgers block ship; do not open/commit/migrate those records here. For remaining paths, locally screen contents without exposing values or raw secret-bearing diffs. Non-example `.env*`, credential/private-key files, or any pending content containing secrets (including `.env.example`, source, README or version files) also block the preparatory commit and release. Report paths only and leave everything intact for the owning workflow or developer. An inability to verify safety is a block, not permission to stage it. Do not just exclude protected paths and continue with a dirty release.

  Under GitHub Flow, unrelated pending work cannot be committed directly to the base under the release-commit exception. Stop and direct it through the normal branch/PR path first. That exception covers only reviewed release version/metadata changes, never arbitrary pending work.

  In Solo, if every pending path/change is verified safe, show the complete safe diff and exact proposed paths/commits, then offer `Commit reviewed safe changes` or `Stop here`. The answer covers only that concrete preparatory commit, not release tagging/push. Recheck inputs and index; stage only exact approved safe paths with literal pathspecs (including reviewed deletions), never everything from status or unrelated pre-staged changes. Inspect the complete proposed index, commit scoped logical units, verify each commit and require a clean tree before continuing. A declined/failed commit leaves actual work intact and stops the release. Never reset, stash or discard work to force a clean status.

If on environment branch (staging, production, etc):
  Proceed with promotion only — Steps 1-4 (version bump, commit, tag, code quality checks, GitHub Release) are all skipped; only Step 5's promotion runs.
  Inform user:
  "On {branch}. Promoting to next environment only — no version bump, commit, tag, code quality checks, or GitHub Release. Those only run from {base_branch}."

If on feature or any other branch:
  Stop and inform user:
  "Feature branches must be merged to {base_branch} via PR before releasing.
  Please merge your branch, switch to {base_branch}, and run /ship
  from there."

---

## Step 1 — Select deployment targets ({base_branch} branch only)

Skip this step if on environment branch — proceed directly to Step 5.

Discover environment branches via: git branch -r
Filter for known environment names (staging, production, or similar).

Check `environment-promotion` in {memory_file} Project Config (see git.md's Environment Branches section; absence defaults to `fan-out`):
- **fan-out**: offer every discovered environment branch below. AskUserQuestion caps at 4 options — if more than 4 branches qualify, offer only the first 4 (recognized tier names first — staging/stage/uat/preprod, then production/prod, then any others alphabetically) and note in the question that remaining branches need a follow-up run.
- **chain**: offer only first-tier branches (staging, stage, uat, preprod) — second-tier branches (production, prod) are never a direct deploy target from {base_branch} in chain mode; they're only reached later via Step 5's promotion from the first tier. If only second-tier branches exist (no first tier to promote through), offer none and inform the human why: "production-tier branches require a pre-production tier to promote through in chain mode; none found."

If no environment branches exist (after filtering):
  Skip this step. Tag and push {base_branch} only.

If environment branches exist (after filtering), use AskUserQuestion:
  AskUserQuestion:
    question: "{base_branch} will always be tagged and pushed. Which additional environments should be promoted?"
    header:   "Deploy targets"
    multiSelect: true
    options: one entry per offered environment branch, e.g.:
      - label: "staging"
        description: "Merge and push {base_branch} to the staging branch"
      - label: "production"
        description: "Merge and push {base_branch} to the production branch"  (fan-out mode only)

  If exactly one environment branch qualifies (after fan-out/chain filtering), a multi-select with one option isn't valid — AskUserQuestion requires at least 2. Ask a direct yes/no confirmation instead:

    AskUserQuestion:
      question: "{base_branch} will always be tagged and pushed. Also promote to {branch}?"
      header:   "Deploy target"
      multiSelect: false
      options:
        - label: "Yes — promote to {branch} (Recommended)"
          description: "Merge and push {base_branch} to {branch}"
        - label: "Skip"
          description: "Deploy to {base_branch} only"

    "Yes" is equivalent to selecting {branch} in the multi-select above — proceed the same way.

  If user selects none → deploy to {base_branch} only.
  Wait for response before proceeding.

---

## Step 2 — Calculate and propose version ({base_branch} branch only)

Skip this step if on environment branch — proceed directly to Step 5.

Detect version file by scanning for `.claude-plugin/plugin.json` (Claude Code plugin format), package.json, composer.json, or VERSION file, in that priority order if more than one exists — a `.claude-plugin/plugin.json` is a strong, deliberate signal that this repo's canonical version lives there, not in an incidental package.json. Needed later in Step 4 regardless of whether a tag exists.

Run: git describe --tags --abbrev=0
If no tag exists:
  Read current version from the detected file.
  If version found in file → use it as base version.
  If not found → use 0.1.0 as base version.
  Inform human: "No tags found. Using {base_version} as base version."

**Detect commit style and calculate version**
Run: git log {last_tag}..HEAD --oneline

Use this single output for both detection and version calculation:
- If feat:/fix:/chore:/feat!: patterns are present → Conventional Commits detected
- If no Conventional Commits patterns → not detected

If Conventional Commits detected:
  Read commit messages and scan file changes.

  Triage by commit type (covers every type in git.md's Conventional Commits list):
  - feat              → minor bump candidate
  - fix, perf         → patch bump candidate — perf is a real improvement to shipped behavior, not a no-op
  - feat! or BREAKING CHANGE → major bump candidate
  - chore, docs, style, ci, build, refactor, test, revert → ignore for version calculation — no behavior change from the user's perspective

  Calculate next version based on highest-priority commit type:
  - Any BREAKING CHANGE or feat! → major bump
  - Any feat (no breaking change) → minor bump
  - Only fix/perf commits (the patch-bump-triggering types) → patch bump

  Present to human:

  Current version: v{last_tag}
  Next version:    v{proposed}

  Commits included:
  - {list of feat and fix commits, skip chore/docs/style}

  Deployment targets:
  - {selected environments from Step 1}

  AskUserQuestion:
    question: "Ship v{proposed}? Confirming will commit, tag, push, and promote to any environments selected in Step 1. Current: v{last_tag} → Proposed: v{proposed}"
    header:   "Version"
    multiSelect: false
    options:
      - label: "Confirm v{proposed} (Recommended)"
        description: "Commit, tag, push, and promote v{proposed} — this is the release go-ahead"
      - label: "Bump to v1.0.0"  (only include if current version is 0.x.x)
        description: "This release completes a usable set of features that solves a real problem end-to-end"
      - label: "Enter custom version"
        description: "Specify a different version number"

  If "Confirm v{proposed}" selected → set `{version}` and record explicit release approval for that exact version and the listed targets.
  If "Bump to v1.0.0" selected → set `{version}` to `1.0.0` and use the final release confirmation below.
  If "Enter custom version" selected → ask human to type the version, then validate it and use the final release confirmation below. Choosing custom entry is not release approval.
  Wait for response before proceeding.

If Conventional Commits not detected:
  Inform human:
  "Conventional Commits not detected in this repo.
  Version cannot be calculated automatically.
  Consider adopting Conventional Commits for future auto-versioning.
  Current version: v{last_tag}
  What should the next version be?"

  Wait for human to input version before proceeding.

Whichever path supplied {version} manually (custom version entry, or the no-CC direct-entry path), validate it matches Semantic Versioning format (MAJOR.MINOR.PATCH, optionally with a `-prerelease` or `+build` suffix, e.g. `2.1.0` or `2.1.0-beta.1`) before proceeding to Step 3. If it doesn't match, inform the human and ask again — this value gets written into the version file and baked into a permanent tag (git.md: tags are never rewritten), so it isn't safe to accept unchecked. {proposed} from the auto-calculated path doesn't need this check — it's derived from a known-good base version, always well-formed by construction.

**Final release confirmation for manual/custom versions and the v1.0.0 shortcut:** after obtaining a valid version, present that exact version, the current/base version, selected environments, and any GitHub capability limitation from preflight, then ask:

  AskUserQuestion:
    question: "Ship v{version}? After quality checks, this commits the release, creates and pushes v{version}, pushes the release branch, and promotes to {selected environments or 'none'}."
    header:   "Release approval"
    multiSelect: false
    options:
      - label: "Ship v{version}"
        description: "Approve this version's commit, tag, push, and selected promotions"
      - label: "Cancel"
        description: "Stop before release edits, tagging, pushing, or promotion"

  If Cancel → stop without executing the release. If Ship selected → record approval for this exact version and target list. A typed version, successful validation, missing answer, or approval of a different version is not release approval. Reuse an explicit approval already given for the same exact release instead of asking twice. The calculated-version Confirm option above already supplies that approval.

---

## Step 3 — Run code quality checks

Only reached on the {base_branch}-branch path — Step 1's redirect sends the environment-branch path straight to Step 5, skipping this step entirely.

Run the git.md Code Quality gate — lint + tests — before releasing. Two release-specific overrides:
- Run the full test suite, not just changed-file tests — a release warrants it.
- If no test framework is detected, don't skip silently — ask "No test framework detected — releasing without test validation. Continue?" and wait.

Do not proceed until lint passes and tests are green.

---

## Step 4 — Execute release on {base_branch}

Only run this step if on {base_branch}.

Require the recorded release approval for `{version}` and the selected targets before release writes or mutations. If the version or targets changed after approval, return to the final release confirmation. Respect any stricter project-specific push confirmation requirements as well.

Bump version in detected version file to {version}.

Scan README.md for version references (badges, inline mentions).
If found, update to {version}. Skip silently if none found.

If the detected version file is `.claude-plugin/plugin.json`, also check `.claude-plugin/marketplace.json` for a `plugins[]` entry whose `name` matches plugin.json's own `name` field, and bump that entry's `version` to {version} too — marketplace metadata drifting from the actual plugin version is exactly the kind of staleness this step exists to prevent. Skip silently if `marketplace.json` doesn't exist or has no matching entry.

Commit, tag, and push only the reviewed release changes. Recheck the clean-tree baseline, source inputs and complete index for safe content before staging. Stop on a failed commit/tag/push, preserve actual results and never execute dependent publication as if it succeeded. Verify published branch/tag refs against the intended objects; report partial publication without creating a new version to retry.

Commit, tag, and push:
- git add {version_file}
- git add README.md  (only if README was updated in the step above)
- git add .claude-plugin/marketplace.json  (only if it was updated in the step above)
- git add {any files the Step 3 linter/formatter modified}  (per git.md: fold formatting changes into the last commit; never git add -A)
- git commit -m "chore(release): bump version to {version}"
- git tag -a v{version} -m "Release v{version}"
- git push origin HEAD
- git push origin v{version}

Capture the commit SHA (`git rev-parse HEAD`) as {commit_sha} for the Step 6 report.

Before promoting, verify the release source commit/ref was actually published. If no environments were selected, no promotion gate is needed. Otherwise apply the **promotion** gate in `{package_root}/prompts/shared/ci.md` to `{commit_sha}` on `{base_branch}`. Inspect all applicable provider checks, not only GitHub Actions or a fixed recent-run window. Unverified/pending/failed CI leaves promotion pending without environment mutations; offer Wait/recheck versus Skip promotion, never Promote anyway. The already-published release remains intact, and its separate GitHub Release creation may still be handled below without claiming environments were promoted.

For each selected environment, only after the gate passes/not applicable, recheck source SHA/CI and destination policy, safely switch to the up-to-date destination, merge `{base_branch}` with `--no-ff` and `chore(deploy): promote {base_branch} to {environment} for v{version}`, then push only after successful merge and verify its remote SHA. Selection supplies approval only for the described target pushes, not a CI waiver. Stop on any failure with actual branch/index preserved; report completed and pending targets separately. Return safely to `{base_branch}` after a successful target.

Then use the provider identity established by origin's capability preflight. A non-GitHub provider skips GitHub Release creation, without skipping its applicable CI gates. For GitHub (including a supported configured enterprise host), use the recorded authenticated repository interface and host; do not infer provider identity solely from a github.com substring.

If hosted on GitHub, use the recorded capability preflight. If gh is unavailable or unauthenticated, skip the AskUserQuestion below and inform human of the reason, the already-completed Git release actions, and how to create this same release manually once CLI access is available:

```sh
gh release create v{version} --title "v{version}" --notes "..."
```

Do not rerun the whole ship workflow merely to retry GitHub Release creation; that would start another version. Do not claim a GitHub Release was created when this step was skipped or failed.

If gh was available/authenticated, use AskUserQuestion:
  AskUserQuestion:
    question: "Create a GitHub Release for v{version}?"
    header:   "GitHub Release"
    multiSelect: false
    options:
      - label: "Create release (Recommended)"
        description: "Run gh release create with auto-generated notes"
      - label: "Skip"
        description: "No GitHub Release for this version"

  If Skip selected → skip silently.

  If Create release selected:
  - Build release notes from git log:
    git log v{last_tag}..HEAD --pretty=format:"- %s" | grep -E "^- (feat|fix)"
  - Run: gh release create v{version} --title "v{version}" --notes "{extracted_notes}"
  - On success, `gh release create` prints the release URL to stdout — capture it as {release_url} for the Step 6 report.
  - If the command fails with an auth, permission, network, or other error, report the failure and actual completed actions, with a non-secret reason. Offer manual creation/retry of the same `v{version}` GitHub Release after access is restored, not a fresh ship invocation. A previously successful preflight is not proof that this write succeeded.

---

## Step 5 — Execute promotion on environment branch

Only run this step if on environment branch.

Check `environment-promotion` in {memory_file} Project Config (see git.md's Environment Branches section; absence defaults to `fan-out`).

### Fan-out mode

There is no chain to advance — environment branches only ever receive code directly from {base_branch} (Step 1), never from each other. Before pushing, confirm:

  AskUserQuestion:
    question: "Push {current_branch} to origin now? This publishes the branch and may trigger its deployment."
    header:   "Push environment"
    multiSelect: false
    options:
      - label: "Push {current_branch}"
        description: "Run git push origin {current_branch}"
      - label: "Cancel"
        description: "Exit without pushing or triggering deployment"

If Cancel → report that no push was attempted and exit without mutations. If Push selected → run `git push origin {current_branch}`. Reuse approval if the user already explicitly authorized this same branch push; the workflow invocation, auto-commit setting, or host tool permission is not a substitute for explicit push approval. On success, report the actual branch pushed; on failure, report it without claiming deployment was triggered.

### Chain mode

Determine next environment in promotion chain. git.md recognizes these environment names; treat names within the same tier as equivalent, matching {current_branch} against whichever it is:
  Tier 1 (pre-production): staging, stage, uat, preprod
  Tier 2 (production):     production, prod

If {current_branch} matches Tier 1: the next environment is whichever Tier 2 branch actually exists on the remote (discover via `git branch -r`, same detection as Step 1). If no Tier 2 branch exists, treat as no further promotion.
If {current_branch} matches Tier 2: no further promotion, inform human and exit.
If {current_branch} matches neither tier (a long-lived branch that still qualifies as an environment branch per git.md, just outside the recognized name list): ask the human which branch it should promote to, rather than guessing.

If a next environment exists, apply the shared **promotion** CI gate to the exact source `{current_branch}` SHA, with provider-aware complete coverage. Required CI must pass before the next-environment merge/push. An unpublished source may need a separately confirmed source-branch push first so CI can run; that authorizes no target merge/push, and trigger filters may still leave checks unavailable. Freeze and verify the published source SHA, then wait/recheck or report promotion pending. No Promote-anyway override is offered, and no required check is replaced by local test success.

Confirm before mutating anything (per safety.md: never push without confirmation):
  AskUserQuestion:
    question: "Promote {current_branch} to {next_environment}? This merges {current_branch} into {next_environment} and pushes the target branch from the verified published source SHA. CI: {passed for exact SHA / not applicable}"
    header:   "Promote"
    multiSelect: false
    options:
      - label: "Promote to {next_environment}"
        description: "Merge {current_branch} into {next_environment} and push"
      - label: "Cancel"
        description: "Exit without promoting"

  If Cancel → exit silently.

  If confirmed:
  - Recheck the verified published source SHA/CI before the target mutation; do not push the already-approved source twice.
  - git checkout {next_environment}
  - git merge {current_branch} --no-ff -m "chore(deploy): promote {current_branch} to {next_environment}"
    - If the merge conflicts: run `git merge --abort` to restore a clean state, then `git checkout {current_branch}` to return to the starting branch. Inform the human: "Merge conflict promoting {current_branch} to {next_environment}. Aborted — {next_environment} is unchanged. Resolve the conflict manually (e.g. merge {current_branch} into {next_environment} in a local checkout, fix conflicts, push), then re-run." Stop here — do not proceed to the push/checkout below.
  - git push origin {next_environment}
  - git checkout {current_branch}
  - Inform human:
    "Promoted {current_branch} → {next_environment}. Report only deployment behavior supported by repository/provider evidence."

If no next environment (already on the last tier):
  Stop and inform human:
  "Already on the last environment in the chain. Nothing to promote further."

---

## Step 6 — Confirm completion

If on {base_branch}:
  Report:
  - Commit:                {commit_sha} "chore(release): bump version to {version}"
  - Version tagged:        v{version}
  - Tag pushed:            yes
  - README updated:        yes/no
  - Environments promoted: {list, or "none" if none selected, or "none — skipped" if skipped for CI reasons}
  - GitHub Release:        {release_url, if created} / skipped with reason / failed with reason / not GitHub
  - GitHub capability/CI:  {available / unavailable with reason; actual CI status if checked}
  - Deployment triggered:  verified triggered / not triggered / unknown (supported by actual deployment configuration/provider evidence, not CI presence alone)

  Required CI overrides are not supported. Report blocked/pending promotion with its exact source SHA and reason; never claim it succeeded.
  If promotion was skipped because CI hadn't passed: add a line — "To promote later: verify required CI for this same published source SHA, then use an approved environment promotion or reviewed manual merge/push — re-running /helm:ship would cut a new version rather than retry this promotion."

If on environment branch, fan-out mode:
  Report:
  - Branch pushed:         {current_branch, or none if cancelled/failed}
  - Deployment triggered:  verified triggered / not triggered / unknown (supported by actual deployment configuration/provider evidence, not CI presence alone)

If on environment branch, chain mode:
  Report:
  - Promoted:              {current_branch} → {next_environment}
  - Source publication:     {pushed this run / already published / pending}
  - Target publication:     {next_environment pushed and verified / not attempted / failed}
  - Deployment triggered:  verified triggered / not triggered / unknown (supported by actual deployment configuration/provider evidence, not CI presence alone)

  If CI blocked promotion, report no target mutation, the exact source SHA and pending reason. Source publication and target publication are reported separately, including whether the source was already published before this run.
