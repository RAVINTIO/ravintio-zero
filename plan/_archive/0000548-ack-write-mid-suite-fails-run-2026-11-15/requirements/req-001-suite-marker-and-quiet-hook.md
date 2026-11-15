---
title: "Requirement: REQ-001 - Suite marker and quiet hook"
summary: "The runners mark a live suite run and the strict hook stays quiet for a step session during it."
status: "active"
version: "0.1.0"
---
# Requirement: REQ-001 - Suite marker and quiet hook

**Skill:** [plan](../skills/ravintio-plan/SKILL.md)
**Feature:** 0000548-ack-write-mid-suite-fails-run
**Source:** US-001
**Priority:** must-have

## User Story

As a step session, I run the full suite in the background, so that no ack prompt changes a tracked file mid-run.

## Functional Requirements
- `run-tests.sh` and `run-tests.ps1` write `plan/.suite-running` with the runner pid before the tree snapshot, and remove it on exit.
- `plan/.suite-running` is in `.gitignore`.
- In strict mode, `check-orchestrator-presence.mjs` prints nothing and exits 0 when `RAVINTIO_INITIATIVE_STEP=1` and the marker holds the pid of a live process.
- A marker that holds a dead pid, or text that is not a pid, leaves the hook as it was.
- The tree check never exempts `plan/.orchestrator-ack`.

## Acceptance Criteria
- [ ] AC-1: Quiet hook during a suite run
  - Given strict mode, an unmatched session id, a step session, and a marker with a live pid
  - When the hook receives a prompt
  - Then the hook prints nothing and exits 0
- [ ] AC-2: Strict banner otherwise
  - Given strict mode and an unmatched session id
  - When the marker names a dead pid, or the session is not a step session
  - Then the hook prints the strict banner
- [ ] AC-3: Marker lifecycle and tree check
  - Given a runner on a repository
  - When the suites run and one changes `plan/.orchestrator-ack`
  - Then the marker exists during the run, the runner removes it on exit, and the tree check still fails

## Dependencies
- None.

## Input Validation

- [x] Input source: the marker file `plan/.suite-running`
- [x] Allowed character pattern: `[0-9]`, any other text counts as no marker
- [x] maximum length: 10 characters, the hook ignores a longer value
- [x] Failure behaviour: treat the marker as absent and show the strict banner
- [x] Logging policy: the hook never logs the marker content
