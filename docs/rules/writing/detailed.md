---
title: Writing
description: Read the complete Writing rule, including its scope, requirements, exceptions and examples.
parent: Rules
nav_exclude: true
has_toc: false
overview: /docs/rules/writing.html
guide_source: rules/writing.md
permalink: /docs/rules/writing/detailed.html
title_category: Detailed guide
---

# Writing

{% include guide-depth.html %}

{{ page.guide_source | guide_intro }}

## Reference-link workflow

```mermaid
flowchart TD
  Find["Find possible references in the requested scope"] --> Select["Select useful links and avoid reading noise"]
  Select --> Match["Verify the relevant destination and section"]
  Match --> Phrase["Embed the URL in a meaningful phrase"]
  Phrase --> Open["Choose current-tab behavior or a justified, warned exception"]
  Open --> Icon["Apply the external destination indicator"]
  Icon --> Verify["Check wording, targets, access and interaction"]
```

The full rule follows. It is the same source that agents load or adopt into a project.

{{ page.guide_source | guide_body }}
