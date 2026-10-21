# Step 4 — Documentation

Create project documentation for long-term archive recovery and future demonstration.

Read the prior step reports from `.archive/` — `step1-explore.md`, `step2-restore-and-freeze.md`, and `step3-postman.md` — and use them as context. If a required report is missing, stop and report that the prior step must complete first.

Goal: Make future me able to understand, restore, run, troubleshoot, and demonstrate this project years later.

---

## Rules

- Read all existing documentation before making any changes.
- Preserve useful historical information. Clearly distinguish it from verified current information.
- Only document verified information. Label anything unverified explicitly.
- Do not invent setup procedures, demo workflows, runtime requirements, or API behavior.
- Do not include secrets, credentials, API keys, or private/production URLs.
- Keep the generated archive index concise — link to docs/ rather than repeating content; protected README content remains unchanged.
- Use em-dashes sparingly — only when no other punctuation (comma, semicolon, colon, or a new sentence) works as well. When in doubt, restructure the sentence instead.
- Do not commit or push.

---

## Consolidation

Before classifying documentation, apply the orchestrator's preservation rules. Root/nested AGENTS.md, overrides, CLAUDE.md, project-local instruction entries, their project imports, and adopted rules stay at their original paths and contents, even if they resemble contributor guides, historical notes, or orphaned Markdown. Do not rewrite Helm settings, move knowledge owners, break imports, or generate another owner. External/global imports remain documented dependencies, not copied inputs. Preserve `.helm/`, `.claude/helm/`, and known flat legacy state opaquely; never classify them as assets or cleanup targets. A generic consolidation approval does not authorize changing these protected files.

For every remaining documentation file, decide: Keep, Update, Merge, Archive, or Remove. Provide a reason for each.

Use this to guide the decision:

| Existing doc type | Action |
| --- | --- |
| Accurate, has recovery or demonstration value | Keep — link from README |
| Accurate but duplicates docs/setup.md content | Merge into docs/setup.md, remove original |
| Outdated instructions that affect restoration | Update |
| Historical context, domain knowledge, business background | Archive — move to docs/historical-notes.md |
| Contributor guides, pull request templates, code of conduct | Remove — irrelevant for private archive |
| Changelogs and release notes | Archive — move to docs/historical-notes.md if they provide context; otherwise remove |
| CI/CD documentation, deployment runbooks | Remove — no recovery value |
| Auto-generated documentation | Remove — regenerate if needed |
| Outdated and no recovery or historical value | Remove |

Consolidate documentation duplicates without altering instruction ownership. Every active recovery document must be reachable through the approved archive index (normally README.md) or another recovery document. Protected instructions/rules and operational state are exempt from this navigation requirement; do not remove or move them to satisfy it.

---

## Required Files

### README.md
Normally write a fresh archive-focused README, but first check the protected-import inventory. If AGENTS.md, CLAUDE.md or another active project instruction imports/reads README.md as instructions, it is protected content: do not rewrite, extract/move content from, or silently repoint that import.

Show this conflict in the consolidation plan before any documentation write and offer `Keep protected README and create an archive index` or `Stop for instruction reconciliation`. The first choice requires a reviewed unused path such as `docs/archive-index.md`; do not overwrite an existing file there without its own reviewed plan. Preserve README and all instruction imports byte-for-byte, write the archive-focused index at the chosen path, and record that entry point in the report, inventory and archive metadata so later steps verify the correct navigation. The second choice leaves the conflicting files unchanged and pauses this step until the developer reconciles instructions outside archive. A generic consolidation approval never authorizes changing a protected import. Apply the same check to any other required output that is a protected instruction import.

Only when README is not protected do the normal rewrite/extraction instructions below apply. For the alternate-index path, use the same index content and links without modifying/extracting the protected README.

Before writing: read the existing README if present. Extract any historically valuable content — business context, domain knowledge, why the project was built — and move it to `docs/historical-notes.md`. Do not carry outdated instructions, contributor guides, or public-facing content into the new README.

Write a clean README containing: project name, one-paragraph purpose, tech stack summary, restoration complexity rating from Step 1, and links to `docs/setup.md` and `docs/archive-metadata.md`. Keep it short — this is an index for future-you, not a public-facing document.

### docs/setup.md

The single reference for everything needed to restore, run, and demonstrate this project. Write the following sections, skipping any that are not applicable to this project type:

**Environment**
Original runtime requirements. Verified restoration environment from Step 2 — note differences from original if any. Environment variables required.

**Restore & Run**
Step-by-step procedure to restore the project locally. Use exact commands from Step 2, including the data-restore step so recovery does not come up empty:
```
docker load < recovery/docker/{service}.tar.gz
# restore data — auto-init from the committed dump, or restore the data-volume tarball first (per Step 2 Data Persistence)
docker-compose up
```
Access points — URLs and ports for web projects, run commands for CLI tools, build steps for mobile or desktop.

**Recovery Priority**
Classify each dependency:
- Required (Docker tarballs, database dump, environment variables)
- Optional (email service, third-party integrations)
- Not required (production services, analytics)

**Demo** *(skip for CLI tools, libraries, and projects with no interactive surface)*
Demo accounts from Step 2. Happy path walkthrough. Key screens or features. Link to Postman collection at `recovery/postman/` if Step 3 generated one.

**API** *(include only if Step 3 generated a Postman collection)*
Authentication method. Collection location: `recovery/postman/{project-name}.postman_collection.json`. How to import and use.

**Restoration Fixes**
Every fix applied in Step 2: what was changed, why it was necessary, and whether it may need revisiting on future recovery.

**Known Limitations**
Anything that could not be restored, features that require unavailable services, or constraints the developer should know before demonstrating.

### docs/archive-metadata.md
Structured snapshot for quick inventory across archived projects:
- Repository name and archive date
- Project purpose (one line)
- Technology stack
- Restoration outcome from Step 2
- Runtime versions used
- Database source used
- Docker images exported and tarball paths
- Postman collection generated: yes / no
- Recovery complexity rating from Step 1
- Known limitations (brief)

---

## Optional File

**docs/historical-notes.md** — create only if significant historical documentation was found that has archival value but would clutter current docs. Clearly label all content as historical.

---

## Tasks

1. Validate the approved archive context/output inventory, identify protected files, and read existing recovery documentation
2. Decide action for each file using the Consolidation table above
3. Present the consolidation plan and wait for approval before making any changes
4. Extract historically valuable content into docs/historical-notes.md
5. Write the approved archive index (fresh README.md only when unprotected; otherwise the separately approved alternate path)
6. Write or update docs/setup.md
7. Write docs/archive-metadata.md
8. Verify every active recovery document is reachable from the approved archive index (protected instructions/rules/state are exempt): read the approved index, list every link found, confirm each linked file exists, and report any active recovery document that is not reachable via a link

---

Output the report in this format:

## Consolidation Summary
List protected instruction/state preservation separately. For every remaining documentation file reviewed: action taken (Keep / Update / Merge / Archive / Remove) and reason.

## Files Created
New files written and what each covers.

## Files Updated
Existing files updated and what changed.

## Files Removed
Files removed and why.

## Navigation
Confirm every active recovery document is reachable from the approved archive index; report protected instruction/rule/state files retained in place without imposing recovery navigation on them.

## Gaps
Anything that could not be documented due to missing or unverified information from previous steps.

---

Do not commit or push. Output the report and stop. Wait for explicit approval before proceeding to Step 5 — Step 5 is destructive (rewrites remotes, deletes branches, pushes).
