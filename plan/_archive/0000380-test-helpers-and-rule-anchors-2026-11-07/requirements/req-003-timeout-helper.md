---
title: "Requirement: req-003 - Timeout helper"
summary: "A helper caps a command with a time limit on every runner."
status: "active"
version: "0.1.0"
---
# Requirement: req-003 - Timeout helper

**Skill:** [plan](../../../ravintio-zero/skills/ravintio-plan/SKILL.md)
**Feature:** 0000380-test-helpers-and-rule-anchors
**Source:** US-003
**Priority:** should-have

## User Story

As a test author, I cap a command with one helper line, so that the test passes on macOS, Linux, and Git Bash.

## Functional Requirements

- `with_timeout <seconds> <command>...` runs the command and stops it after the limit with exit code 124.
- It passes through the exit code of a command that finishes in time.
- It uses `perl` when present and a Bash watchdog otherwise, and never calls `timeout`.
- The two tests that need a limit use it, and `testing-standards.md` names it.

## Acceptance Criteria

- [ ] AC-1: Slow command stopped
  - Given a command that runs 30 seconds
  - When `with_timeout 1` runs it
  - Then the helper returns 124 within 5 seconds
- [ ] AC-2: Fast command passes
  - Given a command that exits 3 at once
  - When `with_timeout 5` runs it
  - Then the helper returns 3

## Dependencies

- None
