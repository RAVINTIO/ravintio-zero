---
title: "Build Log - 0000561-old-name-guard-fails-in-full-suite"
summary: "Working record of the pipeline run, maintained by the orchestrator."
---
# Build Log - 0000561-old-name-guard-fails-in-full-suite

> Created at discovery (P0). Appended by the orchestrator at each phase boundary. Survives session changes.

## Header

| Field | Value |
|-------|-------|
| Feature ID | `0000561-old-name-guard-fails-in-full-suite` |
| Pipeline start | `2026-11-18T07:48:23Z` |
| Tool | `claude-code` |
| Primary model | `claude-sonnet-5-5` |
| Cheaper model | `haiku` |
| Run speed | `fast` |

---

## Phase Log

### P0: Discovery

| Field | Value |
|-------|-------|
| Start | `2026-11-18T07:48:23Z` |
| End | `2026-11-18T07:50:14Z` |
| Wall clock | `4` |
| Model tier | primary |
| Skills loaded | ravintio-orchestrator |
| Agents spawned | `0` |
| MCP calls | `0` |
| Parallel task batches | `0` |
| Notes | initiative step 17, started from an unfinished step with 0 branch commits |

- Decision applied (initiative chart): Confirmation: setup rerun at each `Setup:` stop
- Decision applied (initiative chart): The step PR fails CI or conflicts after ship archived the run
- Decision applied (initiative chart): When to write `ready`
- Decision applied (initiative chart): A test pins text that the step edits
- Decision applied (initiative chart): Pack edits
- Decision applied (initiative chart): Known baseline failures
- Decision applied (initiative chart): Guard cut-back: the old-name guard (0000527)
- Decision applied (initiative chart): A docs unit has no failing test, so `build-log-check.mjs` finds no `RED:` or `GREEN:` for it (0000410)
- Decision applied (initiative chart): Fast batches
- Queue: no item names step 17
- Baseline: clean-clone suite started at 2026-11-18T07:48:23Z, output in `/tmp/step17/baseline.out`
- Adoption mode: standard-iterative (signal: archive beside source in `plan/_archive/`)
- Run mode: autonomous (initiative step)
- Run speed: fast (2026-11-18T07:49:00Z)
- Complete: P0 (2026-11-18T07:50:14Z)

---

## Summary (filled at ship, P4)

| Metric | Value |
|--------|-------|
| Total phases completed | `` |
| Total wall clock | `` |
| Total agents spawned | `` |
| Total MCP calls | `` |
| Phases using parallelism | `` |
| Primary tier agent calls | `` |
| Cheaper tier agent calls | `` |
| Self-corrections | `` |
| Phases skipped | `` |
