---
title: "Requirement: REQ-001 - Safe suite wait"
summary: "The P0 start actions and the P3 skill name the safe wait, and a test bans the unsafe one."
status: "active"
version: "0.1.0"
---
# Requirement: REQ-001 - Safe suite wait

**Skill:** [plan](../skills/ravintio-plan/SKILL.md)
**Feature:** 0000557-self-matching-pgrep-wait
**Source:** US-001
**Priority:** must-have

## User Story

As a step session, I wait on an end marker or a process id, so that my wait ends with the suite.

## Functional Requirements
- P0 start action 15 says to wait on the end marker in the output file or on the process id that the launch returned.
- The fast batch of `ravintio-validate-and-accept` says the same for the background suite.
- Both texts say never to wait with `pgrep -f`, and they say why: the pattern also matches the shell that runs the loop.
- A test fails if a skill or standard line holds `pgrep -f` without `Never`.
- Both pack trees carry the change.

## Acceptance Criteria
- [ ] AC-1: P0 names the wait
  - Given the P0 start actions reference
  - When a test reads step 15
  - Then it names the end marker, the process id, and the `pgrep -f` ban
- [ ] AC-2: P3 names the wait
  - Given the validate-and-accept skill
  - When a test reads its fast batch
  - Then it names the end marker, the process id, and the `pgrep -f` ban
- [ ] AC-3: No unsafe wait
  - Given every skill and standard in the pack
  - When a test greps for `pgrep -f`
  - Then each match line also holds `Never`

## Dependencies
- None.
