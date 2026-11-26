---
title: "Requirement: REQ-002 - Suites remove their temp folders on every exit"
summary: "Each named suite and the git-isolation helper remove their temp paths on exit and on a stop signal."
status: "active"
version: "0.1.1"
---
# Requirement: REQ-002 - Suites remove their temp folders on every exit

**Skill:** [plan](../skills/ravintio-plan/SKILL.md)
**Feature:** 0000583-step-temp-cleanup-after-merge
**Source:** US-002
**Priority:** must-have

## User Story

As a suite, I remove my temp folders on every exit including a stop signal, so that no `ravintio_*` entry outlives the run.

## Functional Requirements
- Suites `0000169-req-004`, `0000245-req-002`, `0000151-req-005`, `0000171-req-004`, and `0000029-req-001-003` remove every folder they make with `mktemp`.
- Each suite traps `TERM`, `INT`, and `HUP` and exits, so the `EXIT` trap runs.
- `0000171-req-004` also removes its `ravintio_0000171_req004_out_` folder.
- `helpers/git-isolation.sh` gives a function that installs the same signal traps for its config file.
- `run-tests.sh` sets `TMPDIR` to a private folder for every suite and removes that folder on exit.

## Acceptance Criteria
- [ ] AC-1: Normal exit leaves nothing
  - Given the user temp folder before a run
  - When each named suite ends
  - Then the folder holds no new `ravintio_*` or `ravintio-gitconfig*` entry
- [ ] AC-2: A stop signal leaves nothing
  - Given a named suite that holds a temp folder
  - When the test sends it `TERM`
  - Then the folder holds no new `ravintio_*` entry

## Dependencies
- None.
