---
title: "Backlog Entry: 0000589 - Ship archive step does not say to write literal git add paths"
summary: "Step 21 lost one Bash call to block-forced-add, which blocks a git add that uses a shell variable."
status: "open"
priority: "low"
theme: "orchestrator"
---
# Backlog Entry: 0000589 - Ship archive step does not say to write literal git add paths

**Source feature:** 0000565-layout-move-test-impact
**Source phase:** P4 Ship
**Deferral source:** discovered mid-flight
**Date filed:** 2026-11-15

---

## Problem

Step 21 ran the archive commands in one Bash call and passed the archive folder to `git add` as a shell variable. The `block-forced-add` hook blocked the call, because it cannot read the flags behind a variable. Ship Step 4 does not say to write literal paths.

## Suggested Action

Add one sentence to ship Step 4. Write each `git add` path as a literal and never as a variable. A standards test checks the sentence.

## Why Deferred

The fix edits the ship skill. It is outside the plan scan change in step 21.
