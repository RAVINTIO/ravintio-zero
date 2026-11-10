---
title: "Backlog Entry: 0000432 - Narrow the brand guard allowlist self-entry"
summary: "Narrow the brand guard allowlist self-entry, from the initiative 0000360 retrospective."
status: "open"
priority: "high"
theme: "initiative"
---
# Backlog Entry: 0000432 - Narrow the brand guard allowlist self-entry

**Source feature:** 0000421-initiative-retrospective

**Source phase:** P2

**Deferral source:** discovered mid-flight

**Date filed:** 2026-11-10

---

## Problem

The human gave five instructions for step 18 on 2026-11-08 in `plan/.initiative-queue/narrow-brand-guard-self-entry/`. Step 18 never read them. The allowlist still holds `^(src/)?ravintio-zero/tests/brand-guard-allowlist\.txt$` with `.` at line 87 of both copies. No decision row approved that standing widening of the brand guard.

The fix narrows the guard. It replaces the row with an exact-path skip for one file. The human chooses whether the skip covers both copies.

Evidence row: 25. See `plan/retrospectives/0000360-backlog-sweep-retrospective.md`.

## Suggested Action

Carry out the queued instruction. Replace the row with an exact-path skip in `brand-guard.sh`. Clear the queue item after the merge.

## Why Deferred

Step 22 only records findings. Each fix is its own later step.
