---
title: "Backlog Entry: 0000427 - The driver runs the approved setup command"
summary: "The driver runs the approved setup command, from the initiative 0000360 retrospective."
status: "open"
priority: "high"
theme: "initiative"
---
# Backlog Entry: 0000427 - The driver runs the approved setup command

**Source feature:** 0000421-initiative-retrospective

**Source phase:** P2

**Deferral source:** discovered mid-flight

**Date filed:** 2026-11-10

---

## Problem

Four steps that changed hooks, skills, or setup each stopped the driver with `Setup:` for the same approved command. Each stop needed a coordinator restart. The driver cannot run a command from a `Confirmation:` row.

Setup rewrites hook wiring, so the human decides this change. The driver would run only the exact command in the row. A missing or different command would still stop the run. No guard widens.

Evidence row: 18. See `plan/retrospectives/0000360-backlog-sweep-retrospective.md`.

## Suggested Action

Run the exact `Confirmation:` command in the driver, then continue. Keep the stop when the row is missing or differs.

## Why Deferred

Step 22 only records findings. Each fix is its own later step.
