---
title: Design
description: Guide responsive, accessible interfaces and predictable navigation while preserving project design choices and avoiding generic website defaults.
parent: Rules
nav_order: 4
---

# Design

Help agents avoid generic AI website defaults and build responsive, accessible interfaces with predictable navigation. Select Design explicitly during [adopt](../commands/adopt.html); it is available but unselected by default, independently of Writing, Git and Safety.

## What it asks the agent to do

- Avoid the automatic centered hero and fixed sequence of feature cards, metrics, testimonials and calls to action.
- Avoid nested card surfaces, badge clutter, oversized icon tiles, decorative accent strips and redundant labels.
- Avoid stock gradient/glow packages, automatic headline effects and animation applied to every section.
- Leave out unsupported social proof and fake dashboards or charts that show nothing specific about the product.
- Watch for replacement clichés, including automatically switching to cream-and-serif or dark-and-neon themes.

The rule gives practical constraints rather than a general design course. Its pattern examples describe what agents should avoid introducing by habit. They remain valid choices when explicitly requested, established by the project or grounded in the actual content and interaction.

## Responsive interfaces and links

New interfaces should work across narrow and wide viewports, using flexible layouts and content-driven changes. Preserve access to information and actions as navigation collapses or content moves. [WCAG 2.2 Level AA](https://www.w3.org/TR/WCAG22/) is the default accessibility reference, including reflow, text resizing and orientation requirements with their stated exceptions.

Links lead to relevant working pages or sections; actions use buttons. Links open in the current tab by default, including external destinations. A new tab needs a clear task reason or explicit project requirement, with a visible and accessible warning. External-link icons follow the project's convention consistently; no particular glyph is required, and leaving the site is separate from opening a new tab.

## Preserve project choices

No font, gradient, card or familiar component is automatically a defect. Avoiding repetition does not require plainness, novelty or replacing a project's design system. Targeted edits preserve the surrounding style and existing functionality, accessibility and responsive behavior.

Keep project branding, tokens, component choices and known user needs in local guidance or the existing design system. Separate local guidance makes reviewed Helm updates easier than customizing the adopted copy. [Writing](writing.html) governs prose, including descriptive link labels; Design covers visual structure, responsiveness and link behavior. Neither rule requires the other.

## Basis and review

Google's [responsive-design guidance](https://web.dev/articles/responsive-web-design-basics) informs implementation alongside WCAG. [W3C's new-window guidance](https://www.w3.org/WAI/WCAG22/Techniques/general/G201) is advisory; the rule's new-tab warning is a usability default, not a blanket WCAG AA requirement. [GOV.UK](https://design-system.service.gov.uk/styles/links/) and [USWDS](https://designsystem.digital.gov/components/link/) inform link guidance but differ on icon conventions.

The pattern list draws on [Anthropic's frontend observations](https://claude.com/resources/articles/improving-frontend-design-through-skills), its [frontend-design guidance](https://github.com/anthropics/skills/blob/main/skills/frontend-design/SKILL.md), [Impeccable's catalog](https://impeccable.style/slop/) and [kill-ai-slop](https://github.com/yetone/kill-ai-slop). These are practitioner observations and editorial choices. They do not establish AI authorship, a scientific slop score or universal usability failures.

During a requested review, agents identify concrete issues, explain their effect and suggest bounded changes. Loading the rule starts no redesign, scan, detector installation or approval process. Detailed sources support the local instructions without requiring whole-guide reads or external skill installation on every task.

Checks scale to the change and available tools, including affected viewport sizes, zoom, keyboard interaction and link destinations or behavior. Required project checks remain required. Agents report material verification limits and do not claim unperformed checks passed.
