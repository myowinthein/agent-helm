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

### Theme preferences

When a theme control is part of the task, use the system preference initially unless a valid saved choice or project requirement takes priority. Manual Light/Dark choices win; system changes apply only in automatic mode. Remember choices per project and browser profile across open tabs and later visits. Preserve the existing toggle or selector; a visible System option is optional. Keep the control usable when storage is blocked.

### Input limits

A maximum length does not automatically need a counter. Ordinary fields with generous limits usually need none; fixed-format values need clear instructions. Show a count when people need to plan or shorten their writing, or consider revealing it near a rarely reached limit. Explain important restrictions without relying on placeholders or color alone.

Preserve pasted answers and let people edit excess text where the field permits it. Describe errors without deleting their work, and keep counts consistent with the accepted value, including emoji and other languages. Browser checks help people correct mistakes; receiving code must enforce its own constraints. Local-only apps use their existing save and import boundaries rather than adding a backend.

### Cursors

Match the cursor to what the person can do: a hand for links and enabled custom actions, an I-beam for selectable text, and grab, resize or zoom cursors only for those working operations. Keep native form-control behavior and established design-system conventions. Read-only text can remain selectable; disabled controls should not promise an available action.

Pressing an ordinary button changes its appearance, not its cursor. Processing and dragging can change the cursor when the operation changes. Keep keyboard focus and touch interaction usable, since cursors are only an extra cue. Preserve deliberate project styling without hiding useful operation hints.

### Links

Links navigate; buttons perform in-page actions. Destinations should answer the link’s promise, including specific sections where useful.

| Link situation | Default behavior and indication |
|---|---|
| Internal page or section | Current tab; no external-link icon. |
| External text link | Current tab; northeast arrow leaving an open square. |
| Necessary new tab/window | No opening notice; external icon only if the destination is external. |

New contexts are limited to preserving an active task, explicit user choice or project requirements. Keep native browser opening choices available. Downloads and email, phone or app links use native handling and clear outcome wording. Identify material surprises such as a login requirement or file format.

Do not add visible or hidden notices solely to announce a new tab/window, including label suffixes, tooltips or screen-reader-only equivalents. Keep labels and accessible names focused on the destination.

Classify destinations by the actual site/service boundary and explicit aliases; absolute URLs can be internal. Follow established design-system conventions and renderer limits. When Writing is also selected, apply these choices within its [reference-link workflow](writing.html#reference-links).

### Link appearance

Use clearly visible underlines for prose, reference and table-text links so readers can spot them before interacting. Hover and keyboard focus can strengthen them; color and thickness follow the project's style. Clearly grouped navigation, button links, cards and icons can use their established component styling instead.

Links need readable contrast in light and dark themes, visible keyboard focus and useful feedback without layout shifts. Muted styling should not make links look disabled. Touch users must be able to recognize links without hovering. Use visited styling where reading history helps, keeping it distinct from the current-page marker. Preserve the project's palette and purposeful motion.

## Preserve project choices

Familiar components, fonts, cards and gradients can be appropriate. The rule asks for considered choices, not novelty or replacement of an existing design system. Targeted edits preserve the surrounding style, functionality and accessibility.

Keep project branding, tokens and known user needs in local guidance or the existing design system, so reviewed Helm updates need less customization.

## Basis and review

Accessibility standards inform the rule; Helm’s default hand cursor for custom actions, external icon and link underlines are usability policies, not blanket WCAG AA requirements. The visual-pattern guidance reflects practitioner observations and editorial choices, not proof of AI authorship or universal design failures.

A requested review identifies concrete issues, their effect and bounded improvements. Loading the rule starts no redesign or scan. Check affected viewport sizes, zoom, keyboard interaction and links with available tools; report material verification limits.
