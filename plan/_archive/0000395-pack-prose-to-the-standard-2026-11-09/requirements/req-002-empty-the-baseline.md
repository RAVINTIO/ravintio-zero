---
title: "Requirement: REQ-002 - Empty the baseline"
summary: "The baseline drops with each batch and the tests stay green."
status: "draft"
version: "0.1.0"
---
# Requirement: REQ-002 - Empty the baseline

**Skill:** [plan](../../../ravintio-zero/skills/ravintio-plan/SKILL.md)
**Feature:** 0000395-pack-prose-to-the-standard
**Source:** US-002
**Priority:** must-have

## User Story

As a pack maintainer, I see the baseline drop with each fix, so that new breaches cannot hide behind old ones.

## Functional Requirements
- `plan/state/prose-baseline.json` holds no entry for a file in the pack, `docs/`, `ravintio-overrides/`, or the repository root. The six files in `ravintio-zero/migrations/_done/` are the exception, because a test pins them to `main`.
- Each batch commit lowers the baseline in the same commit as its fixes.
- A test that pins rewritten wording changes with the rewrite, and the build log holds a `Rework:` line for it.

## Acceptance Criteria
- [ ] AC-1: Baseline is empty for the pack
  - Given the rewrite is complete
  - When I read `plan/state/prose-baseline.json`
  - Then the only keys outside `plan/` are the six `ravintio-zero/migrations/_done/` files
- [ ] AC-2: The suite passes
  - Given the baseline update has landed
  - When I run `bash ravintio-zero/tests/run-tests.sh`
  - Then the suite fails no more suites than the baseline failures file lists

## Dependencies
- REQ-001.
