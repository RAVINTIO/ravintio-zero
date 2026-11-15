---
title: "Backlog Entry: 0000584 - Clean up step temp files after each merge"
summary: "Clean up step temp files after each merge"
status: "open"
priority: "medium"
theme: "initiative"
---
# Backlog Entry: 0000584 - Clean up step temp files after each merge

**Source feature:** 0000583-step-temp-cleanup-after-merge
**Source phase:** I-B Activate
**Deferral source:** add-step helper
**Date filed:** 2026-11-14

---

## Problem

Step sessions and their suites leave temp files behind after the step merges. On 2026-11-14 the disk filled up, and the 0000544 driver stopped with `ENOSPC: no space left on device`.

The user temp folder held 10,528 leaked entries older than 2 hours, which took 26.1 GiB. The oldest dated from 2026-10-29. Most came from four suites:

- `ravintio_0000169_req004_test_*`: 3,915 entries.
- `ravintio_0000245_req002_*`: 2,997 entries.
- `ravintio_0000151_req005_test_*`: 1,443 entries.
- `ravintio_0000171_req004_test_*`: 1,297 entries.

Other leaks were `ravintio_0000029_test_*`, `ravintio-gitconfig*`, and `ravintio-clean-clone-*` folders. Some 0000029 test folders still use the retired product prefix. Step sessions also leave `/tmp/step{n}*` files and extra worktrees such as `/tmp/step5-basewt`.

## Wanted outcome

The human set this outcome on 2026-11-14: each step's temp files go away once its feature branch merges into the initiative branch.

- After the merge queue merges a step PR, the driver removes that step's worktree under `plan/.initiative-worktrees/` and runs `git worktree prune`.
- The driver also removes each `/tmp/step{n}*` path and each extra worktree that the step session added.
- Every suite that makes a temp folder removes it on exit, with a `trap` on `EXIT`. The four suites above come first.
- A test runs each of those suites and checks that the user temp folder holds no new `ravintio_*` entry afterwards.
- A test checks that the driver removes a merged step's worktree and `/tmp/step{n}*` paths.
