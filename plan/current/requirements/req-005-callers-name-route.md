---
title: "Requirement: REQ-005 - Callers of --commit name the feat/ route"
summary: "The skills that call reserve-id.mjs --commit say to run it on a feat/ branch when the session sits on initiative/*."
status: "active"
version: "0.1.0"
---
# Requirement: REQ-005 - Callers of --commit name the feat/ route

**Skill:** [plan](../../../ravintio-zero/skills/ravintio-plan/SKILL.md)
**Feature:** 0000352-coordinator-admin-in-step-prs
**Source:** US-004
**Priority:** must-have

## User Story

As a coordinator, I read the `feat/` route in each skill that calls `reserve-id.mjs --commit`, so that I never meet the refusal unprepared.

## Functional Requirements
- The initiative, postmortem, and retrospective skills each say that `--commit` refuses on `initiative/*`.
- Each says to run it on a `feat/` branch, so the counter commit rides in a coordinator PR.
- The initiative skill `## Backlog queue` tells the coordinator not to reserve an id while the driver runs. A queued entry carries an `{id}` placeholder, and the step reserves the id.

## Acceptance Criteria
- [ ] AC-1: three skills name the route
  - Given the initiative, postmortem, and retrospective skills
  - When a reader looks at the `--commit` line
  - Then each says it refuses on `initiative/*` and names a `feat/` branch

## Dependencies
- REQ-001 adds the refusal.
