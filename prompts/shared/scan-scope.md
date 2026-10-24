# Shared scan-depth selection

For log, manifest, test and refactor only, when the caller already reaches a Full scan / Gap scan depth choice. This is a recommendation checklist, not a scanner, state loader or checkpoint writer. Use Full scan / Gap scan consistently; unsupported former mode names need scope clarification. The caller's required investigation depth and checkpoint semantics remain distinct.

## Caller boundaries and supplied facts

Apply only within otherwise valid caller inputs. The caller resolves instruction ownership, parses any permitted own-state inputs and reports blockers first. Malformed/unsupported state or conflicting histories/ownership remain blockers to dependent work, not missing baselines to reset. Independent advisory source review remains available only under the caller's own rules.

Use facts the caller was already permitted to obtain in the current mode:

- Explicit supported request, target/scope, available alternatives and applicable write/read-only prerequisites.
- Actual inspected source snapshot (or its unavailability), applicable review anchor and its validation result.
- Cheap relevant impact evidence, known prior-coverage limits and retained requested/backlog work. Missing evidence stays unknown.

This prompt grants no additional reads or writes. Never discover/load another command's state, perform deep history investigation beyond the caller's existing cheap preflight merely to populate a picker, create metadata/configuration, or fetch/hydrate missing objects. Settings/layout preparation, structure/style repair, targeted and backlog paths gain no baseline or helper prerequisite. Read-only recommendations use only that caller mode's permitted facts; in particular, refactor Audit/Plan do not load operational state.

## Baseline-validity checklist

The caller's local-only inspection must establish that an applicable anchor is a literal hexadecimal commit identity, resolves unambiguously to an available commit object and is an ancestor of the relevant inspected source. Respect its existing abbreviation rules and scope/provenance limits. Do not interpolate file text into shell code or accept arbitrary revision expressions/options. Failed reads/comparisons are unknown, never empty diffs or successful coverage.

An absent/malformed/unavailable/divergent review anchor within otherwise valid inputs is unusable for Gap scan. Do not guess HEAD~1, rewrite anchors, fetch history or borrow another target/branch's checkpoint. Valid endpoints alone do not prove that all required intervening evidence is available or reviewed. Technical ancestry is not proof of when Full scan last happened or of current runtime/external facts.

## Select and explain depth

| Supplied facts | Recommendation |
|---|---|
| Explicit supported depth/scope | Honor it under the caller's prerequisites. Explicit Full scan remains Full scan even without a source gap; narrower work stays narrow. An explicit Gap scan request cannot make an unusable anchor valid. |
| Unusable anchor within otherwise valid inputs | Recommend Full scan of the caller's relevant scope, with its existing repair/targeted/report-only/backlog/Skip alternatives where independently eligible. Do not offer a fictitious Gap scan or bypass a caller blocker. |
| Valid baseline and bounded evidenced impact | Recommend Gap scan, following the caller's complete affected-surface coverage contract. |
| Valid baseline and credible broad changes or insufficiently bounded impact/coverage | Recommend Full scan and state the evidence. This is not a silent upgrade or edit approval. |
| Supported evidence of no source gap | Return that fact to the caller; it alone is not a no-op or completion decision. |

Broad impact can include added/removed first-party services/packages, major runtime/framework/build changes or material cross-area contracts and dependencies, interpreted against the caller's purpose. A local uncertainty may instead need clarification or an existing scoped review. A commit label/path count alone cannot establish significance or dismiss a change. Keep depth selection cheap; detailed coverage is the selected investigation's job.

Age, commit/file counts and numbers of Gap scans are context only, never depth triggers on their own. Do not add a threshold/counter, infer scan age from Git author dates, or use commit distance as a scan count. Unknown Full-scan history does not mean no Full scan occurred; use only the caller's established prior-coverage facts. A plugin update alone does not require a new Full scan.

A missing target may need caller-specific generation; a missing heading/adapter may need a narrow repair. Neither automatically requires a project-wide scan. Open backlog alone does not force Full scan. The caller checks pending findings, lessons, settings, explicit review requests and any external-freshness conditions before its own no-op decision.

With a valid anchor, explicitly requested Gap scan can cover broad changes completely, though it may cost more. Never omit known affected surfaces to make it appear bounded. If required evidence is unavailable or inspection remains incomplete, report that and return to the caller's unchanged completion rules. Full scan does not restore missing local objects.

## Return to the caller

Explain briefly: recommended existing mode, observed reason, actual review scope/limits and independently eligible alternatives. For example: "Gap scan recommended: the validated range affects one reader workflow; Full scan or Skip is also available." Do not fabricate counts, prior coverage or a no-change result.

Reuse explicit mode selections; otherwise use the caller's existing question/fallback. Preserve independent choices above the native four-option limit through existing paging/chat, never merging report-only with Cancel or silently truncating choices. A recommendation, default, silence or timeout is not consent.

Full scan is a review scope, not permission to replace files, run every test or execute effects. The caller alone owns investigation depth, branch/safety/approval gates, no-op handling and persistence: log/manifest retain their acceptance-and-marker rules; test retains separate assessment/case-closure checkpoints; refactor retains its scan/backlog history. This helper changes none of them and is not automatically loaded by the shared runtime.

Detailed investigation uses [shared investigation evidence](investigation-evidence.md) only at the caller's selected investigation step, never as an added preflight or no-scan prerequisite. It does not change this selector's permissions.
