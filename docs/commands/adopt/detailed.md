---
title: adopt
description: "Adopt installs selected Helm rules into another project and connects them to the instructions Claude and Codex read. You review the actual policy changes before a bundled update reaches your project."
parent: Commands
nav_exclude: true
has_toc: false
overview: /docs/commands/adopt.html
permalink: /docs/commands/adopt/detailed.html
title_category: Details
source_files:
  - guides/adopt.md
---

# adopt

{% include guide-depth.html %}

Adopt installs selected Helm rules into another project and connects them to the instructions Claude and Codex read. You review the actual policy changes before a bundled update reaches your project.

## Flow

```mermaid
flowchart TD
  Start(["Start adopt"]) --> Guard{"Helm source or<br/>installation target?"}
  Guard -->|Yes| Stop(["Explain and stop<br/>without changes"])
  Guard -->|No| Inspect["Check the project, instruction<br/>connections and existing rules"]
  Inspect --> Compare["Compare each rule with<br/>the loaded Helm package"]
  Compare --> Needed{"Changes needed?"}
  Needed -->|No| Current(["Report existing rules<br/>and connectivity"])
  Needed -->|Yes| Review["Summarize file actions, versions<br/>and meaningful policy changes"]
  Review --> Decision{"Apply the proposed changes?"}
  Decision -->|Cancel or keep| Finish(["Finish without replacing rules"])
  Decision -->|Yes| Apply["Copy approved rules and<br/>connect project instructions"]
  Apply --> Verify["Verify content and<br/>both instruction paths"]
  Verify --> Done(["Finish locally"])
```

## Start the command

Use a consumer project, not the Helm source checkout, one of its subdirectories or an installed Helm package. Those locations already contain maintained rule sources. For Git-backed writes, start on clean main or master; without Git history, approved files can remain uncommitted.

Adopt examines how the current clients reach project instructions before choosing a destination. A `CLAUDE.md`-only setup or conflicting independent entries may need [log's shared setup](../log.html#shared-project-instructions) first.

## Available rules

[Git and Safety](../../rules/git.html) are a pair: commit and publication choices depend on the preservation and authorization rules. Writing is proposed for new adoption but can be omitted. Design needs explicit selection. Writing and Design can each be used independently.

The installed copies normally live under `.claude/rules/`. Their role is deliberate: a plugin update changes the available upstream rules, while the consumer keeps its reviewed local copies until you adopt again.

## Compare what is already there

Adopt distinguishes content from version labels. Identical text does not need replacing just because its marker differs. A customized file is not automatically outdated, and a newer-looking version is not permission to overwrite it.

| Finding | Possible outcome |
|---|---|
| Missing selected rule | Install the reviewed copy. |
| Existing matching rule | Keep its bytes and repair a missing connection if needed. |
| Different maintained copy | Show the policy changes before updating. |
| Customized or foreign content | Keep it, or explicitly approve the disclosed replacement. |
| External instruction pointer | Report the setup; do not silently convert or merge it. |

## Review the proposed set

You see the files that would be copied, updated, connected or kept, including meaningful policy changes and any downgrade. Accept the whole set, choose a subset or cancel. Full rule bodies and diffs are available when you want to inspect the exact wording.

Keeping a rule also preserves its existing pointers. Adopt does not blend custom clauses into a new rule automatically. Required companions are handled as part of the reviewed selection rather than left silently missing.

## Your result

After applying the chosen set, adopt checks the installed content and instruction connections. The report separates installed, updated, kept, skipped and missing items. Matching files stay unchanged.

When auto-commit is off and the exact copies, pointer changes, paths and commit subject are known, the same review can offer Apply and commit or Apply without committing. Installation approval alone does not approve a commit. Changed results need affected review; unchanged approved content is verified without another commit question.

Start a fresh agent session to load the new instructions. File checks establish what was installed, not that every client's next startup has already loaded it. Publication remains a separate [ship](../ship.html) action.

## Explore the source

For implementation details, read [guides/adopt.md](https://github.com/myowinthein/agent-helm/blob/main/guides/adopt.md).
