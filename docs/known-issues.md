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

Running commands such as test or refactor in separate sessions can produce [different results](https://platform.claude.com/docs/en/about-claude/glossary#temperature), even with the same code and command. One session may find no issues; another finds more.

**What you can do:** Review the suggestions and ask the agent to explain its decisions. You can type questions or feedback, even when choices are provided.

</div>
</details>

<div id="codex-cli"></div>

## Codex

<details id="noticeably-longer-command-runtimes-in-codex" markdown="block">
<summary>Some commands take longer in Codex</summary>

<div class="known-issue__body" markdown="block">

Some commands have taken longer in Codex than in other agents, even with similar model and [reasoning-effort settings](https://learn.chatgpt.com/docs/models#pick-a-reasoning-effort). We haven't confirmed why.

**What you can do:** If the wait is too long, stop the current run and try another agent.

</div>
</details>

<details id="questions-appear-as-plain-text-in-default-mode" markdown="block">
<summary>You may need to type your answers</summary>

<div class="known-issue__body" markdown="block">

Helm uses [Claude's](https://code.claude.com/docs/en/tools-reference#askuserquestion-tool-behavior) and [Codex's](https://github.com/openai/codex/blob/main/codex-rs/core/src/tools/handlers/request_user_input_spec.rs) question tools to ask for choices or written answers. In our testing, only Codex CLI showed these questions as text.

**What you can do:** Type your choice from the colored bullets, or write your own answer.

</div>
</details>

<div id="claude-desktop"></div>

## Claude

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
