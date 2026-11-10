---
layout: home
title: Agent Helm
description: Reusable workflows for Claude and Codex to keep project context, improve code and tests, maintain documentation and ship reviewed changes.
nav_order: 1
permalink: /
---

# Agent Helm

Take the helm.

<img src="https://myowinthein.github.io/agent-helm/docs/images/banner.jpg" alt="agent-helm" width="600" height="400">

Agent Helm is a plugin for developers who work with Claude or Codex.

It gives your agent reusable workflows during project development, from keeping project context across sessions and improving code and tests to maintaining documentation, preparing releases and preserving older projects.

[Documentation site](https://myowinthein.github.io/agent-helm)

## Why I built this

When I started using coding agents to build software, I enjoyed working through ideas together. Then I ran into problems I hadn’t expected.

I found myself explaining the project in every new session, giving instructions so the code would follow the stack’s recommended practices, and saving prompts for recurring tasks like writing tests.

That’s why I built Agent Helm. I wanted an assistant for working with my agents across different kinds of projects, so I could spend more time building and less time explaining the same things again.

You can install Agent Helm in Claude or Codex by following the [setup guide](https://myowinthein.github.io/agent-helm/docs/setup/).

## When I use it

Agent Helm has ten commands that I use at different points during project development.

### Log

When agents need project context, I want useful instructions waiting in `AGENTS.md` and `CLAUDE.md`. I use log to [keep that shared context up to date](https://myowinthein.github.io/agent-helm/docs/commands/log.html), so I spend less time explaining the project in each new session.

```text
Codex → $log    Claude → /log
```

It reviews the project and existing instructions, then proposes updates to setup information, architecture and working agreements. I can accept all, choose changes or ask for revisions. It connects both agents to shared instructions while preserving custom content and decisions unless I approve a change.

### Adopt

I want agents to follow the same working rules across sessions. I use adopt to [add or update those rules](https://myowinthein.github.io/agent-helm/docs/commands/adopt.html) for both Claude and Codex, instead of repeating how I want them to work.

```text
Codex → $adopt    Claude → /adopt
```

It compares existing and bundled rules, then installs the shared local copies I approve. [Git](https://myowinthein.github.io/agent-helm/docs/rules/git.html) and [Safety](https://myowinthein.github.io/agent-helm/docs/rules/safety.html) stay paired for commits, publishing and consequential actions. I can also choose [Writing](https://myowinthein.github.io/agent-helm/docs/rules/writing.html) for clear prose and [Design](https://myowinthein.github.io/agent-helm/docs/rules/design.html) for responsive, accessible interfaces without repetitive AI patterns. Plugin updates leave these copies unchanged until I review an update through adopt.

### Env

As a project grows, its `.env` and `.gitignore` files can fall behind the code. I use env to [review configuration and Git ignore rules](https://myowinthein.github.io/agent-helm/docs/commands/env.html), so required settings are clearer and private files have appropriate protection.

```text
Codex → $env    Claude → /env
```

It checks configuration use, possible secret exposure and ignore rules, then applies the fixes I approve. It can prepare a shareable template with placeholders and correct rules hiding files the project needs. Untracking files needs separate approval. The audit does not start the app or contact services, so it cannot prove credentials work.

### Test

As a project grows, I want tests that protect its important behaviour and stay useful as the code changes. I use test to [find missing protection and maintain existing tests](https://myowinthein.github.io/agent-helm/docs/commands/test.html).

```text
Codex → $test    Claude → /test
```

It can review the whole project or follow changes since an earlier assessment, then prioritises missing cases and tests that need attention. I choose the tests and tooling changes before it starts. It runs the approved checks and reports what passed, failed or could not be verified.

### Refactor

After working with agents for a while, code can become harder to follow and maintain. I use refactor to [find worthwhile improvements](https://myowinthein.github.io/agent-helm/docs/commands/refactor.html) while keeping the behaviour I already rely on.

```text
Codex → $refactor    Claude → /refactor
```

It reviews code changes, the whole project or saved findings, then explains each improvement’s priority and risk. I choose the work and approve a plan before edits. It makes and checks the changes while preserving behaviour and existing test protection. Failed or postponed required checks keep the work pending.

### Manifest

The README helps people decide whether a project fits their needs and how to get started. I use manifest to [create or maintain that introduction](https://myowinthein.github.io/agent-helm/docs/commands/manifest.html), so it reflects the project as it changes.

```text
Codex → $manifest    Claude → /manifest
```

It checks README claims against the project and proposes updates for me to review. I can use a standard layout or agree a custom one for a new README. Existing custom structure, voice and useful content are preserved, and I can accept selected changes or ask for revisions.

### Legal

When a project needs to explain how it handles data or what terms apply, I use legal to [prepare and maintain the relevant documents](https://myowinthein.github.io/agent-helm/docs/commands/legal.html). I want drafts grounded in what the project actually does.

```text
Codex → $legal    Claude → /legal
```

It reviews source, existing documents and confirmed facts, asks for essential missing details together, then writes selected drafts from six supported document types as uncommitted files. I read them in my editor and choose Commit, Revise or Leave uncommitted. Committing needs my approval of the exact content, even with auto-commit enabled. Drafting does not establish legal compliance.

### Normalize

Consistent commit messages make a project’s history easier to follow. I use normalize to [review and correct those messages](https://myowinthein.github.io/agent-helm/docs/commands/normalize.html) when they no longer explain the changes clearly or follow the project’s conventions.

```text
Codex → $normalize    Claude → /normalize
```

It offers read-only review or coordinates readiness for a rewrite, then proposes exact messages and their branch, tag and commit-ID effects. After my rewrite approval, it verifies a backup outside the checkout, rewrites all affected local branches and checks the result. Tags stay fixed; other clones need coordination. [Ship](https://myowinthein.github.io/agent-helm/docs/commands/ship.html#publish-normalized-history) handles later publication with separate approval.

### Ship

Publishing changes involves checks and decisions that are easy to miss when handled differently each time. I use ship to [follow a consistent publication process](https://myowinthein.github.io/agent-helm/docs/commands/ship.html), with a clear view of what I am approving.

```text
Codex → $ship    Claude → /ship
```

It reviews the changes and where they will go, runs required checks, then pushes them or opens pull requests after I approve. I can choose other branches to update independently. Each push needs approval; pull requests stay open for review. A run on main or master can offer a separately approved release once the changes are integrated and ready.

### Archive

Old projects can become difficult to run as tools change and setup details are forgotten. I use archive to [prepare a recovery kit](https://myowinthein.github.io/agent-helm/docs/commands/archive.html) that preserves useful source, setup and data for returning to the project later.

```text
Codex → $archive    Claude → /archive
```

We agree what I need to recover. It then reviews the project, helps restore and freeze the setup, and prepares useful API materials and recovery instructions. I approve each phase’s report and its planned operations. It records the local kit’s recovery limits. I use [ship](https://myowinthein.github.io/agent-helm/docs/commands/ship.html#publish-an-archive-backup) separately to approve and verify a private backup.

## Help me improve it

If something does not work or you have an idea that would make working with agents easier, [share it on GitHub](https://github.com/myowinthein/agent-helm/issues).

Agent Helm is open source under the [MIT license](https://github.com/myowinthein/agent-helm/blob/main/LICENSE).

<!-- last-reviewed: 0b326e7d78f19755a24fa2e1116cba481dc30511 -->
