---
title: "Scope - Reshape at delivery"
summary: "Defines explicit boundaries of what is in scope and out of scope."
status: "active"
version: "0.1.0"
---
# Scope - Reshape at delivery

**Skill:** [plan](../../ravintio-zero/skills/ravintio-plan/SKILL.md)
**Feature:** 0000353-reshape-at-delivery
**Version:** 0.51.0

## In Scope

- `reshape-initiative.mjs` and its tests.
- Tag moves by delete and recreate, with `--tags` and `--push`.
- The I-E Delivery rules and the initiative skill text.
- The ship skill change that removes `--force-with-lease`.

## Out of Scope

- Driver and watcher changes (step 4).
- Any change to `merge-guard` or another fail-closed hook.
- Deleting the old branch from the script. The coordinator does it after the human merges.

## Deferred

- None. Entry 0000345 is complete once this step ships.
