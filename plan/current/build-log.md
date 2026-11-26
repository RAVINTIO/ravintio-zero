---
title: "Build Log - 0000580-log-non-tdd-units"
summary: "Working record of the pipeline run, maintained by the orchestrator."
---
# Build Log - 0000580-log-non-tdd-units

> Created at discovery (P0). Appended by the orchestrator at each phase boundary. Survives session changes.

## Header

| Field | Value |
|-------|-------|
| Feature ID | `0000580-log-non-tdd-units` |
| Pipeline start | `2026-11-26T10:02:15Z` |
| Tool | `claude-code` |
| Primary model | `claude-sonnet-5-5` |
| Cheaper model | `claude-haiku-5-5` |
| Run speed | `fast` |

---

## Phase Log

### P0: Discovery

| Field | Value |
|-------|-------|
| Start | `2026-11-26T10:02:15Z` |
| End | |
| Wall clock | |
| Model tier | primary |
| Skills loaded | ravintio-orchestrator |
| Agents spawned | 0 |
| MCP calls | 0 |
| Parallel task batches | 0 |
| Notes | initiative 0000544 step 36, backlog entry 0000410 |

- Run mode: autonomous (2026-11-26T10:02:15Z)
- Run speed: fast (2026-11-26T10:02:15Z)
- Baseline: clean-clone full suite started 2026-11-26T10:01:50Z, output in the session temp folder `s36/baseline.txt`
- Decision applied (initiative chart): Pack edits
- Decision applied (initiative chart): A test pins text that the step edits
- Decision applied (initiative chart): Known baseline failures
- Decision applied (initiative chart): Guard cut-back: `build-log-check.mjs` (0000410)
- Decision applied (initiative chart): A docs unit has no failing test, so `build-log-check.mjs` finds no `RED:` or `GREEN:` for it (0000410)
- Decision applied (initiative chart): Fast batches
- Decision not applicable (initiative chart): Confirmation: setup rerun at each `Setup:` stop: the step runs no setup
- Decision not applicable (initiative chart): The step PR fails CI or conflicts after ship archived the run: no CI has run yet
- Decision not applicable (initiative chart): When to write `ready`: applies at P4
- Adoption mode: standard-iterative (signal: `plan/_archive/` holds prior runs, source in `src/`)
- Version: last known 0.150.0, step bump minor
- Queue: no item names step 36
- Scope Lock (happy path): The agent logs both markers with class docs and a Done line. The check and report accept them [source: draft-accepted (initiative)]
- Scope Lock (first-run path): A log with no docs unit shows no docs row and the check behaves as before [source: draft-accepted (initiative)]
- Scope Lock (error path): A docs Done line with no marker fails check 7 and exits 1 [source: draft-accepted (initiative)]
- Scope Lock (cross-session continuity): An interrupted unit resumes through the In progress line, with no new state [source: draft-accepted (initiative)]
- Backlog pickup: 0000410 pulled in from the step row, folder deleted in the same commit

---

## Summary (filled at ship, P4)

| Metric | Value |
|--------|-------|
| Total phases completed | |
| Total wall clock | |
| Total agents spawned | |
| Total MCP calls | |
| Phases using parallelism | |
| Primary tier agent calls | |
| Cheaper tier agent calls | |
| Self-corrections | |
| Phases skipped | |
