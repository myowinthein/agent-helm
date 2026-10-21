# legal

Scan the project and generate legal documents based on what the
project actually does. Only generate documents that apply.

## Before starting

`/helm:legal` generates canonical, public-facing legal documents from the project's data profile, so it needs the full merged state and a clean landing path to the resolved base branch. Behavior depends on `git-strategy` in {memory_file}'s Project Config (absence defaults to GitHub Flow, per git.md).

Read `{package_root}/prompts/shared/content-sync.md` and apply **Prepare the working branch** with `{branch_template} = docs/legal-{YYYYMMDD}`. Use the recorded invocation policy, actual `{base_branch}` and unique `{branch}` throughout this run. Scan only after destination ownership/configuration has been revalidated. A no-write exit uses the shared safe empty-branch cleanup; pending drafts or commits retain their branch.

## Step 1 — Project scan

Scan the codebase to understand the project's legal profile:

**App type**
- Chrome extension, web app, mobile app, desktop app, open source library
- Infer from manifest.json, package.json, composer.json, folder structure

**Data collection**
- Forms, auth systems, user accounts
- Analytics tools (Google Analytics, Mixpanel, Hotjar, GTM)
- Error tracking (Sentry, Bugsnag)
- Any personally identifiable information (PII) collected or stored

**Sensitive data (GDPR Art. 9 special category)**
- Health, medical, or fitness data; biometric or genetic data
- Race or ethnicity, religion, political views, trade-union membership, sexual orientation
- Detect from data fields, model schemas, or integrations that handle such data
- If any is present, the privacy policy must call it out — special-category data needs explicit consent and a stricter legal basis

**Children and minors**
- Is the service directed at, or knowingly accessible to, children?
- Age gates, minimum-age checks (13+ / 16+), parental-consent flows, kid-directed content or framing
- Drives the Children's Privacy section (GDPR Art. 8, and COPPA where US minors are involved)

**Third party integrations**
- Payment processors (Stripe, PayPal, Paddle)
- Social auth (Google, GitHub, Facebook OAuth)
- Cloud services (AWS, GCP, Firebase)
- Marketing or tracking tools

**Email and marketing communications**
- Email service providers (Mailchimp, SendGrid, Postmark, Klaviyo, Resend, and similar)
- Newsletter or marketing-list signup forms
- Distinguish transactional email (account/receipts) from marketing email — marketing requires consent under GDPR and the ePrivacy rules, and belongs in the privacy policy

**Monetization**
- Payment processing, subscription logic, pricing pages
- Free vs paid tiers

**Content model**
- Does the app let users generate or upload content?
- Does the app provide advice (financial, health, legal, AI-generated)?

**AI features**
- Does the app use AI to generate recommendations presented as facts?
- Does it use a BYOK model (user provides their own API key)?

**No legal need detected**

If every category above came back empty — no data collection, no sensitive data, not directed at children, no third-party integrations, no email/marketing, no monetization, no user-generated or advice content, no AI features — none of the usual signals that make privacy/terms documents necessary were found. Stop here, before resolving an output location or a contact point (both are pointless if nothing gets generated):

  AskUserQuestion:
    question: "Scan found no data collection, sensitive data, third-party integrations, monetization, user-generated/advice content, or AI features — none of the signals that typically make privacy or terms documents necessary. This project may not need legal documents."
    header:   "No legal need"
    multiSelect: false
    options:
      - label: "Exit — no documents needed (Recommended)"
        description: "Skip document generation entirely; nothing is written"
      - label: "Proceed anyway"
        description: "Continue the scan and pick documents manually — use this if the scan missed something"

  If "Exit" selected → treat exactly as Step 2's "nothing selected" outcome: proceed straight to Step 4, which writes nothing but still needs to run its GitHub Flow cleanup (delete `{branch}`, return to `{original_branch}`) if a temporary branch was created. Report per Step 5 with `Generated: none — scan found no legal need` instead of a document list.

  If "Proceed anyway" selected → continue to Framework and output detection below, same as if this check had never triggered.

**Framework and output detection**

Scan the project to determine which scenario applies. Use config files, package
manifests, folder structure, and any other available signals to decide:

  If the scan finds multiple independent web packages or apps (e.g. a workspace layout with several `package.json` files each defining their own framework, under `apps/`, `packages/`, or similar): ask which one the legal documents belong to, since a monorepo usually has one public-facing surface — then apply the scenarios below scoped to that package only.

  For 2–4 detected packages, use the single-select question below. For more than 4, do not build an oversized picker or truncate the package list: present every package in a numbered list in ordinary conversation, including its framework and project-relative path, then ask the developer to reply with one number or exact package path. Wait for a reply and resolve it to exactly one detected package before proceeding; re-ask for an ambiguous or unknown selection. This same fallback applies on both hosts.

    AskUserQuestion:
      question: "Multiple web packages found: {list}. Which one should receive the legal documents?"
      header:   "Monorepo target"
      multiSelect: false
      options: one entry per detected package (2–4 total), e.g.:
        - label: "{package name}"
          description: "{detected framework and path, e.g. \"Next.js app in apps/web\"}"

  Static site generator (Jekyll, Hugo, Eleventy, and similar):
  - Format: `.md`
  - Output path: the generator's content or docs directory, under a `legal/` subfolder
  - Detect the correct content directory from the generator's config

  JS framework with SSR or SSG (Next.js, Astro, Nuxt, SvelteKit, and similar):
  - Format: `.mdx`
  - Output path: the framework's pages or content directory, under a `legal/` subfolder
  - Detect the correct pages directory from the framework's config and folder structure

  SPA or plain HTML site (no server-side rendering, no static site generator):
  - Format: `.html` with subfolder structure (`legal/privacy-policy/index.html`, etc.)
  - Output path: the directory that is served as the web root (e.g. `public/`, `dist/`, or root)

  No web project detected (pure library, CLI tool, or non-web repo):
  AskUserQuestion:
    question: "No web framework detected. Where should legal documents be written, and in what format?"
    header:   "Output"
    multiSelect: false
    options:
      - label: "legal/ as Markdown (Recommended)"
        description: "Standard location for repos without a web front end"
      - label: "legal/ as HTML"
        description: "Bare semantic HTML — suitable for plain HTML sites"
      - label: "Custom path"
        description: "Specify a path and format manually"

  This question is itself the output-location choice for non-web repos — skip the "Confirm output location" step below when it was asked.

**CSS style detection (HTML output only)**

When the resolved format is `.html`, scan the project to determine whether styles
are applied globally or scoped:

  Global CSS (element and class selectors that apply site-wide):
  → Output bare semantic HTML. The site's stylesheet handles rendering.

  Scoped or utility-first CSS (styles tied to components or utility classes,
  where unstyled semantic HTML receives no visual treatment):
  → Find the prose or layout container used by existing pages and wrap the
  generated semantic HTML in the same element and classes inside `<body>`.

  Cannot determine:
  → Wrap the generated semantic HTML in `<main>` as a safe default.

Record the resolved format and output path before proceeding.

**Confirm output location**

Run this only for the auto-detected scenarios (SSG, JS framework, SPA/plain HTML), where the path and format were resolved without asking. Skip it for the no-web case — the "No web project detected" question already served as the location choice.

After resolving the format and path, confirm with the user before continuing:

  AskUserQuestion:
    question: "Legal docs will be written to {resolved-path} as {Format} files. Confirm or choose a different location."
    header:   "Output location"
    multiSelect: false
    options:
      - label: "Use {resolved-path} (Recommended)"
        description: "{Format} — detected from {framework/scenario name}"
      - label: "Custom path"
        description: "Specify a different output path and format"

  If Custom path selected → ask the user to type the path and preferred format before proceeding.
  If confirmed → proceed with the resolved path and format.

**Contact point**

Legal documents must give users a real way to reach the owner (mandatory under GDPR Art. 13). Resolve it now — do not generate anything until a valid contact point is confirmed. Never fall back to a bare placeholder.

Infer candidates from the project:
- Existing contact page — a contact / contact-us page in the project (e.g. `contact.html`, `contact.md`, a `/contact` route, `pages/contact.*`, `src/pages/contact.*`). Use its site URL or path.
- Repo issues URL — from the git remote, `package.json`, or `composer.json`.
- Support/contact email — from `package.json` (`bugs.email`, `author.email`), `composer.json` (`authors.email`), or a `SECURITY.md` / `CONTACT` file.

Deduplicate candidates by contact value, then choose the question shape by the number found:

- **No candidates:** do not show a picker. Ask in ordinary conversation: "No contact point was found. Enter the email address, URL, or postal address to use in these documents." Wait for the actual contact before continuing; do not invent a candidate or treat an unanswered question as a contact.
- **One candidate:** use the question below with that candidate and an "Enter a contact manually" option, making exactly two options.
- **Two to four candidates:** use the question below with one option per candidate, in the order above, making two to four options.
- **More than four candidates:** list every candidate in a numbered list in ordinary conversation and ask for one number or a manually entered contact. Do not truncate the list. Wait for a reply and resolve it to one contact; re-ask for ambiguous or unknown selections.

Use this picker only in the one-to-four-candidate cases above:

  AskUserQuestion:
    question: "How should users contact the owner in the legal documents? Required — a legal document needs a real contact."
    header:   "Contact point"
    multiSelect: false
    options:
      - label: "Contact page"                ← include only if a contact page was found; show its URL/path in the description
        description: "Point users to {contact page URL}"
      - label: "Open a repo issue"           ← include only if an issues URL was found; show the URL in the description
        description: "Users open an issue at {issues URL}"
      - label: "Email"                        ← include only if an email was found; show it in the description
        description: "Users email {email}"
      - label: "Enter a contact manually"      ← include only when exactly one candidate was found
        description: "Type a different email address, URL, or postal address"

Use distinct labels/descriptions when multiple candidates have the same type. The built-in Other response, or the shared runtime's free-text equivalent, also lets the developer type a contact. If "Enter a contact manually" is selected, ask for the actual value and wait; the option label itself is not a contact. On every path, whatever is chosen or typed must be a valid contact — an email address, a URL, or a postal address. If the response is empty or not a recognisable contact, re-ask; do not proceed without one.

Record the resolved contact and its type (email / issue URL / page / postal) for the Contact section in Step 3.

**Existing legal documents**
- Check whether the resolved output path exists.
- List which documents are already present using the resolved file extension.
- Read `{package_root}/prompts/shared/project-state.md` and apply it to `legal-manifest.json`. Resolve `.helm/legal-manifest.json` and both legacy paths, `.claude/helm/legal-manifest.json` and `.claude/legal-manifest.json`. Validate and compare every existing candidate before classifying documents; resolve differing manifests explicitly. Load without moving files during scanning. The resolved manifest records which documents a previous run generated and the commit each was generated at. Classify each present document:
  - **Helm-generated** — its path is listed in the manifest. Regeneration still follows this workflow's document review/commit gates; it is always a full replacement, never an in-place edit. Before checking staleness, treat `generated_at_commit` as untrusted data: accept only a hexadecimal commit ID (a uniquely resolvable abbreviation or full ID), never an arbitrary revision expression, option or shell fragment. Resolve it to an existing commit object and successfully verify it is an ancestor of the pinned current project HEAD. Run the validated commit range through safe structured arguments/quoting and check command success. Inspect the relevant changes for legal-profile effects (analytics, processors, auth, integrations, data collection, manifests/config/code).
    - Meaningful profile changes: **may be outdated**.
    - Only a valid, successfully inspected range with no relevant changes: **up to date**.
    - Missing/malformed/unavailable/non-ancestor ID, unavailable history, failed Git command, or incomplete inspection: **unknown / may be outdated**, with a non-secret reason. Never turn an error or missing output into up to date or allow the all-up-to-date no-op exit. Keep it in Step 2's regeneration/review candidates; no automatic regeneration is authorized by uncertainty.
    Missing/unusable historical IDs affect staleness, not ownership of an otherwise recognizable generated-document record; malformed JSON, unsupported schemas or invalid manifest structure still follow the shared state stop rules. Recheck HEAD and manifest inputs before using the result. A changed snapshot requires renewed assessment. Do not rewrite stored IDs or migrate a manifest just to repair read-only classification; only normal approved regeneration records a new inspected baseline.
  - **Foreign** — present on disk but not in the manifest. Likely hand-written or lawyer-reviewed; must not be overwritten without explicit confirmation.
- The published legal documents carry no marker of their own — this manifest is the only record of what helm generated, so end-user-facing files stay clean.

Record all findings, including each document's classification and staleness, before proceeding.

---

## Step 2 — Determine which documents to generate

First determine the candidate set: privacy-policy.md and terms.md are always candidates once this step is reached (Step 1's "No legal need detected" check already exited before here if neither applied); cookie-policy.md, refund-policy.md, eula.md, and disclaimer.md are candidates only if applicable per the scan findings below.

**Applicability** (does this document apply at all, regardless of whether it already exists):
- privacy-policy.md — always applies
- terms.md — always applies
- cookie-policy.md — applies if non-essential cookies or analytics detected
- refund-policy.md — applies if payment processing detected
- eula.md — applies if Chrome extension, desktop app, or downloadable software detected
- disclaimer.md — applies if financial, health, legal advice or AI recommendations detected

**Recommended** (whether to nudge the user toward selecting it) is not the same as applicable — an applicable document that's already generated and current doesn't need touching:
- Doesn't exist yet, and applies → Recommended (needs generating for the first time).
- Exists, Helm-generated, and flagged **may be outdated** or **unknown** in Step 1 → Recommended for review/regeneration, with the uncertainty/reason disclosed; selection is still required.
- Exists, Helm-generated, and **up to date** → not Recommended, regardless of applicability — nothing changed since it was last generated.
- Exists, Foreign → not Recommended either way; the user opts in explicitly if they want it replaced (see Step 3's overwrite confirmation).

**All candidates up to date — skip this step entirely:** if every candidate document exists, is Helm-generated, and was classified up to date in Step 1 (none missing, none Foreign, none stale or unknown), there's nothing to regenerate. Inform the user: "Legal documents are up to date — no meaningful changes since last generation." Do not present either AskUserQuestion below. Proceed to Step 4, which writes nothing but still needs to run its GitHub Flow cleanup (delete `{branch}`, return to `{original_branch}`) if a temporary branch was created.

Otherwise, present the two questions below.

AskUserQuestion supports a maximum of 4 options. Split into two questions.

Labeling applies to both questions below:
- Append `(Recommended)` per the Recommended rule above (not the Applicability rule alone — an applicable-but-current document is not Recommended).
- For an existing document, append its classification suffix from Step 1: `(exists — up to date)` for a current Helm-generated file, `(exists — may be outdated)` for a stale Helm-generated file, `(exists — history unknown: {reason})` for an uncertain one, or `(exists — not helm-generated)` for a Foreign file. This lets the user tell an auto-generated file from a hand-edited one, and a current file from a stale one.

Question 1 — core documents:
  AskUserQuestion:
    question: "Which core legal documents should be generated? (Jurisdiction: GDPR · Tone: plain English)"
    header:   "Core documents"
    multiSelect: true
    options:
      - label: "privacy-policy.md"                  ← append "(Recommended)" per the Recommended rule above; append the existing-document suffix if present
        description: "Explains what data is collected and how it is handled"
      - label: "terms.md"                            ← append "(Recommended)" per the Recommended rule above; append the existing-document suffix if present
        description: "Acceptable use, IP ownership, liability, governing law"
      - label: "eula.md"                             ← same treatment, gated on downloadable-software applicability
        description: "License grant, restrictions, and liability for installable software"
      - label: "disclaimer.md"                       ← same treatment, gated on AI-content/advice applicability
        description: "No-professional-advice notice and AI-generated content warning"

Question 2 — conditional documents (only ask if applicable based on scan findings):

  If both cookie-policy.md and refund-policy.md apply:
    AskUserQuestion:
      question: "Any additional legal documents needed?"
      header:   "Additional documents"
      multiSelect: true
      options:
        - label: "cookie-policy.md"                   ← same treatment, gated on analytics applicability
          description: "Required if non-essential cookies or analytics tools are present"
        - label: "refund-policy.md"                   ← same treatment, gated on payments applicability
          description: "Required if payment processing is present"

  If only one of the two applies, a multi-select with a single option isn't valid — AskUserQuestion requires at least 2. Ask directly instead:
    AskUserQuestion:
      question: "{document} appears to be needed based on the scan. Generate it?"
      header:   "Additional document"
      multiSelect: false
      options:
        - label: "Yes (Recommended)"                  ← same treatment, applying the existing-document suffix if present
          description: "{same description as the applicable document above}"
        - label: "Skip"
          description: "Don't generate {document} this run"

    "Yes" is equivalent to selecting that document in the multi-select above — proceed the same way.

  Skip Question 2 entirely if neither cookie-policy nor refund-policy is applicable
  based on scan findings (no analytics, no payments detected).

Generate only the documents selected across both questions.
If nothing is selected, exit without generating anything — proceed to Step 4, which writes nothing but still needs to run its GitHub Flow cleanup (delete `{branch}`, return to `{original_branch}`) if a temporary branch was created.
Selected Helm-generated documents that already exist are overwritten. Selected Foreign documents are confirmed individually before overwriting (see Step 3).

Wait for both responses before proceeding.

---

## Step 3 — Generate documents

Generate each selected document in plain English, GDPR compliant.
Use em-dashes sparingly — only when no other punctuation (comma, semicolon, colon, or a new sentence) works as well. When in doubt, restructure the sentence instead.
Write to the resolved output path using the resolved format. When a document already exists, this is a full replace, not an incremental patch: use the Write tool to overwrite the entire file in one operation with the freshly generated content — never targeted `Edit` calls that leave old wording in place alongside new. This matches Step 1's "Do not edit it in place — regeneration is always a full rewrite."

**Before writing a document that already exists:**
- If it is **Helm-generated** (in the manifest) → overwrite silently.
- If it is **Foreign** (not in the manifest) → confirm first, since it may be hand-written or lawyer-reviewed:

  AskUserQuestion:
    question: "{file} already exists and was not generated by helm — it may be customized or lawyer-reviewed. Overwrite it?"
    header:   "Overwrite existing"
    multiSelect: false
    options:
      - label: "Overwrite"
        description: "Replace it with the freshly generated document"
      - label: "Skip"
        description: "Leave the existing file untouched"

  If Skip → do not write that document; note it in the completion report.

Do not write any marker into the documents themselves — they are published to end users and must stay clean.

Before updating or migrating the manifest, read back the generated documents using Step 5's completeness checks. A missing or incomplete document stops the manifest write and legacy cleanup; preserve the prior manifest candidates and report the incomplete output.

**After generating at least one document**, write/update `.helm/legal-manifest.json` using the shared project-state procedure so future runs can recognize generated documents and detect staleness. Verify the canonical result now, but preserve legacy sources until Step 4's explicit commit approval; retire only verified same-file legacy sources in that same commit. If no document was actually written (including every foreign document being skipped), do not write or migrate a manifest. Record each document actually written, with its path, the current date, and the current HEAD commit:

```
{
  "schema_version": 1,
  "documents": [
    { "file": "legal/privacy-policy.md", "generated_at": "YYYY-MM-DD", "generated_at_commit": "abc1234" }
  ]
}
```

`schema_version` — bumped only if this manifest's structure changes in a future release. Lets a future version of this command detect an older-shaped file and handle it explicitly instead of misreading it. Treat a missing `schema_version` as `1` (every manifest written before this field existed). Always write it going forward.

Keep entries for documents that still exist; add or refresh entries for the ones written this run (the refreshed `generated_at_commit` resets their staleness baseline).

**Format rules**

For Markdown (`.md`) in an SSG content directory:
- Use standard markdown headings (`#`, `##`)
- No YAML frontmatter
- No HTML wrapper — the site's template handles rendering

For MDX (`.mdx`) in a JS framework's pages directory:
- Use standard markdown headings (`#`, `##`)
- No HTML wrapper — the framework's layout handles rendering

For HTML (`.html`):
- Write each document to its own subfolder as `index.html` for clean URLs:
  `{output-path}/privacy-policy/index.html`, `{output-path}/terms/index.html`, etc.
- Write a complete standalone page: `<!DOCTYPE html>`, `<html>`, `<head>`, `<body>`
- Use semantic HTML elements: `<h1>`, `<h2>`, `<p>`, `<ul>`, `<li>`
- No inline styles, no `<style>` blocks, no JavaScript — the site's stylesheet handles rendering
- Include `<meta charset="UTF-8">` and `<meta name="viewport" content="width=device-width, initial-scale=1.0">`
- Set `<title>` to the document title (e.g. "Privacy Policy")

**Last updated (all documents):** Begin every document with a `**Last updated:** {current date}` line directly below the title, before the first section. Use the current date in `YYYY-MM-DD` format (e.g. `2026-07-07`).

**Contact section (all documents):** End every document with a `## Contact` section, using the contact point resolved in Step 1 and wording that matches its type:

  Email → "For questions about this {Document Title}, contact us at {email}."
  Contact page → "For questions about this {Document Title}, visit our contact page at {url}."
  Repo issue URL → "For questions about this {Document Title}, open an issue at {issues URL}."
  Other URL → "For questions about this {Document Title}, reach us at {url}."
  Postal address → "For questions about this {Document Title}, write to us at {address}."

  Never emit a placeholder here — Step 1 has already guaranteed a valid contact.

---

### privacy-policy.md

Title: `# Privacy Policy`

Required sections in order:

1. `## Who We Are` — one paragraph identifying the project, its purpose, and its owner
2. `## What Data We Collect` — list every category of data collected; if none, state that explicitly
3. `## How We Use Your Data` — for each purpose, state the GDPR legal basis (Art. 6); mandatory
4. `## Data Sharing and Third Parties` — name every third party that receives data; if none, state that
5. `## International Data Transfers` — state whether data leaves the EEA and under what safeguards; omit only if no data is collected at all
6. `## Data Retention` — how long each category of data is kept and why
7. `## Your Rights` — cover all GDPR Art. 15–21 rights: access, rectification, erasure, restriction, portability, objection; mandatory
8. `## Cookies` — include if cookies are used; omit if not applicable
9. `## Children's Privacy` — state whether the service is directed at children and any age restrictions
10. `## Supervisory Authority` — inform users of their right to lodge a complaint with a data protection authority (GDPR Art. 77); mandatory
11. `## Changes to This Policy` — how and when users are notified of updates
12. `## Contact` — standard contact wording

---

### terms.md

Title: `# Terms of Service`

Required sections in order:

1. `## Acceptance of Terms` — by using the service, users accept these terms
2. `## Description of Service` — what the service is and what it does
3. `## User Accounts and Eligibility` — age requirements, account responsibilities; omit if no accounts
4. `## Acceptable Use` — what users may do
5. `## Prohibited Conduct` — what users may not do; be specific
6. `## Intellectual Property` — who owns the software; who owns user-generated content if any
7. `## Disclaimer of Warranties` — service provided as-is; no guarantees
8. `## Limitation of Liability` — cap on damages; exclude consequential damages
9. `## Indemnification` — user agrees to hold the owner harmless for their misuse
10. `## Termination` — conditions under which access can be revoked
11. `## Governing Law and Dispute Resolution` — jurisdiction and how disputes are handled
12. `## Changes to These Terms` — how users are notified of updates
13. `## Contact` — standard contact wording

---

### cookie-policy.md

Title: `# Cookie Policy`

Required sections in order:

1. `## What Are Cookies` — brief plain-English explanation
2. `## How We Use Cookies` — overview of cookie usage on this site/app
3. `## Categories of Cookies` — list each category with its legal basis under GDPR/ePrivacy:
   - Necessary (no consent required)
   - Functional (consent required)
   - Analytics (consent required)
   - Marketing (consent required)
   Only include categories that actually apply; omit the rest.
4. `## Third-Party Cookies` — name each third party that sets cookies; link to their policies
5. `## Your Consent and How to Withdraw It` — how consent was obtained and how to withdraw it; withdrawal must be as easy as giving consent; mandatory under ePrivacy Directive
6. `## Managing Cookies in Your Browser` — link or instructions for browser cookie controls
7. `## Contact` — standard contact wording

---

### refund-policy.md

Title: `# Refund Policy`

Required sections in order:

1. `## Overview` — what this policy covers and which products or plans it applies to
2. `## Eligibility for Refunds` — conditions that must be met to qualify
3. `## Refund Window` — how many days after purchase a refund can be requested
4. `## How to Request a Refund` — step-by-step process
5. `## How Refunds Are Issued` — method (original payment method, credit, etc.) and timeline
6. `## Non-Refundable Items` — what is explicitly excluded
7. `## Contact` — standard contact wording

---

### eula.md

Title: `# End User License Agreement`

Required sections in order:

1. `## Grant of License` — what rights the user is granted (scope, number of devices, personal vs commercial)
2. `## License Restrictions` — what the user may not do (reverse engineer, redistribute, sublicense, etc.)
3. `## Intellectual Property Ownership` — all IP belongs to the owner; no transfer of ownership
4. `## Updates and Modifications` — owner may update the software; user's continued use implies acceptance
5. `## No Warranty` — software provided as-is; all implied warranties disclaimed
6. `## Limitation of Liability` — cap on damages; exclude consequential and indirect damages
7. `## Termination` — conditions for termination; what happens on termination (cease use, delete copies)
8. `## Governing Law` — jurisdiction
9. `## Contact` — standard contact wording

---

### disclaimer.md

Title: `# Disclaimer`

Required sections in order:

1. `## No Professional Advice` — nothing in the output constitutes legal, financial, or medical advice; name all three categories explicitly
2. `## AI-Generated Content` — output is produced by an AI model; AI can make mistakes, omit details, or misread context; always review before use
3. `## Accuracy and Completeness` — information may be incomplete, outdated, or incorrect; no guarantee of accuracy
4. `## External Links` — if the project links to third-party sites, disclaim responsibility for their content; omit if not applicable
5. `## Limitation of Liability` — owner is not liable for decisions made based on the output
6. `## Changes to This Disclaimer` — owner may update this disclaimer; continued use implies acceptance
7. `## Contact` — standard contact wording

---

## Step 4 — Commit and finalize

If no document was actually written (including no legal need, all verified current, no selection, or all foreign files skipped), do not commit or write/migrate state. Only a genuine no-write/no-commit run may use the shared empty-branch cleanup. If a write/read-back failed, preserve the actual drafts and legacy sources and report incomplete work instead.

Read back every generated document before finalization, verifying its required content, date and real resolved contact, plus the canonical manifest under the project-state procedure. Show the actual documents/diff and always ask `Commit reviewed legal documents` or `Leave uncommitted`, regardless of auto-commit. This review covers exact output paths and any manifest migration/removals, never push or PR publication. On decline preserve remaining legacy sources, any canonical draft and documents on the actual branch; no integration, deletion or checkout.

On approval, recheck inputs and retire only verified same-file legacy manifest sources under the shared state procedure. Stage exact reviewed documents, `.helm/legal-manifest.json` if changed, and tracked approved legacy removals with literal pathspecs. Inspect the complete staged diff and commit `docs(legal): generate legal documents`, including resolved output path/format in the body when nondefault. A failed staging/commit stops with actual pending state and remaining sources preserved. Verify the commit and all intended outputs before proceeding.

Read `{package_root}/prompts/shared/content-sync.md` and apply **Finalize verified workflow commits** with `{workflow} = legal`. Its PR/push, configured integration, `{base_branch}`, exact-SHA CI and fan-out gates apply, with legal's stronger approval requirement retained for every integration commit. A branch-push/PR choice never replaces legal content review. Do not claim published legal documents merely because their local commit or PR exists.

---

## Step 5 — Confirm completion

If publication/review/CI remains pending, label that outcome explicitly rather than claiming a completed base merge/push. Distinguish a published review branch from the published base, report the PR/manual handoff, current checkout and retained work, and keep output/assessment completion separate from Git finalization.

If Step 1's "No legal need detected" check exited early: report just that outcome — output location and contact point were never resolved, so the full report below doesn't apply.

LEGAL COMPLETE
Generated: none — scan found no legal need (no data collection, third-party integrations, monetization, user-generated/advice content, or AI features)

GitHub Flow only:
Branch:       {branch} — deleted
Returned to:  {original_branch}

If Step 2's "all candidates up to date" check exited early: report that instead — output location and contact point were resolved (this exit happens after them), but nothing needed regenerating.

LEGAL COMPLETE
Generated: none — legal documents already up to date, no meaningful changes since last generation

Location:     {resolved output path}

GitHub Flow only:
Branch:       {branch} — deleted
Returned to:  {original_branch}

Otherwise, summarize the pre-commit/integration read-back on the actual workflow branch (not a different checkout after cleanup). For each generated document, confirm it exists, begins with a `**Last updated:** {date}` line, and ends with a `## Contact` section that does not contain a placeholder (an unfilled `{...}` or `[...]` token) in place of the real contact resolved in Step 1. If any document fails this check, report the error for that specific file instead of folding it into LEGAL COMPLETE below — this is public, legally-binding text, so a silently incomplete document is worse than a loud one.

Report:

LEGAL COMPLETE
Generated:
- {list of documents generated}

Location:     {resolved output path}
Format:       {Markdown / MDX / HTML}
Jurisdiction: GDPR
Tone:         plain English
Committed:    yes / no
Pushed:       yes / no — push manually when ready / N/A (not committed)
Environments promoted: {list or none}

GitHub Flow only:
Branch:       {branch} — PR pending / integrated to {base_branch}, deleted or retained / local only / pending drafts
Returned to:  {original_branch}

Note: These documents are AI-generated starting points.
Review before publishing. Consult a lawyer for high-stakes products.
