---
title: "Requirement: REQ-001 - Unfinished step finding"
summary: "Resume detection prints a finding when a step session has no build log and no archive."
status: "active"
version: "0.1.0"
---
# Requirement: REQ-001 - Unfinished step finding

**Skill:** [plan](../skills/ravintio-plan/SKILL.md)
**Feature:** 0000556-step-session-finds-unfinished-step
**Source:** US-001
**Priority:** must-have

## User Story

As a step session, I read a finding that names the missing P0, so that I start P0 without piecing the state together.

## Functional Requirements
- `resume-detect.mjs` reads the feature id from the branch name `feat/{id}` or `hotfix/{id}`. The id must match `{7 digits}-{kebab-case}`.
- In a step session, if `plan/current/build-log.md` is absent and no folder `plan/_archive/{id}-*` exists, the script prints `unfinished step: no build log and no archive, start P0`.
- The script then prints `step branch commits: {n}`, where n counts the commits on the branch that the initiative branch lacks.
- If the branch name or git cannot be read, the script prints neither line and exits 0.
- `orchestrator-resume-detection.md` maps both lines to a check in a new table row and a bullet under check 3. The orchestrator reference tells the session to start P0.
- Both pack trees carry the change: `src/ravintio-zero/` and `ravintio-zero/`.

## Acceptance Criteria
- [ ] AC-1: Finding prints
  - Given a step session whose branch has no build log and no archive
  - When resume detection runs
  - Then it prints the unfinished-step line and the commit count line
- [ ] AC-2: Finding stays silent
  - Given a build log, an archive folder, no step session, or an unreadable branch
  - When resume detection runs
  - Then it prints neither line and exits 0
- [ ] AC-3: Reference maps the lines
  - Given the resume-detection reference
  - When a test reads it
  - Then it holds both lines and says to start P0

## Dependencies
- None.
