---
title: "Backlog Entry: 0000592 - refuse a symlink at the boot file write"
summary: "A discovered-but-out-of-scope item deferred for pickup at a future discovery run."
status: "open"
priority: "low"
theme: "unsorted"
---
# Backlog Entry: 0000592 - refuse a symlink at the boot file write

**Source feature:** 0000551-refuse-symlink-style-outputs
**Source phase:** P3
**Deferral source:** deliberate scope decision
**Date filed:** 2026-11-16

---

## Problem

`write_boot_file` in `setup.sh` and the boot file write in `setup.ps1` write `AGENTS.md` and the other tool boot files through a link. Step 7 of initiative 0000544 stops the writing block at that path. The boot content still reaches the link target. See S-001 in the security report of 0000551.

## Suggested Action

Refuse a link at each boot file path in both setup scripts. Print a fixed line, skip the write, and exit 0.

## Wanted outcome

Setup on a repo with a link at a boot file path writes nothing through it and exits 0 with a fixed line. A test per shell covers it.

## Why Deferred

The brief of 0000551 limited the scope to the writing style output paths.
