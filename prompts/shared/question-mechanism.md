# Question mechanism (QM)

Shared question presentation and answer handling for workflows and supporting prompts. The workflow owns the decision; QM adapts it to the host without adding tools, settings, state or approval authority. Actual exposed tools and restrictions take precedence over the researched inventory.

Read forms, routing, baseline and answer rules for ordinary questions, plus applicable host-inventory rows. Consult alternatives for a capability gap and recovery for a confirmed failure. Other-host/MCP details and evidence links remain reference material; do not probe capabilities to read them.

## Choose the question form

Use the workflow's **Question points**, including conditional questions in its body/helpers. Missing human facts use Input. The map adds no gate and changes no prerequisites. Reuse explicit answers and valid concrete approval; ask only for missing material input.

| Form | Use | What the command supplies |
|---|---|---|
| **Single** | One mutually exclusive route, preference or remedy; Yes/Skip is a two-choice Single. | Clear question, meaningful labels and short tradeoffs; mark a recommendation only with evidence. |
| **Multi** | Any independent subset of rules, documents, findings or targets. | Complete identities/labels, grouping and actual selection constraints; preserve explicit None and exclusions. |
| **Input** | Missing facts, intent, path, contact, version, outline, explanation or feedback. | Exact missing facts and why needed; include units/format or known candidates when useful, never fabricated alternatives. |
| **Review** | Authorization of a shown diff, plan, commit, publication or consequential operation. | Concrete content/paths/targets/effects and the workflow's exact approve/revise/partial/decline choices. |

Compose forms without combining decisions: Single → Input for a custom version or manual contact; Multi → Review for selected work; Review → Multi/Input for Apply some or Revise. A selection alone is not authorization unless the existing workflow and the shown concrete action already make it so. A Review can approve only the described unit; preserve separate push, release, legal, per-file and archive gates.

## Route once, then ask

1. Resolve form, required/optional input, choices and sensitive/attachment needs. Check exposed tool schemas, purpose/mode restrictions and the applicable inventory rows. The parent asks; workers return missing facts.
2. Use a faithful, permitted native tool: Claude's `AskUserQuestion`; Codex's `request_user_input`, otherwise `request_user_input_async`; a future host's documented equivalent. Blocking input may be Plan-only, and optional-preference tools cannot carry required input or authorization when prohibited.
3. Keep the preferred form when supported; otherwise use the first eligible **Ordered native alternative**, then the baseline. This is capability substitution, separate from rendering recovery. Never change modes, permissions or client settings, or install MCP, to obtain a picker.
4. Batch independent questions only within the supported limit and one prerequisite snapshot. Split oversized batches; ask dependent follow-ups after answers. Preserve per-file decisions, separate confirmations, short unique labels and exact file/finding/branch IDs where labels could collide.
5. Wait for an actual answer before dependent work. Blocking tools wait in-call; accepted async requests are only queued. Continue independent authorized work, leaving dependents pending. Do not duplicate a pending native question in chat. Revalidate late replies against the current question/snapshot.

### Ordered native alternatives

Use these representations only for a capability gap in an existing question, not as undocumented host widgets or new per-command lists. Preserve the complete question, identities, cardinality, scope, evidence and exits. Every alternative must satisfy current tool purpose, mode and schema restrictions, including required-input/authorization limits.

| Preferred presentation lacking support | Ordered equivalent native representations, then the baseline |
|---|---|
| **Single** choice list, including a list too wide for the host | Original selector → paged Single where the workflow permits paging → native Input naming one displayed ID/label → conversational baseline. Pages expose the full candidate list first, preserve navigation and exits, and produce exactly one business decision. Never ask independent Single questions for mutually exclusive alternatives. |
| **Multi** independent subset | Original selector → independent Yes/No membership questions when a small visible set fits one supported native batch → native Input for selected IDs/exclusions or explicit `none` → conversational baseline. Membership asks one question per candidate against the same visible set; only a complete human-submitted batch supplies the subset. All explicit No answers mean None; missing/auto-resolved answers remain incomplete. Keep Skip/Cancel distinct and summarize the exact resulting subset without adding an approval gate. Preserve caller dependency checks without silently adding prerequisites. Large sets use Input rather than a long membership sequence or oversized batch. |
| **Input** free text without a native text field | Original text input → genuine existing candidate choices with supported Other/notes/custom text → conversational baseline. Use this only when the candidates answer the same question; no invented choices, coercion into a default, or Provide manually answer mistaken for the actual value. With no genuine candidates or custom-text channel, use the baseline. |
| **Review** exact action/content decision | Original review choices → paged Single only where permitted and the complete review stays visible → native Input for an unambiguous decision about that same shown unit → conversational baseline. Never decompose one approval into membership questions, split its effects across pages, or treat partial/revise as approve. Existing independent per-file reviews remain independent. |
| Optional rich preview or option descriptions | Supported original preview → supported Markdown preview → show the same evidence/comparison beside native choices; put missing option descriptions in the question or preceding report. Retain material visual evidence through an already available permitted display; if it cannot be shown, leave that review pending rather than approve from a weaker summary. If the choice control also lacks support, use its Single/Multi/Review row. |

Workflow-mandated conversational lists and stronger gates still win. QM adds no choices, confirmation stages or persistent fallback settings.

### Recover after a presentation failure

For a confirmed failure, continue the ordered candidates: try any remaining compatible tool for the same representation in the host order above, then the next eligible representation, and finally the conversational baseline. Skip unavailable or already failed combinations. Try each representation/tool combination at most once for this unchanged question; keep the original content, choices and review snapshot. A changed question or capability needs fresh routing, not a blind retry.

Proceed to another presentation only when the host explicitly reports rejection before any question was created, or available request status/user confirmation establishes that the failed request is no longer active and no answer was submitted. An error after dispatch, disconnect, missing visual acknowledgement or user report that the card is invisible can leave display status uncertain. Reconcile using already exposed status or ask the user to resolve the old prompt; do not display a duplicate while it may still be active. Do not add UI probes or inspect private transcripts to infer rendering success.

An accepted/queued asynchronous call is pending input, not a render test. Silence, an empty/partial answer, explicit None, rejection, cancellation, interruption or timeout is never by itself a rendering failure and never advances the alternatives. Honor actual answers/exits or keep the decision pending. If a user explicitly requests a replacement after closing a broken prompt, use only its still-current question; revalidate any late answer before accepting it. No presentation retry executes the action under review.

### One common conversational baseline

After eligible native alternatives are exhausted, explain the limitation briefly once per unchanged limitation in the invocation and ask in conversation. Single/Review shows the original choices; Multi shows the complete numbered/ID list with exact selections/exclusions and an explicit `none`; Input requests the missing facts directly. Keep the workflow's own Skip/Cancel/Leave pending exits distinct. A zero-candidate list produces no picker; a single candidate uses a meaningful Yes/Skip choice when confirmation is required.

Never truncate a list, replace an independent subset with one mutually exclusive choice, or silently select all. If host instructions prohibit textual choice lists, ask one concise free-text question referring to the already presented choices/IDs. If even that channel is unavailable, report the precise pending decision and stop its dependents. An explicit workflow-specific safe exit still governs its effects.

### Interpret the answer

- Preserve selected labels/IDs and custom text verbatim as data, never shell code. A free-text reply may refine scope, ask for explanation or tell the agent to wait; it is not automatically the highlighted option. Clarify conflicting, ambiguous, out-of-range or partial required answers before dependent work. A manual-entry choice is not the missing value itself.
- Distinguish submitted empty selection/explicit None from an unanswered or cancelled request. Cancellation is not a recorded skip, rejection or accepted risk. Honor the owning workflow's outcome; never invent a ledger decision from nonselection.
- Defaults, recommendations, preselection, timeouts, auto-resolution, tool permission and an empty answer supply no human consent. Do not set a timeout to approve work. If a host times out or clears a request, keep required input pending; optional work may proceed only under an already authorized caller default, without persisting an unanswered preference. Reuse the question on actual continuation rather than loop or broaden it.
- Show the full review evidence before requesting approval; short option descriptions and optional previews cannot replace a diff or exact effect plan. Changed content/target/effects invalidate only the affected approval. Native OS/tool/plan approval remains separate and cannot be granted by QM or simulated through another tool.
- When the invoking workflow explicitly uses file-based review, exact readable local files and their available diffs can supply that content evidence. Give concise paths/links and the concrete action scope in chat; do not paste bodies unless requested. Bind approval to the actual reviewed bytes. Inaccessible files, file opening alone or a summary of unseen content cannot supply approval. This changes presentation only, not a caller's write order or stronger pre-write gates.
- Never collect credentials or private user records through QM, including masked fields. Ask for safe metadata or the approved secure owning route. For file/image references use normal chat attachments or an explicitly supplied safe path; never ask for uploads through a text-only question tool or upload evidence to a new service.

## Researched host elements and limits

Reviewed 2026-10-26 against the official references below, the tools exposed to this session, and offline protocol schemas generated by Codex CLI 0.164.0. Model-callable fields, client protocol fields and SDK customization are different surfaces. Recheck the actual interface when using an element; do not pass protocol-only fields to a model tool or infer UI support from a response type.

| Element | Claude | Codex | Helm use |
|---|---|---|---|
| Question and compact heading | `question`, `header` (12 characters). | Blocking tool: `question`, `header` (12 characters), unique `id`; async tool here: self-contained `title`. | Single/Multi/Input/Review wording; retain explicit identities outside short headers. |
| Option text and explanation | `options[].label`, `description`. | Blocking tool: same; async tool here: option strings. | Preserve meaning; show tradeoffs outside the card when the schema lacks descriptions. |
| Single and multiple choices | `multiSelect: false/true`. | Neither question tool exposed here declares a Multi switch; protocol `answers: string[]` alone proves no multi-select UI. | Preserve the form through the ordered native alternatives, including bounded membership questions for Multi; then the baseline. |
| Questions/options per call | 1–4 questions, 2–4 choices each. | Blocking tool here: 1–3 questions, 2–3 mutually exclusive choices each. Async here accepts one or more questions and optional options; obey any tighter host guidance. Protocol arrays do not establish model-tool limits. | Respect caller limits and current schema; no dummy choices or truncated lists. |
| Other/custom input and notes | Other/notes accept custom text; SDK per-question answers can contain that text. | Blocking client adds Other; async client here always allows free text. Protocol has `isOther`. | Input with real candidates, scope refinements and explanations; do not add duplicate Other options. |
| Pure free text | Native multiple-choice tool requires genuine options; ordinary conversation remains available. | Async here can omit options. Protocol nullable `options` is not proof the blocking model tool permits omission. | Input uses an exposed free-text tool, genuine candidates plus custom text where equivalent, then the baseline. |
| Recommendations/defaults | Recommended label/order is presentation; no general model-callable default field is established by these references. | Blocking tool recommends first; async client here preselects first. MCP can declare defaults. | Inform, never assume an answer or approval. |
| Visual previews | SDK `toolConfig.askUserQuestion.previewFormat` enables optional option `preview`: Markdown or HTML. Not guaranteed in CLI/tool schema; SDK rejects script/style/doctype in HTML. | Neither question tool here exposes previews. | Use only for a meaningful visual comparison when already supported; show diff/content in conversation otherwise. No added UI assets/configuration. |
| Return values and general replies | SDK `answers` keyed by question text; Multi labels as array or joined labels; optional general `response` can replace the per-question list. | Blocking result maps question IDs to answer arrays; async answers arrive later as user messages. Protocol also carries thread/turn/item IDs. | Match the real question/context; preserve notes and general steering. An accepted transport result is not an answer. |
| Waiting and lifecycle | Default question waits; SDK callback can remain pending and supports deferred-hook continuation. Agent-spawned SDK subagents lack the question tool. | Mode/tool availability varies; async does not wait. Protocol has `isBlocking`; requests can be resolved/cleared on answer, turn completion or interruption. | Parent-only questions; wait for required replies, reconcile cancellation/interruption and late responses. No new resume state. |
| Timeout | Client `askUserQuestionTimeout` optionally auto-continues; not a per-question approval field. Permission/plan prompts are separate. | Protocol has `autoResolutionMs` (deprecated in CLI 0.164.0 in favor of `isBlocking`); model tool may not expose either. | No timer/settings edits; no timeout-generated consent. |
| Masked, numeric, date, file inputs | Native tool has no general typed-form/file-upload contract in these references. | Protocol has `isSecret`, not exposed by the question tools here. No upload field in either tool. | No secrets. Use Input for nonsecret typed values and validate expected units/format; attachments stay in chat. |
| Native execution/plan approvals | Permission prompts, `canUseTool`, `EnterPlanMode`/`ExitPlanMode` are host control surfaces. | Permissions/approval requests and collaboration modes are host control surfaces. | Preserve their independent gates; never substitute them for a workflow answer or switch modes just to ask. |

### MCP forms are a separate optional integration

Both clients document MCP elicitation. It is not a built-in Helm question tool and is not installed, configured or called by this Markdown contract. A future already-authorized integration must verify client capability, supported schema and actual rendering before using it; the protocol does not mandate a particular UI. Ordinary host tools/fallback remain available without an MCP dependency.

The standard form elements are: object `properties`/`required`; field `title`/`description`/`default`; string with `minLength`/`maxLength` and `email`/`uri`/`date`/`date-time` formats; number/integer with `minimum`/`maximum`; Boolean; single enum via `enum` or titled `oneOf`/`const`; multiple enum via array `items.enum` or titled `items.anyOf`/`const`, with `minItems`/`maxItems`. Legacy `enumNames` exists but is deprecated. Nested objects and general arrays are not portable form inputs. These cover typed Input, Single and Multi without making defaults into consent.

MCP also carries request message/schema and identity, and separate `accept`/`decline`/`cancel` responses with submitted `content`. URL mode uses `url`/`elicitationId` for external flows; it is not an ordinary Helm question or permission to navigate/upload. Codex additionally documents gated `openai/form`; its generated schema includes legacy `openaiForm` and device-proof `openai/userVerification` extensions plus `_meta`. These are client/integration surfaces, not model-callable QM fields or a way to collect secrets/bypass approval. No custom HTML, form server, device verification or OAuth flow is introduced here.

## Evidence

- [Claude question behavior and timeouts](https://code.claude.com/docs/en/tools-reference#askuserquestion-tool-behavior).
- [Claude question fields, responses, previews and SDK limitations](https://code.claude.com/docs/en/agent-sdk/user-input).
- [Claude MCP elicitation](https://code.claude.com/docs/en/mcp#respond-to-mcp-elicitation-requests).
- [Codex user-input and lifecycle protocol](https://learn.chatgpt.com/docs/app-server#toolrequestuserinput) and [MCP requests](https://learn.chatgpt.com/docs/app-server#mcp-server-elicitation-requests).
- [MCP form fields and interaction contract](https://modelcontextprotocol.io/specification/2025-11-25/client/elicitation).
- Local schema evidence: `codex app-server generate-json-schema --experimental --out <temporary-directory>`; inspected `ToolRequestUserInputParams/Response` and `McpServerElicitationRequestParams/Response`. This generated schemas only, called no models and read no consumer ledger. Tool schemas and client behavior can differ by version.
