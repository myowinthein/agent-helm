---
title: "Step 5: Finalize"
parent: /helm:archive
grand_parent: Commands
nav_order: 5
---

# Step 5: Prepare locally

Finish and commit the reviewed local archive payload, then stop. No private destination, push/PR prompt, branch switching/creation, ref cleanup or remote receipt is required to finish this command. Later run `/helm:ship archive` when ready to publish/verify the private backup.

## Local preparation

Use only the validated canonical `.helm/archive/` directory. Unsupported old-bundle evidence stops this route without being read or moved. Preserve schema 1, source names/remotes/tags, protected imports/rules and opaque other-owner state. Revalidate the four prior reports, current inventory/output fingerprints, actual source and current host; do not replay completed restoration/imports/stops.

Before the payload commit, choose per artifact: regular Git, supported LFS with actual local objects, or an explicitly accepted separate/local-only exclusion. Review actual sizes/checksums/free space and known provider evidence; ask a provider preference only if it changes this storage choice. Unknown destination support does not make large regular blobs safe. Record compatibility limits or accepted incomplete preservation; Cancel preserves existing work.

Exact private destination/account/plan/quota/retrieval checks belong to ship; unknown remote availability does not gate local completion. Provider limits vary: [GitHub blocks regular files larger than 100 MiB](https://docs.github.com/en/repositories/working-with-files/managing-large-files/about-large-files-on-github), which is not a universal host limit. LFS pointers do not prove actual bytes are retrievable, and `.gitattributes` does not retroactively convert historical blobs. Record history/limit problems separately, with no implicit rewrite, installation or global hook/config change. Verified local storage is not a verified remote backup.

Consolidate only supplementary BA docs, diagrams, mockups, design/history material when useful; retain organized files in place by default. `recovery/assets/` is optional for approved scattered material. Application icons/backgrounds/fonts, fixtures/seeds, datasets and build/runtime/data inputs retain their native paths and wiring. Protected/checkpoint inputs are not generic assets. Older reports lacking this distinction get scoped source follow-up, not migration.

Keep native originals. Useful existing portable views or conversions with available approved tools are optional; no installation, activation, payment or unapproved upload for conversion. External materials use supplied exact local paths, not personal-drive crawls/authenticated fetches. Review comments/tracked changes/customer information before inclusion without bulk redaction or rewriting originals.

Approved moves must account for source/docs/Compose/Dockerfile/script/data/init/recovery references, update current navigation and preserve historical reports. Unknown external consumers favor keeping paths stable. Stop only currently identified owned project services after explicit target approval; no blanket shutdown, volumes or guessed process ownership.

## Review the payload

Show exact source/manifest/files, per-artifact storage choices/exclusions, retained/consolidated supplementary materials, secret-safety evidence, actual service/move results, recovery instructions and performed/deferred checks. The fifth report states **prepared locally; remote backup not published/verified**. No invented payload SHA, destination or recovery success. Real credentials/private records and unreviewed work are excluded; selected-history secrets block future publication for separate resolution.

Offer **Commit reviewed local archive / Leave uncommitted**. Auto-commit does not replace this content/commit approval. Persist/read back the fifth report, checkpoint digest and inventory with cursor 4/phase prepared; remote and payload fields may be null. Stage literal approved paths/deletions only, inspect the complete index and verify the payload commit's actual parent/tree/archive identity. No directories, broad add or other-ledger drafts.

Report the actual payload SHA and stop without a post-commit tracked journal update. Exact source-parent/archive-ID/report/manifest/committed-journal proof identifies this local payload later, never its subject or newest HEAD alone. A rerun with proven preparation replaces nothing. Failed/declined commits leave actual drafts pending rather than claiming complete preparation.

## Publish later through ship archive

Ship archive narrowly validates this bundle and its already-prepared payload. Only it selects/verifies one private destination and separately obtains backup publication approval for the exact payload, recovery/LFS bytes, selected cleanup and receipt. Actual provider review/signing/checks/limits/triggers remain binding. A PR cannot substitute for payload/receipt ancestry. Canonical remote main uses normal fast-forward publication; no force or source-remote replacement.

Publish/read back the pinned payload and verify required bytes before any selected cleanup or receipt. Keep names/remotes by default. Then replace the local-preparation fifth report with the explicitly reviewed factual completion receipt, retaining the prior report in Git history. Commit it with cursor 5/receipt_prepared as a child of the verified payload and publish/read back its exact SHA/tree/ancestry. The local cursor alone is no remote proof; no tracked write follows final receipt verification.

An interrupted current-format run can continue only its identified missing phase. Proven own journal/receipt drafts have a narrow reviewed exception; unrelated pending source/index work still blocks. No repeated restoration, extra payload commits, new root, changed tags or reset/stash. Partial publication retains exact successes and pending actions.

## Optional portable copy

After ship verifies the receipt, separately approve an unused external destination for a self-contained Git bundle and available required LFS/submodule/image/data/setup inputs, checksums and explicit omissions. Protect existing backups, inspect containment/size/privacy and verify source bundle prerequisites/objects and copied artifact hashes. A bundle alone excludes external recovery bytes. No repository/state amendment, scheduler or implicit upload. Copy failure preserves the verified seal and exact retry point.

See [ship](../ship.html), [archive](../archive.html) and [Git and CI behavior](../../setup/git-and-ci.html) for routing, safeguards and completion boundaries.
