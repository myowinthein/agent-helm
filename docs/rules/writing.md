---
title: writing.md
parent: Rules
nav_order: 3
---

# writing.md

Shared writing guidance for Claude and Codex. It favours simple, approachable, accurate prose that native and non-native English readers can understand. It covers agent replies and newly authored or requested edits to documentation, README files, UI/help/error text, useful comments and commit/PR/release descriptions.

The rule guides writing quality. It does not identify AI authorship, promise detector results or require pretending to be human. Loading it starts no scan, tool, workflow or repository-wide rewrite, and adds no configuration or operational state.

## What it asks the agent to do

| Area | Guidance |
|---|---|
| Reader and purpose | Lead with the answer or action; include what the reader needs to understand, decide or act, then stop. |
| Appropriate depth | Be concise but complete; match the request, audience and medium, retaining requested depth and necessary explanations. |
| Familiar language | Use common words and direct verbs while retaining necessary technical terms. |
| Natural tone | Be friendly, respectful and direct without canned praise, hype, slang or invented experiences. |
| Useful content | Select details by need, not relevance alone; remove filler, repetition and unnecessary adjacent detail. |
| Readable sentences | Order ideas logically, make references clear and connect sentences and paragraphs without choppy fragments or filler transitions. |
| Consistent terminology | Keep the same name for the same concept; explain unfamiliar terms when needed. |
| Structure | Use suitable paragraphs, steps, lists and tables; place optional depth later or link to existing reliable docs, keeping essential warnings beside actions. |
| Punctuation | Default to avoiding em dashes in new prose. Restructure the sentence instead of substituting another dash. |
| Global readers | Avoid unexplained idioms and cultural assumptions; make references, dates and units clear. |
| Final revision | Silently check content selection, completeness and flow, preserving requested content, material facts, warnings and required formats. |

Accurate, related details can still overwhelm readers. Include them when they serve the immediate task, rather than listing every feature, implementation detail or possible caveat. A simple question may need a direct answer; a detailed guide may need substantial explanation. Explicit requests for depth or exhaustive coverage take priority over concision.

Optional depth can follow the main answer or use existing reliable documentation. Do not hide essential warnings or decision context behind links, create extra files or move content just to shorten the output, or substitute an offer of more for a complete answer.

Words such as delve, leverage, seamless and robust are examples to reconsider when they add no meaning, not a forbidden-word list. Technical uses remain valid. There is no fixed sentence length, word count, reading-grade target or writing score.

Avoiding em dashes is a style preference. Meaningful hyphens, minus signs, ranges and Unicode remain valid. Exact quotations and technical syntax are preserved.

## Examples

| Before | After |
|---|---|
| Utilise this command to commence installation. | Use this command to start installation. |
| It is important to note that this action may permanently delete data. | This action may permanently delete data. |
| FooCLI is a robust, seamless solution that empowers developers to effortlessly manage configuration files. | FooCLI helps you manage configuration files. |
| This change leverages caching to improve performance, though it is worth noting that the cache could potentially return stale data. | This change uses caching to improve performance. The cache may return stale data. |

These examples remove filler while preserving the available facts. An agent must not invent measurements, features or causes just to make a sentence more concrete.

For a hypothetical editor, a reader asks whether it works offline:

| Before | After |
|---|---|
| Yes. The editor stores files locally, has three colour themes and supports keyboard shortcuts. Cloud sync requires internet. | Yes. You can edit local files offline; cloud sync requires internet. |

The focused answer keeps the offline capability and its limitation while omitting unrelated features. This illustrates content selection for a question, not permission to remove facts from unrelated text.

## Scope and safeguards

Applicable instruction precedence, explicit user requirements, required formats and project style/voice/locale take priority over these defaults. A technical guide, error message and legal document can require different tones. General principles apply across languages, while the vocabulary examples are English-specific.

Edits stay within the requested scope and preserve surrounding voice. Loading the rule does not authorise restyling, shortening, reorganising or changing punctuation in existing text. Comments remain proportionate and useful rather than becoming a narration of the code.

When editing, preserve material meaning, including facts, real uncertainty, conditions, warnings and limitations. New writing selects facts for the task without omitting material limitations or unresolved risks, including rare but serious ones. Requested comparisons, necessary explanations and required steps remain. Remove stacked hedges without turning a possibility into a certainty. Preserve exact code, identifiers, commands, structured data, quotations, attribution, names, licence text and legal obligations unless the task explicitly calls for a scoped edit under the relevant safeguards.

Smooth reading means coherent idea order, clear references and natural connections. It does not require filler transitions or override useful lists, procedures, required formats, exact syntax, factual precision or punctuation preferences. Existing terminology and unfamiliar-term explanations remain important.

[Git rules](git.html) still control commit formats and publication. [Safety rules](safety.html) and workflow approvals still apply. Writing guidance cannot authorise publication, weaken a warning or replace legal review. Operational Helm records are excluded from ordinary text editing.

## Loading and adoption

Helm workflows read the bundled rule through the shared runtime. This affects prose produced during those workflows without installing project-wide rules or rewriting existing instructions.

For sessions outside a Helm workflow, use [adopt](../commands/adopt.html) to install one shared `.claude/rules/writing.md` copy. AGENTS.md explicitly tells either agent to read it, and CLAUDE.md imports the shared owner. Codex does not require an installed Claude client, and no second client-specific copy is needed. The copied writing rule works without a loaded plugin.

New adoption proposes all three rules in the reviewed plan; writing may be omitted. Existing projects receive a separate offer to add writing, initially unselected. Updating or reconnecting Git/safety rules does not install writing as a side effect. A missing, unselected writing rule does not make a healthy Git/safety installation incomplete.

Each copy retains adopt's marker/content comparison, exact diff, custom-file, rollback and pointer protections. A user-owned file with the same name is not automatically overwritten or treated as Helm-managed. Plugin updates do not change project copies; rerun adopt for reviewed changes. Static path verification does not prove native loading or compliance, so a fresh session is recommended after adoption.

## Research and limits

- [Kobak and colleagues: LLM-assisted writing and excess vocabulary](https://arxiv.org/abs/2406.07016) found aggregate shifts in style-word use in biomedical abstracts. This supports vocabulary tendencies in that domain, not an authorship verdict for an individual text.
- [Juzek and Ward: lexical overrepresentation](https://aclanthology.org/2025.coling-main.426/) studied overrepresented words and possible contributing mechanisms. The causes are not settled, and the findings do not justify a universal blacklist.
- [Reinhart and colleagues: grammatical and rhetorical styles](https://pmc.ncbi.nlm.nih.gov/articles/PMC11874169/) found noun-heavy writing and limited stylistic variation in the tested models. Results depend on models, genres and study conditions; they are not a universal description of every current model.
- [GOV.UK clear-language guidance](https://guidance.publishing.service.gov.uk/writing-to-gov-uk-standards/writing-guidelines/clear-language/) recommends familiar words, specific wording and explanations of necessary specialist terms.
- [Google's global-audience guidance](https://developers.google.com/style/translation) supports clear, consistent terminology and fewer idioms or cultural assumptions. Its [voice and tone guidance](https://developers.google.com/style/tone) recommends friendly, useful prose without excessive informality or filler.

The rule adopts writing principles rather than every organisation's spelling or formatting convention. Plain language improves the basis for clear communication; a Markdown rule cannot guarantee that every generated passage will sound natural.
