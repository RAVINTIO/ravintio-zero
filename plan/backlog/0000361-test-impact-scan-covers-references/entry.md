---
title: "Backlog Entry: 0000361 - test impact scan covers skill reference files"
summary: "A retrospective finding, filed for pickup at a future discovery run."
status: "open"
priority: "low"
theme: "pipeline-checks"
---
# Backlog Entry: 0000361 - test impact scan covers skill reference files

**Source feature:** 0000351-step-titles-and-history-shape
**Source phase:** P4
**Deferral source:** retrospective `plan/retrospectives/0000351-step-titles-and-history-shape-2026-11-06.md`
**Date filed:** 2026-11-06

---

## Problem

The plan skill's test impact scan triggers on an edit to a `SKILL.md`. It ignores the files in `ravintio-zero/skills/*/references/`. In step 0000351, an edit to a line in `orchestrator-p0-start-actions.md` broke the frozen-line test `test-0000151-req-011-orchestrator-references-split.sh`. P2 found it only in the full suite, which cost one rework cycle.

## Suggested Action

Add a cause to the Test impact scan in `ravintio-zero/skills/ravintio-plan/SKILL.md`: the run edits a file in a skill's `references/` folder. The grep names the file and finds the frozen-line test. A test could check that the plan skill names the cause.

## Why Deferred

The step's scope was the history check and the title forms.
