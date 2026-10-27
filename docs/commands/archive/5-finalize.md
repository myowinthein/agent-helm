---
title: "Step 5: Prepare locally"
parent: archive
grand_parent: Commands
nav_order: 5
---

# Step 5: Prepare locally

Review and commit the local recovery kit. Private backup publication happens later through ship.

## Flow

```mermaid
flowchart TD
  Start(["Documentation report approved"]) --> Storage["Review artifact storage<br/>and preservation exclusions"]
  Storage --> Assets["Keep or approve moves of<br/>supplementary documents/assets"]
  Assets --> Services["Stop only identified owned<br/>services when approved"]
  Services --> Review["Review the final report,<br/>exact payload and limitations"]
  Review --> Approval{"Commit the local archive?"}
  Approval -->|Revise| Review
  Approval -->|Leave uncommitted| Pending(["Keep drafts and pending work"])
  Approval -->|Yes| Commit["Verify files and recovery bytes;<br/>commit the approved payload"]
  Commit --> End(["Prepared locally;<br/>ship is a separate next action"])
```

## Review storage and supplementary assets

Choose regular Git, supported LFS with actual objects, or an explicit separate/local-only exclusion per artifact. Use actual sizes and available limits; LFS pointers alone do not preserve bytes. Exclusions can leave recovery incomplete.

Keep organized design and history material in place. Approved consolidation preserves originals and updates references. Runtime assets and data are not generic cleanup targets.

Only currently identified owned services may be stopped, with approval. There is no blanket daemon or volume cleanup.

## Approve the local payload

Review exact files, storage, exclusions, actual changes and verification limits. Credentials, private records and unrelated work stay out; protected instructions and other commands' state remain intact.

Choose **Commit reviewed local archive** or **Leave uncommitted**. This approval is required even with auto-commit enabled. The verified commit proves local preparation, not remote backup.

## What happens next

You get **ARCHIVE PREPARED LOCALLY** with the payload commit and limitations, or a pending-draft result. A rerun validates existing preparation without repeating it.

Use [ship](../ship.html#publish-an-archive-backup) to approve private payload and receipt publication. Cleanup is optional. After a verified receipt, ship can separately offer a portable copy; a Git bundle alone does not include external data, images or LFS bytes.
