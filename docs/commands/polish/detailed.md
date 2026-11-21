---
title: Polish
description: Understand how Polish uses selected project rules, presents meaningful findings and verifies the fixes you approve.
parent: Commands
nav_exclude: true
has_toc: false
overview: /docs/commands/polish.html
permalink: /docs/commands/polish/detailed.html
title_category: Details
source_files:
  - guides/polish.md
---

# Polish

{% include guide-depth.html %}

Polish brings wording, visual design and interaction review into one scoped conversation. It helps you improve a particular experience without replacing your project's voice or turning every difference into a defect.

## Choose a useful scope

A request such as “review the checkout dialog” gives the agent a clearer task than “make everything better.” You can name a page, component, document, directory or defined set of changes. Related shared styles or consumers may need inspection to understand the effect, but the review does not silently expand into whole-project cleanup.

Normal polish checks branch eligibility and a clean worktree before investigating the target. It can work on the actual main/master base, an established feature or maintenance branch, or a confirmed environment branch, subject to project restrictions. Branch names alone do not establish those roles, and the command does not move or commit unrelated work to make itself eligible.

For feedback on pending work, explicitly request a read-only review. That route uses static inspection, allows dirty or detached inputs and makes its limitations clear. It does not run project code, offer Apply or turn into an editing run after the report. Request fixes separately when the normal prerequisites are satisfied.

## Use the standards your project chose

Writing, Design and Interaction are independently optional. Polish follows the versions actually selected by your project, including direct project-maintained rules and customizations. A rule merely existing in a plugin or a disconnected file does not make it a review standard.

| Project selection | What happens |
|---|---|
| Writing only | Review relevant wording, structure and references. Skip unselected visual and interaction standards. |
| Design and Interaction | Review the interface against those rules without requiring Writing. |
| All three | Combine relevant findings rather than producing three overlapping reports. |
| None | Stop before investigating the target and explain that a rule must be selected. |
| A selected rule cannot be read | Stop and identify the broken reference; do not quietly use another copy. |

For example, a valid Writing rule does not let the command ignore a broken selected Interaction reference. Conversely, intentionally leaving Design unselected is not an error. Polish neither installs missing rules nor changes how regular coding sessions load them. Git and Safety continue to govern the work without becoming audit subjects.

## Understand the findings

The report explains each meaningful issue, where it occurs, the selected guidance behind it and the proposed remedy. Overlap is combined: an unclear error message and its inconsistent placement may form one coherent finding instead of separate rule-by-rule tickets.

A demonstrated problem, a conditional risk and an optional improvement carry different weight. A recommendation should offer enough benefit to justify disruption, compatibility risk and future maintenance. The agent preserves intentional typography, custom document outlines, branding and other project decisions rather than treating personal taste as a failure.

Ready fixes include a concrete before/after or diff, relevant dependencies and how the result should be checked. A fix that still needs a design or product decision stays pending. Large reports can use a numbered index and reviewable batches; approval never extends to undisplayed fixes.

## Approve a concrete change

**Apply recommended — 1–2** selects the shown recommended set; **Apply all proposed fixes — 1–3** also includes the ready optional change. These numbers are examples. When both sets are the same, the report offers only Apply all proposed fixes. **Leave unchanged** makes no changes for that review.

You can type `2–3`, exclusions or an exact correction without a separate Apply some or Revise menu. If your selection depends on another fix, the agent explains that dependency rather than silently adding it. A material change to the proposal needs the missing approval; an unchanged result already covered by your decision does not need another question.

Custom READMEs, agent instructions and legal documents keep their own authoring boundaries. A Polish review does not authorize a broad rewrite or advance another command's review marker. Exact legal-content and commit approval remain required even when auto-commit is enabled.

## Check the result

For a normal review, an available safe preview can help establish how the scoped interface actually works. After approved edits, verification uses relevant existing checks and rendered or interaction checks where needed and authorized. Polish does not install tooling or create temporary helper programs to fill a gap.

A source inspection may show that a button has a loading handler; it cannot establish that the loading state looks right or works with a keyboard. Unavailable rendered checks remain unverified. A required failure stops the run with actual drafts and prior verified changes preserved.

The final report identifies what was reviewed, which rules applied, what changed, the local commit if any, and remaining findings or verification gaps. Auto-commit follows project policy; with it disabled, exact known changes can be approved with or without a commit. Publication is a separate [ship](../ship.html) action.

Polish keeps no ledger, review dates or Full/Gap checkpoint. Each invocation reviews its current requested scope, so a declined or deferred issue may appear again. With no meaningful findings, it finishes without edits or a commit.

## Explore the source

For exact workflow instructions, read [guides/polish.md](https://github.com/myowinthein/agent-helm/blob/main/guides/polish.md).
