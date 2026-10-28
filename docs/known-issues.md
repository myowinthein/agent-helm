---
title: Known issues
nav_exclude: true
permalink: /docs/known-issues.html
---

# Known issues

Observations from maintainer use on macOS, alongside documented platform limitations. Platform documentation was checked on **28 October 2026**; affected app versions were not recorded for the observations.

## Agent choice

### Some commands take longer in Codex

**Observed:** Some Helm commands took longer with **GPT-6.1 Sol in Codex** than with **Claude Sonnet 5.5**, both at **High** effort. This does not establish that one agent is always faster.

More reasoning can increase response time. Effort is model-specific: selecting High in both clients does not establish an equal amount of reasoning. See [OpenAI's model guidance](https://learn.chatgpt.com/docs/models) and [Sonnet 5.5's effort behavior](https://platform.claude.com/docs/en/models/sonnet-5-5/whats-new-sonnet-5-5#behavior-differences).

The cause of the difference in these runs has not been isolated. “Overthinking” is a possible explanation, not a confirmed diagnosis, and no specific fix has been verified.

## Claude Desktop

### The plugin icon is missing

**Observed:** Helm's custom icon did not appear in Claude Desktop.

Anthropic documents the manifest's icon as metadata for its plugin-directory listing and says Claude Code ignores it. This does not establish how imported plugins display icons in Chat/Cowork; the cause there remains unconfirmed. See the [plugin manifest reference](https://code.claude.com/docs/en/plugins-reference#directory-listing-fields).

Use the plugin name to identify Helm and check its workflows using the [Claude setup guide]({{ '/docs/setup/claude.html' | relative_url }}). A missing icon alone does not establish that installation failed; no icon-display fix has been verified here.

### Code and terminal installations do not appear in Chat/Cowork

**Documented behavior:** Installing a plugin through the desktop app's **Code** tab or the **terminal** does not add it to the account's **Claude (Chat + Cowork)** plugin library.

Anthropic documents one-way sync from the Claude account into Claude Code, not back into the account. See [Use plugins in Claude](https://support.claude.com/en/articles/13837440-use-plugins-in-claude).

If you need Helm in Chat/Cowork, add it through Claude's **Customize → Plugins** using the [Claude setup guide]({{ '/docs/setup/claude.html' | relative_url }}). Account-to-Code sync requires the same Claude account and a supported Code version; see Anthropic's requirements above.
