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
| Reader and purpose | Lead with the answer or action and provide enough context to act. |
| Familiar language | Use common words and direct verbs while retaining necessary technical terms. |
| Natural tone | Be friendly, respectful and direct without canned praise, hype, slang or invented experiences. |
| Useful content | Remove filler and repetition; replace vague praise with supported facts or remove it. |
| Readable sentences | Prefer clear actors and actions; split overloaded sentences without making the prose choppy. |
| Consistent terminology | Keep the same name for the same concept; explain unfamiliar terms when needed. |
| Structure | Use paragraphs, steps, lists and tables according to the information, without excessive formatting. |
| Punctuation | Default to avoiding em dashes in new prose. Restructure the sentence instead of substituting another dash. |
| Global readers | Avoid unexplained idioms and cultural assumptions; make references, dates and units clear. |
| Final revision | Silently check for filler, repetition, awkward wording and lost meaning before delivery. |

Words such as delve, leverage, seamless and robust are examples to reconsider when they add no meaning, not a forbidden-word list. Technical uses remain valid. There is no fixed sentence length, reading-grade target or writing score.

Avoiding em dashes is a style preference. Meaningful hyphens, minus signs, ranges and Unicode remain valid. Exact quotations and technical syntax are preserved.

## Examples

| Before | After |
|---|---|
| Utilise this command to commence installation. | Use this command to start installation. |
| It is important to note that this action may permanently delete data. | This action may permanently delete data. |
| FooCLI is a robust, seamless solution that empowers developers to effortlessly manage configuration files. | FooCLI helps you manage configuration files. |
| This change leverages caching to improve performance, though it is worth noting that the cache could potentially return stale data. | This change uses caching to improve performance. The cache may return stale data. |

These examples remove filler while preserving the available facts. An agent must not invent measurements, features or causes just to make a sentence more concrete.

## Scope and safeguards

Applicable instruction precedence, explicit user requirements, required formats and project style/voice/locale take priority over these defaults. A technical guide, error message and legal document can require different tones. General principles apply across languages, while the vocabulary examples are English-specific.

Edits stay within the requested scope and preserve surrounding voice. The rule does not authorise polishing unrelated text or replacing existing punctuation throughout a project. Comments remain proportionate and useful rather than becoming a narration of the code.

Keep facts, real uncertainty, conditions, warnings and limitations. Remove stacked hedges without turning a possibility into a certainty. Preserve exact code, identifiers, commands, structured data, quotations, attribution, names, licence text and legal obligations unless the task explicitly calls for a scoped edit under the relevant safeguards.

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
