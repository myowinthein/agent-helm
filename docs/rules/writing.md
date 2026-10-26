---
title: Writing
parent: Rules
nav_order: 3
---

# Writing

Helps agents write clear, useful text for people, using simple language that works for native and non-native English readers. It covers replies, documentation, UI and help text, useful comments and commit, PR and release descriptions.

The aim is natural communication, not a fixed word count or a way to identify or disguise AI authorship. Use [adopt](../commands/adopt.html) to add it to ordinary sessions; Helm commands already load the bundled rule. Writing is optional, including when Git and Safety are already installed.

## What it asks the agent to do

- Lead with the answer, purpose or action.
- Include what this reader needs to understand, decide or act, then stop.
- Use familiar words, direct verbs and consistent technical terms.
- Connect ideas naturally without filler, canned praise or invented experiences.
- Preserve facts, uncertainty, warnings and necessary explanations.

Concision means selecting useful content, not making every answer short. A direct question may need one paragraph; a detailed guide may need much more. Requested depth takes priority. Related facts do not all belong in the answer, and optional detail must not hide essential warnings or replace a complete explanation.

The rule favours clear references and unambiguous dates, numbers and units. It avoids unexplained idioms and cultural assumptions. Words such as “robust” or “leverage” are examples to reconsider when empty, not a blacklist of legitimate technical language.

## Choose useful formatting

Choose elements for the information, rather than adding variety for its own sake.

| Element | Use it for |
|---|---|
| Paragraphs and headings | Connected explanations and sections readers need to find, with a logical heading hierarchy. |
| Lists and definitions | Parallel items, ordered steps or terms paired with descriptions. |
| Tables | Comparisons with shared attributes, clear headers and concise cells. |
| Inline code and blocks | Exact identifiers, paths, commands, configuration and output, with placeholders identified. |
| Bold and italic | Selected meaningful emphasis or established UI conventions. |
| Links and quotations | Useful destinations, supporting sources and clearly attributed exact wording. |
| Notes and warnings | Information beside the action it affects, using the project's existing callout style. |
| Images and diagrams | Information clearer to show than explain, with appropriate text alternatives and useful captions. |

Task lists, footnotes, collapsible details and specialised notation are useful when the subject and renderer support them. Keep required steps and warnings visible. Reuse existing navigation; do not add another contents list or divide every section mechanically.

Use native Markdown, meaningful HTML elements or readable plain text to suit the destination. Tables, alerts, math and other extensions do not render everywhere. Prefer an existing convention or readable fallback instead of adding scripts, styling or dependencies just for formatting.

In new prose, the default is to avoid em dashes by rewriting the sentence. Meaningful hyphens, ranges, Unicode and exact syntax remain intact; substituting another dash is not the goal.

## Examples

| Before | After |
|---|---|
| Utilise this command to commence installation. | Use this command to start installation. |
| It is important to note that this action may permanently delete data. | This action may permanently delete data. |
| FooCLI is a robust, seamless solution that empowers developers to effortlessly manage configuration files. | FooCLI helps you manage configuration files. |

The warning survives; the filler does not. An agent must not invent facts to make a sentence more specific.

## Scope and safeguards

Explicit user requirements, required formats and project voice or locale take priority over these defaults. Edits stay within the requested scope and preserve surrounding style, material meaning, exact code, quotations and legal obligations. Clearer legal wording does not replace legal review.

Loading Writing does not authorize a bulk rewrite, extra tooling or changes to operational records. [Git](git.html) still controls commit and publication policy; [Safety](safety.html) still controls consequential actions. The final writing review is silent, without an extra report or approval process.

For syntax and further guidance, see [Google's global-audience guidance](https://developers.google.com/style/translation), [GitHub Flavored Markdown](https://github.github.com/gfm/) and [MDN's HTML element reference](https://developer.mozilla.org/en-US/docs/Web/HTML/Reference/Elements).
