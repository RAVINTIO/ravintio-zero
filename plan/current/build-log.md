---
title: "Build Log - 0000566-test-impact-for-history-moves"
summary: "Working record of the pipeline run, maintained by the orchestrator."
---
# Build Log - 0000566-test-impact-for-history-moves

## Header

| Field | Value |
|-------|-------|
| Feature ID | `0000566-test-impact-for-history-moves` |
| Pipeline start | `2026-11-15T17:09:24Z` |
| Tool | `claude-code` |
| Primary model | `sonnet` |
| Cheaper model | `haiku` |
| Run speed | `fast` |

---

## Phase Log

### P0: Discovery

| Field | Value |
|-------|-------|
| Start | `2026-11-15T17:09:24Z` |
| End | `2026-11-15T17:10:20Z` |
| Wall clock | `1` |
| Model tier | primary |
| Skills loaded | ravintio-orchestrator |
| Agents spawned | 0 |
| MCP calls | 0 |
| Parallel task batches | 0 |
| Notes | initiative 0000544 step 22 |

- Run mode: autonomous (2026-11-15T17:09:24Z)
- Run speed: fast (2026-11-15T17:09:24Z)
- Adoption mode: standard-iterative (signal: archive in plan/_archive beside source in src/)
- Version: 0.123.0 last known, step bump minor
- Baseline run started in the background: /tmp/step22-baseline.out
- Queue: no item names step 22
- Decision applied (initiative chart): Confirmation: setup rerun at each `Setup:` stop
- Decision applied (initiative chart): The step PR fails CI or conflicts after ship archived the run
- Decision applied (initiative chart): When to write `ready`
- Decision applied (initiative chart): A test pins text that the step edits
- Decision applied (initiative chart): Pack edits
- Decision applied (initiative chart): Known baseline failures
- Decision applied (initiative chart): A docs unit has no failing test, so `build-log-check.mjs` finds no `RED:` or `GREEN:` for it (0000410)
- Decision applied (initiative chart): Fast batches
- Scope lock, happy path: the scan names the cause and greps tests for the archive exclusion lists [source: draft-accepted (initiative)]
- Scope lock, first-run path: static text, no state [source: draft-accepted (initiative)]
- Scope lock, error path: a missing cause fails a test [source: draft-accepted (initiative)]
- Scope lock, cross-session path: committed text only [source: draft-accepted (initiative)]
- Design confirmation: draft-accepted (initiative)
- Complete: P0 (2026-11-15T17:10:20Z)

### P1: Plan

| Field | Value |
|-------|-------|
| Start | `2026-11-15T17:10:20Z` |
| End | `{{pending}}` |
| Wall clock | `{{pending}}` |
| Model tier | primary |
| Skills loaded | ravintio-plan |
| Agents spawned | 0 |
| MCP calls | 0 |
| Parallel task batches | 0 |
| Notes | small change, units written inline |
