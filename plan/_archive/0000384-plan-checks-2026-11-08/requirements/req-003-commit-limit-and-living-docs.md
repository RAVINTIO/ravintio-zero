---
title: "Requirement: REQ-003 - Commit limit and living docs unit"
summary: "The dispatch template states the subject limit and the plan check demands a living docs unit."
status: "active"
version: "0.1.0"
---
# Requirement: REQ-003 - Commit limit and living docs unit

**Skill:** [plan](../skills/ravintio-plan/SKILL.md)
**Feature:** 0000384-plan-checks
**Source:** US-003
**Priority:** must-have

## User Story

As a dispatching agent, I want the dispatch template to state the 72-character subject limit and the plan to hold a living docs unit, so that no subagent retries a commit and ship writes no living docs.

## Functional Requirements
- The agent dispatch template in `agent-dispatch-standards.md` states that a commit subject has at most 72 characters.
- The plan skill Concurrency plan guidance adds a living docs unit that writes the files under `docs/` that the run changes.
- `consistency-check.mjs` check 10 fails an execution plan whose Concurrency plan has no unit that writes a path under `docs/`.

## Acceptance Criteria
- [ ] AC-1: Limit in the template
  - Given the dispatch standard
  - When a test reads the dispatch template
  - Then it states the 72-character subject limit
- [ ] AC-2: Missing unit fails
  - Given an execution plan with no unit that writes under `docs/`
  - When `consistency-check.mjs` runs
  - Then it exits 1 and names the missing living docs unit
- [ ] AC-3: Present unit passes
  - Given a plan with a unit that writes `docs/decisions-index.md`
  - When `consistency-check.mjs` runs
  - Then check 10 reports no finding

## Dependencies
- None
