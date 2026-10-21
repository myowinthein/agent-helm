---
title: Claude desktop and Cowork
parent: Setup
nav_order: 2
permalink: /docs/setup/claude-desktop.html
---

# Claude desktop and Cowork

Open the plugin controls in Claude's Customize area. Add a marketplace from the GitHub repository `myowinthein/agent-helm`, then add the `helm` plugin. Check its version and enabled state, start a fresh task, and select a Helm workflow from the `/` picker.

For updates or removal, open the installed plugin's menu and use the available update or remove action. Menu labels can vary by app version and account. Check the workflow list in a new task after making a change.

Connect the consumer project folder before running Helm. Workflows read their own resources from the installed package and save project results in the connected workspace. If a resource cannot be read, Helm should report the missing path instead of substituting a file from your project.

Cowork folder access does not establish access to the same Git checkout, shell environment, Docker daemon, or credentials as Claude Code. Each workflow checks the capabilities its next step requires. A missing capability stops that step without marking it complete. Use Claude Code for operations requiring local tools that your Cowork environment cannot reach.

The shared package has native CLI discovery checks. Cowork UI installation and full workflow execution must be checked in the actual desktop environment; CLI validation is not evidence that every Cowork capability is available.
