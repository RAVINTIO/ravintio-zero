---
title: "Requirement: REQ-001 - Rebuild rule in I-D Advance"
summary: "I-D Advance tells a step to rebuild the backlog index after a manual base merge and names the CI check that fails otherwise."
status: "active"
version: "0.1.0"
---
# Requirement: REQ-001 - Rebuild rule in I-D Advance

**Skill:** [plan](../skills/ravintio-plan/SKILL.md)
**Feature:** 0000547-step-merge-regenerates-index
**Source:** US-001
**Priority:** must-have

## User Story

As a step session, I rebuild the backlog index after a manual base merge, so that CI does not fail on a stale index.

## Functional Requirements
- `### I-D Advance` in the roadmap standards says to run `node ravintio-zero/scripts/backlog-index.mjs` after a manual base merge.
- The rule says to commit the result before the push.
- The rule names the `Check the backlog index` step of the `validate-branch` job as the check that fails on a stale index.
- The rule sits in both pack trees, `src/ravintio-zero/` and `ravintio-zero/`.

## Acceptance Criteria
- [ ] AC-1: Rebuild command named
  - Given the I-D Advance section
  - When a step merges the base branch by hand
  - Then the section says to run `node ravintio-zero/scripts/backlog-index.mjs` and commit the result before the push
- [ ] AC-2: Failing check named
  - Given the I-D Advance section
  - When a reader looks for the cost of skipping the rebuild
  - Then the section names the `Check the backlog index` step of `validate-branch`

## Dependencies
- None
