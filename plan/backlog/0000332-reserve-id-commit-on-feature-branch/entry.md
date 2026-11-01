---
title: "Backlog Entry: 0000332 - id reservation commit lands directly on the initiative branch"
summary: "reserve-id.mjs --commit commits the counter file on the current branch, which is a direct commit when the coordinator sits on the initiative branch."
status: "open"
priority: "medium"
theme: "unsorted"
---
# Backlog Entry: 0000332 - id reservation commit lands directly on the initiative branch

**Source feature:** 0000318-titled-coordinator-prs
**Source phase:** P3
**Deferral source:** discovered mid-flight
**Date filed:** 2026-11-01

---

## Problem

The initiative skill (`ravintio-zero/skills/ravintio-initiative/SKILL.md`, Backlog queue) tells the coordinator to reserve ids with `node ravintio-zero/scripts/reserve-id.mjs --commit`. The flag commits `plan/backlog/.next-id` alone on the current branch. If the coordinator runs it on the initiative branch, the commit is direct and untitled. Step 6 made every other coordinator change a titled PR and left this one.

## Suggested Action

Run the reservation on the coordinator's `feat/` branch so the counter commit rides in the coordinator PR. Or make `--commit` refuse to run on `initiative/*`. Add a test for the chosen route.

## Why Deferred

The fix changes a script and its contract with the queue. Entry 0000274 covered the written rules only.
