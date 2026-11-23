---
title: Known issues
description: Review observed Agent Helm limitations in Claude and Codex, including instruction following, command runtimes, question handling, plugin icons and installation differences.
nav_exclude: true
permalink: /docs/known-issues.html
---

# Known issues

Observations from maintainer testing and use on macOS, alongside documented platform limitations.

<div id="agent-behaviour"></div>
<div id="agent-choice"></div>

## Across agents

<details id="instructions-and-workflow-steps-may-not-be-followed-consistently" markdown="block">
<summary>Instructions and workflow steps may not be followed consistently</summary>

<div class="known-issue__body" markdown="block">

During Helm workflows, Claude and Codex have sometimes skipped steps, stopped early or changed required outputs. [Written instructions do not guarantee execution](https://code.claude.com/docs/en/best-practices#deterministic-and-non-deterministic-instructions).

**What you can do:** Point out the missed requirement and ask the agent to resume from the last verified step. Inspect the changes and verification results. Treat ship's push, CI, release and deployment as separate outcomes.

</div>
</details>

<details id="repeated-reviews-may-keep-producing-findings" markdown="block">
<summary>Repeated reviews may keep producing findings</summary>

<div class="known-issue__body" markdown="block">

Fresh Helm reviews have produced new findings after earlier fixes. Research on specific models reports [variation between reviews](https://arxiv.org/abs/2502.20747) and [unnecessary corrections](https://link.springer.com/article/10.1007/s10515-026-00638-5).

**What you can do:** Keep the scope and earlier decisions in view, and require concrete evidence for findings. Separate defects from optional improvements. A no-findings result covers only the reviewed scope.

</div>
</details>

<details id="noticeably-longer-command-runtimes-in-codex" markdown="block">
<summary>Noticeably longer command runtimes in Codex</summary>

<div class="known-issue__body" markdown="block">

Longer Helm reviews have been noticeably slow in Codex; timings vary by task and model. The cause is unconfirmed, although [reasoning effort](https://learn.chatgpt.com/docs/models#pick-a-reasoning-effort) can affect waiting time.

**What you can do:** Ask whether the agent is working, waiting for your answer or awaiting a check. Use Gap scan only when offered and its baseline fits the task; keep required coverage and checks.

</div>
</details>

## Codex CLI

<details id="questions-appear-as-plain-text-in-default-mode" markdown="block">
<summary>Questions appear as plain text in Default mode</summary>

<div class="known-issue__body" markdown="block">

In maintainer testing, some Helm questions in Codex CLI Default mode needed a typed reply. Codex's [Default-mode instructions](https://github.com/openai/codex/blob/main/codex-rs/collaboration-mode-templates/templates/default.md) restrict when its question picker is used.

**What you can do:** Type your choice or answer to continue. You don't need to change modes. A missing answer, preselected option or timeout isn't approval.

</div>
</details>

## Claude Desktop

<details id="the-plugin-icon-is-missing" markdown="block">
<summary>The plugin icon is missing</summary>

<div class="known-issue__body" markdown="block">

Claude Code [ignores the manifest's icon field](https://code.claude.com/docs/en/plugins/manifest-reference#directory-listing-fields). The cause of Helm's missing icon in Chat/Cowork remains unconfirmed.

**What you can do:** Check Helm's name, enabled state, version and eleven listed skills. Missing artwork alone doesn't mean the workflows failed to load. No Chat/Cowork icon fix is verified.

</div>
</details>

<details id="code-and-terminal-installations-do-not-appear-in-chatcowork" markdown="block">
<summary>Code and terminal installations do not appear in Chat/Cowork</summary>

<div class="known-issue__body" markdown="block">

Anthropic's [one-way plugin sync](https://support.claude.com/en/articles/13837440-use-plugins-in-claude) runs from the Claude account to Claude Code. Installing Helm in Code or the terminal doesn't add it to Chat/Cowork.

**What you can do:** Install Helm through [Claude's plugin interface]({{ '/docs/setup/claude.html#desktop-install' | relative_url }}). Check that it's enabled and lists eleven skills, then start a fresh chat.

</div>
</details>
