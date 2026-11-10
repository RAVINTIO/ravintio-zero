---
title: "Requirement: REQ-002 - Driver recovery"
summary: "The driver recovers the PR number from the step branch when the ready file is bad."
status: "active"
version: "0.1.0"
---
# Requirement: REQ-002 - Driver recovery

**Skill:** [plan](../../ravintio-zero/skills/ravintio-plan/SKILL.md)
**Feature:** 0000442-ready-file-helper
**Source:** US-002
**Priority:** must-have

## User Story

As the driver, I recover the PR number from the step branch when the ready file is bad. Then a slip costs no stop.

## Functional Requirements
- If `ready` exists and is empty or fails the PR pattern, the driver runs `gh pr list --head feat/{feature-id} --state open --json number`.
- If the answer holds exactly one number that matches the pattern, the driver rewrites `ready` with it and prints `I-D Advance: Ready: step {n} recovered PR #{k} from the step branch`.
- If the lookup returns no PR, more than one, an unreadable answer, or an error, the driver stops with `I-C Run: Blocked: step {n} wrote an invalid ready file`.
- The driver passes the branch as one argument and never to a shell.

## Acceptance Criteria
- [ ] AC-1: Recover an empty file
  - Given a stub `gh` that lists one open PR for the step branch and an empty `ready` file
  - When the driver reads the control folder
  - Then the driver rewrites `ready` with that number and queues the step
- [ ] AC-2: Recover a timestamp
  - Given a `ready` file that holds a timestamp and the same stub
  - When the driver reads the control folder
  - Then the driver rewrites the file and carries on
- [ ] AC-3: Stop without a single PR
  - Given a stub `gh` that lists no PR, two PRs, or fails
  - When the driver reads an invalid `ready` file
  - Then the driver stops with the existing invalid ready file line

## Dependencies
- REQ-001 for the shared pattern.

## Input Validation

- [ ] Input source: the `gh` output and the `ready` file
- [ ] Allowed character pattern: the answer is JSON, and each number must match `^[1-9][0-9]{0,6}$`
- [ ] maximum length: 7 characters for the number
- [ ] Failure behaviour: stop with the existing line
- [ ] Logging policy: the stop line names the step only
