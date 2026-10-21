# normalize

Normalize non-conventional commit messages on an explicitly approved set of local branches. Preserve every existing tag; exclude remote-tracking refs, stashes, notes, and unrelated backup refs from rewriting.

## Before starting

Read the shared runtime and resolve `{memory_file}` before Git actions. Record the effective `git-strategy` and `git-auto-commit` (absence means off). Both hosts use the same owner and ledger; this command never creates, migrates, or edits settings in AGENTS.md or CLAUDE.md.

History inspection can start from any attached local branch, independently of the commit strategy. Require a repository with HEAD, a clean index/working tree including untracked project files, and no in-progress merge/rebase. Stop on detached HEAD or unavailable Git/filesystem capabilities. Never reset, stash, or commit pending user work to make normalization possible.

Plan ledger placement before rewriting:
- **Solo:** use main/master for a ledger commit. If starting elsewhere, plan to switch there only after rewrite verification.
- **GitHub Flow:** plan a new, uniquely named `chore/normalize-ledger-{date}` branch from main/master after verification. Do not commit the ledger directly on main/master or an environment branch, auto-merge it, or include this new bookkeeping branch in the frozen rewrite set. Leave it for normal PR review.
- Resolve the base branch and read its effective configuration before mutation. If it conflicts with the invocation's settings, or project-specific rules prohibit the planned placement, resolve the plan first; never silently bypass those rules. State the planned ledger destination. Commit approval remains separate from rewrite and push approval.

## Step 1 — Risk warning

Before any writes, ask:

  AskUserQuestion:
    question: "This command rewrites approved local branch history. Changed commits and their descendants get new SHAs, and commit signatures may be lost. Existing tags remain on their original objects; tagged releases retain their old history. Remote-only branches, stashes, notes, and unrelated refs are excluded. Publishing rewritten branches can disrupt other clones. Continue to inspect history?"
    header:   "Risk"
    multiSelect: false
    options:
      - label: "Continue to scan"
        description: "Inspect history and prepare an exact plan without rewriting yet"
      - label: "Cancel"
        description: "Exit without changes"

Cancel leaves instruction files, history, and all ledger paths untouched. Continuing authorizes inspection only.

## Step 2 — Load ledger and scan history

### 2.1 Load and validate the shared ledger

Read `{package_root}/prompts/shared/project-state.md` and apply it to `normalize-log.json`. The canonical path is `.helm/normalize-log.json`; check both `.claude/helm/normalize-log.json` and `.claude/normalize-log.json` too. Validate and compare all existing candidates before using their watermarks. Differing data requires explicit reconciliation, never silent replacement. Load legacy state without writing or removing any candidate during inspection; migration waits for Step 6's eligible authorized write. Malformed or unsupported schemas stop the run with the files preserved. A missing `schema_version` means `1`.

```json
{
  "schema_version": 1,
  "branches": {
    "main": {
      "last_checked_commit": "abc1234",
      "last_checked_date": "2026-08-01"
    }
  }
}
```

With no candidate file, report first run and use an empty `branches` map. `branches` remains keyed by local branch name. A watermark is a fully inspected tip, using the post-rewrite SHA when rewriting occurred, captured before a later ledger commit.

### 2.2 Freeze exact refs and inputs

Enumerate local branch refs using `git for-each-ref --format='%(refname) %(objectname)' refs/heads/`. Freeze these fully qualified `refs/heads/...` names and old tips as `{approved_branch_refs}` for the scan and proposed rewrite. Do not use an unbounded `--all`, wildcard, or fresh branch enumeration during execution. A remote-only branch must be materialized by the developer before a new scan/plan if they want it included.

Snapshot all existing ref names/object IDs, including exact tag object IDs and symbolic refs, plus remote configuration. Record origin's branch tips read-only when publication is possible; retain these expected remote SHAs for push leases. An inaccessible remote prevents publication, not an otherwise authorized local-only review. Do not fetch, prune, delete stashes/backups, or turn remote-tracking refs into local branches as cleanup. Stop if grafts or replace refs would alter the interpreted history unless a separate reviewed plan resolves them first.

Check the selected rewrite backend and Python availability before proposing mutation. Prefer git filter-repo; use the filter-branch fallback only if unavailable and its prerequisites are supported. Inspect encoding declarations in the traversal; if non-UTF-8 messages cannot be preserved correctly by the chosen backend and replacement encoding, stop before rewriting and request a separate supported plan. Before execution recheck refs, configuration, ledger inputs, and working-tree cleanliness against the scan. Changed inputs invalidate the plan and require a fresh scan/approval.

Diff frozen local branches against ledger keys: new branches receive a full scan; removed branches are omitted from the next ledger; carried entries are usable only when the stored commit exists and is an ancestor of that branch's frozen tip. Otherwise re-scan that branch and report why. When combining exclusions, use only watermarks that still validly describe already-reviewed reachable history.

### 2.3 Inspect the bounded history

Use the frozen branch refs as positive revisions and valid watermarks as negative revisions:

```sh
git log --oneline --no-decorate {approved_branch_refs} --not {valid_last_checked_commits}
```

Omit `--not` entirely when there are no valid exclusions. Never substitute `--all`, `--branches`, or `--tags`. A full re-scan is not permission to include extra refs or delete recovery data.

Classify each returned commit as compliant (`type(scope): description`, including valid breaking-change forms) or non-compliant. For non-compliant commits, inspect `git show {sha} --stat --format="%B"` and relevant diffs to infer the message. Record the full original SHA and exact original message. Index replacements by **SHA**, not message text: identical messages can describe different changes, and unrelated messages must pass through unchanged.

Use this inference logic:

**Type inference (from diff):**
- New files added, new functionality → feat
- Existing files changed to fix broken behavior → fix
- Files restructured or renamed with no behavior change → refactor
- Test files added or modified → test
- Documentation files only (.md, comments) → docs
- package.json, composer.json, lock files, dependencies → chore
- CI/CD config files (.github/, .gitlab-ci.yml, etc.) → ci
- Build config (webpack, vite, makefile, etc.) → build
- Whitespace, formatting, style only → style
- Performance optimization with benchmarks → perf

**Scope inference (from diff):**
- Use the primary module, folder, or domain area affected
- If changes span multiple areas, use the dominant one
- If truly cross-cutting, use "project" or "core"
- Keep it lowercase, one word or hyphenated

**Breaking change detection:**
- If the original message contains "breaking", "BREAKING", or "!" → flag as breaking change
- Add `!` to the type and append `BREAKING CHANGE: {description}` footer

Build the plan as `{sha, original_message, proposed_message}` for each non-compliant commit. Show uncertain classifications explicitly and resolve them before applying the plan; do not rewrite uncertain guesses and merely flag them afterward.

## Step 3 — Show plan and confirm

If nothing needs rewriting, report a clean scan and proceed to Step 6 for an eligible ledger update. Skip Steps 4–5 and the rewrite-publication path in Step 7. A clean scan never authorizes force-pushing anything.

Otherwise show the complete plan, with up to five examples in the question and the remaining exact changes available for review. Include frozen branch refs/tips, preserved tags/excluded refs, the chosen backend, recovery-backup location, and planned ledger placement. Then ask:

  AskUserQuestion:
    question: "Scanned {total} commits: {compliant_count} compliant, {non_compliant_count} message replacements proposed. Apply the reviewed plan to {frozen branch list}? All existing tags stay unchanged; remote history will not be pushed without a later separate confirmation."
    header:   "Confirm rewrite"
    multiSelect: false
    options:
      - label: "Apply reviewed rewrite"
        description: "Rewrite only the frozen local branch refs and approved commit messages"
      - label: "Cancel"
        description: "Exit with history and ledger untouched"

Cancel does not advance or migrate the ledger. Approval applies only to the displayed inputs and transformation, not a changed plan or any tag movement.

## Step 4 — Rewrite the approved branch history

Recheck frozen inputs. Create a recoverable Git bundle of the approved branches and existing tag refs in a unique private location outside the checkout before running the filter. Retain it through verification/publication and report its path. If backup creation fails, stop before rewriting. Never prune old objects or delete recovery refs automatically.

Capture the unique commit count and branch-tip trees over `{approved_branch_refs}` only. Create a unique private temp directory outside the checkout. Write the SHA-to-proposed-message JSON map there and export its absolute path as `HELM_NORMALIZE_MAP`; values contain each complete approved message with its intended newline/footer formatting. Never interpolate message data into shell code or trim unchanged messages. Preserve unselected messages byte-for-byte. If a backend cannot preserve the source encoding/metadata needed for this plan, stop instead of claiming equivalent results.

### Preferred: git filter-repo with explicit refs

Pass each frozen fully qualified branch ref as its own safely quoted argument. `--refs` implies partial mode: tags and remote-tracking refs are excluded, origin is retained, and automatic cleanup of unrelated refs/history is disabled. Do not add tags, `--all`, or a ref-renaming callback. Disable automatic message-hash substitution and commit pruning so changes stay within the approved plan:

```sh
git filter-repo --force --preserve-commit-hashes --preserve-commit-encoding \
  --prune-empty never --prune-degenerate never --commit-callback '
import json, os
with open(os.environ["HELM_NORMALIZE_MAP"], encoding="utf-8") as f:
    rewrite_map = json.load(f)
replacement = rewrite_map.get(commit.original_id.decode("ascii"))
if replacement is not None:
    commit.message = replacement.encode("utf-8")
' --refs {approved_branch_refs}
```

`--force` bypasses the fresh-clone check only after the approved plan, clean-tree check, and backup above. It is not permission to expand scope or bypass host restrictions.

### Fallback: git filter-branch with the same explicit refs

Only when filter-repo is unavailable, create an absolute helper path exported as `HELM_NORMALIZE_FILTER`. Its contents are:

```python
import json
import os
import sys

with open(os.environ["HELM_NORMALIZE_MAP"], encoding="utf-8") as stream:
    rewrite_map = json.load(stream)
original = sys.stdin.buffer.read()
replacement = rewrite_map.get(os.environ["GIT_COMMIT"])
sys.stdout.buffer.write(original if replacement is None else replacement.encode("utf-8"))
```

Choose a new, empty backup-ref namespace `{backup_namespace}` for this run, outside all existing refs; include it in the reviewed plan. Then run:

```sh
git filter-branch --original {backup_namespace} \
  --msg-filter 'python3 "$HELM_NORMALIZE_FILTER"' -- {approved_branch_refs}
```

Do not use `--all`, `--tag-name-filter`, or `-f` to overwrite existing backup refs. Preserve fallback-created backup refs; disclose that only this planned backup namespace may be added outside the frozen branch refs. If the fallback refuses the repository or fails, stop without retrying with broader/destructive flags.

### Verify before advancing

A backend error stops the run: no ledger advance or remote publication. Keep recovery data and report the actual state, never a generic success.

After a successful filter, verify the full approved replacement set, unchanged unselected messages, commit count, branch-tip trees, parent topology, and unaffected metadata (disclosing inherent signature effects). Compare all excluded refs and remote configuration against the snapshot; only approved branch updates and the fallback's declared new backup refs may differ. Derive the exact old-to-new mapping and changed branch list from verified results. A changed ref set, unintended message change, or failed invariant stops ledger writes and publication. A sample alone is insufficient verification.

Keep the recovery bundle and maps until verification succeeds; remove only this run's temporary helper/map files afterward. Do not reconstruct or silently restore origin, tags, or other refs if an unexpected change is detected.

## Step 5 — Verify tags are unchanged

Compare every pre-existing `refs/tags/...` name and exact object ID against the snapshot, with no additions, deletions, or replacements. This preserves annotated/signed tag objects as well as lightweight tags. A tag remaining on old history and no longer reachable from a rewritten branch is expected, not a failure to repair. Never move it to the new history, strip its signature, or force-push tags.

Any mismatch stops ledger advance and publication. Report the unexpected change and recovery location; do not try to fix it by replacing a published tag. All existing tags are protected on private and public repositories alike, so publication detection is not required to protect them.

## Step 6 — Update or migrate the ledger under project policy

Only a complete clean scan or fully verified rewrite reaches this step. Cancellation, unresolved classifications, changed scan inputs, or verification failure leaves the prior ledger unchanged and does not delete the legacy file.

For the frozen branch list, capture verified current tip SHAs before any ledger commit. Build schema version 1 with those tips/dates, adding new branches and dropping removed ones. Do not add a newly created bookkeeping branch to this run's watermark set or record a tip that was not inspected. If no checkpoint data change is needed, skip the write/commit entirely; legacy paths alone do not justify a cleanup-only write.

Switch to the planned ledger destination only after verification. Under Solo, commit on main/master. Under GitHub Flow, create the planned unique `chore/normalize-ledger-{date}` branch from main/master and leave its ledger change for normal PR review; never auto-merge it or force-push it as part of rewritten history. Recheck destination instructions and any existing ledger for unexpected divergence from the reviewed inputs before overwriting. If placement is blocked, leave history intact and report the pending ledger update; do not force checkout or bypass project policy.

Write `.helm/normalize-log.json` and read it back to verify schema, every watermark, and branch coverage, following the shared project-state procedure. Re-resolve candidates on the planned destination branch before writing. Retire only queued same-file legacy sources after canonical verification and commit authorization; stage the canonical change and tracked legacy removals together using exact paths. Never stage unrelated files. A declined commit preserves legacy sources and leaves any canonical draft pending; report migration as pending.

Follow the resolved `git-auto-commit` for **this ledger commit**: true permits an automatic commit; false or absent requires explicit commit confirmation, independent of rewrite/push approvals. A declined commit leaves verified files uncommitted, reports the actual branch, and never silently commits during publication. Commit message: `chore(normalize): update ledger after {scan / rewrite}`.

A separately committed Solo ledger change can travel with a later explicitly approved branch publication. GitHub Flow leaves the bookkeeping branch local for a separately approved normal push/PR; it is not part of the force-push set. Return to the starting branch when safe; otherwise preserve files and report where work remains. No-rewrite runs finish with Step 8 after this ledger handling and never reach a force-push gate.

## Step 7 — Publish only verified rewritten branches

Run only after an actual verified rewrite. Compare frozen old tips with post-filter tips to identify exactly which approved branches changed. Freeze these verified results before any ledger commit; an extra ledger commit does not itself count as a history rewrite. No changed branches means skip this step. Missing origin or unavailable remote access leaves local changes/recovery data intact and reports publication as unavailable.

Present only changed branch names, the intended new tip (including an authorized Solo ledger commit when applicable), and recorded expected remote tips. Ask separately:

  AskUserQuestion:
    question: "Publish the verified rewritten branches {changed branch list} to origin? This replaces those branch histories using explicit push leases. All tags and excluded refs remain untouched."
    header:   "Publish rewrite"
    multiSelect: false
    options:
      - label: "Publish listed branches"
        description: "Push only the reviewed branch refspecs with explicit expected remote SHAs"
      - label: "Keep local only"
        description: "Leave the rewrite and backup available without changing the remote"

For each approved changed branch, use a fully qualified refspec and the remote tip recorded before rewriting:

```sh
git push origin --force-with-lease=refs/heads/{branch}:{expected_remote_sha} \
  refs/heads/{branch}:refs/heads/{branch}
```

Use an explicit empty expected SHA only for a branch confirmed absent on the remote and explicitly approved for creation. Before pushing, verify the local ref still equals the intended new tip. If the remote advanced, the lease fails: stop, report any branches already pushed and those remaining, and obtain a new reviewed plan. Never retry with plain `--force`, refresh the lease merely to override others' work, push `--all`/`--mirror`, or push any tag ref. On Keep local only, provide these exact bounded commands and the backup path without executing them. Avoid coercive claims that immediate publication is safer.

Normal local remote-tracking updates caused by an approved Git push are publication results, not authorization to rewrite excluded refs. Distinguish those expected tracking updates from Step 4's invariant that excluded refs stayed unchanged during filtering.

## Step 8 — Report actual state

Report:
- Outcome: {clean scan / rewritten locally / published / partial publication / cancelled / blocked / verification failed}
- Commits scanned, compliant, and actually rewritten, with uncertain items if blocked
- Frozen branch scope and branches actually changed/pushed; excluded refs and tags verified unchanged
- Ledger: {canonical / migrated / pending migration / unchanged}, branch counts, watermark validation, destination branch, committed/uncommitted status
- Publication: {not applicable without rewrite / confirmed and completed / kept local / unavailable / failed}, by branch
- Recovery bundle and retained fallback backup refs; any pending PR/normal ledger-branch push
- Current branch and any unresolved manual work

Show up to five actual before/after message examples. Do not report planned rewrites or pushes as completed. Instruction files and Helm settings remain untouched.

After a published rewrite, explain that other clones need deliberate reconciliation with the new branch history. Tell developers to preserve local work and coordinate with collaborators first; do not prescribe an unconditional `reset --hard` or delete/recreate branches as a generic recovery command. Unchanged release tags intentionally retain the original history. An unpublished local rewrite has its recovery bundle and has not altered other clones.
