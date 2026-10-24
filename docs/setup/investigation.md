---
title: Scan investigation and coverage
parent: Setup
nav_order: 7
permalink: /docs/setup/investigation.html
---

# Scan investigation and coverage

Claude and Codex use the same investigation contract. A completed scan describes the evidence actually reviewed at a named source snapshot and depth. Repository access, a file listing, elapsed time, high reasoning effort or a number of findings does not establish complete inspection. Reading everything still cannot guarantee every issue was found.

## Standard scan names

| Command | Current choices |
|---|---|
| log | Full scan / Gap scan |
| manifest | Full scan / Gap scan |
| test | Full scan / Gap scan |
| refactor | Full scan / Gap scan |

Full scan covers the command's entire relevant scope at its required depth. Gap scan covers changes since a valid baseline and their evidenced affected surface, including unchanged consumers. Unsupported request terms need scope clarification; literal paths retain their existing syntax. Audit, Plan, Targeted and Fix Backlog remain independent concepts. The other six commands keep their specialized workflows, without artificial Full/Gap modes.

The [scan-depth selector](compatibility.html#shared-scan-depth-selection) still applies only to the four commands above. It recommends from actual impact and valid provenance, not age, file counts, commit distance or numbers of Gap scans. An explicit Full scan remains Full even without changes. A plugin update alone triggers no scan, reset or retrospective checkpoint invalidation. Older checkpoints retain their historical meaning without certifying that the newer detail contract was satisfied; known coverage gaps can inform the existing recommendation.

## Investigation depth by command

| Command | Required investigation |
|---|---|
| refactor | Full scan reads every eligible human-maintained first-party implementation and test file in full, through bounded sections; scripts and Markdown workflows count when they implement the product. Inspect relevant configuration, schemas and contracts too. Gap/Targeted reviews complete affected logical units and evidenced consumers with enough context, without compulsory whole-file rereads for every small edit. |
| test | Full scan assesses every scoped component's behavior and relevant existing tests in detail, tracing implementation/configuration and cross-component flows. Gap scan assesses impacted behaviors, existing cases and consumers. A coverage percentage, sample test or executable file labelled glue cannot stand in for assessment. |
| log | Full scan traces representative real workflows across every package and knowledge topic, including applicable config/CI and tests, and assesses all existing memory entries. Gap scan accounts for every commit's relevant patches, merge/revert/rename/deletion effects and durable knowledge impact in the validated range. |
| manifest | Trace existing README claims to evidence and sweep reader-facing surfaces for missing requirements, installation/configuration, usage, interfaces and help/policy facts. Gap scan traces changed reader workflows and affected sections. It is not a detailed whole-code audit or log's lesson-history review. |
| env | Assess current scoped service/loader/input families and the eleven existing checks. Inspect loaders/configuration and consumer references under value-free projection, including relevant ignored/hidden env inputs. Dynamic/external references remain explicit uncertainty. |
| legal | Trace the selected service's relevant data, integration and commercial behavior and assess document source changes. Keep business/provider confirmation and current applicable primary legal research separate from source freshness. No-signal or unchanged-source results do not certify compliance or absence of legal need. |
| ship | Review the exact publication scope; release analysis reads all required commit subjects, bodies and footers in the selected release history. Reconcile exact IDs, not recent samples or counts. No unrelated whole-code audit is added. |
| normalize | Review full messages/metadata in the frozen requested audit set, with diffs where intent needs them. Preserve per-branch evidence and keep audit scope separate from the all-affected rewrite graph. |
| archive | Inventory every relevant recovery category and trace required build/runtime/data/service/configuration/docs/asset dependencies. Static coverage does not establish successful restoration, offline recovery or a sealed backup. Resume retains the existing phase/report protocol. |
| adopt | Inspect actual rule bodies, ownership, import chains, versions and complete content differences. Its narrow rule-by-rule procedure does not need an application-source scan. |

## Exclusions follow evidence

Normally exclude third-party dependencies/vendor trees, generated or compiled output, caches, binaries, unrelated runtime data and real user records. Establish ownership and purpose from actual evidence; names, extensions, hidden status and `.gitignore` alone are insufficient. `bin/`, `public/` and `storage/` can contain first-party source. Schemas, migrations, fixtures, deployment/CI configuration and scripts may be essential evidence.

Inspect relevant generator inputs and consumers, and generated artifacts when they are themselves a selected contract or necessary evidence. Ambiguous or hand-maintained source is not silently classified away. Env intentionally discovers relevant ignored/hidden/custom-loader inputs under its value-free procedure. Never expose secret values, real user records or raw sensitive snippets to demonstrate coverage; unavailable safe inspection leaves that part blocked.

Ordinary source scans always exclude `.helm/`, legacy `.claude/helm/`, `.archive/` and known unsupported old operational paths. Only the separately authorized owning procedure accesses its own state. Archive can preserve other records opaquely without parsing or migrating them. Exclusion, outside scope and inaccessible/blocked are reported separately; an unread required area cannot silently count as covered.

## Chunking, workers and parent review

Inventory intended source/history units before discovery, independently of old findings or familiar hotspots. Keep exact path/commit assignments and the remaining queue transient in working context or already available safe structured tooling. No new inventory file, ledger schema, settings or dependency is required. Discovery continues through assigned coverage after several findings; zero findings is valid.

Substantial refactor/test Full scans and large log investigations benefit from permitted read-only subagents. Other large independent scopes may delegate proportionally; small or ordered work, especially ship and adopt, normally stays with the parent. Host, invocation and active project instructions govern availability. Batch limits bound simultaneous work rather than total coverage; test retains at most eight chunks per batch within actual host limits, with further batches as needed. Without workers, cover the same scope sequentially or report incomplete.

Assignments pass actual package/consumer paths, input identity, exact scope/depth, applicable instructions/overrides, relevant policy/decisions, exclusions and safety restrictions. Workers do not necessarily inherit the parent's context. They return findings plus inspected identities/sections, depth, no-finding areas, unresolved relationships and unread remainder. They do not write, mutate Git, operate providers, run project/configuration code, tests, discovery, installers or services, ask the user or access operational records. Sensitive projections stay with the parent; env workers receive only safely filtered evidence. Ordinary source can unexpectedly contain credentials, so workers report safe location/type only and stop affected reads for safe handling.

The parent reconciles exact identities and required depth, not just counts. Reports distinguish full-file reading, tracing, search/context-only evidence, justified exclusions and unmet reads. A partial file read may meet a tracing requirement; unread required material cannot meet a full-file requirement. Giant files use section maps and bounded reads, accounting for truncated output and unread ranges.

The parent also resolves cross-package/interface/configuration/test relationships, reconciles duplicates and prior decisions, and makes risk-based rereads of important findings and questionable no-finding claims. Identical bytes may reuse a read, but different path/module/loader/consumer meanings still need assessment. Dynamic references cannot be dismissed as unused from zero search hits. No separate mandatory verifier or per-file perspective matrix is introduced.

## Evidence and completion limits

Path inventories, commit-set equality and available tool traces support structural accountability. Worker declarations, semantic review, adequate test protection and noise dismissals remain judgments; none is proved by a read log. Context compaction must preserve input identity, coverage evidence, outstanding units/edges and applicable approvals, or missing material must be recovered/reread. No persistent resume framework is added.

Use concise existing reports for scope/depth, covered/excluded/blocked areas, significant evidence and remaining work, without dumping every file or raw log. A Full scan never authorizes executing every test, fixing every finding, migrating state or publishing changes. Existing checkpoints remain command-owned:

- Log/manifest advance markers only under their existing complete-review and content-acceptance rules.
- Test may save supported partial cases without advancing project-wide anchors.
- Refactor writes no incomplete scan checkpoint.
- Specialized commands keep their own source, phase, evidence and approval gates.

Runtime verification remains separate from static assessment. Subagents can reduce elapsed time while increasing total tokens; use them where focused independent investigation justifies the cost.
