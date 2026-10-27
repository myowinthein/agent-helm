---
name: env
description: Audit environment loading and Git protection, then apply reviewed fixes or create safe templates
---

Read [the shared runtime](../../prompts/shared/runtime.md) and [the env workflow](../../workflows/env.md) together in one batch when possible. Apply the runtime first, then follow only this workflow.

Resolve symlinks to this SKILL.md's actual packaged location before resolving these relative links; do not resolve them from the consumer workspace. Pass invocation arguments and user answers to the workflow unchanged.
