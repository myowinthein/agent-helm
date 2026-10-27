---
title: adopt
parent: Commands
nav_order: 2
---

# adopt

Install shared working rules for Claude and Codex, then approve updates when the bundled rules change.

## Start the command

```text
adopt
```

Use the prefix for your app or terminal from [Setup]({{ '/docs/setup/' | relative_url }}#run-a-command).

Preview rules in a consumer project. Git-backed writes require clean **main or master**; a folder without Git history can receive uncommitted files.

Adopt blocks Helm's own source checkout, its nested directories and package installations. These use maintained source rules directly; copied rules could redirect them to an older version. Test adoption in a separate consumer project.

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

## Available rules

| Rule | Purpose |
|---|---|
| [Git](../rules/git.html) | Commit conventions and publication policy. |
| [Safety](../rules/safety.html) | Boundaries around consequential actions. |
| [Writing](../rules/writing.html) | Clear, useful prose. |

New adoption proposes all three; you can omit Writing or explicitly request it alone. Git and Safety stay paired. Existing installations offer Writing as an optional addition in the same review.

## What to expect

Adopt compares complete files internally, not just version markers. You see a compact **File | Action | Local → Source version** table, the selected package, pointer changes and a short summary of meaningful policy changes. Named custom-file overwrites and downgrades are disclosed. Approve the proposed set or a subset once; optional Writing needs explicit inclusion. No review-first or repeated per-file confirmation follows unchanged approval.

Full rule bodies/diffs are available on request or through editor links, rather than printed by default. Approval covers exact copies from the identified package and the stated instruction changes; internal comparison and byte-for-byte verification still apply.

Equivalent content stays untouched even with an older marker. Keep/Skip preserves existing files and pointers; customizations are not merged automatically.

| Situation | Result |
|---|---|
| No rules installed | Summarize installations, purposes and instruction changes; install after approval. |
| All bodies match, even with older/newer markers | Preserve files and markers; no update question. |
| Managed bodies differ | Summarize named replacements and meaningful changes; apply the approved set. |
| Copies or references are missing | Summarize missing copies and exact connection effects; apply approved repairs. |
| Writing is newly available | Include its purpose/version/pointer as an optional addition in the same proposal. |
| Custom files or a downgrade | Name the overwrite or lower version explicitly; apply only approved changes. |
| Mixed updates, repairs and kept files | Use one proposal and accept all shown actions or a named subset. |
| Comparison source is unavailable | Keep copies; allow valid connection-only work and report blocked updates. |

Keeping a rule does not cancel an approved addition or connection. A populated folder without project markers gets a placement warning in the same installation review, rather than a separate Continue question.

Suitable copies can be connected without replacement. Independent instruction files or a `CLAUDE.md`-only layout need [log](log.html) first. A fresh project can receive minimal shared instructions during installation.

## Your result

Selected copies live under `.claude/rules/`, using `git.md`, `safety.md` and `writing.md`. Shared pointers belong in `AGENTS.md`; `CLAUDE.md` imports it.

The report shows installed, kept, skipped and missing rules. File connections are checked; native startup loading needs separate observation. Start a fresh agent session after instruction changes.

Updates follow your local commit policy on the same branch. Plugin updates do not refresh project copies: rerun adopt to review them. External installation references need separate maintenance; adopt does not convert them. Use [ship](ship.html) to publish.
