---
title: "Backlog Entry: 0000256 - hold the expected claude arguments in one test helper"
summary: "Four driver suites repeat the expected claude argument string, so each driver flag change edits all four."
status: "open"
priority: "medium"
theme: "unsorted"
---
# Backlog Entry: 0000256 - hold the expected claude arguments in one test helper

**Source feature:** 0000240-stream-step-session-activity
**Source phase:** P2
**Deferral source:** discovered mid-flight
**Date filed:** 2026-10-28

---

## Problem

Adding `--output-format stream-json --verbose` to the driver broke assertions in `test-0000043-req-007-roadmap-driver.sh`, `test-0000151-req-006-roadmap-step-model-and-turn-cap.sh`, and `test-0000189-req-006-old-variable-stop.sh`. Each suite repeats the full `-p --permission-mode auto ...` string. Any later driver flag change edits the same suites again. Source retrospective: `plan/retrospectives/0000240-stream-step-session-activity-2026-10-28.md`.

## Suggested Action

Add a helper in `ravintio-zero/tests/helpers/` that prints the fixed argument prefix, and make the three suites call it.

## Why Deferred

It is a test refactor outside the stream feature, and steps 13 and 14 of initiative 0000238 may change the driver again.
