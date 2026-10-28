---
title: Known issues
nav_exclude: true
permalink: /docs/known-issues.html
---

# Known issues

Observations from maintainer testing and use on macOS, alongside documented platform limitations. Platform documentation was checked on **28 October 2026**.

## Agent choice

### Noticeably longer command runtimes in Codex

**Observed:** Helm commands have taken noticeably longer in Codex than in Claude during maintainer testing and daily use, particularly in longer workflows. The size of the difference varies with the task, model and client.

Official guidance describes factors that can increase waiting time:

- [OpenAI's model guidance](https://learn.chatgpt.com/docs/models): higher reasoning effort takes longer and uses more tokens.
- [OpenAI's latency guide](https://developers.openai.com/api/docs/guides/latency-optimization): token generation and repeated sequential requests add latency.
- [Anthropic's effort guide](https://platform.claude.com/docs/en/build-with-claude/effort): effort trades response depth against latency and cost; its behavior varies by model.

These explain possible contributors, not the proven cause of Helm's observed slowdown. We have not established that “overthinking” alone explains it or verified a specific fix.

## Claude Desktop

### The plugin icon is missing

**Observed:** Helm's custom icon did not appear in Claude Desktop.

Anthropic documents the manifest's icon as metadata for its plugin-directory listing and says Claude Code ignores it. This does not establish how imported plugins display icons in Chat/Cowork; the cause there remains unconfirmed. See the [plugin manifest reference](https://code.claude.com/docs/en/plugins-reference#directory-listing-fields).

Use the plugin name to identify Helm and check its workflows using the [Claude setup guide]({{ '/docs/setup/claude.html' | relative_url }}). A missing icon alone does not establish that installation failed; no icon-display fix has been verified here.

### Code and terminal installations do not appear in Chat/Cowork

**Documented behavior:** Installing a plugin through the desktop app's **Code** tab or the **terminal** does not add it to the account's **Claude (Chat + Cowork)** plugin library.

Anthropic documents one-way sync from the Claude account into Claude Code, not back into the account. See [Use plugins in Claude](https://support.claude.com/en/articles/13837440-use-plugins-in-claude).

If you need Helm in Chat/Cowork, add it through Claude's **Customize → Plugins** using the [Claude setup guide]({{ '/docs/setup/claude.html' | relative_url }}). Account-to-Code sync requires the same Claude account and a supported Code version; see Anthropic's requirements above.
