---
title: "Backlog Entry: 0000437 - Coordinator guidance for repeated shell tasks"
summary: "Coordinator guidance for repeated shell tasks, from the initiative 0000360 retrospective."
status: "open"
priority: "high"
theme: "initiative"
---
# Backlog Entry: 0000437 - Coordinator guidance for repeated shell tasks

**Source feature:** 0000421-initiative-retrospective

**Source phase:** P2

**Deferral source:** discovered mid-flight

**Date filed:** 2026-11-10

---

## Problem

Shell snags cost time from 2026-11-08 to 2026-11-10. zsh does not split `set -- $x`. zsh reads `$b:r` as a modifier. A JavaScript `replace` with `$'` duplicated a test file. `merge-guard` and `block-forced-add` blocked compound and variable commands. Build reports from 0000316, 0000317, and 0000405 give the same advice. It never reached a standard.

This change adds guidance and scripts. It must not allow variables, compound commands, or quoting in `merge-guard` or `block-forced-add`.

Evidence row: 22. See `plan/retrospectives/0000360-backlog-sweep-retrospective.md`.

## Suggested Action

Add a coordinator section that names bash and tells the coordinator to write scripts with the Write tool. Ship scripts for the drain, the overlap check, and bulk edits.

## Why Deferred

Step 22 only records findings. Each fix is its own later step.
