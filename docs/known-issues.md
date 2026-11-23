---
title: Known issues
description: Review observed Agent Helm limitations in Claude and Codex, including instruction following, command runtimes, question handling, plugin icons and installation differences.
nav_exclude: true
permalink: /docs/known-issues.html
---

# Known issues

Agent Helm supplies workflows for Claude and Codex; the host agent carries out their steps and provides the question controls and plugin interface. These notes combine observations from maintainer testing on macOS with documented platform behavior. Results can vary by model, client and version.

<div id="agent-behaviour"></div>
<div id="agent-choice"></div>

## Across agents

<details id="instructions-and-workflow-steps-may-not-be-followed-consistently" markdown="block">
<summary>Instructions and workflow steps may not be followed consistently</summary>

<div class="known-issue__body" markdown="block">

**What happens:** During Helm workflows, Claude and Codex have sometimes skipped rules or steps, stopped before completion, or changed a required output format. A completion message can therefore leave part of the requested work unverified.

**Why it happens:** Helm's Markdown workflows guide the agent's decisions. Anthropic distinguishes [model-followed instructions from enforced checks](https://code.claude.com/docs/en/best-practices#deterministic-and-non-deterministic-instructions): a skill's written instructions do not guarantee execution. This describes a general limitation, rather than a confirmed cause for every missed step.

**What you can do:** Point out the missed requirement and ask the agent to resume from the last verified step. Inspect the changes and actual check results before accepting completion. For ship, distinguish a successful push from passing CI, a release and deployment.

**Related reports:** Users have reported [ignored Claude instructions](https://github.com/anthropics/claude-code/issues/18454), [Codex stopping early](https://github.com/openai/codex/issues/36596) and [Codex output-format failures](https://github.com/openai/codex/issues/25673). These reports describe other sessions, not verified reproductions of Helm workflows.

</div>
</details>

<details id="repeated-reviews-may-keep-producing-findings" markdown="block">
<summary>Repeated reviews may keep producing findings</summary>

<div class="known-issue__body" markdown="block">

**What happens:** Repeating a Helm review in a fresh Claude or Codex session has produced new findings after earlier fixes. Another pass can identify a missed defect or suggest an optional change; a new finding alone does not establish which it is.

**Why it happens:** Research has found [variation across repeated code reviews](https://arxiv.org/abs/2502.20747) and [incorrect judgments that working code needs correction](https://link.springer.com/article/10.1007/s10515-026-00638-5). Those studies cover specific models and tasks, not Helm or every current agent.

**What you can do:** Keep the scope and requirements consistent when comparing reviews. For test or refactor findings, ask for the affected behavior, concrete evidence and a way to verify the proposed change. Separate defects from optional improvements, and review existing decisions before approving more edits. A no-findings result applies only to the checked scope.

</div>
</details>

<details id="noticeably-longer-command-runtimes-in-codex" markdown="block">
<summary>Noticeably longer command runtimes in Codex</summary>

<div class="known-issue__body" markdown="block">

**What happens:** In maintainer use, Helm workflows in Codex have been noticeably slow, especially during longer reviews. This is an observation, not a controlled performance comparison; duration varies by task, model and client.

**Why it happens:** The cause of the observed slowdown has not been isolated. OpenAI documents that [higher reasoning effort takes longer](https://learn.chatgpt.com/docs/models#pick-a-reasoning-effort), while its API latency guidance explains how [sequential model and tool calls add waiting time](https://developers.openai.com/api/docs/guides/latency-optimization#make-fewer-requests). These are possible contributors, not a diagnosis of a particular Helm run.

**What you can do:** Ask which workflow step is active and whether it is waiting for your answer or an external check. When log, manifest, test or refactor offers a scan choice, use Gap scan only when its baseline and coverage fit the task. If comparing model or effort settings, keep the work comparable and check result quality as well as time; preserve the selected review coverage and required checks.

</div>
</details>

## Codex CLI

<details id="questions-appear-as-plain-text-in-default-mode" markdown="block">
<summary>Questions appear as plain text in Default mode</summary>

<div class="known-issue__body" markdown="block">

**What happens:** In maintainer testing, Helm's questions appeared as plain text in Codex CLI Default mode and required a typed reply. Native single-choice selection and custom replies worked in the tested Plan mode and desktop sessions.

**Why it happens:** The host controls which question tools are available and permitted. Codex's [Default-mode instructions](https://github.com/openai/codex/blob/main/codex-rs/collaboration-mode-templates/templates/default.md) restrict the native question tool to optional questions and direct required input to plain text. Helm uses the available question mechanism, so a picker is not guaranteed for every decision or client version.

**What you can do:** Type the requested choice or answer to continue. A text reply can supply the same workflow decision; a preselected option, missing answer or timeout supplies no approval. You do not need to change modes just to answer a Helm question.

</div>
</details>

## Claude Desktop

<details id="the-plugin-icon-is-missing" markdown="block">
<summary>The plugin icon is missing</summary>

<div class="known-issue__body" markdown="block">

**What happens:** Helm's custom icon did not appear in Claude Desktop during maintainer testing. The missing image alone does not establish whether the plugin's workflows loaded.

**Why it happens:** Anthropic documents the [manifest icon as a directory-listing field](https://code.claude.com/docs/en/plugins/manifest-reference#directory-listing-fields) that Claude Code ignores at load time. That explains the field's role in Code; the cause of the missing icon in Chat/Cowork remains unconfirmed.

**What you can do:** Identify the plugin by its Agent Helm name, check its enabled state and version, and confirm that its eleven skills are listed. No icon fix has been verified for Chat/Cowork.

</div>
</details>

<details id="code-and-terminal-installations-do-not-appear-in-chatcowork" markdown="block">
<summary>Code and terminal installations do not appear in Chat/Cowork</summary>

<div class="known-issue__body" markdown="block">

**What happens:** Installing Helm through the desktop app's **Code** tab or the **terminal** does not add it to the account's **Claude (Chat + Cowork)** plugin library. Helm can therefore be available in Code while absent from Chat/Cowork.

**Why it happens:** Anthropic documents [one-way plugin sync from the Claude account to Claude Code](https://support.claude.com/en/articles/13837440-use-plugins-in-claude). Code reads the account's plugins without changing that library, so a Code or terminal installation does not sync back. This is documented platform behavior.

**What you can do:** To use Helm in Chat/Cowork, add it through Claude's plugin interface using the [Claude installation instructions]({{ '/docs/setup/claude.html#desktop-install' | relative_url }}). Check that Helm is enabled and lists its eleven skills, then start a fresh chat. An existing Code installation is not proof of account-library installation.

</div>
</details>
