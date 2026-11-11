---
title: "Requirement: REQ-001 - Driver handoff"
summary: "A Restart-only hit starts a successor driver at once."
status: "active"
version: "0.1.0"
---
# Requirement: REQ-001 - Driver handoff

**Skill:** [plan](../../../ravintio-zero/skills/ravintio-plan/SKILL.md)
**Feature:** 0000493-driver-starts-after-restart
**Source:** US-001
**Priority:** must-have

## User Story

As the coordinator, I want a new driver to start steps at once after a Restart. A ready step then never waits for unrelated steps.

## Functional Requirements
- After a merge, the concurrent driver checks the changed files. A hit on a watched file with no setup file is a Restart-only hit.
- On a Restart-only hit, the driver fast-forwards the root to the merged ref, as the approved setup command does.
- The driver then spawns `node {script} --root {root} --handoff`. The child runs detached and shares the driver's output and error handles.
- The driver writes the child pid into the lock file. It never releases that lock.
- The driver prints `I-D Advance: Restart: step {n} changed {files}. A new driver took over new starts.`
- After the handoff, the old driver starts no step and runs no queue. It exits 0 when its own sessions end.

## Acceptance Criteria
- [ ] AC-1: Restart-only merge hands off
  - Given step 2 runs and step 3 is ready to start
  - When step 1 merges and changed `initiative-run.mjs`
  - Then the successor starts step 3 while step 2 still runs
- [ ] AC-2: Setup hit keeps the stop
  - Given a merge changed a setup file
  - When the driver checks the files
  - Then it prints the existing `Setup:` or `Restart: Setup:` stop and hands off nothing
- [ ] AC-3: A failed handoff keeps the stop
  - Given the spawn fails or the root cannot fast-forward
  - When the driver tries the handoff
  - Then it prints the existing `Restart:` stop line and starts no new step

## Dependencies
- REQ-002 and REQ-003 define what the successor does.
- ADR-0323 records the decision.
