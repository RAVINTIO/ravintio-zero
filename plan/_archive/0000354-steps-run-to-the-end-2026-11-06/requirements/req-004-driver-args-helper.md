---
title: "Requirement: REQ-004 - One driver-arguments helper"
summary: "One driver-arguments helper."
status: "active"
version: "0.1.0"
---
# Requirement: REQ-004 - One driver-arguments helper

**Skill:** [plan](../../ravintio-zero/skills/ravintio-plan/SKILL.md)
**Feature:** 0000354-steps-run-to-the-end
**Version:** 0.52.0
**Source:** US-004
**Priority:** must-have

## User Story

As a maintainer, I want the three driver suites to read the `claude` arguments from one helper, so that a flag change edits one file.

## Functional Requirements
- `ravintio-zero/tests/helpers/driver-args.sh` prints the fixed prefix `-p --output-format stream-json --verbose --permission-mode auto`.
- `test-0000043-req-007-roadmap-driver.sh`, `test-0000151-req-006-roadmap-step-model-and-turn-cap.sh`, and `test-0000189-req-006-old-variable-stop.sh` build their expected strings from it.
- The resume tests use the helper too.

## Acceptance Criteria
- [ ] AC-1: one source
  - Given the three suites
  - When a test greps them
  - Then none repeats `--permission-mode auto`
- [ ] AC-2: suites pass
  - Given the refactor
  - When the three suites run
  - Then they pass
