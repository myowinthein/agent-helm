# Mechanical helper audit

Baseline: `2d485f2`. This is a maintainer review record, outside the installed package and runtime context. It creates no command, rule, ledger or per-invocation audit requirement.

## Scope and boundary

The initial inventory covers all 46 then-tracked Python, Ruby, JavaScript/MJS and Rake sources, their command/build/test callers, the CI shell blocks and setup redirect/head integration. Runtime implementations, workflow consumers and execution wrappers were reviewed; test contracts and existing protection were assessed separately. Dependencies, generated site/cache content and operational records are outside the source inventory. The EduQuest incident supplied the already observed failure example; this work makes no changes to that project/session.

The single agent-facing boundary is [Mechanical helpers and temporary scripts](../../prompts/shared/runtime.md#mechanical-helpers-and-temporary-scripts). Helpers do named mechanical work; agents retain interpretation, decisions and authority. Native tools serve straightforward tasks. The stricter follow-up prohibits generated helper/probe/orchestration code, including inline programs and executable heredocs. Native queries and reviewed packaged helpers remain available; structured requests and message maps are data. Approved project code/tests remain outputs. Replacement validators, tracking frameworks and extra gates are not permitted. Data transport is lossless and an evidenced invocation/argument or data-delivery mistake in an existing read-only tool call has one bounded correction without code creation/editing. Real blockers, protected state, approvals, source coverage and recovery proof retain their protections.

## Decisions

| Action | Change and reason |
|---|---|
| Keep | The three runtime jobs: ledger structure/retrieval, normalize syntax/graph selection and private locator I/O. Each replaces a concrete mechanical operation. Filesystem/strict-data protections defend actual records; removing them would weaken the job rather than simplify its surrounding process. |
| Remove | The long equivalent-validator recipe and repeated fallback explanations that encouraged agents to build a second implementation during consumer work. Existing verified equivalent tools remain eligible under the same contract. |
| Remove | Mandatory check-then-view sequencing and parser/setup work for proven absent records. Record writes still require complete validation. |
| Update | Initial `ledger-view` now validates and returns a bound page in one call. Subsequent pages and snapshot-bound work still require the returned digest; invalid input/state and drift remain errors. Existing callers remain compatible. |
| Update | Shared instructions prohibit dynamic helper creation, preserve exact transported data and distinguish a malformed existing tool call from an established blocker. Env uses Git readiness and relevant content checks rather than an invented metadata-snapshot framework. |
| Remove | Duplicate process wrappers/temp output plumbing in the two older model smoke runners. They now reuse the existing bounded runner, including its tested process-group timeout cleanup. |
| Keep | Packaging/native-discovery tools, offline tests, opt-in model fixtures and website code serve distinct maintainer/product jobs. They are not run as extra consumer helper phases. No broad rewrite or new framework is justified by their language or size. |
| Update | Disable incidental automatic Git maintenance/GC in disposable fixture commands after a background lock disappeared during fixture cleanup. This changes no user/global Git configuration. |
| Add | The initial cleanup added first-view/continuation/missing-state regressions without a new runtime module. The stricter follow-up moves normalize's existing inline callback into a fixed packaged file and adds a bounded dotenv key extractor, so neither job needs generated programs. The extractor is lexical only, not a project scanner or environment auditor. Native UUID/path operations replace inline setup instructions. No writer, state schema, cache, dependency or model service is introduced. |

## Code inventory

All rows are retained for their stated purpose; the changed ledger implementation and smoke runners are identified above. The table now also records two fixed helpers added by the stricter follow-up (48 sources total). Maintainer test fixtures may generate controlled scripts to exercise existing protocols in disposable repositories. That is reviewed test code, not a consumer permission to improvise another protocol.

| Source | Purpose |
|---|---|
| `Rakefile` | Offline test entry points; no model calls. |
| `docs/_plugins/asset_digest.rb` | Content-based versions for published static assets. |
| `docs/_plugins/frontend.rb` | Build-time static diagrams, initial theme and deferred search integration. |
| `docs/_plugins/repository_content.rb` | Render shared README/icon/version without maintained content copies. |
| `docs/assets/js/guide-nav.js` | Keep the correct Overview navigation entry active on a Details page. |
| `docs/assets/js/setup-tabs.js` | Accessible setup tabs, keyboard navigation and fragment selection. |
| `docs/assets/js/theme-switcher.js` | System/light/dark selection and the existing site-specific preference. |
| `docs/scripts/browser.mjs` | Shared loopback serving, Chrome resolution and origin confinement. |
| `docs/scripts/browser_acceptance.py` | Opt-in local preview with synthetic browser-storage fault controls. |
| `docs/scripts/docs_checks.rb` | Published URL mapping and built setup fallback/anchor checks. |
| `docs/scripts/render-diagrams.mjs` | Batch Mermaid-to-SVG rendering using installed Chrome on loopback. |
| `docs/tasks.rb` | Docs build, links and explicit frontend-check tasks. |
| `docs/tests/browser_frontend.mjs` | Isolated Chrome assertions for setup, navigation, themes, search and diagrams. |
| `docs/tests/check-theme-colors.mjs` | Shared computed-color/contrast assertions used by browser tests. |
| `docs/tests/guide_pairs.rb` | Discover authored Overview/Details pairs for docs checks. |
| `docs/tests/test_asset_digest.rb` | Stable digests, changed assets and unpublished-asset rejection. |
| `docs/tests/test_docs_links.rb` | Internal/canonical URL mapping and external/lookalike exclusion tests. |
| `docs/tests/test_docs_workflow.rb` | Docs CI/build and publication boundary regression tests. |
| `docs/tests/test_frontend.rb` | Theme/search/static-diagram source contracts. |
| `docs/tests/test_guide_views.rb` | Built guide depth selectors and navigation/anchor relationships. |
| `docs/tests/test_human_guides.rb` | Authored pair inventory, source references and no raw-prompt embedding. |
| `docs/tests/test_repository_content.rb` | Shared homepage/icon/version output and canonical public URLs. |
| `helpers/env_keys.py` | Bounded stdin-only dotenv key/classification projection; skips multiline value text and refuses unsupported syntax without echoing values. |
| `helpers/helm.py` | Dispatch the fixed ledger operations and report runtime/package errors. |
| `helpers/helm_lib/__init__.py` | Package marker. |
| `helpers/helm_lib/common.py` | Strict, exact JSON and bounded no-follow reads of permitted records. |
| `helpers/helm_lib/ledger.py` | Validate one owning ledger and return a compact, digest-bound selection. |
| `helpers/normalize_callback.py` | Fixed filter-repo callback applying only the approved UTF-8 original-ID/message map; added by the stricter follow-up. |
| `helpers/normalize_check.py` | Check message structure and calculate graph/baseline review membership. |
| `helpers/normalize_handoff.py` | Register immutable private recovery locators and discover bounded metadata. |
| `scripts/acceptance_cases.rb` | Predeclared synthetic inputs, exact approvals and expected outcomes. |
| `scripts/acceptance_support.rb` | Trace validation, outcome oracles and bounded process execution/cleanup. |
| `scripts/check_clients.rb` | Opt-in native discovery in temporary installations; no model execution. |
| `scripts/git_acceptance.rb` | Independent graph, rewrite, bundle and publication oracles for disposable fixtures. |
| `scripts/smoke_acceptance.rb` | One opt-in bounded model scenario with file/ref/trace oracles. |
| `scripts/smoke_layout.rb` | Opt-in model scenarios for instruction ownership and reviewed layout changes. |
| `scripts/smoke_support.rb` | Disposable fixture construction, exact file/Git comparisons and safe artifact reads. |
| `scripts/smoke_workflows.rb` | Opt-in model scenarios for command gates and preserved consumer inputs. |
| `scripts/test_acceptance_oracles.rb` | Exercise lifecycle, normalization and publication oracles with synthetic Git data. |
| `scripts/test_acceptance_support.rb` | Trace/canary controls and actual bounded-runner timeout cleanup tests. |
| `scripts/test_git_acceptance.rb` | Negative controls for independent rewrite and publication proofs. |
| `scripts/test_ledger.py` | Own-record isolation, strict parsing, exact numbers, retrieval and drift tests. |
| `scripts/test_normalize.py` | Synthetic syntax, policy, graph and baseline-selection tests. |
| `scripts/test_normalize_handoff.py` | Disposable private-path, atomic locator and worktree/clone tests. |
| `scripts/test_plugin.rb` | Package relocation/export and resource regression tests. |
| `scripts/test_smoke_support.rb` | Positive/negative controls for fixture preconditions and preservation checks. |
| `scripts/test_support.rb` | Minimal assertion helpers for offline tests. |
| `scripts/validate_plugin.rb` | Check package identity, discovery, resource links, icon and structural contract. |

CI shell blocks only install locked docs dependencies, resolve the selected theme, call existing checks and publish the built site under their existing triggers. The inline setup redirect preserves old URL fragments; the head include loads existing site assets. None is a command-time agent helper.

## Evidence and limits

The ledger comparison used the same synthetic schema-3 shape with 1,000 records, five local runs per route and 20 returned index rows. It used disposable consumers and no models/network:

| Route | Helper invocations | Median local time | Response bytes |
|---|---:|---:|---:|
| Check then view | 2 | 0.163 s | 5538 |
| Initial view | 1 | 0.084 s | 4982 |

This establishes a smaller mechanical call path, not end-to-end command speed, model token counts or a client latency guarantee. The existing shared runner has offline timeout/preservation controls; live model scenarios remain opt-in and were not used for this change.

Whitespace word counts below record the initial cleanup, before the stricter follow-up. They describe authored context, not tokenizer output or quality. Actual loaded context depends on the selected route.

| Instruction source | Before words | After words |
|---|---:|---:|
| `prompts/shared/runtime.md` | 1883 | 1837 |
| `prompts/shared/ledger-helper.md` | 2110 | 1092 |
| `prompts/shared/project-state.md` | 733 | 696 |
| `prompts/refactor-ledger.md` | 2080 | 1996 |
| `guides/refactor.md` | 8256 | 8232 |
| `guides/test.md` | 9656 | 9665 |
| `guides/env.md` | 4178 | 4200 |
| `prompts/shared/normalize-handoff.md` | 993 | 996 |
| `prompts/shared/content-sync.md` | 872 | 889 |
| `guides/normalize.md` | 7642 | 7655 |

Initial validation passed: package/relocation/export checks; 39 normalize, 18 handoff and 28 ledger tests; smoke and acceptance-support/oracle groups; docs/source/link/build checks and 220 Chrome assertions. The first combined run found the fixture maintenance race described above; the affected suite and all remaining checks passed after the scoped fix.

The stricter follow-up passed the full offline suite: package checks; 41 normalize, 18 handoff and 28 ledger tests; 20 smoke-support, 16 acceptance-support and four direct acceptance-oracle groups; docs/source/link/build checks and 220 Chrome assertions. New controls cover dotenv value confidentiality, multiline/unsupported input, common inline-program trace forms and callback exact-ID/cache/invalid-data behavior. Disposable backend fixtures also use the fixed callback. No models were called.

These checks validate implementation and preserved contracts. They do not prove that every future model session follows the instructions. The dynamic-script failure is addressed through the shared instruction boundary and fixed mechanical helpers, without a runtime enforcement system. The earlier measurements describe only the initial cleanup; no end-to-end speed claim is made for this follow-up.
