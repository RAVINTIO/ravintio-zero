---
title: "Build Log - 0000574-delivery-pr-lists-steps-in-version-order"
summary: "Working record of the pipeline run, maintained by the orchestrator."
---
# Build Log - 0000574-delivery-pr-lists-steps-in-version-order

> Created at discovery (P0). Appended by the orchestrator at each phase boundary. Survives session changes.

## Header

| Field | Value |
|-------|-------|
| Feature ID | `0000574-delivery-pr-lists-steps-in-version-order` |
| Pipeline start | `2026-11-16T07:03:00Z` |
| Tool | `claude-code` |
| Primary model | `claude-sonnet-5-5` |
| Cheaper model | `haiku` |
| Run speed | `fast` |

---

## Phase Log

### P0: Discovery

| Field | Value |
|-------|-------|
| Start | `2026-11-16T07:03:00Z` |
| End | `` |
| Wall clock | `` |
| Model tier | primary |
| Skills loaded | ravintio-orchestrator |
| Agents spawned | `0` |
| MCP calls | `0` |
| Parallel task batches | `0` |
| Notes | initiative step 30 of 0000544, started from an unfinished step with 0 branch commits |

- Decision applied (initiative chart): Confirmation: setup rerun at each `Setup:` stop
- Decision applied (initiative chart): The step PR fails CI or conflicts after ship archived the run
- Decision applied (initiative chart): When to write `ready`
- Decision applied (initiative chart): A test pins text that the step edits
- Decision applied (initiative chart): Pack edits
- Decision applied (initiative chart): Known baseline failures
- Decision applied (initiative chart): A docs unit has no failing test, so `build-log-check.mjs` finds no `RED:` or `GREEN:` for it (0000410)
- Decision applied (initiative chart): Fast batches
- Queue: no item names step 30
- Baseline: clean-clone suite started at 2026-11-16T07:03:44Z, output in `/tmp/step30/baseline.out`
- Adoption mode: standard-iterative (signal: archive beside source in `plan/_archive/`)
- Run mode: autonomous (initiative step)
- Run speed: fast (2026-11-16T07:05:00Z)
