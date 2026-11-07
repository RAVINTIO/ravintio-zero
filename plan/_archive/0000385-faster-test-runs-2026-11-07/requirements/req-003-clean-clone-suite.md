---
title: "Requirement: req-003 - Clean clone suite"
summary: "P3 runs the suite in a clean clone of HEAD."
status: "active"
version: "0.1.0"
---
# Requirement: req-003 - Clean clone suite

**Skill:** [plan](../../../ravintio-zero/skills/ravintio-plan/SKILL.md)
**Feature:** 0000385-faster-test-runs
**Source:** US-003
**Priority:** must-have

## User Story

As a developer, I want P3 to run the suite in a clean clone of `HEAD`, so that its result matches CI.

## Functional Requirements

- `clean-clone-test.mjs [--workflow path] -- {command}` clones the repository, checks out the commit `HEAD` names, runs the command in the clone, and returns its exit code.
- It removes the clone on every exit.
- It prints `OS gap: local {os}, CI {os list}` when the local OS is not among the `runs-on` values of the workflow file.
- The validate skill runs it for the test check, reruns only failed suites after a failure, and runs the full suite once before acceptance.

## Acceptance Criteria

- [ ] AC-1: Clone used and removed
  - Given a repository with a committed file
  - When the script runs `pwd`
  - Then the output is a folder other than the repository
  - And that folder no longer exists after the script exits
- [ ] AC-2: Untracked file fails
  - Given a test that needs an untracked file
  - When the script runs the test
  - Then it exits non-zero
- [ ] AC-3: OS gap named
  - Given a workflow whose `runs-on` values exclude the local OS
  - When the script runs
  - Then it prints an `OS gap:` line

## Dependencies

- None
