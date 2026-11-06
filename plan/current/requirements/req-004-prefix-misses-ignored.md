---
title: "Requirement: REQ-004 - prefix-misses log ignored"
summary: "Both ignore files hold plan/.prefix-misses.log, so a fresh clone and CI ignore it."
status: "active"
version: "0.1.0"
---
# Requirement: REQ-004 - prefix-misses log ignored

**Skill:** [plan](../skills/ravintio-plan/SKILL.md)
**Feature:** 0000357-guard-gaps-closed
**Source:** US-004
**Priority:** must-have

## User Story

As a developer, I find `plan/.prefix-misses.log` ignored in a fresh clone and in CI, so that the ignored-file check sees a forced add of it.

## Functional Requirements
- `ravintio-zero/.gitignore`, which setup copies to a repo with no `.gitignore`, holds the line `plan/.prefix-misses.log`.
- This repo's `.gitignore` holds the same line.
- The line carries a comment that names the hook that writes the log.

## Acceptance Criteria
- [ ] AC-1: both files ignore the log
  - Given a fresh clone
  - When `git check-ignore plan/.prefix-misses.log` runs, with `.git/info/exclude` empty
  - Then it prints the path
- [ ] AC-2: setup writes the rule
  - Given a repo with no `.gitignore`
  - When setup runs
  - Then the new `.gitignore` holds the line

## Dependencies
- None.
