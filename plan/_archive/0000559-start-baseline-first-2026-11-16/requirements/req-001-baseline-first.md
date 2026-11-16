---
title: "Requirement: REQ-001 - Baseline first"
summary: "The start actions begin the baseline run before any action that writes a P0 artifact."
status: "active"
version: "0.1.0"
---
# Requirement: REQ-001 - Baseline first

**Skill:** [orchestrator](../skills/ravintio-orchestrator/SKILL.md)
**Feature:** 0000559-start-baseline-first
**Version:** 0.141.0
**Source:** US-001
**Priority:** must-have

## User Story

As a step session, I start the baseline run before I write any P0 artifact, so that P3 finds the result ready.

## Functional Requirements
- In `orchestrator-p0-start-actions.md`, the `p0-start-baseline` action comes before the stale run-mode, sentinel, build log, and `discovery.md` actions.
- The `p0-start-decisions` action comes after the pre-flight and before the baseline action.
- The baseline action says to log the start time and output path once the build log exists.
- Every cross-reference to a renumbered action names the new number.

## Acceptance Criteria
- [ ] AC-1: the baseline action comes first among the artifact actions
  - Given the numbered rule anchors of the start actions file
  - When a test reads their order
  - Then `p0-start-baseline` comes before `p0-start-stale-run-mode`, `p0-start-sentinel`, `p0-start-build-log`, and `p0-start-discovery-md`
- [ ] AC-2: the decision rows come before the baseline, after the pre-flight
  - Given the same order
  - When a test compares positions
  - Then `p0-start-preflight` comes before `p0-start-decisions`, and that comes before `p0-start-baseline`
- [ ] AC-3: cross-references follow the renumbering
  - Given the orchestrator skill, the roadmap standards, and the start actions file
  - When a test reads the cited step numbers
  - Then each cited number matches the position of the action it names

## Dependencies
- None
