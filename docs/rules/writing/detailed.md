---
title: Writing
description: "Writing guides prose that people can understand and use. It applies to replies, documentation, interface copy and useful comments, with depth chosen for the reader rather than copied from the amount of available source material."
parent: Rules
nav_exclude: true
has_toc: false
overview: /docs/rules/writing.html
permalink: /docs/rules/writing/detailed.html
title_category: Details
source_files:
  - rules/writing.md
---

# Writing

{% include guide-depth.html %}

Writing guides prose that people can understand and use. It applies to replies, documentation, interface copy and useful comments, with depth chosen for the reader rather than copied from the amount of available source material.

## What it asks the agent to do

Start with the answer, purpose or action. Add the explanation a reader needs to understand, decide or proceed, using concrete facts and familiar words. Keep necessary technical terms consistent and explain them when the audience needs help.

Clear writing can be detailed. An Overview establishes the journey; a Details guide explains the decisions and examples along that journey. Neither needs to reproduce every implementation instruction. Necessary qualifications, uncertainty and warnings remain visible even when the surrounding prose is shortened.

Reading order matters as much as length. Introduce a concept before using it to explain another, and make the connection visible. Put a condition before the instruction it qualifies so someone knows whether it applies before acting. Shorten an overloaded sentence while keeping its relationship to the next one; a string of fragments can be harder to follow than a connected paragraph.

When editing, preserve the requested scope and surrounding voice. A loaded writing preference is not permission to restyle a whole project, change quotations or rewrite legal commitments. Unsupported claims, invented measurements and generic praise should be removed rather than made more polished.

## Choose useful formatting

Use connected paragraphs for explanation, lists for parallel choices or ordered steps, and tables when readers need to compare shared attributes. Code blocks keep exact syntax separate from prose. A diagram should explain relationships or choices that would otherwise be harder to follow.

Formatting is a means of understanding, not a variety quota. A short answer can be one paragraph; a complex procedure can need several sections and examples. Keep essential warnings beside the relevant action instead of hiding them in optional material.

New prose normally avoids em dashes, decorative punctuation and repeated rhetorical templates. Exact identifiers, meaningful Unicode, quotations and required formats are preserved.

## Reference links

```mermaid
flowchart TD
  Find["Find possible references in the requested scope"] --> Select["Select useful links and avoid reading noise"]
  Select --> Match["Verify the relevant destination and section"]
  Match --> Phrase["Embed the URL in a meaningful phrase"]
  Phrase --> Verify["Check wording, destinations and fragments"]
```

### Find useful references without linking everything

Read the passage for references that help someone act, understand context or verify a claim. A named internal procedure or an authoritative external explanation may deserve a link; an incidental product name does not automatically need one.

Default to one useful contextual occurrence per destination on a page. Distant sections, independent entry points and required citations can justify repetition. Do not add adjacent links that merely send the reader to the same explanation twice.

### Match the destination, then preserve the phrase

A specific topic should lead to the relevant section when it answers the question without skipping prerequisites. A broad introduction should lead to the page. Check available local or supplied target content and actual local section anchors. External destinations can use supplied or previously verified evidence, with any unverified details reported honestly.

Reading external targets requires an explicit research, named-source reading or live-link verification scope. Within it, check meaning and the relevant section rather than treating HTTP success as proof of relevance. These checks concern links in the requested content; background citations inside loaded rules do not trigger browsing, update checks or comparisons against their sources.

Wrap an existing clear phrase. Make only the smallest wording correction needed for a vague or misleading label. For example, a sentence about a release decision should link to [the release section](../../commands/ship.html#optional-versioned-release), while a general introduction to publishing can link to the whole ship guide.

Use verified canonical domains and actual routes. HTTPS is preferred where supported. Preserve working hostnames; non-www is only a default for a new project when hosting supports it. Display an origin as `https://example.com`, but keep path slashes, queries and fragments according to the destination's router. External websites retain their own canonical form.

### Verify the finished reference

<span id="choose-opening-behavior-and-indicators"></span>Read the linked phrase back in its sentence, check the destination and fragment, and preserve established anchors when headings change. Report inaccessible sources and unperformed verification. When separately selected, [Interaction](../interaction/detailed.html#links) adds opening behavior, indicators and control-state checks within this same pass. Writing remains independently usable, and source inspection alone does not establish working interaction.

## Examples

| Less useful | Clearer |
|---|---|
| Utilise this command to commence installation. | Use this command to start installation. |
| This seamless solution empowers developers. | Explain the actual task the tool helps complete. |
| It is important to note that the cache could potentially return stale data. | The cache may return stale data. |
| An offline-use answer lists themes and keyboard shortcuts too. | Explain local editing and the internet requirement for cloud sync. |

## Scope and safeguards

Explicit requirements, locale, required formats and project voice take precedence over stylistic defaults. Code, quotations, attribution, legal wording and material limitations are not disposable filler.

The rule is a writing preference, not an authorship detector or a reason to add deliberate mistakes. It starts no scan or bulk rewrite by itself. Useful depth and comfortable reading determine the result; word or line quotas do not establish quality.

## Explore the source

For implementation details, read [rules/writing.md](https://github.com/myowinthein/agent-helm/blob/main/rules/writing.md).
