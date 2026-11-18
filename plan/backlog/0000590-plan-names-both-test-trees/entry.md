---
title: "Backlog Entry: 0000590 - the plan names both test trees when a unit adds a test"
summary: "A new test written only to ravintio-zero/tests/ fails the CI sync check, and the local suite cannot catch it during an initiative."
status: "open"
priority: "medium"
theme: "initiative"
---
# Backlog Entry: 0000590 - the plan names both test trees when a unit adds a test

**Source feature:** 0000546-queue-failure-leaves-dirty-files

**Source phase:** P4

**Deferral source:** retrospective

**Date filed:** 2026-11-15

---

## Problem

Step 2 of initiative 0000544 wrote its new test to `ravintio-zero/tests/` only. CI `validate-branch` failed on `sync-installed.mjs --check` with `extra: tests/...`. The check skips while an initiative is active, so the local suite did not catch it. The plan's Test impact scan has a `New test file` cause but no cause for the source copy.

## Suggested Action

Add a cause to `ravintio-zero/skills/ravintio-plan/references/test-impact-causes.md` for a new test file. It tells the plan to list `src/ravintio-zero/tests/` as a second write target. A test checks that the cause exists.

## Why Deferred

The step fixed its own copy. The cause needs a plan skill edit outside the step scope.

Source retrospective: `plan/retrospectives/0000546-queue-failure-leaves-dirty-files-2026-11-15.md`.
