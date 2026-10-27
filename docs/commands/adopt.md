---
title: adopt
parent: Commands
nav_order: 2
---

# adopt

Install shared working rules for Claude and Codex, then review updates when the bundled rules change.

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
  Needed -->|Yes| Review["Choose rules and review<br/>each replacement or repair"]
  Review --> Decision{"Approve the local plan?"}
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

New adoption proposes all three; you can omit Writing or explicitly request it alone. Git and Safety stay paired. Existing installations get a separate offer to add Writing.

## What to expect

Adopt compares actual bodies, not just version markers. Changed Helm copies get a diff and **Replace / Keep / Cancel** per file. Other existing files need **Overwrite / Skip**. Equivalent content stays untouched even with an older marker; downgrades require explicit review. Customizations are not merged automatically.

Suitable copies can be connected without replacement. Independent instruction files or a `CLAUDE.md`-only layout need [log](log.html) first. A fresh project can receive minimal shared instructions during installation.

## Your result

Selected copies live under `.claude/rules/`, using `git.md`, `safety.md` and `writing.md`. Shared pointers belong in `AGENTS.md`; `CLAUDE.md` imports it.

The report shows installed, kept, skipped and missing rules. File connections are checked; native startup loading needs separate observation. Start a fresh agent session after instruction changes.

Updates follow your local commit policy on the same branch. Plugin updates do not refresh project copies: rerun adopt to review them. External installation references need separate maintenance; adopt does not convert them. Use [ship](ship.html) to publish.
