---
title: "Backlog Entry: 0000600 - Find colliding seven-digit ADR ids"
summary: "id-collisions.mjs matches four-digit ADR numbers only, so it misses collisions in repos that use seven digits."
status: "open"
priority: "medium"
theme: "initiative"
---
# Backlog Entry: 0000600 - Find colliding seven-digit ADR ids

**Source feature:** none (human request)

**Source phase:** none (human request)

**Deferral source:** human request

**Date filed:** 2026-11-25

---

## Problem

`ravintio-zero/scripts/id-collisions.mjs` matches ADR files with `^docs/adr/(\d{4})-`. The consumer `claude-code-launcher` names ADRs with seven digits, as in `docs/adr/0000003-registry-owns-sessions-file.md`. Two parallel steps there both added ADR 0000003 and 0000004. The module found no collision, and the coordinator renumbered the files by hand.

The consumer filed this as its backlog entry 0000026.

## Suggested Action

Accept four to seven digits in `ADR_FILE`. Keep the width of the existing number when the module renames a file.

## Observable condition

A test merges two branches that each add a seven-digit ADR with the same number. The module renames one file to the next free seven-digit id.

## Why Deferred

Found in a consumer repo during an initiative run. The fix belongs to the pack, not the consumer.
