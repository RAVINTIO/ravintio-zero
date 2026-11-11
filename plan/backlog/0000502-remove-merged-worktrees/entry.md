---
title: "Backlog Entry: 0000502 - Driver removes merged step worktrees"
summary: "On 2026-11-11 the worktree `plan/.initiative-worktrees/step-12` still existed, although step 12 merged on 2026-11-08."
status: "open"
priority: "high"
theme: "initiative"
---
# Backlog Entry: 0000502 - Driver removes merged step worktrees

**Source feature:** 0000501-remove-merged-worktrees
**Source phase:** I-C Run
**Deferral source:** human request, 2026-11-11
**Date filed:** 2026-11-11

---

## Problem

On 2026-11-11 the worktree `plan/.initiative-worktrees/step-12` still existed, although step 12 merged on 2026-11-08. Nothing removes the worktree of a merged step, so old worktrees pile up and hold their branches.

Evidence: `git worktree list` at 00:29 on 2026-11-11.

## Suggested Action

after a step merges, the driver removes its worktree once the session has exited and the head matches origin. If the worktree holds uncommitted files, the driver keeps it and reports them.

## Why Deferred

Found at the step 27 driver stop of initiative 0000360. The human asked for it as its own step at the end of the chart.
