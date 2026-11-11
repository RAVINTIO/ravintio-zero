---
title: "Backlog Entry: 0000508 - Check every hook after setup"
summary: "After setup, the coordinator checks that every hook in `.claude/settings.json` loads and runs."
status: "open"
priority: "high"
theme: "initiative"
---
# Backlog Entry: 0000508 - Check every hook after setup

**Source feature:** 0000507-hook-check-after-setup
**Source phase:** I-C Run
**Deferral source:** human request, 2026-11-11
**Date filed:** 2026-11-11

---

## Problem

After setup, the coordinator checks that every hook in `.claude/settings.json` loads and runs. No command does this. On 2026-11-11 the first check failed for every hook, because the ad hoc script did not set `CLAUDE_PROJECT_DIR`.

Evidence: coordinator hook check at 00:33 on 2026-11-11.

## Suggested Action

add a hook check script. It runs each installed hook with `CLAUDE_PROJECT_DIR` set and a sample input for its matcher. It reports a hook that fails to load, and it treats a guard's deliberate block as a pass. The driver runs it after setup and stops on a failure.

## Why Deferred

Found at the step 27 driver stop of initiative 0000360. The human asked for it as its own step at the end of the chart.
