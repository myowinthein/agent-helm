---
title: "Step 3: Postman Collection"
parent: /helm:archive
grand_parent: Commands
nav_order: 3
---

# Step 3: Postman Collection

Preserve a useful API recovery collection when the project owns a REST, GraphQL or similar API. Discover actual method/path/operation identities from source/routes/specs. A broad frontend/library label does not rule out an owned API; third-party integrations alone do not qualify.

Owned frontend-hosted routes, serverless/BaaS functions and inbound webhooks qualify when they expose an actual API contract. Direct client-SDK database access or server actions without a stable HTTP contract do not justify inventing endpoints.

Normal mode reads the verified Step 1 and 2 reports and records this step's approved report in the same [validated run directory](../archive.html#archive-directory-and-existing-projects): canonical `.helm/archive/` only. Postman deliverables stay under the approved recovery path, outside state storage.

## Reuse and output

Choose **Retain / Repair / Create / Skip** within the existing stage plan, reusing exact unchanged approval. Keep a useful collection at its current path, repair evidenced gaps, create only useful missing coverage, or explicitly skip with reasons/limits. Retain existing owned specs, custom examples and descriptions. Link canonical specifications at their original paths; no forced recovery copy or multiple client formats.

For creation, prefer an evidenced current OpenAPI contract where useful, cross-checking implementation/routes, validation and auth. Routes alone do not establish bodies/auth/expected behavior, and stale specs do not settle conflicts. Record disabled/deprecated/uncertain endpoints and gaps without silently changing API contracts. Preserve native specs for protocols unsupported by Postman v2.1 and explain the limits instead of forcing conversion.

Normally write safe slugged paths:

- `recovery/postman/{project-name}.postman_collection.json`
- `recovery/postman/{project-name}.postman_environment.json`, only when separate environment selection adds value beyond collection variables.

Collection variables alone are enough when they meet the need; no empty environment companion is required. These are defaults for new outputs, not renamed paths for retained collections.

Check existing-path collisions and protected imports before any write. Generate new collections as v2.1; retaining a usable existing collection does not require conversion. Bruno also supports v2 imports; format support does not guarantee every imported script/dependency behaves identically. See [Bruno's migration guide](https://docs.usebruno.com/get-started/import-export-data/postman-migration).

Export local base-URL placeholders, expected request examples, auth instructions and evidenced happy/error behavior. Inspect environment/current values, headers, URLs, saved responses and scripts; no real credentials, private records or runtime tokens, including local generated tokens, are persisted. Approved request auth remains ephemeral. Do not blindly run existing scripts or install their dependencies.

## Verification choices

Step 2's running status is historical. Revalidate this host's actual isolated project/runtime, owned data target and endpoint before approved requests. An open port is insufficient; no credentials or redirects to unidentified/unapproved hosts. Unavailable identity/access uses source-only generation with requests unverified, without automatically repeating restoration.

Choose meaningful representative requests based on actual risk/value, including relevant auth/domain/error behavior. GET, health and login endpoints can have effects; inspect handlers/integrations instead of assuming safety by verb. Existing approvals remain required for destructive/data/import/external-message/payment/bulk actions. There is no one-GET-per-area or endpoint-percentage quota.

When verification is deferred, make no requests/client-script runs and report that plainly. Static discovery/import format is not executed endpoint verification or complete test coverage.

## Report and stop

With no owned API, give a short factual report containing `Postman collection generated: no`, the scope/evidence, reason and no-files/no-requests result. Keep normal report approval; never skip silently.

For applicable APIs, report `Postman collection generated: yes/no`, the actual Retain/Repair/Create/Skip outcome, existing collection/spec preservation and paths, discovered/excluded identities, auth setup, exact files, actual verified requests, unverified reasons and limits. A retained unchanged collection may have generated: no; Step 4 uses actual outcomes/paths as well as that fixed flag. Explicit Skip is distinct from no applicable API. No commit/push. Stop for explicit approval before Step 4. See the [archive guide](../archive.html) for modes and protected inputs.
