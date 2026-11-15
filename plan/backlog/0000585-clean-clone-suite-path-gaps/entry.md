---
title: "Backlog Entry: 0000585 - Clean-clone suite path gaps"
summary: "Three suites fail in the clean-clone P3 run and pass in the working tree."
status: "open"
priority: "medium"
theme: "test-reliability"
---
# Backlog Entry: 0000585 - Clean-clone suite path gaps

**Source feature:** 0000545-clear-feature-id-at-ship

**Source phase:** P3

**Deferral source:** discovered mid-flight

**Date filed:** 2026-11-15

---

## Problem

The P3 clean-clone run fails three suites that pass in the working tree. Source: retrospective `plan/retrospectives/0000545-clear-feature-id-at-ship-2026-11-15.md`.

- `test-0000037-req-004-remove-old-folder.sh` expects `core.hooksPath` to read `ravintio-zero/hooks`. A fresh clone sets none.
- `test-0000318-req-004-merge-guard-pinned.sh` diffs `merge-guard.mjs` against `origin/initiative/0000312-guards-history-and-test-noise`. The clone has no such branch, and the file has changed since.
- `test-0000450-req-004-report-format.sh` finds the repo root with `$ZERO_DIR/../..`. From `ravintio-zero/tests/` that path leaves the repo, so `docs/` reads empty.

`baseline-failures.mjs check` reports each as `new:`, so the agent must prove each one inherited by hand.

## Suggested Action

Make each suite set up what it needs, or skip with a named reason in a clean clone. Add the three to the baseline only if a fix is out of reach.

## Why Deferred

The step changes ship Step 8 and the queue resolver. The three suites touch neither.
