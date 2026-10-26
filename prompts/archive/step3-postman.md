# Step 3 — Generate Postman Collection

Preserve useful API recovery files when the project owns an API. Read verified `{archive_root}/step1-explore.md` and `{archive_root}/step2-restore-and-freeze.md` as historical context, using only the root validated by the orchestrator; missing/mismatched reports stop dependent work.

## Applicability and preservation

An owned REST, GraphQL or similar API qualifies, regardless of the project's broad frontend/backend label. Include owned frontend-hosted server routes, serverless/BaaS functions and inbound webhooks when they expose an actual API contract. Third-party consumption, direct client-SDK database access or server actions without a stable HTTP contract do not justify inventing endpoints. With no applicable API, output the not-applicable report below and keep the normal report approval.

Choose **Retain / Repair / Create / Skip** within the existing approved stage plan: retain a useful collection at its current path; repair evidenced gaps while preserving customization; create only when useful recovery coverage is missing; or explicitly skip with the reason/limitations. Reuse still-applicable exact approval instead of adding another picker. Skip for an applicable API is distinct from not applicable, and retained files need no redundant recovery copy.

Reuse existing Postman collections/specifications and useful examples/customization. For creation, prefer an evidenced current OpenAPI contract when useful, cross-checking implementation/routes, validation and auth. Routes alone do not establish request bodies, auth or expected behavior; neither does an unverified stale specification. Record conflicts/unknowns rather than silently changing the API contract.

Discover actual method/path/operation identities and disclose disabled/deprecated endpoints. Avoid duplicates; GraphQL operations sharing a URL are not automatically the same request. Preserve canonical source specs at their paths and link them from recovery docs. Do not require extra client formats or force unsupported protocols into Postman v2.1; link useful native specs and document the limits.

Apply the orchestrator's protected-import check before any collection/spec/example write. Review existing target conflicts and proposed diffs, retaining custom requests unless a specific approved repair requires changes. Record exact output changes in the inventory. No commit, push, dependency installation, automatic runtime restart or other workflow invocation.

## Secret-free, portable output

Use the explicit `Project name:` from Step 1 to select a safe lowercase hyphenated filename, normally:

- `recovery/postman/{project-name}.postman_collection.json`
- `recovery/postman/{project-name}.postman_environment.json` only when separate environment selection adds value beyond collection variables.

These are defaults for new outputs, not relocation instructions for retained files. Use collection variables alone when sufficient; do not create an empty environment companion.

Review empty/ambiguous slug or existing-path collisions, reject escaping/symlinked unsafe destinations, and use approved alternate paths for protected imports. For new collections, generate Collection Format v2.1 with schema `https://schema.getpostman.com/json/collection/v2.1.0/collection.json`; retaining a usable existing collection does not require conversion. v2.1 is the preferred new output; Bruno supports importing both v2 and v2.1, so do not claim v2 is inherently incompatible. Import format support is not proof that every script/dependency behaves identically across clients.

Organize by actual functional area and include useful descriptions, local base URL placeholders, parameter/body examples, auth setup and expected happy/error results where evidenced. Review/redact collection/environment/current values, examples, saved responses, URLs, headers and scripts. No real credentials, tokens (including generated local runtime tokens), private records or production endpoints are persisted. Requests may use approved ephemeral local auth in memory; exported variables remain empty/placeholders, with reproducible local auth instructions.

Inspect existing collection/pre-request/test scripts before any execution. They may invoke additional hosts, dependencies or effects; importing/reusing a file does not authorize those actions. Source-derived generation and static format/reference review remain available without running the API or client.

## Verification by value and actual effects

Treat Step 2's `App running:` status as historical. Before any approved request, establish this host's current isolated project/container/process identity, owned data target and exact local endpoint. A reachable port is insufficient. Do not follow redirects to unapproved hosts or send credentials to an unidentified service. Missing/uncertain runtime access uses source-only discovery and marks requests unverified; never automatically repeat restoration after a host/session change.

Choose representative requests based on actual project value/risk, such as relevant auth/authorization, a useful domain read/workflow and an error case. These are examples, not a mandatory one-of-each quota. GET/health/auth handlers can mutate data, enqueue work or contact services: inspect their effects and isolation, not HTTP verb alone. Destructive operations, imports, external messages/webhooks/payments/bulk actions require their existing exact-target approval and must not be exercised merely to increase coverage. Do not impose one GET per area or a verified-endpoint percentage floor.

Honor explicit verification deferral; make no requests or client-script runs when deferred. Report actual selected identities, inputs without sensitive values, outcomes, exclusions and unverified reasons. Static discovery/import-format validity does not certify endpoint behavior or comprehensive test coverage.

## Report

For a project with no owned API, use the following report:

## Applicability
Postman collection generated: no
Reason/evidence that no applicable owned API was found, with inspected scope/limitations. No collection/environment files created and no requests executed.

For applicable projects, preserve the following report sections:

- **Applicability:** on its own line, `Postman collection generated: yes/no`; actual Retain/Repair/Create/Skip outcome and scope. A retained unchanged collection may have generated: no while still providing useful recovery files; record its actual paths. Skip does not mean no owned API.
- **Existing Collection:** existing collections/specs retained, linked or approved for repair, including preserved custom content.
- **Endpoints Discovered:** stable method/path/operation identities, source evidence, excluded/deprecated/uncertain items and scope limits.
- **Authentication:** non-secret method/setup, ephemeral runtime usage if any; exported tokens/values omitted.
- **Files Created or Updated:** exact paths and meaningful changes or pending drafts.
- **Verified Requests:** only requests actually performed, current ownership/isolation checks and actual scoped results.
- **Unverified Requests:** excluded/deferred/unreachable/unsafe requests and reasons; no quotas or blanket success.
- **Known Limitations:** unsupported scripts/import behavior, external dependencies, missing context and remaining gaps.

Preserve the literal `Postman collection generated:` field for Step 4's structured snapshot. Step 4 also uses the actual outcome and retained/updated paths, never this flag alone to infer API applicability or artifact absence. Present the report, including a not-applicable or skipped result, and wait for explicit approval before recording it/proceeding to Step 4. Do not commit or push.
