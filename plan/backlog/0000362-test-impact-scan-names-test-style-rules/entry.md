---
title: "Backlog Entry: 0000362 - test impact scan names test style rules"
summary: "A new test failed a repo-wide style test that the plan phase never listed."
status: "open"
priority: "low"
theme: "pipeline-process"
---
# Backlog Entry: 0000362 - test impact scan names test style rules

**Source feature:** 0000352-coordinator-admin-in-step-prs
**Source phase:** P2
**Deferral source:** discovered mid-flight
**Date filed:** 2026-11-06

---

## Problem

The standards test written in step 2 used a `done < <(...)` loop. `test-0000164-req-008-no-process-substitution-loops.sh` bans that form for every file under `ravintio-zero/tests/`, and it failed in the full suite. The plan phase scans for tests that read an edited file. It has no cause for style rules that apply to a new test file. Source retrospective: `plan/retrospectives/0000352-coordinator-admin-in-step-prs-2026-11-06.md`.

## Suggested Action

Add a cause to the test impact scan in `ravintio-zero/skills/ravintio-plan/SKILL.md`: the run adds a test file. The scan then lists the repo-wide style tests under `ravintio-zero/tests/`, such as 0000164-req-008, so the test writer reads them first. A test can check that the skill names the cause.

## Why Deferred

The change edits the plan skill and needs its own test. Step 2 changes other skills and has no room in its scope.
