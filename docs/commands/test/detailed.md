---
title: test
description: Follow the complete test procedure, including its choices, prerequisites, approval boundaries, verification and outcomes.
parent: Commands
nav_exclude: true
has_toc: false
overview: /docs/commands/test.html
guide_source: guides/test.md
permalink: /docs/commands/test/detailed.html
title_category: Details
---

# test

{% include guide-depth.html %}

Use test to find missing protection and improve useful existing tests. You choose which cases and tooling changes to implement after reviewing the findings.

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

The complete procedure follows, including conditions and exceptions within each phase.

{{ page.guide_source | guide_intro }}

{{ page.guide_source | guide_body }}
