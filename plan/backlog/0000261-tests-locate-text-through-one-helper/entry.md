---
title: "Backlog Entry: 0000261 - tests locate orchestrator text through one helper"
summary: "Ten tests hard-coded where Resume Detection text lives, so moving the section broke them. A shared helper stops that."
status: "open"
priority: "medium"
theme: "unsorted"
---
# Backlog Entry: 0000261 - tests locate orchestrator text through one helper

**Source feature:** 0000243-session-start-detection
**Source phase:** P2
**Deferral source:** discovered mid-flight
**Date filed:** 2026-10-28

Source retrospective: `plan/retrospectives/0000243-session-start-detection-2026-10-28.md`.

---

## Problem

Moving the Resume Detection checks into a reference file broke ten tests and two regression copies. Each read `ravintio-zero/skills/ravintio-orchestrator/SKILL.md` directly and cut the section out with its own `sed` or `awk` range. Step 6 moves more sections, so the same breakage will recur. The helper `orch_combined` in `ravintio-zero/tests/helpers/assert.sh` already joins `SKILL.md` and the references, but each test extracts a section on its own.

## Suggested Action

Add a helper to `ravintio-zero/tests/helpers/assert.sh` that returns a named section from `SKILL.md` and every reference file together. Move the tests that extract the Resume Detection, Exception Stops, and Phase Invocation sections onto it.

## Wanted outcome

Moving a section between `SKILL.md` and a reference file fails no test that asserts the section's text. A test that finds a heading in neither place still fails.

## Why Deferred

Step 5 only repointed the tests it broke. A shared helper touches more tests and belongs to its own step, ahead of step 6.
