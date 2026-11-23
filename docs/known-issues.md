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

**Observed:** Claude and Codex have sometimes [skipped rules or command steps](https://github.com/anthropics/claude-code/issues/18454), [stopped before completion](https://github.com/openai/codex/issues/36596), or [changed a required output format](https://github.com/openai/codex/issues/25673).

[Written instructions do not guarantee consistent execution](https://code.claude.com/docs/en/best-practices#deterministic-and-non-deterministic-instructions). Point out the missed requirement and ask the agent to resume from the last verified step. Check the actual result before accepting a completion claim.

</details>

<details id="repeated-reviews-may-keep-producing-findings" markdown="block">
<summary>Repeated reviews may keep producing findings</summary>

**Observed:** Repeating the same review request in fresh Claude or Codex sessions has produced additional findings after earlier fixes.

Code-review studies report [inconsistent assessments across repeated runs](https://arxiv.org/abs/2502.20747) and [correct implementations rejected as defective](https://link.springer.com/article/10.1007/s10515-026-00638-5). These results describe tested models and benchmarks; they do not establish the cause of each new finding.

New findings can be missed defects, regressions, optional improvements or false alarms. Keep the review scope and requirements consistent, ask for reproducible evidence of each defect, and separate optional changes from required fixes. A no-findings result applies only to what was actually checked.

</details>

<details id="noticeably-longer-command-runtimes-in-codex" markdown="block">
<summary>Noticeably longer command runtimes in Codex</summary>

**Observed:** The slowdown is more apparent in longer workflows and varies by task, model and client.

Official guidance describes factors that can increase waiting time:

- [OpenAI's model guidance](https://learn.chatgpt.com/docs/models#pick-a-reasoning-effort): higher reasoning effort takes longer and uses more tokens.
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

Anthropic documents [one-way plugin sync](https://support.claude.com/en/articles/13837440-use-plugins-in-claude#h_891ea8258e) from Claude (Chat + Cowork) to Claude Code. Code and terminal installs do not sync back.

</details>
