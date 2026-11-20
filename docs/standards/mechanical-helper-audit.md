# Mechanical helper maintenance

Use this standard when developing or reviewing Helm's mechanical helpers and their callers, in any language. Helpers exist to save agent work, reduce context and tool overhead, or make mechanical results more consistent and accurate. This is maintainer guidance, not a per-command audit or runtime prerequisite.

## When a helper is justified

Prefer existing native tools for straightforward work. Add or expand a fixed helper only for a concrete recurring mechanical job that those tools cannot handle simply and reliably. Identify the manual work it replaces and consider the complete cost: invocation, input preparation, output size, loaded instructions and maintenance. A smaller script or fewer calls alone does not establish an improvement.

Reuse a suitable existing helper before adding another implementation. Keep each operation focused, such as parsing, filtering, exact comparison, counting, retrieval or applying an already-approved data map. Avoid general frameworks, wrappers and speculative capabilities without a demonstrated need.

## Implementation boundary

- Use explicit bounded inputs and predictable, compact structured results. Preserve exact identities, numbers and unknown data where the operation requires them; report unsupported or invalid input without silently truncating it or exposing secrets.
- Keep interpretation, priorities, selections, approvals and workflow decisions with the agent. A helper may validate structure or perform a specifically authorized mechanical operation; it cannot establish human consent, semantic coverage or publication correctness.
- Match access and side effects to the named job. Use stdin/stdout when sufficient; filesystem work needs explicit scope and the owning procedure's protections. Preserve required state validation, digest binding, recovery evidence and readback. Simplification must not remove guarantees the job actually needs.
- Keep policy and orchestration in the owning instructions. Add no helper-driven workflow phase, setup requirement, cache, tracking system, dependency or approval gate merely to support the helper itself. Combine redundant calls and avoid repeating validated work while preserving required coverage and fresh checks.

The shared runtime's [Mechanical helpers and temporary scripts](../../prompts/shared/runtime.md#mechanical-helpers-and-temporary-scripts) is the single command-time boundary, including the prohibition on dynamically generated helper programs. Develop helpers only in an authorized source-maintenance task; routine workflow execution does not grant that authority.

## Other executable code

Website behavior, build tooling, packaging checks and tests serve their own product or maintainer purposes. Assess them against those purposes rather than treating every script as a command-time helper. They do not become extra consumer prerequisites. Reviewed tests may create controlled executable fixtures in disposable environments; this grants no permission for dynamic helpers during ordinary workflow execution.

## Review and verification

Review the affected implementation and callers together. Keep, simplify or remove code based on its actual job and required guarantees, preserving useful existing behavior and test protection. Use focused existing checks; add coverage for meaningful new behavior or risks rather than mirroring implementation details.

Use comparable measurements when claiming speed, context or call savings. Source size, loaded context, mechanical execution time and end-to-end model latency are different evidence. Report relevant verification limits in the normal handoff; require no new inventory, benchmark, report artifact or runtime enforcement system merely to follow this standard.
