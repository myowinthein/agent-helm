# manifest

## Before starting

Resolve `{memory_file}` through the shared runtime before any Git mutation or file write. If the resolved owner does not exist (including a fresh project with neither AGENTS.md nor CLAUDE.md), stop: "Run the log workflow first to establish shared project instructions, then re-run manifest." Do not create instruction files or automatically invoke log. Existing bridges, overrides, conflicts, and missing import targets still follow the shared runtime's resolution rules.

`/helm:manifest` rewrites README.md from the project's state, so it needs the full merged, stable state — never an in-progress feature branch. Behavior depends on `git-strategy` in {memory_file}'s Project Config (absence defaults to GitHub Flow, per git.md).

Read `{package_root}/prompts/shared/content-sync.md` and apply **Prepare the working branch** with `{branch_template} = docs/manifest-{YYYYMMDD}`. Use the recorded invocation policy, actual `{base_branch}` and unique `{branch}` throughout this run. Scan only after destination ownership/configuration has been revalidated. A no-write exit uses the shared safe empty-branch cleanup; pending drafts or commits retain their branch.

---

## Scope

README.md = human-facing documentation (contributors, GitHub visitors, new users).
Not a changelog. Not a technical spec. Not a deployment manual.
Write for people reading the project, with clear, scannable explanations. Shared agent instructions for Claude and Codex belong in the resolved project-memory owner.
Whenever writing to README.md, in any step: use em-dashes sparingly — only when no other punctuation (comma, semicolon, colon, or a new sentence) works as well. When in doubt, restructure the sentence instead.

---

## Step 1 — Assessment

**Determine readme-style:**

Check {memory_file} Project Config for `readme-style`.

If `readme-style` is absent:
  Check whether README.md exists and has content — the question below depends on it.

  If README.md exists with content:
    AskUserQuestion:
      question: "README.md exists with no known style. Which style should this project use?"
      header:   "README style"
      multiSelect: false
      options:
        - label: "Standard Readme spec"
          description: "Enforce the Standard Readme spec structure when writing or updating."
        - label: "Custom style"
          description: "Follow the existing README structure — never rewrite into the spec."

  If README.md is absent or empty (nothing to be "custom" relative to yet):
    AskUserQuestion:
      question: "No README.md yet. Which style should this project use?"
      header:   "README style"
      multiSelect: false
      options:
        - label: "Standard Readme spec"
          description: "Write README.md following the Standard Readme spec structure."
        - label: "Custom style"
          description: "No existing structure to follow yet — you write README.md yourself in whatever structure you prefer; once it exists, future runs preserve it rather than rewrite it."

  Write the chosen value (`readme-style: standard` or `readme-style: custom`) into {memory_file}'s existing recognized configuration block before continuing, preserving its layout, including a recognized Compass-style fenced block. If the existing owner has no recognized configuration block, this step permits adding a `## Project Config` section containing only the chosen `readme-style` declaration to that same file. Insert it without rewriting existing content or moving an end-of-file review marker away from the end. Do not invent other settings. Never put configuration in a wrapper or create a second owner. In the shared layout, update AGENTS.md and leave CLAUDE.md's import and Claude-specific additions intact; preserve an existing legacy owner until log performs a reviewed migration.

If `readme-style` is already set → use it as-is. Do not ask again.

---

**Assess README.md:**

Check README.md:
- Does it exist?
- Does it have content?
- Is there a saved commit hash? (look for `<!-- last-reviewed: {hash} -->`)
- If hash exists, run `git log {hash}..HEAD --oneline` to see the gap
- How significant is the gap? (ignore: bug fixes, styling, dependency updates, routine CRUD)
- If `readme-style: standard` and the file exists and has content, check whether all mandatory sections are present:
  `Title`, `Short Description`, `Install`, `Usage`, `Contributing`, `License`

  Structure is intact if all mandatory sections are found. Structure is broken if any are missing.

Based on current state, use AskUserQuestion (single-select) to present options:

If README.md is absent or empty:
  AskUserQuestion:
    question: "{one sentence status, e.g. 'README.md not found — a full scan is required.'}"
    header:   "Update mode"
    multiSelect: false
    options:
      - label: "Full scan (Recommended)"
        description: "Write README.md from a complete project scan"
      - label: "Skip"
        description: "No update needed"

If README.md exists but has no saved commit hash:
  AskUserQuestion:
    question: "{one sentence status and recommendation}"
    header:   "Update mode"
    multiSelect: false
    options:
      - label: "Full scan (Recommended)"
        description: "Replace README.md's full contents from a complete project scan — anything existing content held that the scan doesn't recapture will not carry over"
      - label: "Skip"
        description: "No update needed"

If README.md exists with a saved commit hash and (structure is intact or `readme-style: custom`), and there are no meaningful commits since the hash (`git log {hash}..HEAD` is empty, or only noise commits):
  README.md is already current. Inform the user: "README.md is up to date — no meaningful commits since last review." Do not present any prompt. Proceed to Step 4 to account for any earlier approved configuration write; only a genuine no-write/no-commit outcome uses shared safe empty-branch cleanup.

If README.md exists with a saved commit hash, and either structure is broken or there are meaningful commits since the hash:
  Determine recommendation:
  - If `readme-style: standard` and structure is broken (any mandatory section missing): recommend Full scan regardless of gap size — state which sections are missing.
  - Otherwise: recommend Gap update for a small or moderate gap, or Full scan for a large or significant gap.
  List the recommended option first and append "(Recommended)" to it.

  AskUserQuestion:
    question: "{one sentence status and recommendation}"
    header:   "Update mode"
    multiSelect: false
    options:
      - label: "Gap update"
        description: "Edit only sections affected by commits since last review, leaving the rest of the file untouched{ — missing sections will not be added, if structure is broken}"
      - label: "Full scan"
        description: "Replace the entire file's contents from a complete project scan{ to restore missing sections, if structure is broken} — existing content the scan doesn't recapture will not carry over"
      - label: "Skip"
        description: "No update needed"

---

## Step 2 — Full Project Scan

If `readme-style: custom` and README.md is absent or empty: skip investigation entirely — there is nothing to write. Do not write anything — custom mode preserves structure, it does not author it. Report that there is no README.md yet, so there is nothing to be "custom" relative to, and ask the developer to write one in whatever structure they prefer. A future run will then preserve that structure. Skip the rest of Step 2 and Step 3, but proceed to Step 4 to finalize any earlier approved configuration write or use safe genuine-no-op cleanup.

Otherwise, before writing anything, investigate:
- Business purpose and target audience
- Technology stack and major dependencies
- Installation requirements and steps
- Core usage patterns and CLI commands
- Public API surface (if any)
- License, contributing model, maintainers
- Project motivation or history (if non-obvious) and any meaningful limitations worth surfacing

If `readme-style: standard`:
  Write README.md following the Standard Readme spec section order.
  Include only sections relevant to this project — do not force all sections.

  Mandatory sections (always include):
  - Title (must match repo/package name)
  - Short Description (under 120 chars, matches package.json description field)
  - Table of Contents (if README will exceed 100 lines)
  - Install
  - Usage
  - Contributing
  - License (must be last section before the comment tag)

  Include when relevant:
  - Badges (CI, version — keep minimal)
  - Long Description (only if short description is insufficient)
  - Background (useful if the "why" behind the project is non-obvious)
  - API (if the project has a public interface)
  - Limitations (only if the project has meaningful limitations worth surfacing to users evaluating adoption)

  Skip unless specifically needed:
  - Banner, Security, Thanks, Maintainers, Extra Sections

  Sections must appear in the order listed by the spec.
  Do not invent sections outside the spec.

If `readme-style: custom` (README.md already exists with content — the only way to reach this point in custom mode, per the early exit above):
  Read the existing README structure before writing.
  Preserve the existing section order and naming.
  For each existing section, investigate its specific topic — not just the generic checklist above, which is standard-mode-shaped and won't cover a project-specific section (Sponsors, Roadmap, Screenshots, Acknowledgments, etc.). Use the section's current content as a source for what it's about, then rewrite it based on what the investigation finds.
  Do not add, remove, or rename sections without explicit approval — and do not blank out or invent content for a section just because it fell outside the generic checklist; investigate its actual topic instead, per above.

At the end of the file, append:
`<!-- last-reviewed: {current HEAD commit hash} -->`

This is a full replace, not an incremental patch, in both `readme-style` modes: use the Write tool to overwrite the entire file in one operation rather than leaving sections as targeted `Edit` calls would. In `standard` mode, this means regenerating every included section's content from the scan, even sections whose content turns out unchanged — spec sections are generic, so the checklist above is expected to cover all of them. In `custom` mode, structure is preserved per above, and every section's content is still fully regenerated (not carried over verbatim) — but grounded in that section's own investigated topic, not just what the generic checklist happens to surface, so a project-specific section is rewritten with fresh findings rather than silently emptied or fabricated.

Write directly — no approval needed.

---

## Step 3 — Gap Update

Read commit messages first to get the shape of what changed.
Then read file changes only for significant commits — skip: bug fixes,
styling, dependency updates, routine CRUD.

Focus on: new features, API changes, new install steps, changed usage,
changed CLI commands, new env vars, removed functionality.

For each significant change, identify which README section is affected.
Update only those sections. Do not rewrite unaffected sections. Unlike Full scan, this is a targeted patch: use `Edit`, not `Write` — touch only the affected sections and leave everything else exactly as it is.

If no significant changes are found despite the initial gap estimate: report that no update is needed — the equivalent of log.md's Outcome A. Skip the proposal and confirmation below; only the hash advances.

If `readme-style: standard`:
  Sections must remain in spec order after updates.
  If a significant change makes an optional section newly relevant (per Step 2's "include when relevant" list — e.g. a first public API, a newly meaningful limitation), add it in its spec-ordered position. If a change removes what justified an existing optional section (e.g. the public API is removed), remove that section. Do not invent sections outside the spec.
If `readme-style: custom`:
  Preserve existing section order and naming.
  Do not add, remove, or rename sections without explicit approval — matching Step 2.
  If a significant change does not fit any existing section, ask whether to add a new section (and where) or fold it into the closest existing one; do not decide silently.

Update the saved commit hash at the end of the file to current HEAD.

If significant changes were found: propose changes per affected section. Ask for confirmation before writing.

---

## Step 4 — Commit and finalize

Account for README writes **and** any approved `readme-style` write in the resolved owner. If neither changed, use the shared genuine-no-op cleanup. Custom mode with no README may still have a configuration write, which must not be discarded as no change.

Before committing, read back README and any changed owner, verify the approved sections/style and review marker, and preserve all unrelated instructions/settings/adapter content. Stage only the exact approved paths with literal pathspecs; inspect the diff and honor invocation auto-commit for `docs(manifest): update project README` (or configuration-only wording). A declined/failed commit or verification stops with actual drafts/branch retained, without integration, push or cleanup.

After verifying the workflow commit, read `{package_root}/prompts/shared/content-sync.md` and apply **Finalize verified workflow commits** with `{workflow} = manifest`. This supplies confirmed PR publication/review handoff, configured merge strategy, resolved main/master base, exact-SHA CI-gated fan-out and safe cleanup. It does not create or migrate an instruction owner.

---

## Step 5 — Confirm completion

If publication/review/CI remains pending, label that outcome explicitly rather than claiming a completed base merge/push. Distinguish a published review branch from the published base, report the PR/manual handoff, current checkout and retained work, and keep output/assessment completion separate from Git finalization.

Summarize pre-commit/integration verification on the actual workflow branch, not a different checkout after cleanup. For a full scan or gap update, confirm it contains the `<!-- last-reviewed: {hash} --> ` comment with the hash just written, and that the sections claimed as updated actually reflect the intended content. If verification fails for any section, report the error for that section instead of folding it into a clean Outcome below — README.md is what contributors and new users rely on, so a silently incomplete write is worse than a loud one.

Report:

- Outcome: {up to date / full scan written / gap update written / skipped}
- Style: {standard / custom}
- Sections updated: {list, or none}
- Environments promoted: {list or none}
- If GitHub Flow: temporary branch's fate ({PR pending / integrated and deleted / integrated with branch retained / left local / pending drafts}) and which branch you were returned to.
