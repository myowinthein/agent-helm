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

Claude and Codex sometimes skip Helm steps, stop too soon or give results in the wrong format. [Instructions alone cannot prevent this](https://code.claude.com/docs/en/best-practices#deterministic-and-non-deterministic-instructions).

**What you can do:** Tell the agent which step it missed and ask it to continue from the last step you checked. Review its changes and test results. With ship, check each result separately: were changes uploaded, did automatic checks pass, was a release published, and was the live site or app updated?

</div>
</details>

<details id="repeated-reviews-may-keep-producing-findings" markdown="block">
<summary>Another review may report more issues</summary>

<div class="known-issue__body" markdown="block">

A new Helm review may report more issues, even after you fix earlier ones. Studies of specific AI models found that [reviews can differ](https://arxiv.org/abs/2502.20747) and [some suggested fixes are unnecessary](https://link.springer.com/article/10.1007/s10515-026-00638-5).

**What you can do:** Be clear about which files or features to review, and remind the agent of earlier decisions. Ask it to show why each reported issue is a problem and separate necessary fixes from optional improvements. Finding no issues only tells you about what was checked.

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
