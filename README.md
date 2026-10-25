---
title: Home
nav_order: 1
permalink: /
---

# Agent Helm

Take the helm.

<img src="https://myowinthein.github.io/agent-helm/docs/images/banner.jpg" alt="agent-helm" width="600">

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

At the start of a new session, agents read project instruction files such as `AGENTS.md` and `CLAUDE.md` for context. I use this command to [keep those instructions up to date](https://myowinthein.github.io/agent-helm/docs/commands/log.html).

```text
log
```

It reviews the project, reports what it finds and applies the updates I approve, so agents have the context to start coding without me explaining the project in every new session.

### Adopt

Rule files tell agents how to behave while working on a project. I use this command to [add working rules](https://myowinthein.github.io/agent-helm/docs/commands/adopt.html), so I don’t have to give agents the same instructions in every session.

```text
adopt
```

I add [Git rules](https://myowinthein.github.io/agent-helm/docs/rules/git.html) for commits and publishing, [safety rules](https://myowinthein.github.io/agent-helm/docs/rules/safety.html) for actions that could cause damage or be difficult to undo, and [writing rules](https://myowinthein.github.io/agent-helm/docs/rules/writing.html) for clear, natural content. It checks existing rules, then adds or updates the ones I approve as shared local copies for both agents.

### Env

As a project grows, its `.env` and `.gitignore` files can become messy or fall behind the code. I use this command to [keep them organised and up to date](https://myowinthein.github.io/agent-helm/docs/commands/env.html).

```text
env
```

It checks for exposed secrets, missing settings and potentially unused variables, then applies the fixes I choose. It also maintains environment templates and checks that ignore rules protect private files without hiding files the project needs in Git.

### Test

As the project grows and test coverage becomes more important, I use this command to [find testing gaps and maintain existing tests](https://myowinthein.github.io/agent-helm/docs/commands/test.html).

```text
test
```

It reviews changes to the code and existing tests since the last scan, or reviews the project in full when needed. It reports new tests to add and existing tests that need attention, each with a priority, then works on the ones I choose using tools suited to the project.

### Refactor

After working with agents for a while, the code can become harder to follow and maintain. I use this command to [review its quality and choose improvements](https://myowinthein.github.io/agent-helm/docs/commands/refactor.html).

```text
refactor
```

It reviews code changes since the last scan, or reviews the project in full when needed. It reports findings with their priority and risk, then works on the ones I choose, following the tech stack’s recommended practices while preserving the code’s behaviour.

### Manifest

The README helps developers understand a project before getting started. I use this command to [create it and keep it up to date](https://myowinthein.github.io/agent-helm/docs/commands/manifest.html).

```text
manifest
```

It reviews the project and can create a README using a standard layout if I don’t have a custom structure in mind. For an existing custom README, it preserves the structure and applies the content updates I approve.

### Legal

Legal documents help explain how a project handles people’s data and what terms apply to its use. I use this command to [prepare and maintain the documents my project needs](https://myowinthein.github.io/agent-helm/docs/commands/legal.html).

```text
legal
```

It reviews the project and suggests relevant documents, then creates or updates the ones I choose based on confirmed facts. It asks for missing business details, and the drafts still need appropriate human review.

### Normalize

Consistent commit messages make it easier to understand what changed and follow a project’s history. I use this command to [bring commit messages into a consistent format](https://myowinthein.github.io/agent-helm/docs/commands/normalize.html).

```text
normalize
```

It reviews the commit history and suggests corrections using Conventional Commits. After I approve, it saves recovery evidence and rewrites the affected local branches together. Publishing those changes happens later through `ship`.

### Ship

Publishing changes involves checks and decisions that are easy to miss when handled differently each time. I use this command to [follow a consistent process when sharing my work](https://myowinthein.github.io/agent-helm/docs/commands/ship.html).

```text
ship
```

It reviews the changes, then pushes them or creates PRs after I approve. I can choose other branches to update and, once changes are published and integrated on main/master, approve a versioned release.

### Archive

Old projects can become difficult to run as tools change and setup details are forgotten. I use this command to [preserve what I need to use them again in the future](https://myowinthein.github.io/agent-helm/docs/commands/archive.html).

```text
archive
```

It reviews the project and proposes a preservation plan. After I approve each stage, it helps restore and freeze the setup, then prepares the necessary data and recovery instructions. I use `ship` later when I’m ready to back it up.

## Help me improve it

If something does not work or you have an idea that would make working with agents easier, [share it on GitHub](https://github.com/myowinthein/agent-helm/issues).

Agent Helm is open source under the [MIT license](https://github.com/myowinthein/agent-helm/blob/main/LICENSE).
