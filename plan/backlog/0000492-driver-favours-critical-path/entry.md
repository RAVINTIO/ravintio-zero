---
title: "Backlog Entry: 0000492 - Driver favours the critical path"
summary: "The driver fills a free slot with any step that can start."
status: "open"
priority: "high"
theme: "initiative"
---
# Backlog Entry: 0000492 - Driver favours the critical path

**Source feature:** 0000491-driver-favours-critical-path
**Source phase:** I-C Run
**Deferral source:** human request, 2026-11-10
**Date filed:** 2026-11-10

---

## Problem

The driver fills a free slot with any step that can start. It does not favour the longest chain of dependent steps. On 2026-11-10 the driver lane, steps 24 to 29 then 41, waited while steps in shorter lanes ran, so the initiative took hours longer.

Evidence row: 29 in `plan/current-initiative/coordinator-evidence.md`.

## Suggested Action

When several steps can start, the driver starts first the one with the longest chain of steps waiting behind it.

## Why Deferred

Found during I-C Run of initiative 0000360, after the step 22 retrospective. The human asked for it as its own step.
