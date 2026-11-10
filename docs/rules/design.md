---
title: Design
description: Guide responsive, accessible interfaces and predictable navigation while preserving project design choices and avoiding generic website defaults.
parent: Rules
nav_order: 4
---

# Design

Help agents avoid generic AI website defaults and build responsive, accessible interfaces with predictable navigation. Select Design explicitly during [adopt](../commands/adopt.html#available-rules); it is available but unselected by default, independently of Writing, Git and Safety.

## What it asks the agent to do

- Avoid the automatic centered hero and fixed sequence of feature cards, metrics, testimonials and calls to action.
- Avoid nested card surfaces, badge clutter, oversized icon tiles, decorative accent strips and redundant labels.
- Avoid stock gradient/glow packages, automatic headline effects and animation applied to every section.
- Leave out unsupported social proof and fake dashboards or charts that show nothing specific about the product.
- Watch for replacement clichés, including automatically switching to cream-and-serif or dark-and-neon themes.

The rule gives practical constraints rather than a general design course. Its pattern examples describe what agents should avoid introducing by habit. They remain valid choices when explicitly requested, established by the project or grounded in the actual content and interaction.

## Responsive interfaces and links

New interfaces should work across narrow and wide viewports, using flexible layouts and content-driven changes. Preserve access to information and actions as navigation collapses or content moves. [WCAG 2.2 Level AA](https://www.w3.org/TR/WCAG22/) is the default accessibility reference, including reflow, text resizing and orientation requirements with their stated exceptions.

Links lead to relevant working pages or sections; buttons perform in-page actions. Current-tab navigation is the default for internal and external destinations, including references, repositories and viewable documents. New tabs are limited to preserving an active task, explicit user-selected opening or an explicit project requirement. Every deliberate new tab/window has a visible and accessible warning; normal browser choices remain available.

For prose references, these choices belong to the single [Reference links workflow in Writing](writing.html#reference-links), from finding useful phrases through checking the finished links. When both rules are selected, agents apply the interface standard within that sequence rather than performing another reference pass.

The default external-link icon is a northeast arrow leaving an open square. It marks external text navigation links consistently, regardless of tab behavior. Internal new-tab links get opening warnings without that icon. Established project design-system requirements take precedence. Internal/external classification follows the actual site/service boundary and explicit aliases, not whether the URL is absolute.

Downloads use download wording and native handling; email, phone and application links use their native protocols. Identify file formats, known login requirements and other material outcomes. The rule also covers accessible icon treatment, opener protection and renderer limits; it does not require custom HTML in plain Markdown or chat.

## Preserve project choices

No font, gradient, card or familiar component is automatically a defect. Avoiding repetition does not require plainness, novelty or replacing a project's design system. Targeted edits preserve the surrounding style and existing functionality, accessibility and responsive behavior.

Keep project branding, tokens, component choices and known user needs in local guidance or the existing design system. Separate local guidance makes reviewed Helm updates easier than customizing the adopted copy. Writing governs prose and includes the complete reference-link sequence; Design covers visual structure, responsiveness and the broader interface standard. Neither rule requires the other.

## Basis and review

Google's [responsive-design guidance](https://web.dev/articles/responsive-web-design-basics) informs implementation alongside WCAG. W3C's guidance on [limiting new tabs](https://www.w3.org/WAI/WCAG22/Techniques/general/G200) and [advance warnings](https://www.w3.org/WAI/WCAG22/Techniques/general/G201) is advisory; Helm's mandatory warning and default icon are local usability policy, not blanket WCAG AA requirements. [GOV.UK](https://design-system.service.gov.uk/styles/links/) and [USWDS](https://designsystem.digital.gov/components/link/) inform link guidance but differ on icon conventions, so symbols never replace clear wording.

The pattern list draws on [Anthropic's frontend observations](https://claude.com/resources/articles/improving-frontend-design-through-skills), its [frontend-design guidance](https://github.com/anthropics/skills/blob/main/skills/frontend-design/SKILL.md), [Impeccable's catalog](https://impeccable.style/slop/) and [kill-ai-slop](https://github.com/yetone/kill-ai-slop). These are practitioner observations and editorial choices. They do not establish AI authorship, a scientific slop score or universal usability failures.

During a requested review, agents identify concrete issues, explain their effect and suggest bounded changes. Loading the rule starts no redesign, scan, detector installation or approval process. Detailed sources support the local instructions without requiring whole-guide reads or external skill installation on every task.

Checks scale to the change and available tools, including affected viewport sizes, zoom, keyboard interaction and link destinations or behavior. Required project checks remain required. Agents report material verification limits and do not claim unperformed checks passed.
