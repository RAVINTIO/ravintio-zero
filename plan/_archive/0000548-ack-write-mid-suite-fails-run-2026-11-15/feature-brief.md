---
title: "Feature Brief - Strict-mode ack write mid-suite fails the suite run"
summary: "A step session that runs the full suite must not fail it when the strict hook asks for an ack."
status: "approved"
version: "0.1.0"
---
# Feature Brief - Strict-mode ack write mid-suite fails the suite run

**Feature ID:** 0000548-ack-write-mid-suite-fails-run

Source: backlog entry 0000476-ack-write-mid-suite-fails-run, pulled in by initiative 0000544 step 4.

## Business Goal

A step that runs the full suite in the background gets a strict-mode ack prompt mid-run. The ack write changes a tracked file, so `run-tests.sh` exits 1 with "Tree changed during the run: plan/.orchestrator-ack" although every suite passes. The fix removes the false failure without weakening the tree check.

## Features

| Feature | User Stories | Priority | Wave |
|---------|-------------|----------|------|
| Suite marker and quiet hook | As a step session, I run the full suite in the background, so that no ack prompt changes a tracked file mid-run | must-have | 1 |

## Scope Boundaries

### In Scope
- `run-tests.sh` and `run-tests.ps1` write a git-ignored marker `plan/.suite-running` that holds the runner pid, and remove it on exit.
- `check-orchestrator-presence.mjs` stays silent in strict mode for a step session while the marker names a live process.
- A test that checks both parts and shows the runner still exits 0 when a prompt reaches the hook mid-run.
- Docs for the hook and the runner.

### Out of Scope
- Any exemption of `plan/.orchestrator-ack` from the tree check (chart decision).
- A change to the coordinator banner or the advisory mode.

### Deferred
- Nothing deferred.

## Acceptance Criteria

- [ ] With `RAVINTIO_INITIATIVE_STEP=1`, strict mode, an unmatched session id, and a marker naming a live process, the hook prints nothing and exits 0.
- [ ] With a marker naming a dead process, or with no step variable, the hook still prints the strict banner.
- [ ] The runner creates the marker before its first suite and removes it on exit, and the tree check still fails when a suite changes `plan/.orchestrator-ack`.
