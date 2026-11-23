<!-- shared-helper-standard:start -->
# Mechanical helper maintenance

Use this standard when developing or reviewing the project's mechanical helpers and their callers, in any language. Helpers exist to save agent work, reduce context and tool overhead, or make mechanical results more consistent and accurate. This is maintainer guidance, not a per-command audit or runtime prerequisite.

## When a helper is justified

Prefer existing native tools for straightforward work. Add or expand a fixed helper only for a concrete recurring mechanical job that those tools cannot handle simply and reliably. Identify the manual work it replaces and consider the complete cost: invocation, input preparation, output size, loaded instructions and maintenance. A smaller script or fewer calls alone does not establish an improvement.

Reuse a suitable existing helper before adding another implementation. Keep each operation focused, such as parsing, filtering, exact comparison, counting, retrieval or applying an already-approved data map. Avoid general frameworks, wrappers and speculative capabilities without a demonstrated need.

## Implementation boundary

- Use explicit bounded inputs and predictable, compact structured results. Preserve exact identities, numbers and unknown data where the operation requires them; report unsupported or invalid input without silently truncating it or exposing secrets.
- Keep interpretation, priorities, selections, approvals and workflow decisions with the agent. A helper may validate structure or perform a specifically authorized mechanical operation; it cannot establish human consent, semantic coverage or publication correctness.
- Match access and side effects to the named job. Use stdin/stdout when sufficient; filesystem work needs explicit scope and the owning procedure's protections. Preserve required state validation, digest binding, recovery evidence and readback. Simplification must not remove guarantees the job actually needs.
- Keep policy and orchestration in the owning instructions. Add no helper-driven workflow phase, setup requirement, cache, tracking system, dependency or approval gate merely to support the helper itself. Combine redundant calls and avoid repeating validated work while preserving required coverage and fresh checks.

## Other executable code

Website behavior, build tooling, packaging checks and tests serve their own product or maintainer purposes. Assess them against those purposes rather than treating every script as a command-time helper. They do not become extra consumer prerequisites. Reviewed tests may create controlled executable fixtures in disposable environments; this grants no permission for dynamic helpers during ordinary workflow execution.

## Review and verification

Review the affected implementation and callers together. Keep, simplify or remove code based on its actual job and required guarantees, preserving useful existing behavior and test protection. Use focused existing checks; add coverage for meaningful new behavior or risks rather than mirroring implementation details.

Use comparable measurements when claiming speed, context or call savings. Source size, loaded context, mechanical execution time and end-to-end model latency are different evidence. Report relevant verification limits in the normal handoff; require no new inventory, benchmark, report artifact or runtime enforcement system merely to follow this standard.

The project-specific requirements below identify local contracts and their owners. Maintain them alongside this shared guidance without weakening either project's execution, state or approval boundaries.
<!-- shared-helper-standard:end -->

## Project-specific requirements

The shared runtime's [Mechanical helpers and temporary scripts](../../prompts/shared/runtime.md#mechanical-helpers-and-temporary-scripts) owns Helm's command-time execution boundary. Develop helpers only during authorized source maintenance; routine workflow execution permits no dynamically generated helper programs.

- Keep ledger validation/retrieval read-only and digest-bound. Normalize's syntax/graph checker remains a pure stdin/stdout operation without Git, file or network access. Helpers do not execute project code or establish semantic review coverage.
- Private recovery locator and retention I/O keeps its bounded paths, immutable evidence and owning Normalize/Ship procedures. Maintaining source never grants access to real operational records, locators or recovery contents.
- Preserve exact policy/data identities, unknown fields and applicable schema validation. Use the existing synthetic ledger, normalize and handoff/retention checks for affected contracts; model smoke checks remain separately selected.
