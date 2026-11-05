# Design Rules

Design web experiences around their content, audience and purpose. Make information understandable, actions usable and visual choices coherent. Familiar patterns and expressive styles can both serve those goals; appearance alone does not establish AI or human authorship.

## Scope and precedence

- Apply when creating or editing websites and web interfaces, or when design planning, review or critique is requested. This includes documentation presentation and navigation. Loading the rule during unrelated work starts no design review.
- Follow applicable instruction precedence, explicit requirements, existing design systems and project branding. Keep applicable accessibility requirements and honest presentation intact. If they conflict, use a suitable compliant variant within the system where possible; otherwise report the conflict without silently changing branding or claiming the requirement was met. For targeted edits, preserve surrounding visual and interaction conventions; do not redesign adjacent content or restructure documentation merely because this rule was loaded. Report a material adjacent problem noticed during the task without silently expanding the edit.
- This rule governs presentation and interaction. Follow the project's prose guidance for wording, terminology, content accuracy and document structure. Writing guidance can be adopted independently; this rule requires no sibling rule file.
- Keep project choices such as brand, tokens, component conventions and known user needs in existing local guidance or design-system sources. Prefer separate local guidance to customizing shared defaults, while respecting explicitly requested customization. Do not create a design brief, new configuration or extra file just to apply this rule.
- Loading this rule starts no workflow, scan, tool call, installation, bulk restyling or approval process. It needs no plugin/runtime, ledger, score or external service. Existing task scope, operational boundaries and required checks remain binding.

## Purpose, content and direction

- Establish the current surface's job from available project evidence: who uses it, what they need to understand or accomplish, and what content or actions support that. Reuse known answers; do not turn routine work into an intake questionnaire or research project.
- Build structure from actual content and relationships. Do not fill a standard sequence of hero, features, statistics, testimonials and call to action merely to complete a template. A section needs useful content and a purpose; missing evidence is a reason to omit it or use visibly identified draft placeholders. Note unfinished content in the normal handoff.
- When no visual direction exists, choose a coherent direction grounded in the subject, audience, content and available assets. Make reasonable reversible choices rather than asking about every color or spacing value. Clarify material ambiguity about identity, unavailable facts or costly changes. For a new surface or substantial redesign, briefly state important inferred choices before substantial implementation so the user can assess them; routine edits need no design rationale report.
- Adapt emphasis to the surface. Landing pages explain relevance, evidence and a useful next step. Product interfaces support recurring tasks, comparison, feedback and recovery, often at greater density. Documentation supports finding, reading and using information. Personal sites can prioritize identity, work and expression. One project may need several treatments; none requires a fixed section order.

## Visual craft and hierarchy

- Give important content and actions appropriate prominence through type, placement, contrast and spacing. Distinguish headings, body text, metadata and controls. Avoid making every item equally large, colorful or boxed, or making secondary text too faint or small to read.
- Use coherent typography, spacing, alignment and recurring visual treatments, preferably through the project's existing tokens. Choose readable line lengths and line heights for the content and language. Keep related elements visibly related and separate unrelated groups; a border or card is only one way to do that.
- Let whitespace support grouping and reading without displacing useful information. Dense working interfaces and spacious editorial pages have different needs. Do not equate quality with minimalism, maximum whitespace or a fixed number of fonts, colors or components.
- Use imagery, illustration, texture, color and motion when they explain, orient, express identity or create an intended experience. Preserve legibility and task access. Do not add effects to every element or replace useful expression with uniform plainness.

## Components and familiar defaults

Choose components by the information and interaction they support. Reuse suitable project components and familiar control behavior before inventing alternatives. A library's presence does not prove its configured components are accessible or appropriate.

These are choices to reconsider, not banned techniques or a required alternative style:

| Choice | Useful when | Reconsider when |
|---|---|---|
| Cards and tiled grids | Independent items benefit from grouping and browsing. | Continuous explanation is fragmented or comparison would work better in a table or aligned list. |
| Badges and pills | They convey meaningful status, category or active filters. | They repeat ordinary labels, compete for attention or imply unsupported authority. |
| Gradient headlines, glows and decorative backgrounds | They support a coherent visual identity or intended emphasis. | They weaken contrast, obscure content or become the dominant treatment everywhere. |
| Animation and scroll effects | They explain change, provide feedback or support a deliberate expressive experience. | They delay access, distract from tasks or make essential content depend on motion. |
| Repeated promotional sections and calls to action | They answer distinct visitor questions or appear at useful decision points. | They repeat the same claim, interrupt a working interface or demand invented proof. |

Avoid novelty for its own sake. Familiar navigation, recognizable links and predictable controls help users transfer what they already know. Prefer a visible label or conventional interaction when an unfamiliar icon, gesture or custom control would obscure the action.

## Interaction, states and responsive behavior

- Make actions discoverable and distinguish navigation from actions. Controls must do what their presentation promises. Provide relevant feedback, validation and recovery; preserve user input when an operation fails. Do not add nonfunctional controls to make an implemented interface look complete. Clearly distinguish prototype behavior when that is the requested deliverable.
- Design the states the task actually needs, including loading, empty, error, success, disabled and permission states where applicable. Explain whether an empty result means no data, no matches or unavailable data. Implemented behavior must not report success, saving, verification or live status unless the underlying operation or data confirms it. Mockups and requested prototypes may illustrate those states when their simulated nature is clear.
- Use disclosures, tabs and dialogs for appropriate secondary detail or focused tasks. Keep essential information and consequences available at the relevant decision point. Avoid hiding required explanations in hover-only tooltips or introducing modals simply to reduce page length.
- Adapt content priority, navigation and controls to available space, input methods and zoom. Stacking desktop blocks is not sufficient when it buries the task. Preserve logical reading and focus order; do not hide essential actions or data to make a narrow screenshot fit. Use suitable contained scrolling for genuinely two-dimensional content such as comparison tables.
- Account for realistic content variation: long names, text expansion, missing images and relevant locales, including right-to-left layout where supported. Check sticky elements, overlays and the on-screen keyboard where relevant so they do not cover content or focused controls.

## Accessibility, assets and credibility

- Use [WCAG 2.2 Level AA](https://www.w3.org/TR/WCAG22/) as the default accessibility reference unless applicable project requirements specify otherwise. Preserve stronger requirements. Consult relevant criteria and their exceptions when needed; reading the entire standard is not a prerequisite for each edit.
- Use meaningful HTML and native controls where suitable, with accessible names, associated labels and understandable states. Ensure keyboard operation, visible unobscured focus, sufficient text/control contrast and usable targets. Essential meaning must not rely on color, position, hover or a gesture alone. Custom widgets need their expected semantics and keyboard behavior, not just ARIA attributes; use the [WAI-ARIA patterns](https://www.w3.org/WAI/ARIA/apg/) when relevant.
- Support reduced-motion preferences and appropriate pause/stop controls for moving content. Keep essential content and actions available when animation is reduced. Check relevant WCAG requirements and exceptions separately; reduced-motion support alone does not establish conformance with moving-content, flashing or animation criteria.
- Distinguish informative from decorative images and implement appropriate text alternatives under the project's content guidance. Keep essential text available as text. Preserve useful cropping, legible overlays and space for assets while loading. Weigh large images, fonts, video and effect scripts against their benefit; do not add dependencies or assets merely for visual variety.
- Present evidence without manufacturing trust. Charts need meaningful scales, labels and context; comparisons need a fair basis. Sample data, estimates and unfinished capabilities must not appear as actual results. Avoid decorative ratings, customer logos, testimonials, certification-like badges or statistics that imply evidence the project does not have.
- Preserve informed choice. Do not conceal material terms, manufacture urgency, disguise promotions as independent evidence or make refusal and exit paths misleading or obstructive. Clear wording cannot compensate for deceptive prominence, placement or interaction.

## Before delivering

Review the affected design proportionately to the change. Consider whether its structure follows real content, hierarchy supports the task, visual choices work together and relevant states behave coherently. Use representative content and relevant widths, zoom, input methods and states when the change warrants it and suitable rendering/interaction tools are available within scope. Include loading, responsiveness and layout stability when assets or effects materially affect them; [Web Vitals](https://web.dev/articles/vitals) can inform performance checks.

A screenshot cannot establish interaction or accessibility, and [automated accessibility tools](https://www.w3.org/WAI/test-evaluate/tools/selecting/) do not replace manual evaluation. Required project checks remain required; unavailable checks leave the dependent result unverified. Use established authorized preview/check commands; unavailable tools do not authorize installing dependencies or changing services. State material limitations without treating unperformed checks as passed, and bound accessibility or usability claims to the actual evaluation. An agent walkthrough is not research with real users.

For a requested critique, describe concrete observations, their effect on the user and suitable alternatives. Distinguish a standards issue, a contextual usability concern and a preference. Ordinary delivery needs no score, checklist dump or extra artifact; report important changes and verification limits through the task's normal handoff.
