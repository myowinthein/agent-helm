---
title: /helm:legal
parent: Commands
nav_order: 8
---

# /helm:legal

Scan the project's legal profile, detect the output format based on the web framework (or ask if none is found), let the user choose which documents to generate, then write GDPR-compliant legal documents in plain English, commit them, and push after a separate confirmation.

Command names below use Claude notation. In Codex, select the same Helm workflow from the skill picker. Configuration comes from the existing memory owner, including through a bridge; [compatibility notes](../setup/compatibility.html) describe host-specific behavior.

## Flow

```mermaid
flowchart TD
  Start([Run legal]) --> Prepare[Resolve owner, policy and main/master base]
  Prepare --> Branch[Solo on base; GitHub Flow on unique branch]
  Branch --> Work[Workflow assessment, choices and approved edits]
  Work --> Changed{Any workflow changes or commits?}
  Changed -->|no| Noop[Safe empty-branch cleanup and report]
  Changed -->|yes| Verify[Verify outputs and required commit approvals]
  Verify --> Mode{Git strategy?}
  Mode -->|GitHub Flow| Review[Confirmed branch push and PR handoff; required review and CI]
  Review -->|pending| Pending[Retain work and report pending state]
  Review -->|satisfied| Merge[Configured integration strategy]
  Mode -->|Solo| Push
  Merge --> Push[Separately confirm publication]
  Push -->|declined or failed| Pending
  Push -->|verified published SHA| CI[Required promotion CI passed or not applicable]
  CI -->|blocked| Pending
  CI -->|ready| Promote[Optional confirmed fan-out]
  Promote --> Cleanup[Safe eligible cleanup and report]
```

## Steps

### Before starting

Configuration is read from the resolved project-memory owner: normally `AGENTS.md` through `CLAUDE.md`'s import on Claude, or directly on Codex. Existing legacy owners, bridges, overrides, and recognized fenced configuration blocks follow the shared runtime. This command does not create or modify Helm settings in either instruction file; both hosts share the generation record in `.helm/legal-manifest.json`.

Behavior depends on that owner's `git-strategy` (absence defaults to GitHub Flow, per git.html):

Use the [shared Git and CI flow](../setup/git-and-ci.html): resolve the actual main/master base and invocation policy, require a clean setup, use a unique GitHub Flow branch (unused suffix on collisions), and revalidate destination ownership/configuration after checkout. Solo stays on the base without a temporary branch. Preserve real drafts/commits on failure; only a genuine no-write/no-commit exit safely returns before deleting its empty branch.

### 1. Project scan

Reads the codebase to build a legal profile:

- **App type**: web app, mobile, Chrome extension, desktop, open source library.
- **Data collection**: forms, auth, accounts, analytics (GA, Mixpanel, Hotjar, GTM), error tracking (Sentry, Bugsnag), any PII.
- **Sensitive data**: GDPR Art. 9 special-category data (health, biometric, race, religion, sexual orientation, political views); triggers explicit-consent requirements the policy must state.
- **Children and minors**: whether the service targets or admits children (age gates, 13+/16+ checks, parental consent); drives the Children's Privacy section (GDPR Art. 8, COPPA).
- **Third parties**: payment processors (Stripe, PayPal, Paddle), social auth, cloud services, marketing tools.
- **Email and marketing**: email service providers (Mailchimp, SendGrid, Postmark, …) and newsletter signups; marketing email needs consent (GDPR/ePrivacy), transactional does not.
- **Monetization**: paid tiers, subscriptions, pricing pages.
- **Content model**: user-generated content, advice content (financial, health, legal), AI-generated recommendations.
- **AI features**: AI used to generate recommendations presented as facts, BYOK models.

**No legal need detected**: if every category above comes back empty (no data collection, no sensitive data, not child-directed, no third-party integrations, no email/marketing, no monetization, no user-generated/advice content, no AI features), the command stops here rather than resolving an output location or contact point for nothing. It asks whether to exit (Recommended: nothing is written, same cleanup as Step 2's "nothing selected" case) or proceed anyway, in case the scan missed something. This runs before output-location and contact-point resolution below, since both are pointless if nothing ends up generated.

**Monorepo detection**: if the scan finds multiple independent web packages (a workspace layout with several `package.json` files each defining their own framework, under `apps/`, `packages/`, or similar), asks which package should receive the legal documents before anything else runs, since a monorepo usually has one public-facing surface. For two to four packages, uses a single-select picker. For more than four, lists all packages with frameworks and paths in ordinary conversation and waits for one number or exact package path, on either host. Never truncates the list or builds an oversized picker; ambiguous or unknown answers are clarified before proceeding. The rest of Framework and output detection then applies scoped to that package only.

**Framework and output detection**: determines the file format and output path from the project's structure:

| Scenario | Format | Output path |
|---|---|---|
| Static site generator (Jekyll, Hugo, Eleventy, …) | `.md` | Generator's content/docs directory, under `legal/` |
| JS framework with SSR/SSG (Next.js, Astro, Nuxt, SvelteKit, …) | `.mdx` | Framework's pages/content directory, under `legal/` |
| SPA or plain HTML (no SSR, no SSG) | `.html` | Web root (`public/`, `dist/`, or root), clean URL subfolders |
| No web project detected | ask user | User chooses: `legal/` Markdown, `legal/` HTML, or custom path |

**CSS detection (HTML output only)**: if the resolved format is `.html`:
- Global CSS (element/class selectors site-wide) → bare semantic HTML; the site's stylesheet renders it.
- Scoped or utility-first CSS (Tailwind, CSS Modules, etc.) → wrap the generated HTML in the same prose/layout container existing pages use, so it inherits the site's design.
- Cannot determine → wrap in `<main>` as a safe default.

**Output location confirmation**: for the auto-detected scenarios (SSG, JS framework, SPA/plain HTML), the resolved path and format are shown to the user to confirm or override before anything is written. The no-web case is not asked twice: its "where and in what format?" question already served as the location choice, so the confirmation is skipped there.

**Existing documents**: checks the resolved output path for already-present files and resolves `.helm/legal-manifest.json` (the record of what a previous run generated and at which commit; carries a `schema_version` field: a missing one is treated as `1`, since every manifest written before that field existed is implicitly version 1). Both `.claude/helm/legal-manifest.json` and `.claude/legal-manifest.json` are also checked. Validate and compare all copies before classification; differing manifests require explicit reconciliation rather than choosing a winner. Only a run that actually writes a document can migrate the manifest. Verify canonical state before retiring legacy sources after explicit commit approval, in the same commit. Inspection, Skip, and no-op exits leave paths intact. No other command's state moves. Each present file is classified: **Helm-generated** (in the manifest, safe to overwrite) or **Foreign** (not in the manifest, likely hand-written or lawyer-reviewed). For a Helm-generated file, validate `generated_at_commit` as a hexadecimal commit ID, resolve an existing commit object and verify ancestry to the inspected HEAD before safely running its Git range. Only a successful, complete relevant-profile review with no changes permits **up to date**. Relevant changes mean **may be outdated**. Invalid/missing/unavailable/non-ancestor IDs, command failures or incomplete review mean **unknown / may be outdated**, keeping the document in the review candidates and preventing an all-up-to-date exit. Recheck changed HEAD/manifest inputs and never rewrite stored IDs just to repair classification. This is a real classification the selection step below acts on, not just a label. Regeneration is always a full rewrite, never a surgical clause edit. The published documents carry **no marker of their own**: the manifest is the sole record, so end-user-facing files stay completely clean.

### 2. Select which documents to generate

**Applicability** (does the document apply at all) is separate from **Recommended** (should the user be nudged to select it right now). privacy-policy.md and terms.md always apply; cookie-policy.md/refund-policy.md/eula.md/disclaimer.md apply per scan findings. A document is Recommended only if it's missing and applies, or it exists but was classified **may be outdated** or **unknown** above (with the reason disclosed); an applicable document that already exists and is up to date is *not* Recommended, regardless of the applicability rule. This means privacy-policy.md/terms.md aren't unconditionally Recommended on every run the way they used to be: once generated and unchanged, they drop out of the nudge.

**All candidates up to date**: if every applicable document already exists, is Helm-generated, and is up to date (nothing missing, nothing Foreign, stale or unknown), the command skips this step's questions entirely: "Legal documents are up to date: no meaningful changes since last generation." Proceeds straight to Step 4's cleanup, same as if nothing had been selected.

Otherwise, AskUserQuestion has a 4-option limit, so this step uses two questions.

**Question 1: core documents** (always asked when this step is reached):

| Option | Recommended when |
|---|---|
| `privacy-policy.md` | missing, stale, or history unknown (reason shown) |
| `terms.md` | missing, stale, or history unknown (reason shown) |
| `eula.md` | same, gated on installable-software applicability |
| `disclaimer.md` | same, gated on AI-content/advice applicability |

**Question 2: conditional documents** (only asked if relevant signals were detected):

| Option | Recommended when |
|---|---|
| `cookie-policy.md` | same, gated on analytics applicability |
| `refund-policy.md` | same, gated on payment-processing applicability |

Question 2 is skipped entirely if the scan found no analytics and no payment processing. If both apply, it's a multi-select as shown above; if only one applies, a multi-select with a single option isn't valid (AskUserQuestion needs at least 2), so it asks a direct yes/no confirmation for that one document instead.

Each existing document's option also carries a status suffix: `(exists: up to date)`, `(exists: may be outdated)`, `(exists: history unknown: reason)`, or `(exists: not helm-generated)` for a Foreign file, so the user can tell an auto-generated file from a hand-edited one, and a current file from a stale one, independent of whether it's Recommended.

All documents are opt-in: the user can deselect any recommended document or add ones the scan did not flag. If nothing is selected across both questions, the command exits without writing anything, proceeding to Step 4, which writes nothing but still runs GitHub Flow cleanup (delete the temporary branch, return to the original branch) if one was created. Selected documents that already exist are overwritten (Foreign ones confirmed individually first).

### 3. Generate documents

Each selected document is written in plain English, GDPR compliant, to the resolved output path and format.

**Format rules:**
- Markdown/MDX: standard headings, no HTML wrapper, the site's template handles rendering.
- HTML: one subfolder per document (`legal/privacy-policy/index.html`, etc.) for clean URLs; complete standalone page with `<!DOCTYPE html>`, semantic elements, no inline styles or JavaScript.

**Last updated:** every document begins with a `**Last updated:** {current date}` line below the title, in `YYYY-MM-DD` format.

**Contact section:** every document ends with a `## Contact` section using the contact point resolved in Step 1, with wording matched to its type: "contact us at {email}", "visit our contact page at {url}", "open an issue at {url}", or "write to us at {address}". The contact is resolved up front: the command infers and deduplicates candidates (an existing contact/contact-us page, repo issues URL, support email). With none, asks directly in ordinary conversation for an email address, URL, or postal address and waits. With one, offers that candidate plus "Enter a contact manually"; with two to four, offers one option per candidate. With more than four, lists all candidates in conversation and waits for one number or a manual contact. A custom contact can also be supplied through Other or the shared runtime's free-text equivalent. Selecting manual entry still requires providing the actual value; empty, unknown, or ambiguous answers are clarified. It **will not generate anything until a valid contact is provided** and never falls back to a placeholder.

**Document specs**: summary of titles and key sections. The command specification is the canonical source for full section lists and content rules:

| Document | Title | Key required sections |
|---|---|---|
| `privacy-policy` | `# Privacy Policy` | Who We Are, What Data We Collect, How We Use Your Data (GDPR Art. 6 legal basis), Data Sharing, International Transfers, Retention, Your Rights (Art. 15–21), Cookies (when applicable), Children's Privacy, Supervisory Authority (Art. 77), Changes, Contact |
| `terms` | `# Terms of Service` | Acceptance, Description of Service, Acceptable Use, Prohibited Conduct, Intellectual Property, Disclaimer of Warranties, Limitation of Liability, Indemnification, Termination, Governing Law, Changes, Contact |
| `cookie-policy` | `# Cookie Policy` | What Are Cookies, How We Use Cookies, Categories of Cookies (with legal basis), Third-Party Cookies, Your Consent and How to Withdraw It, Managing Cookies in Your Browser, Contact |
| `refund-policy` | `# Refund Policy` | Overview, Eligibility, Refund Window, How to Request, How Refunds Are Issued, Non-Refundable Items, Contact |
| `eula` | `# End User License Agreement` | Grant of License, License Restrictions, IP Ownership, Updates and Modifications, No Warranty, Limitation of Liability, Termination, Governing Law, Contact |
| `disclaimer` | `# Disclaimer` | No Professional Advice (legal/financial/medical), AI-Generated Content, Accuracy and Completeness, External Links, Limitation of Liability, Changes, Contact |

### 4. Commit and finalize

Always review actual generated documents/diff and confirm their exact commit, even with auto-commit enabled. Verify document content/date/contact and manifest before staging. Decline leaves documents, canonical drafts and remaining legacy sources intact on the actual branch, with no merge/deletion/checkout. Approval allows only exact generated outputs, the verified canonical manifest and tracked same-file removals in `docs(legal): generate legal documents`. Verify the commit. Legal also requires explicit approval for any integration commit; PR/push approval never substitutes for legal content review.

No documents written means no manifest write/migration or commit; only a genuine no-op uses empty-branch cleanup.

Follow the [shared Git and CI flow](../setup/git-and-ci.html) after the command's own output verification and commit approvals. GitHub Flow offers separately confirmed branch publication and PR creation, or a local/manual handoff, until required review/checks pass. Integration uses the configured squash/rebase/merge strategy and actual main/master base. Solo requires no PR unless explicit project policy says otherwise. Base publication always has its own confirmation.

Before fan-out promotion, verify configured/applicable CI for the exact published source SHA with complete provider-aware coverage. Missing/failed/pending/unknown results stop or defer promotion; target selection cannot waive the gate. Use at most four target options or Yes/Skip for one, explicitly describing merge and push. Verify each operation and report completed/pending targets separately.

Declined/failed commits, unsafe local edits or incomplete checkpoints preserve actual work and stop dependent operations. Safe cleanup uses ancestry checks and `git branch -d`; squash/rebase branches outside ancestry are retained, never force-deleted. Remote deletion needs its own push confirmation. Report PR URL/review status, actual branch, commits, integration/publication, CI, and promotions separately. Summarize output verification captured before publication, not a different original checkout after cleanup.

### 5. Confirm completion

If Step 1's "No legal need detected" check exited early, reports just that: no documents generated, no legal need found, since output location and contact point were never resolved. If Step 2's "all candidates up to date" check exited early, reports that instead: output location was resolved, but nothing needed regenerating. Otherwise, summarize the read-back already completed on the workflow/integration branch before commit/publication, not a different checkout after cleanup. Confirm it exists, opens with the `**Last updated:**` line, and closes with a `## Contact` section containing no unfilled placeholder: a failed check is reported per-file instead of folded into a generic success message, since an incomplete legal document is worse silent than loud. Then reports which documents were generated, the output path, format, jurisdiction, tone, whether the changes were committed, whether they were pushed, and which environments were promoted. Under GitHub Flow, also reports the temporary branch's actual fate (PR pending, integrated with deletion/retention, local only, or pending drafts) and confirms which branch you were returned to. Reminds the user that these are AI-generated starting points: review before publishing and consult a lawyer for high-stakes products.

## Stop conditions

- **Solo Mode, not on main/master.** Switch to main or master and re-run.
- **No legal need detected.** Scan found no data collection, third-party integrations, monetization, user-generated/advice content, or AI features; asks whether to exit (Recommended) or proceed anyway.
- **All candidates up to date.** Every applicable document already exists, is Helm-generated, and has no legal-relevant changes since it was last generated; informs the user and exits, no picker shown.
- **User selects nothing.** Nothing written: GitHub Flow cleanup still runs (delete the temporary branch, return to the original branch) if one was created.

## See also

- [`/helm:log`](log.html): reflect legal additions in `AGENTS.md`
- [`/helm:manifest`](manifest.html): reference the legal pages from `README.md` if relevant
