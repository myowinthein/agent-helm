---
title: Design
description: Guide visual composition, theme appearance and responsive, accessible layouts while preserving project identity and avoiding generic website defaults.
parent: Rules
detailed: /docs/rules/design/detailed.html
nav_order: 4
---

# Design

{% include guide-depth.html %}

Build responsive, accessible layouts with visual choices grounded in the project. Select Design explicitly during [adopt](../commands/adopt.html#available-rules); it is independent of Writing and Interaction. Those rules guide prose and control behavior respectively.

## What it asks the agent to do

Avoid introducing familiar defaults by habit: the same centered hero and card sequence, nested surfaces, badge clutter, decorative effects or animation on every section. Leave out invented social proof and dashboards that communicate no product information.

Choose structure, typography and interaction for the actual content and user task. Switching automatically to cream-and-serif or dark-and-neon styling merely creates another repeated default.

Use hierarchy, alignment, spacing and typography to make importance and relationships clear. Let the content and primary task determine the composition, with decoration supporting them.

Reuse established visual treatments for comparable messages, loading indicators and separators, with consistent placement and spacing. Meaning and hierarchy can justify different treatments; exact colors, icons and measurements remain project choices.

## Theme appearance

For work on supported themes, reuse the project's color roles across pages and components so backgrounds, surfaces, text, borders and status cues stay consistent. Give each appearance a coherent palette and clear hierarchy, preserving branding and the existing design system.

Check affected pages, components and assets in each supported appearance and relevant state. Text, essential controls and meaningful graphics need appropriate contrast under WCAG's conditions and exceptions. Logos, icons, diagrams and code blocks should remain readable; reuse assets that work in both modes and adapt them only where needed.

## Responsive interfaces and links

Layouts should work across narrow and wide viewports, preserving access to content and actions as navigation changes. Reading and keyboard-navigation order must remain meaningful when columns stack or content moves. Media should keep its proportions and reserve space to avoid unexpected movement while loading.

Check representative long labels, URLs, supported languages and user-adjusted text spacing, alongside viewport sizes and zoom. [WCAG 2.2 Level AA](https://www.w3.org/TR/WCAG22/) is the default accessibility reference, including its stated conditions and exceptions.

<span id="theme-preferences"></span><span id="input-limits"></span><span id="cursors"></span><span id="links"></span><span id="link-appearance"></span>
The separately selected [Interaction rule](interaction.html#controls-and-feedback) covers theme selection and persistence, input feedback, cursors and link behavior. Design keeps layouts, theme appearance and visual states readable while preserving existing working controls.

## Preserve project choices

Familiar components, fonts, cards and gradients can be appropriate. The rule asks for considered choices, not novelty or replacement of an existing design system. Targeted edits preserve the surrounding style, functionality and accessibility.

Keep project branding, tokens and known user needs in local guidance or the existing design system, so reviewed Helm updates need less customization.

## Basis and review

Accessibility standards inform the rule. The visual-pattern guidance reflects practitioner observations and editorial choices, not proof of AI authorship or universal design failures. Interaction owns Helm's detailed control and link conventions.

A requested review identifies concrete issues, their effect and bounded improvements. Loading the rule starts no redesign or scan. Check affected viewport sizes, zoom, keyboard interaction and links with available tools; report material verification limits.
