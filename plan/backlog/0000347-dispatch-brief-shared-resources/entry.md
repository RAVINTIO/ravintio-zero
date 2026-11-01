---
title: "Backlog Entry: 0000347 - Name shared resources in the concurrency plan"
summary: "A discovered-but-out-of-scope item deferred for pickup at a future discovery run."
status: "open"
---
# Backlog Entry: 0000347 - Name shared resources in the concurrency plan

**Source feature:** none (human request)
**Source phase:** none (human request)
**Deferral source:** human request
**Date filed:** 2026-11-01

---

## Problem

Copied from the `ravintio-docs` repo's retrospective `plan/retrospectives/0000016-site-regression-and-quality-2026-11-01.md`, run 0000016.

The execution plan's concurrency plan lists each unit's write targets, but not shared runtime resources. In run 0000016, two units both rebuilt `dist/` and served it on a fixed port. The concurrency plan put them in one parallel batch, and P2 had to run them in sequence and log a departure.

## Suggested Action

Add a `Shared resources` column to the concurrency plan in `execution-plan.template.md`, for build output, ports, and lock files. Have `consistency-check.mjs` (check 8) treat a shared resource like a shared write target.

## Why Deferred

It changes the pack. The `ravintio-docs` retrospective filed it here for the pack maintainer.
