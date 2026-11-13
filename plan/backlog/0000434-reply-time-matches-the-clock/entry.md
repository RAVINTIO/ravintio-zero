---
title: "Backlog Entry: 0000434 - Check reply times against the clock"
summary: "Check reply times against the clock, from the initiative 0000360 retrospective."
status: "open"
priority: "high"
theme: "initiative"
---
# Backlog Entry: 0000434 - Check reply times against the clock

**Source feature:** 0000421-initiative-retrospective

**Source phase:** P2

**Deferral source:** discovered mid-flight

**Date filed:** 2026-11-10

---

## Problem

Steps 14, 15, and 19 typed reply times that ran up to an hour off. `check-reply-prefix.mjs` accepts any `hh:mm` and checks the shape only. The injected time is context only, and the reply rule does not tell the step to read the clock each time.

Evidence row: 24. See `plan/retrospectives/0000360-backlog-sweep-retrospective.md`.

## Suggested Action

Make the check reject a time that differs from the clock by more than a set margin. Tell steps to read `date +%H:%M` before each reply.

## Why Deferred

Step 22 only records findings. Each fix is its own later step.
