---
title: "Requirement: REQ-001 - no tree-wide git under subagents"
summary: "The orchestrator and implement skills ban tree-wide git commands while a subagent runs and name the scratch clone."
status: "active"
version: "0.1.0"
---
# Requirement: REQ-001 - no tree-wide git under subagents

**Skill:** [plan](../skills/ravintio-plan/SKILL.md)
**Feature:** 0000359-safe-parallel-commits
**Source:** US-001, US-002
**Priority:** must-have

## User Story

As a maintainer, I find the orchestrator and implement skills ban `git stash`, `git checkout -- {path}`, `git reset`, and `git clean` while a subagent runs, so that no step changes the tree under a running unit.

As a maintainer, I find the implement skill names a scratch clone as the way to test a clean tree mid-phase, so that a unit needing one has a safe route.

## Functional Requirements
- The orchestrator skill states that while any subagent of the step runs, the step session never runs `git stash`, `git checkout -- {path}`, `git reset`, or `git clean`. The addition stays under 200 bytes.
- The implement skill states the same ban, names a scratch clone in a scratch folder as the way to test a clean tree, and says to record in the build log when the step waits for its subagents before a tree-wide git operation.
- The dispatch standard's existing subagent ban stays as it is.

## Acceptance Criteria
- [ ] AC-1: orchestrator names the commands
  - Given the orchestrator skill
  - When a test reads it
  - Then it names the four commands and the words "subagent" and "never"
- [ ] AC-2: implement names the clone and the log note
  - Given the implement skill
  - When a test reads it
  - Then it names the four commands, "scratch clone", and the build log note
- [ ] AC-3: caps hold
  - Given the orchestrator skill and the skill text
  - When a test measures them
  - Then the orchestrator holds at most 9000 bytes and the skill text at most 1720 lines

## Dependencies
- None.
