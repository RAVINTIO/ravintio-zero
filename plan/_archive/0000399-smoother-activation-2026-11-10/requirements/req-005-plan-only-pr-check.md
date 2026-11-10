---
title: "Requirement: REQ-005 - Plan-only PR check"
summary: "A script decides whether a coordinator PR skips the full suite."
status: "draft"
version: "0.1.0"
---
# Requirement: REQ-005 - Plan-only PR check

**Skill:** [plan](../../../ravintio-zero/skills/ravintio-plan/SKILL.md)
**Feature:** 0000399-smoother-activation
**Source:** US-005
**Priority:** should-have

## User Story

As the human, I skip the full suite when only `plan/` files changed, so that activation does not wait 10 minutes.

## Functional Requirements
- `coordinator-pr-check.mjs` takes a base commit and lists the changed files.
- When every changed file is under `plan/`, it runs `backlog-index --check` and the chart parse, prints `plan-only`, and exits 0.
- Otherwise it prints `full-suite`, exits 0, and runs neither check.
- The initiative skill states the rule.

## Acceptance Criteria
- [ ] AC-1: Plan-only change
  - Given every changed file since the base is under `plan/`
  - When the script runs
  - Then it runs the plan format checks, prints `plan-only`, and exits 0
- [ ] AC-2: Other change
  - Given one changed file is outside `plan/`
  - When the script runs
  - Then it prints `full-suite`, exits 0, and runs no check
- [ ] AC-3: Skill states the rule
  - Given the initiative skill text
  - When a test reads it
  - Then it names the plan-only rule and the script

## Dependencies
- ADR-0297
