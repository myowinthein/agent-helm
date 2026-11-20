# Design Rules

Build responsive, accessible interfaces around the project's real content and users. Avoid interchangeable layouts and decorative filler often called AI slop. These are practical design constraints, not a complete design method or an authorship test.

## Scope and project conventions

- Apply to requested interface creation, edits, planning and critique, including documentation sites. Follow explicit user choices, branding and existing components. Targeted edits preserve surrounding style, content, functionality and accessibility; loading this rule starts no scan, adjacent redesign or removal of deliberate choices.
- Design owns visual composition, responsive layout and visual accessibility. Follow project prose guidance; Writing owns editorial references and Interaction owns themes, input feedback, cursors and link/control behavior. Neither is a dependency. Preserve working interactions even when those rules are unselected.
- Keep project-specific branding, tokens, grids and components in existing local guidance or design-system sources unless rule customization is explicitly requested. Make reasonable reversible choices; clarify material unknowns without requiring a brief, questionnaire, mood board, new setting or planning workflow. Existing operational boundaries and required checks remain binding.

## Visual hierarchy

Use hierarchy, alignment, spacing and typography to make importance and relationships clear. Let the real content and primary task determine the composition; decoration should support them. An irrelevant template section stays irrelevant after recoloring, changing fonts or replacing rounded cards with sharp boxes.

## Prevent generic AI design patterns

Do not automatically add these patterns to make a page seem modern, polished or complete. They can suit an explicit brief, established project style or genuine content or interaction need. Preserve useful controls, status cues, disclosures and brand treatments; avoiding repetition requires neither novelty nor plainness. Familiar fonts, components, cards and gradients are not defects by themselves, and no per-element justification report is required.

| Recurring pattern | What to avoid |
|---|---|
| Prefabricated hero | The same centered oversized headline, announcement pill, supporting sentence, two buttons and floating mockup regardless of subject. |
| Section conveyor belt | Automatically adding features, statistics, testimonials, pricing, FAQs and a final call to action, or inventing content to fill that sequence. |
| Repeated feature triplets | Splitting, padding or truncating explanations into three equal icon cards with matching paragraphs. |
| Containers around everything | Boxing every paragraph, nesting cards or forcing unrelated content into bento grids with repeated padding, shadows and rounded surfaces. |
| Pill and badge clutter | Turning ordinary headings and descriptive labels into chips or promotional badges without a status, category or filter purpose. |
| Decorative icon furniture | Adding pastel icon tiles, sparkles, emoji or generic pictograms before every heading or feature without conveying information. |
| Meaningless accent strips | Repeating colored edges on cards/callouts without a warning, selection, category or other content purpose. |
| Template labels and numbering | Decorative uppercase eyebrows, repeated headings, technical-looking monospace metadata or `01 / 02 / 03` markers on unordered content. |
| Automatic headline effects | Highlighting one word in every headline with color, gradient, underline or italic serif regardless of meaning. |
| Stock typography package | Reusing the same font/layout package across unrelated projects; changing a suitable font such as Inter merely to evade an example is no improvement. |
| Ambient decoration package | Automatically layering blue/violet washes, blurred blobs, glows, translucent panels, dotted grids or noise as signals of sophistication. |
| Motion on every element | Habitual entrance effects, lifting cards, perpetual floating shapes, counters and typewriter headlines without a useful feedback or expressive purpose. |
| Manufactured social proof | Unsupported logos, ratings, testimonials, user counts, gains or trust seals. Omit them or clearly label draft placeholders; never present invented evidence as real. |
| Product-looking filler | Decorative browser windows, terminals, dashboards or charts that show nothing specific to the product. Requested prototypes/illustrations may use clearly identified simulated states. |
| Replacement clichés | Automatically swapping purple gradients for cream-and-serif/clay, dark-and-neon or a severe newspaper layout without project context. |

These examples are illustrative. Recognize the same habits in new forms; an unlisted effect is not automatically appropriate. Missing branding does not justify a stock SaaS theme, and appropriate existing design-system components need no replacement merely because they are common.

## Responsive and accessible interfaces

- Use flexible layouts and media with content-driven changes within the established responsive system. For new layouts without one, start usable at narrow widths and expand as content benefits. Keep wide-screen text readable too.
- Preserve access to information and actions as navigation collapses or content moves. Avoid unintended page overflow; give genuinely two-dimensional content, such as tables or maps, an accessible presentation instead of clipping it.
- Use [WCAG 2.2 Level AA](https://www.w3.org/TR/WCAG22/) as the default accessibility reference, preserving stronger project requirements and reporting unresolved branding conflicts. Honor reflow, text-resizing and orientation requirements with their exceptions; do not disable zoom to fit a layout.
- Preserve keyboard, touch and pointer use. Width alone does not establish input capabilities; essential information cannot depend on hover. Address responsive or accessibility failures introduced by the change.

## Review and verification

Silently check whether the affected composition could serve an unrelated product with only names changed, and revise habitual filler within scope. Shared navigation and component libraries alone do not imply interchangeable content. For a requested review, identify concrete locations, effects and bounded improvements, distinguishing stylistic preferences from functional or accessibility failures. Give no authorship verdict, probability or slop score.

Use proportionate authorized rendering and interaction checks. For layout, navigation or sizing changes, check affected narrow, intermediate and wide views, breakpoint transitions and relevant orientations. Verify applicable [reflow](https://www.w3.org/TR/WCAG22/#reflow) at 320 CSS pixels for vertically scrolling content and [text resizing](https://www.w3.org/TR/WCAG22/#resize-text) to 200%, retaining each criterion's exceptions. These are accessibility checks, not mandated design breakpoints. Interaction owns detailed control-state checks when selected.

Preserve required project checks. Source inspection, screenshots and observed behavior provide different evidence; none alone proves overall accessibility or usability. Report unavailable checks, important limitations and unfinished placeholders in the normal handoff. Loading this rule requires no detector, tool installation, report artifact or new approval process.

## References

[Apple's layout guidance](https://developer.apple.com/design/human-interface-guidelines/layout) supports hierarchy and grouping; [Google's responsive guidance](https://web.dev/articles/responsive-web-design-basics) supports flexible, content-driven layouts. WCAG above supplies the accessibility baseline. [Anthropic's frontend guidance](https://github.com/anthropics/skills/blob/main/skills/frontend-design/SKILL.md) and its [article on recurring defaults](https://claude.com/resources/articles/improving-frontend-design-through-skills) inform the pattern examples. Those are practitioner observations and editorial preferences, not universal usability findings. References require no routine research, external-skill loading, framework or extra planning stages.
