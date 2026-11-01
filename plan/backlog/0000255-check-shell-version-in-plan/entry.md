---
title: "Backlog Entry: 0000255 - plan checks the target shell version"
summary: "A plan chose a Bash 4 feature that macOS Bash 3.2 lacks, and the plan skill has no check for it."
status: "open"
priority: "medium"
theme: "unsorted"
---
# Backlog Entry: 0000255 - plan checks the target shell version

**Source feature:** 0000239-test-suite-reliability
**Source phase:** P2
**Deferral source:** discovered mid-flight
**Date filed:** 2026-10-28

---

## Problem

The plan for 0000239-test-suite-reliability chose `command_not_found_handle`. macOS ships Bash 3.2, which lacks it, so P2 reworked the design (`plan/_archive/0000239-test-suite-reliability-2026-10-28/build-log.md`, first `Rework:` line). The plan skill has no step that checks a shell feature against the oldest supported shell. The source retrospective is `plan/retrospectives/0000239-test-suite-reliability-2026-10-28.md`.

## Suggested Action

Add a line to the plan skill: when an ADR picks a shell feature, name the oldest shell version it must run on and check the feature exists there.

## Wanted outcome

A plan that picks a shell feature absent from Bash 3.2 fails the consistency check or names the older shell in its ADR. A fixture ADR checks this.

## Why Deferred

It changes the plan skill and the consistency check, which are outside this feature.
