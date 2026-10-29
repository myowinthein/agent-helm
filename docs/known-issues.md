---
title: Known issues
nav_exclude: true
permalink: /docs/known-issues.html
---

# Known issues

Observations from maintainer testing and use on macOS, alongside documented platform limitations. Platform documentation was checked on **28–29 October 2026**.

## Agent choice

<details id="noticeably-longer-command-runtimes-in-codex" markdown="block">
<summary>Noticeably longer command runtimes in Codex</summary>

**Observed:** The slowdown is more apparent in longer workflows and varies by task, model and client.

Official guidance describes factors that can increase waiting time:

- [OpenAI's model guidance](https://learn.chatgpt.com/docs/models): higher reasoning effort takes longer and uses more tokens.
- [OpenAI's latency guide](https://developers.openai.com/api/docs/guides/latency-optimization): token generation and repeated sequential requests add latency.
- [Anthropic's effort guide](https://platform.claude.com/docs/en/build-with-claude/effort): effort balances response depth, latency and cost.

</details>

## Codex CLI

<details id="questions-appear-as-plain-text-in-default-mode" markdown="block">
<summary>Questions appear as plain text in Default mode</summary>

**Observed:** Helm's questions appeared as plain text in Default mode, requiring a typed reply. Native single-choice selection and custom text replies worked in Plan mode and the desktop app.

OpenAI describes [Plan mode](https://learn.chatgpt.com/docs/learn/best-practices#plan-first-for-difficult-tasks) as planning before implementation. In Default mode, type your choice or text to continue.

</details>

## Claude Desktop

<details id="the-plugin-icon-is-missing" markdown="block">
<summary>The plugin icon is missing</summary>

**Observed:** Helm's custom icon did not appear in Claude Desktop.

Claude Code ignores the [manifest icon field](https://code.claude.com/docs/en/plugins-reference#directory-listing-fields), which is used for directory listings. The cause in Chat/Cowork remains unconfirmed.

</details>

<details id="code-and-terminal-installations-do-not-appear-in-chatcowork" markdown="block">
<summary>Code and terminal installations do not appear in Chat/Cowork</summary>

**Observed:** Installing a plugin through the desktop app's **Code** tab or the **terminal** does not add it to the account's **Claude (Chat + Cowork)** plugin library.

Anthropic documents [one-way plugin sync](https://support.claude.com/en/articles/13837440-use-plugins-in-claude) from Claude (Chat + Cowork) to Claude Code. Code and terminal installs do not sync back.

</details>
