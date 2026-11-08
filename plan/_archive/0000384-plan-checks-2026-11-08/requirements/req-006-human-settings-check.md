---
title: "Requirement: REQ-006 - Human-only settings check"
summary: "P1 reads the human-only settings that the chart names and blocks before P2 when one reads wrong."
status: "active"
version: "0.1.0"
---
# Requirement: REQ-006 - Human-only settings check

**Skill:** [plan](../skills/ravintio-plan/SKILL.md)
**Feature:** 0000384-plan-checks
**Source:** US-006
**Priority:** must-have

## User Story

As an initiative step, I want P1 to read each human-only setting that the chart names, so that a wrong setting blocks before P2.

## Functional Requirements
- A chart names a setting as a `## Decisions` row whose Fork starts `Human setting:`. The answer cell holds `GET {endpoint} {jq-path}={expected}`.
- `ravintio-zero/scripts/human-settings-check.mjs` reads those rows from `plan/current-initiative/initiative.md` and runs `gh api -X GET` for each. It uses no other method.
- The script accepts only endpoints that match an allowlist of repository setting reads. It refuses any other endpoint and exits 1.
- On a mismatch it prints `P1 Plan: Blocked: human-only setting {name} reads {actual}, wanted {expected}.` and exits 1. The plan skill runs the script before P2 and stops on exit 1.
- With no `Human setting:` row, the script prints `none` and exits 0.

## Acceptance Criteria
- [ ] AC-1: Mismatch blocks
  - Given a `Human setting:` row and a stubbed `gh` that returns a different value
  - When the script runs
  - Then it prints the `Blocked:` line and exits 1
- [ ] AC-2: Disallowed endpoint refused
  - Given a row whose endpoint is outside the allowlist
  - When the script runs
  - Then it exits 1 and calls `gh` zero times
- [ ] AC-3: No rows passes
  - Given a chart with no `Human setting:` row
  - When the script runs
  - Then it prints `none` and exits 0

## Dependencies
- `gh` CLI at run time
