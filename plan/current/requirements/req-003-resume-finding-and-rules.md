---
title: "Requirement: REQ-003 - Resume finding and rules"
summary: "Resume detection reads the initiative pause record first, and the standards state the rules."
status: "active"
version: "0.1.0"
---
# Requirement: REQ-003 - Resume finding and rules

**Skill:** [plan](../skills/ravintio-plan/SKILL.md)
**Feature:** 0000555-initiative-pause-reaches-every-step
**Source:** US-002
**Priority:** must-have

## User Story

As the human on the loop, I restart the driver and each step resumes from its own record. No work repeats.

## Functional Requirements
- `resume-detect.mjs` prints `initiative pause record present` when `plan/current-initiative/pause.md` exists. The line comes before the step findings.
- `orchestrator-resume-detection.md` maps the finding to check 3 and says the orchestrator reads the initiative record first.
- `roadmap-standards.md` holds a section on pause with rules `icpause-request`, `icpause-records`, and `icpause-resume`.
- The initiative skill says how the coordinator pauses and resumes, in one line.

## Acceptance Criteria
- [ ] AC-1: Finding
  - Given `plan/current-initiative/pause.md`
  - When `resume-detect.mjs` runs
  - Then it prints `initiative pause record present` before the `pause record present` line
- [ ] AC-2: Rules
  - Given the standards and the skill
  - When a reader looks for the pause rule
  - Then both name the request, the records, and the resume order

## Dependencies
- REQ-001 and REQ-002 for the names they define.
