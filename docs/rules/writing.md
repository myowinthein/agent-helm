---
title: Writing
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
| Links and quotations | Useful destinations and attributed evidence. |
| Notes, images and diagrams | Information clearer to highlight or show. |

Use supported Markdown, HTML or plain text and existing conventions. Formatting does not justify extra content. Link optional detail without hiding necessary warnings. Avoid em dashes in new prose while preserving exact syntax and meaningful punctuation.

## Examples

| Before | After |
|---|---|
| Utilise this command to commence installation. | Use this command to start installation. |
| It is important to note that this action may permanently delete data. | This action may permanently delete data. |
| FooCLI is a seamless solution that empowers developers to manage configuration. | FooCLI helps you manage configuration. |

## Scope and safeguards

Explicit requirements, required formats, voice and locale take priority. Edit only the requested scope; preserve code, quotations, legal obligations and material limitations. Brevity is not a word quota or an authorship test.

Loading the rule starts no bulk rewrite, tool or approval process. [Git](git.html) and [Safety](safety.html) retain their boundaries. The final prose check is silent.
