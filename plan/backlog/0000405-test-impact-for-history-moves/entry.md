---
title: "Backlog Entry: 0000405 - test impact scan misses suites that scan live files"
summary: "A run that moves archive content into a live folder broke eleven suites that the Test impact scan never listed."
status: "open"
priority: "medium"
theme: "plan-checks"
---
# Backlog Entry: 0000405 - test impact scan misses suites that scan live files

**Source feature:** 0000384-plan-checks
**Source phase:** P2
**Deferral source:** discovered mid-flight
**Date filed:** 2026-11-08

---

## Problem

Step 8 moved 270 ADRs from `plan/_archive/` to `docs/adr/`. Eleven suites scan live files and exclude `plan/_archive/` as history, so each flagged the moved text. The Test impact scan has no cause for a move into a live folder. The full suite found them after P2, and a fix pass followed. See the Rework lines in `plan/_archive/0000384-plan-checks-2026-11-08/build-log.md` and the retrospective `plan/retrospectives/0000384-plan-checks-2026-11-08.md`.

## Suggested Action

Add a cause to the plan skill's Test impact scan: the run moves or copies archived content into a live folder. Grep `ravintio-zero/tests/` for `plan/_archive/` exclusion lists and list each match.

## Wanted outcome

A plan that moves archived content into a live folder lists every suite with a `plan/_archive/` exclusion under `## Test impact`. A suite checks that the cause is named in the plan skill.

## Why Deferred

It edits the plan skill and a new suite, which are outside step 8.
