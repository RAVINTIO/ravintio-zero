---
title: "Backlog Entry: 0000363 - the test impact scan misses the runner allowlist"
summary: "A retrospective finding: a run that adds a test helper fails the runner until it lists the file."
status: "open"
priority: "low"
theme: "plan-skill"
---
# Backlog Entry: 0000363 - the test impact scan misses the runner allowlist

**Source feature:** 0000354-steps-run-to-the-end
**Source phase:** P2
**Deferral source:** discovered mid-flight
**Date filed:** 2026-11-06

---

## Problem

`ravintio-zero/tests/run-tests.sh` stops with `Undiscovered file` for any file under `ravintio-zero/tests/` that its allowlist does not name. Step 4 of initiative 0000349 added `helpers/driver-args.sh`, and the full suite stopped until the allowlist listed it. The plan skill's test impact scan greps for skill counts, size caps, and backlog ids, and does not name the runner allowlist. Source retrospective: `plan/retrospectives/0000354-steps-run-to-the-end-2026-11-06.md`.

## Suggested Action

Add a cause to the test impact scan in `ravintio-zero/skills/ravintio-plan/SKILL.md`: the run adds a file under `ravintio-zero/tests/` that is not a `test-*.sh` suite. The scan then lists `run-tests.sh` and `run-tests.ps1` in the unit that adds the file.

## Why Deferred

The plan skill is outside the scope of the step that found it, and the skill text has a line budget.
