---
title: "Requirement: REQ-001 - Pause script and records"
summary: "One script writes the step and initiative pause records."
status: "active"
version: "0.1.0"
---
# Requirement: REQ-001 - Pause script and records

**Skill:** [plan](../skills/ravintio-plan/SKILL.md)
**Feature:** 0000555-initiative-pause-reaches-every-step
**Source:** US-001
**Priority:** must-have

## User Story

As the human on the loop, I pause an initiative with one command. The initiative and each running step then get a pause record.

## Functional Requirements
- `initiative-pause.mjs write --root {dir}` writes `plan/current/pause.md` in the worktree of each running step, from `pause.template.md`.
- A running step is a control folder `plan/.initiative-control/step-{n}/` that holds `running` and no `ready`.
- Each step record takes the phase and the active task from the last lines of the step build log. It treats the text as data.
- The script writes `plan/current-initiative/pause.md` with the merged count, the remaining step order, the open questions, and the resume steps.
- The script refuses a symlink at a control folder, a worktree, or a pause path, and it never overwrites a record that exists.

## Acceptance Criteria
- [ ] AC-1: Step records
  - Given a root with two running steps and their worktrees
  - When the script runs `write`
  - Then each worktree holds `plan/current/pause.md` with its phase and active task
- [ ] AC-2: Initiative record
  - Given the same root
  - When the script runs `write`
  - Then `plan/current-initiative/pause.md` holds the merged count, the remaining order, the open questions, and the resume steps
- [ ] AC-3: Refusals
  - Given a symlinked worktree or an existing record
  - When the script runs `write`
  - Then it exits 1 and names the path

## Dependencies
- `pause.template.md` and the control folder layout of the driver.
