---
title: Writing
description: Guide clear, useful prose for replies, documentation and interface text while preserving meaning, material limitations and the project voice.
parent: Rules
nav_order: 3
---

# Writing

Write clear, useful prose for people: replies, guides, UI text, comments and commit or release descriptions. Helm commands load this rule; [adopt](../commands/adopt.html) can install it independently of Git and Safety.

## What it asks the agent to do

- Lead with the answer, purpose or action.
- Include what the reader needs to understand, decide or act, then stop.
- Use familiar words and consistent technical terms.
- Connect ideas without filler, hype or invented facts.
- Preserve material meaning, uncertainty and warnings.

Depth follows the audience and task. A guide need not mirror its source's detail. During maintenance, rewrite the affected passage at its intended depth rather than continually appending text. Required steps and decision context stay visible.

## Choose useful formatting

| Element | Use |
|---|---|
| Paragraphs and headings | Connected explanations and sections readers need to find. |
| Lists | Parallel choices or ordered steps. |
| Tables | Concise comparisons with shared attributes. |
| Code and blocks | Exact identifiers, commands and configuration. |
| Links and quotations | Descriptive link labels, useful destinations and attributed evidence. |
| Notes, images and diagrams | Information clearer to highlight or show. |

Use supported Markdown, HTML or plain text and existing conventions. Formatting does not justify extra content. Link optional detail without hiding necessary warnings. Avoid em dashes in new prose while preserving exact syntax and meaningful punctuation.

## Reference links

Writing handles references as one ordered workflow:

1. Find potential internal and external references within the requested scope.
2. Select links that help readers, avoiding unnecessary repetition and reading noise.
3. Match and verify the relevant page or section, including the source's meaning and actual fragment ID.
4. Embed the URL in a meaningful phrase, preserving existing wording unless a small correction is needed.
5. Choose opening behavior: current tab by default, with warned exceptions for specific task needs, explicit user choice or project requirements.
6. Apply the external-link symbol when appropriate, independently of tab behavior.
7. Verify the finished reference and report any unchecked behavior.

The default is one useful contextual occurrence per destination per page. Distant sections, independent tasks and necessary citations can justify repetition; every product mention need not become a link. Specific topics can link to sections, while broad references can link to whole pages. External sources should be authoritative and relevant to the claim.

The default symbol is a northeast arrow leaving an open square for external text navigation links. Internal links get no external arrow, including new-tab exceptions. Downloads and email, phone or application links keep their native handling and clear outcome wording. Explicit project conventions and renderer limits remain respected.

This sequence is complete in Writing. [Design](design.html#responsive-interfaces-and-links) provides the broader interface standard when selected; no second reference pass or Design dependency is introduced. The approach draws on [Google's cross-reference guidance](https://developers.google.com/style/cross-references#choose-links-selectively) and [GOV.UK's effective links guidance](https://guidance.publishing.service.gov.uk/writing-to-gov-uk-standards/writing-guidelines/add-links/).

## Examples

| Before | After |
|---|---|
| Utilise this command to commence installation. | Use this command to start installation. |
| It is important to note that this action may permanently delete data. | This action may permanently delete data. |
| FooCLI is a seamless solution that empowers developers to manage configuration. | FooCLI helps you manage configuration. |

## Scope and safeguards

Explicit requirements, required formats, voice and locale take priority. Edit only the requested scope; preserve code, quotations, legal obligations and material limitations. Brevity is not a word quota or an authorship test.

Loading the rule starts no bulk rewrite, tool or approval process. [Git](git.html) and [Safety](safety.html) retain their boundaries. The final prose check is silent.
