---
title: "Requirement: REQ-001 - Marker script"
summary: "A script appends a RED, GREEN, or Done line with a clock-read time."
status: "draft"
version: "0.1.0"
---
# Requirement: REQ-001 - Marker script

**Skill:** [plan](../skills/ravintio-plan/SKILL.md)
**Feature:** 0000575-build-log-marker-helper
**Source:** US-001
**Priority:** must-have

## User Story

As a step session, I append a marker line with one command, so that its time comes from a clock read.

## Functional Requirements
- `node ravintio-zero/scripts/build-log-mark.mjs <kind> <unit>` takes the kind `RED`, `GREEN`, or `Done`, in any letter case.
- The script appends `- {KIND}: {unit} ({time})` to `plan/current/build-log.md`. The time is the UTC clock read in the form `YYYY-MM-DDTHH:MM:SSZ`.
- The kind `Done` also takes `--class`, `--tier`, and `--effort`. Its line reads `- Done: {unit} ({class}, {tier}, {effort}, {time})`.
- The `--log` flag names another build log. The script inserts a line before a `## Summary` heading when one exists.
- The script exits 2 with one stderr line on a refusal.
- A refusal is a bad kind, a missing unit, a missing `Done` field, a missing log, or a symlinked log.

## Acceptance Criteria
- [ ] AC-1: RED and GREEN lines
  - Given a build log
  - When the script runs with the kind `RED` and a unit
  - Then the log ends with `- RED: {unit} ({time})` and the exit code is 0
- [ ] AC-2: Done line
  - Given a build log
  - When the script runs with the kind `Done`, a unit, and the three flags
  - Then the log ends with the `Done:` line in the dispatch standard form
- [ ] AC-3: Refusals
  - Given a bad kind, a missing field, a missing log, or a symlinked log
  - When the script runs
  - Then it exits 2, writes one stderr line, and changes no file

## Dependencies
- none
