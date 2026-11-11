---
title: "Backlog Entry: 0000526 - Test impact scan names frozen-line suites"
summary: "The plan's test impact scan misses the suites that freeze lines of a size-capped skill and the boot template cap."
status: "open"
priority: "low"
theme: "initiative"
---
# Backlog Entry: 0000526 - Test impact scan names frozen-line suites

**Source feature:** 0000521-replies-name-actors-by-role
**Source phase:** P2 Implement
**Deferral source:** retrospective, 2026-11-11
**Date filed:** 2026-11-11

---

## Problem

The test impact scan lists a `Size cap` cause for the orchestrator skill. It does not say that `test-0000151-req-011-orchestrator-references-split.sh` also freezes every base line of the skill and caps the boot templates at 3800 bytes. The first edit of step 59 changed a base line and the boot templates, and two checks failed.

Evidence: the step 59 execution plan `## Test impact` table and the P2 notes.

## Suggested Action

The `Size cap` and `Reference file edit` causes in `ravintio-plan/SKILL.md` name the frozen-line check and the boot template cap. A test in `test-0000383-req-001-005-test-impact-causes.sh` pins the wording.

## Why Deferred

Found during P2 of step 59. The fix edits a plan skill, which no requirement of the step covers.
