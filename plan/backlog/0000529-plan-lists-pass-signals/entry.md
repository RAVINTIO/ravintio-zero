---
title: "Backlog Entry: 0000529 - Plan lists every way a check can pass"
summary: "The plan skill asks the planner to list each way a checked component produces a pass signal."
status: "open"
priority: "medium"
theme: "plan-skill"
---
# Backlog Entry: 0000529 - Plan lists every way a check can pass

**Source feature:** 0000507-hook-check-after-setup

**Source phase:** P4

**Deferral source:** discovered mid-flight

**Date filed:** 2026-11-12

---

## Problem

The hook check first treated exit 2 as a pass for a guard. `guard-run.mjs` also exits 2 for a guard script it cannot run, so a missing guard passed. P3 execution verification found it. The plan skill in `src/ravintio-zero/skills/ravintio-plan/SKILL.md` has no step that lists the ways a checked component produces its pass signal. The postmortem is `plan/postmortems/2026-11-12-missing-guard-passed-hook-check.md`, and the retrospective is `plan/retrospectives/0000507-hook-check-after-setup-2026-11-12.md`.

## Suggested Action

Add a step to the plan skill. For a requirement that judges another component by its exit code, the planner lists each path that produces the pass signal. The list includes the failure paths of any launcher in between. Each path gets an acceptance criterion.

## Why Deferred

The change edits a skill and its size-cap tests. It needs its own design decision and stays outside the scope of step 55.
