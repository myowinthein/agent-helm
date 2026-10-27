---
title: test
parent: Commands
nav_order: 4
---

# test

Find missing protection and maintain useful existing tests. Review the findings, then choose the cases and setup work to implement.

## Start the command

```text
test
```

Use the prefix for your app or terminal from [Setup]({{ '/docs/setup/' | relative_url }}#run-a-command).

Static review works on the current checkout. Edits and recorded assessments need a clean, eligible **main/master, feature, maintenance or confirmed environment branch**.

## Flow

```mermaid
flowchart TD
  Start(["Start test"]) --> Inspect["Identify project behavior,<br/>existing tests and tooling"]
  Inspect --> Scope["Choose Full scan or Gap scan<br/>using valid review history"]
  Scope --> Assess["Review behavior and tests;<br/>report prioritized cases"]
  Assess --> Select["Choose cases and review<br/>the test and setup plan"]
  Select --> Choice{"What should proceed?"}
  Choice -->|Skip| End(["Report findings and pending work"])
  Choice -->|Record findings only| Record["Save the approved assessment"]
  Choice -->|Approved tests and setup| Checkpoint["Save the approved assessment<br/>before implementation"]
  Record --> End
  Checkpoint --> Work["Prepare tools, write or maintain<br/>selected tests and verify results"]
  Work --> Evidence["Record supported case outcomes"]
  Evidence --> End
```

## Choose the review scope

- **Full scan:** assess every scoped component's behavior and relevant tests, including assertions, fixtures and cross-component contracts.
- **Gap scan:** follow changes since a valid saved assessment through affected consumers, tests and configuration. Older open findings remain visible.

A first run, unusable baseline or broad change can call for Full scan. An empty diff does not prove adequate protection. Limited reviews report their limits.

Assessment is static: test discovery, project code and installers are not run merely to find gaps.

## What kinds of tests can it suggest?

Cases cover supported behavior at a fitting unit, component, integration, contract or end-to-end layer. Depending on actual needs, recommendations can include property/fuzz, accessibility, visual, compatibility, security, performance, mutation or recovery checks. Human acceptance work stays distinct from automated results.

Useful existing tests stay by default. A justified plan can **Improve**, **Consolidate**, **Replace** or **Remove** them. Replacement must preserve required guarantees; removal needs proved obsolescence or equivalent remaining protection. Failure or repetition alone does not justify deletion.

## Priorities and your selection

Priority measures the risk left unprotected, separately from implementation cost.

| Priority | Meaning |
|---|---|
| **High** | Severe consequences with credible exposure, or meaningful consequences with high regression likelihood. |
| **Medium** | Meaningful but recoverable failure. |
| **Low** | Useful protection against minor consequences or limited edge cases. |
| **Unknown impact** | A material expectation or consequence needs clarification. |

For larger reports, choose **Recommended**, **All ready proposals**, **Choose cases or groups**, or **None**. Select by ID or filter; unclear, blocked and costly work remains visible separately.

Review the exact cases, paths, setup and execution plan before writes. Unknown behavior can be clarified, explicitly characterized or deferred. Production fixes need separate scope.

## Tools and verification

Existing project tools come first. Missing dependencies prompt a restore or repair proposal; new or upgraded tools need compatible, reviewed setup.

Approved tests use isolated targets and synthetic fixtures. The plan explains material service, database and download effects. Relevant protection is checked before old tests are retired; installation or exit zero alone does not prove the intended cases ran.

When required execution is unavailable or deferred, findings stay open. Explicitly approved additive drafts remain uncommitted, preserving existing protection.

## Your result and the next run

You get test changes, actual commands and outcomes, remaining findings and manual checks. Coverage is reported only when measured.

An approved assessment saves findings in `.helm/test-log.json` before implementation, including unselected and blocked cases. Assessment currency and verified protection are separate; a case closes only with evidence for its guarantees. Invalid or unsupported state blocks dependent work without automatic reset.

Verified changes follow your local commit policy on the same branch. Reruns reassess source and retained findings. Use [refactor](refactor.html#refactor-vs-test) for code maintenance and [ship](ship.html) for publication.
