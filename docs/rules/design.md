---
title: Design
description: Guide responsive, accessible interfaces and predictable navigation while preserving project design choices and avoiding generic website defaults.
parent: Rules
detailed: /docs/rules/design/detailed.html
nav_order: 4
---

# Design

{% include guide-depth.html %}

Build responsive, accessible interfaces with predictable navigation and choices grounded in the project. Select Design explicitly during [adopt](../commands/adopt.html#available-rules); it is optional and independent of Writing, Git and Safety.

## What it asks the agent to do

Avoid introducing familiar defaults by habit: the same centered hero and card sequence, nested surfaces, badge clutter, decorative effects or animation on every section. Leave out invented social proof and dashboards that communicate no product information.

Choose structure, typography and interaction for the actual content and user task. Switching automatically to cream-and-serif or dark-and-neon styling merely creates another repeated default.

## Responsive interfaces and links

Layouts should work across narrow and wide viewports, preserving access to content and actions as navigation changes. [WCAG 2.2 Level AA](https://www.w3.org/TR/WCAG22/) is the default accessibility reference, including its stated exceptions.

Links navigate; buttons perform in-page actions. Destinations should answer the link’s promise, including specific sections where useful.

| Link situation | Default behavior and indication |
|---|---|
| Internal page or section | Current tab; no external-link icon. |
| External text link | Current tab; northeast arrow leaving an open square. |
| Necessary new tab/window | Visible and accessible opening warning; external icon only if the destination is external. |

New contexts are limited to preserving an active task, explicit user choice or project requirements. Keep native browser opening choices available. Downloads and email, phone or app links use native handling and clear outcome wording. Identify material surprises such as a login requirement or file format.

Classify destinations by the actual site/service boundary and explicit aliases; absolute URLs can be internal. Follow established design-system conventions and renderer limits. When Writing is also selected, apply these choices within its [reference-link workflow](writing.html#reference-links).

## Preserve project choices

Familiar components, fonts, cards and gradients can be appropriate. The rule asks for considered choices, not novelty or replacement of an existing design system. Targeted edits preserve the surrounding style, functionality and accessibility.

Keep project branding, tokens and known user needs in local guidance or the existing design system, so reviewed Helm updates need less customization.

## Basis and review

Accessibility standards inform the rule; Helm’s mandatory new-context warning and default external icon are local usability policy, not blanket WCAG AA requirements. The visual-pattern guidance reflects practitioner observations and editorial choices, not proof of AI authorship or universal design failures.

A requested review identifies concrete issues, their effect and bounded improvements. Loading the rule starts no redesign or scan. Check affected viewport sizes, zoom, keyboard interaction and links with available tools; report material verification limits.
