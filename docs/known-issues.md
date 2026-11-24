---
title: Known issues
description: Problems you may see when using Agent Helm in Claude or Codex, and what you can do about them.
nav_exclude: true
permalink: /docs/known-issues.html
---

# Known issues

Observations from maintainer testing and use on macOS, alongside documented platform limitations.

<div id="agent-behaviour"></div>
<div id="agent-choice"></div>

## Across agents

<details id="instructions-and-workflow-steps-may-not-be-followed-consistently" markdown="block">
<summary>The agent may skip steps or stop early</summary>

<div class="known-issue__body" markdown="block">

Claude and Codex [may not follow every instruction](https://code.claude.com/docs/en/best-practices#deterministic-and-non-deterministic-instructions), so they can skip Helm steps, stop early or give results in the wrong format.

**What you can do:** Point out what was missed and ask the agent to resume. See the [command overviews]({{ '/docs/commands.html' | relative_url }}) for the workflow steps.

</div>
</details>

<details id="repeated-reviews-may-keep-producing-findings" markdown="block">
<summary>Command results can differ between sessions</summary>

<div class="known-issue__body" markdown="block">

Commands such as log, manifest, test and refactor can produce [different results](https://platform.claude.com/docs/en/about-claude/glossary#temperature) across sessions, even with identical project files. One session may report everything is complete while another suggests more work.

**What you can do:** Review the suggestions and ask the agent to explain its decisions. You can type questions or feedback, even when choices are provided.

</div>
</details>

<details id="noticeably-longer-command-runtimes-in-codex" markdown="block">
<summary>Some commands take longer in Codex</summary>

<div class="known-issue__body" markdown="block">

Some longer Helm reviews have taken noticeably more time in Codex. We haven't confirmed why. The task, chosen AI model and [how much reasoning it does](https://learn.chatgpt.com/docs/models#pick-a-reasoning-effort) can affect the wait.

**What you can do:** Ask whether the agent is still working, waiting for your reply or waiting for a check to finish. Use Gap scan only if the agent offers it and confirms it can build on a suitable earlier review. Keep all required review work and checks.

</div>
</details>

## Codex CLI

<details id="questions-appear-as-plain-text-in-default-mode" markdown="block">
<summary>You may need to type your answers</summary>

<div class="known-issue__body" markdown="block">

In our testing with Codex in a terminal, some Helm questions appeared as chat messages without answer buttons. Its [Default-mode instructions](https://github.com/openai/codex/blob/main/codex-rs/collaboration-mode-templates/templates/default.md) limit when those buttons appear.

**What you can do:** Type your answer to continue; you don't need to switch modes. An option shown as selected does not count as your permission. Neither does leaving a question unanswered, however long you wait.

</div>
</details>

## Claude Desktop

<details id="the-plugin-icon-is-missing" markdown="block">
<summary>The plugin icon is missing</summary>

<div class="known-issue__body" markdown="block">

Helm's icon may be missing in Claude Desktop. [Claude Code does not use the plugin's icon setting](https://code.claude.com/docs/en/plugins/manifest-reference#directory-listing-fields). We haven't confirmed why the icon is missing in Chat/Cowork or found a verified fix.

**What you can do:** Find Agent Helm by name in the plugin list. Check that it is turned on, shows the expected version and lists eleven skills. A missing icon alone does not mean Helm failed to load.

</div>
</details>

<details id="code-and-terminal-installations-do-not-appear-in-chatcowork" markdown="block">
<summary>Installing in Code or the terminal does not add it to Chat/Cowork</summary>

<div class="known-issue__body" markdown="block">

Claude [copies plugins one way](https://support.claude.com/en/articles/13837440-use-plugins-in-claude), from your Claude account to Claude Code. Installing Helm in the Code tab or a terminal does not add it to Chat/Cowork.

**What you can do:** Install Helm through [the plugin menu in Claude]({{ '/docs/setup/claude.html#desktop-install' | relative_url }}). Make sure it is turned on and shows eleven skills, then start a new chat.

</div>
</details>
