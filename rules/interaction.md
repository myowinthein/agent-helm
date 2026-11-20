# Interaction Rules

Keep themes, input feedback, cursors and link behavior predictable during requested interface work, including documentation sites. Preserve explicit user choices, project conventions, existing controls and the output medium's capabilities. Apply only relevant sections; loading this rule starts no redesign, scan, installation, workflow or extra execution authority.

Writing owns prose and editorial references; Design owns visual composition, responsive layout and visual accessibility. Neither is a dependency. Use their relevant guidance when separately selected, within the same task. Helm's hand cursor, external icon, underline and theme-persistence defaults are preferences, not universal accessibility requirements.

## Theme preferences

Reuse the existing control and preference mechanism, respecting explicit project requirements.

- With no valid explicit choice, follow the browser-reported system preference; if unavailable, use the project default or light. Apply the initial theme before paint and align browser controls' `color-scheme`.
- Store the user's chosen mode, not the detected appearance. Manual Light/Dark wins even when it matches the system; follow live system changes only in automatic mode, without overwriting a manual choice.
- Remember explicit choices per project and browser profile across tabs, windows and later visits until changed or browser data is removed; synchronize that project's open views. Projects sharing an origin need separate keys. Existing account synchronization or explicit requirements may define another scope.
- Preserve the toggle or selector style; a visible System option is optional. Selecting System when available, or clearing the override, restores automatic behavior. Do not invent hidden modes or reinterpret a matching manual choice.
- Keep switching usable in page memory if storage is blocked. Invalid or cleared preferences and later visits without usable storage return to the default. Respect private-browsing limits; add no backend or synchronization across browsers or devices merely to remember a theme.

## Input limits and feedback

Keep existing accepted-data contracts. Limits need a product, format or resource reason; do not tighten them as visual cleanup. Reassess a frequently exceeded limit rather than automatically adding a counter.

| Situation | Default feedback |
|---|---|
| Ordinary field with a generous technical limit | No counter; explain material or unexpected restrictions. |
| Fixed-format value, such as a six-digit code | Clear format instruction; usually no counter. |
| Composed text whose length matters, such as a title or biography | Show the maximum and a live count. |
| Longer text rarely approaching its limit | Consider a near-limit counter with a task-appropriate threshold. |

- Explain restrictions and how to correct errors; color, width, borders, icons, placeholders or an unexplained disabled submit button cannot replace needed text. Associate hints, counters and errors with the field. Visible counts may update while typing; pace assistive announcements and do not interrupt text composition.
- Preserve the answer after errors. For composed text, normally allow temporary excess and full paste so people can edit down; do not silently truncate, discard overflow or block paste. A justified hard stop needs clear feedback. Editing flexibility does not remove a larger resource-safety bound.
- Keep counters, normalization and final validation consistent about limits and counting units, including emoji, combining characters, whitespace and newlines. HTML `maxlength` counts UTF-16 units; prefer user-perceived characters for writing limits when the data contract permits. Never strip meaningful text merely to fit.
- Browser feedback does not enforce a receiving service's trust boundary. Validate independently there; local-only apps use existing save, import and outgoing-data boundaries without adding a backend. Include programmatic and imported values, which native `maxlength` alone does not cover. Report outside-scope enforcement gaps rather than expanding an interface task or claiming frontend checks secure the whole path.

## Cursors and pointer feedback

Match the cue to the available operation, using system cursors and established project conventions.

| Element or operation | Default treatment |
|---|---|
| Ordinary content and decoration | `auto`; preserve text selection. |
| Links and enabled custom buttons, tabs, toggles or disclosures | `pointer` over the actual clickable area. |
| Editable or selectable text, including read-only fields | Native behavior or `text`; read-only is not disabled. |
| Native selects, checkboxes, radios and sliders | Preserve browser or component behavior. |
| Disabled custom action | `not-allowed` or the design system's arrow; no enabled-action hand or hover cue. |
| Working drag handle / engaged drag | `grab` / `grabbing`. |
| Available resize or zoom operation | Matching directional resize or `zoom-in` / `zoom-out`. |
| Processing | `progress` while interaction remains available; `wait` only over the blocked area. |

Ordinary hover and press keep the operation's cursor; pressing needs visible feedback. Change cues when the operation or availability changes and restore them after completion, cancellation or failure. Copy buttons use the action cursor; `copy`, `move` and `no-drop` describe transfer operations. Use `help` only for an available help interaction.

Scope styling to the actual control or handle, not an unrelated card, row or label. Avoid wildcard overrides hiding text selection, native controls or specialized cues; validation errors do not disable editable fields. Cursor styling, `aria-disabled` or `pointer-events: none` alone cannot prevent every activation path: implement correct native semantics and handlers and preserve selectable read-only content.

Keep recognizable controls, visible focus, keyboard and touch use independently of cursors. Prefer native click activation so users can cancel before release. Dragging needs keyboard access and a non-drag single-pointer alternative unless an applicable exception applies. Avoid decorative cursor replacements or trails by default; preserve deliberate designs that retain operation cues and native usability. Respect reduced motion and platform differences, without demanding identical cursor artwork.

## Links and navigation

Use real links for navigation and downloads and buttons for in-page actions. Verify relevant destinations, fragments and meaningful labels; no invented URLs or placeholders presented as working links. When Writing is selected, apply these behaviors within its editorial reference pass without repeating selection.

Current tab is the default. Existing `target="_blank"` alone establishes no requirement for a new context.

| Destination or task | Opening behavior | Indication |
|---|---|---|
| Internal page, section, menu, breadcrumb or pagination | Current tab. | No external icon. |
| External website, reference, repository or social text link | Current tab. | External icon. |
| Reference needed alongside an active form, editor or task | New context only to preserve state or required work alongside it. | External icon only if external. |
| Explicit user-selected opening or project requirement | Requested behavior within renderer and browser limits. | Ordinary meaningful label; no opening notice. |
| Viewable document, including PDF | Current tab or browser handling; file type alone warrants no new tab. | Actual format; external icon if external. |
| Actual download | Native handling, no forced extra tab. | Download wording, format and known size; no external-navigation arrow. |
| Email, telephone or app link | Native protocol handling, no forced extra tab. | Clear action/destination. |

- Classify against the actual site or service boundary, configured aliases and relevant paths. Absolute URLs can be internal; sharing an organization or parent domain does not establish this. Parse boundaries instead of matching hostname substrings. Externality, long references, login or visitor retention alone warrant no new tab.
- Preserve modified clicks, middle-click and context menus. Do not promise a tab or window presentation controlled by the browser. Apply supported behavior without unsupported HTML or renderer customization.
- Add no visible or hidden opening announcement: no label suffix, tooltip, accessible-only text, live announcement, dialog or group notice solely for opening a new tab or window. Keep labels and accessible names meaningful. External links need no interrupting confirmation.
- Use one external HTTP(S) text-navigation symbol: a northeast arrow leaving an open square, from the existing icon set or matching SVG. Apply consistently across content, lists, tables, navigation and footers. It identifies the destination, independently of opening behavior; internal new-tab links get none. Preserve explicit design-system alternatives consistently.
- Place the icon after text inside the same link. Hide redundant icons from assistive technology; convey otherwise missing information in text. An arrow alone explains no purpose; logo-only or icon-only links need meaningful accessible names rather than appended arrows. Identify known login requirements, app launches and actual file outcomes without inventing sizes or promising downloads that may be viewers.
- Ordinary HTML new-tab links use `target="_blank"` with `rel="noopener"`; `noreferrer` separately changes referrer disclosure. Preserve specified authentication and window protocols rather than blanket-rewriting them.

### Link appearance and interaction

Make links recognizable before interaction, using the existing palette and components. Appearance does not change opening or indicator policy.

| Context | At rest | On hover |
|---|---|---|
| Prose, reference lists and table text | Visible underline and readable text. | Retain underline; strengthen thickness, color or another established cue. |
| Standalone text link | Underlined unless an established recognizable component supplies another cue. | Strengthen that cue or add underline. |
| Header, sidebar, breadcrumb or footer navigation | Underline optional when grouping and placement clearly identify navigation. | Consistent component feedback. |
| Button-styled link | Existing button treatment. | Existing button hover. |
| Linked card | Recognizable linked title or navigation affordance. | Emphasize title, border or background; retain purposeful motion. |
| Icon or logo link | Recognizable placement and accessible name; no underline needed. | Suitable component feedback. |

- Do not rely on hue or hover alone. Keep underlines visible at rest; reserve them for links rather than ordinary emphasis. If an explicit convention omits them, verify a persistent distinction; 3:1 contrast against surrounding text is one W3C technique, separate from background contrast.
- Text contrast against its background in rest, hover and visited states meets WCAG AA: 4.5:1 for ordinary text or 3:1 for qualifying large text. Muted links must remain readable and usable-looking; blue is not required.
- Provide visible keyboard focus independently of hover. Essential labels and indicators remain available on touch. Avoid emphasis that shifts layout; preserve purposeful motion and reduced-motion preferences.
- Use visited styling when reading history helps; it is optional for menus or buttons where it adds little. Keep it readable and distinct from the current-page marker, which indicates location.

## Review and verification

Use available authorized tools on affected controls and states, preserving required project checks, palette, layout and accessibility. Check keyboard, touch and pointer use without relying solely on hover or cursors, and verify recovery after completion, cancellation or failure.

| Changed area | Relevant checks |
|---|---|
| Themes | Initial paint, saved/manual overrides, automatic system changes, same-project tab updates and unavailable storage. |
| Input limits | Boundaries, paste, autofill, imports, relevant languages and text composition, counting agreement, accessible feedback and preserved answers. Distinguish browser checks from receiving validation. |
| Cursors | Actual hit area, hover, press, disabled/read-only, processing and drag states, and selection. |
| Links | Destinations, fragments, opening behavior, indicators, contrast at rest/focus/hover/visited states in supported themes, and stable layout. |

Source inspection, screenshots and observed behavior provide different evidence; none alone proves overall accessibility or usability. Report unavailable checks, important limitations and unfinished placeholders in the normal handoff. This rule requires no detector, tool installation, report artifact or added approval process.

## References

- **Themes:** [Google's theme switch](https://web.dev/articles/building/a-theme-switch-component) and [MDN storage guidance](https://developer.mozilla.org/en-US/docs/Web/API/Window/localStorage) inform preference handling and browser limits; Helm defines its persistence scope and optional System control.
- **Input:** [GOV.UK guidance](https://design-system.service.gov.uk/components/character-count/) supports selective counters and preserved paste; [HTML length constraints](https://html.spec.whatwg.org/multipage/form-control-infrastructure.html#limiting-user-input-length:-the-maxlength-attribute) define counting limits. [W3C guidance on status messages](https://www.w3.org/WAI/WCAG22/Understanding/status-messages.html) informs accessible feedback.
- **Cursors:** [CSS definitions](https://www.w3.org/TR/css-ui-3/#cursor), [pointer cancellation](https://www.w3.org/WAI/WCAG22/Understanding/pointer-cancellation.html) and [dragging alternatives](https://www.w3.org/WAI/WCAG22/Understanding/dragging-movements.html) ground operation cues and input access.
- **Links:** [Link purpose](https://www.w3.org/WAI/WCAG22/Understanding/link-purpose-in-context.html), [text contrast](https://www.w3.org/WAI/WCAG22/Understanding/contrast-minimum.html), [G183](https://www.w3.org/WAI/WCAG22/Techniques/general/G183) and [HTML opener protection](https://html.spec.whatwg.org/multipage/links.html#link-type-noopener) ground the technical distinctions. [GOV.UK](https://design-system.service.gov.uk/styles/links/) and [USWDS](https://designsystem.digital.gov/components/link/) differ on external icons; Helm's chosen conventions remain preferences.

These sources support maintenance, not routine external reading or additional workflows.
