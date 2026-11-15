---
title: "Backlog Entry: 0000587 - P0 start actions do not say to write the sentinel in its own call"
summary: "A step wrote the sentinel and the P0 artifacts in one command, and gate-write blocked the whole command."
status: "open"
priority: "low"
theme: "orchestrator"
---
# Backlog Entry: 0000587 - P0 start actions do not say to write the sentinel in its own call

**Source feature:** 0000563-test-impact-misses-output-readers
**Source phase:** P0 Discovery
**Deferral source:** discovered mid-flight
**Date filed:** 2026-11-15

---

## Problem

Step 19 wrote `plan/.orchestrator-active` and the P0 artifacts in one Bash command. The `gate-write` hook checked the sentinel before the command ran and blocked the whole command. The step lost one call. The P0 start actions list the sentinel as step 4 but never say it needs its own call.

## Suggested Action

Add one sentence to Discovery Start Actions step 4: write the sentinel in a call of its own, before any `plan/` artifact. A standards test checks the sentence.

## Why Deferred

The fix edits the orchestrator reference. It is outside the plan scan change in step 19.
