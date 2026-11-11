---
title: "Backlog Entry: 0000513 - Pending migration noise in step sessions"
summary: "Resume detection reports pending migration 0009 in every step session, and a step session has no human to run it."
status: "open"
priority: "medium"
theme: "initiative"
---
# Backlog Entry: 0000513 - Pending migration noise in step sessions

**Source feature:** 0000448-driver-runs-approved-setup-command

**Source phase:** P0

**Deferral source:** discovered mid-flight

**Date filed:** 2026-11-11

---

## Problem

Resume detection prints `pending migration: 0009` at the start of every step session. Check 1 in `orchestrator-resume-detection.md` says to run `ravintio-migrator` first. The migration asks the human `Proceed? (y/n)` and writes a large diff, and a step session has no human. Each step spends time on the same decision, and the build log records it as a note. The build logs of steps 40 and 28 show it.

## Suggested Action

Let a step session skip a migration whose `Safe to skip:` field says `Yes`, and log one line. Or have the coordinator run the migration once before the driver starts.

## Why Deferred

The fix changes the orchestrator skill and resume detection, which this step does not touch. It needs its own design decision.
