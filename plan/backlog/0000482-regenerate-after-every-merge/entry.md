---
title: "Backlog Entry: 0000482 - Regenerate shared files after every base merge"
summary: "Step 32 (0000456) made the queue resolve shared files only when the base merge conflicts."
status: "open"
priority: "high"
theme: "initiative"
---
# Backlog Entry: 0000482 - Regenerate shared files after every base merge

**Source feature:** 0000481-regenerate-after-every-merge
**Source phase:** I-C Run
**Deferral source:** human request, 2026-11-10
**Date filed:** 2026-11-10

---

## Problem

Step 32 (0000456) made the queue resolve shared files only when the base merge conflicts. On 2026-11-10 the base merge into PR #171 for step 26 was clean, but it left `plan/backlog/index.md` stale. CI `validate-branch` then failed with "backlog-index: plan/backlog/index.md is stale", and the queue stopped.

Evidence row: 30 in `plan/current-initiative/coordinator-evidence.md`.

## Suggested Action

After every base merge, clean or not, the queue regenerates `plan/backlog/index.md` and checks `plan/backlog/.next-id` and `docs/adr/.next-id`. If any file changes, the queue commits the regeneration before it pushes.

## Why Deferred

Found during I-C Run of initiative 0000360, after the step 22 retrospective. The human asked for it as its own step.
