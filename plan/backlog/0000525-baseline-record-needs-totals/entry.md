---
title: "Backlog Entry: 0000525 - Baseline record needs a finished run"
summary: "baseline-failures.mjs record accepts unfinished runner output and records no failures."
status: "open"
priority: "medium"
theme: "initiative"
---
# Backlog Entry: 0000525 - Baseline record needs a finished run

**Source feature:** 0000521-replies-name-actors-by-role
**Source phase:** P2 Implement
**Deferral source:** retrospective, 2026-11-11
**Date filed:** 2026-11-11

---

## Problem

`node ravintio-zero/scripts/baseline-failures.mjs record` reads only the `Failed suites:` list. Output from a clean-clone run that has not finished holds no such list. The script then wrote `None.` and exited 0. A later `check` would have flagged the three inherited suites as new.

Evidence: the step 59 build log, P2 block, and the first `baseline-failures.md` commit.

## Suggested Action

`record` exits 2 with one line on stderr when the input holds no `Feature suites:` totals line. A test covers a partial output file.

## Why Deferred

Found during P2 of step 59. The fix edits the baseline script, which no requirement of the step covers.
