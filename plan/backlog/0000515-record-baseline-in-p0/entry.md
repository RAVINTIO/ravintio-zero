---
title: "Backlog Entry: 0000515 - P0 records the baseline failures file"
summary: "P0 start action 15 saves the baseline output but a run can skip the record call, so P3 finds no baseline file."
status: "open"
priority: "medium"
theme: "pipeline"
---
# Backlog Entry: 0000515 - P0 records the baseline failures file

**Source feature:** 0000442-ready-file-helper

**Source phase:** P3

**Deferral source:** discovered mid-flight

**Date filed:** 2026-11-10

**Renumbered:** filed as 0000479, which a second entry also took. Step 44 (0000485) renumbered it to 0000515.

---

## Problem

Step 25 started the baseline run in P0 and saved its output. It never ran `baseline-failures.mjs record`, so `plan/current/baseline-failures.md` did not exist at P3. The first `check` reported both inherited failures as new. The run recorded the baseline late from the saved output.

## Suggested Action

Make `clean-clone-test.mjs` or the P0 start action run `baseline-failures.mjs record` when the run ends. Alternatively, let `check` report a missing baseline file as an error and not as an empty baseline.

## Wanted outcome

Take the second option. `baseline-failures.mjs check` exits 1 with "no baseline recorded" when the file is missing. A test covers the missing-file case.

The human approved this outcome at the chart of initiative 0000544 on 2026-11-14.

## Why Deferred

The step scope covers the ready file only. The fix touches P0 and P3 tooling and needs its own design.

Retrospective: `plan/retrospectives/0000442-ready-file-helper-2026-11-10.md`.
