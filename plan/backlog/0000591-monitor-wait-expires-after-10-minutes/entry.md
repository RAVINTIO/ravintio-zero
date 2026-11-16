---
title: "Backlog Entry: 0000591 - A monitor wait expires after 10 minutes"
summary: "A step session must re-arm its Monitor each 10 minutes while a suite runs."
status: "open"
priority: "low"
theme: "initiative"
---
# Backlog Entry: 0000591 - A monitor wait expires after 10 minutes

**Source feature:** 0000557-self-matching-pgrep-wait

**Source phase:** P2 Implement

**Deferral source:** discovered mid-flight

**Date filed:** 2026-11-16

---

## Problem

The wait that 0000557 teaches names an end marker, and a step session watches it with a Monitor. A Monitor expired after 10 minutes with no event, also in persistent mode. A 30-minute suite then needs three or more re-arms, and each one costs a turn.

Evidence: `plan/_archive/0000557-self-matching-pgrep-wait-2026-11-16/build-log.md`, P2 and P3 blocks. The P2 suite ran from 23:16 to 23:45 and needed three re-arms.

## Suggested Action

Name the expiry in the P0 start actions and the validate skill, with the re-arm step. Or name a wait form that does not expire, such as a background command that exits at the end marker.

## Why Deferred

It needs its own design decision on which wait form the skills name. Entry 0000532 asked only for the end marker or the process id.
