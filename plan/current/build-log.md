---
title: "Build Log - 0000565-layout-move-test-impact"
summary: "Working record of the pipeline run, maintained by the orchestrator."
---
# Build Log - 0000565-layout-move-test-impact

## Header

| Field | Value |
|-------|-------|
| Feature ID | `0000565-layout-move-test-impact` |
| Pipeline start | `2026-11-15T16:04:14Z` |
| Tool | `claude-code` |
| Primary model | `sonnet` |
| Cheaper model | `haiku` |
| Run speed | `fast` |

---

## Phase Log

### P0: Discovery

| Field | Value |
|-------|-------|
| Start | `2026-11-15T16:04:14Z` |
| End | `2026-11-15T16:05:09Z` |
| Wall clock | `1` |
| Model tier | primary |
| Skills loaded | ravintio-orchestrator |
| Agents spawned | 0 |
| MCP calls | 0 |
| Parallel task batches | 0 |
| Notes | initiative 0000544 step 21 |

- Run mode: autonomous (2026-11-15T16:04:14Z)
- Run speed: fast (2026-11-15T16:04:14Z)
- Adoption mode: standard-iterative (signal: archive in plan/_archive beside source in src/)
- Version: 0.122.0 last known, step bump minor
- Baseline run started in the background: /tmp/step21-baseline.out
- Queue: no item names step 21
- Decision applied (initiative chart): Confirmation: setup rerun at each `Setup:` stop
- Decision applied (initiative chart): The step PR fails CI or conflicts after ship archived the run
- Decision applied (initiative chart): When to write `ready`
- Decision applied (initiative chart): A test pins text that the step edits
- Decision applied (initiative chart): Pack edits
- Decision applied (initiative chart): Known baseline failures
- Decision applied (initiative chart): A docs unit has no failing test, so `build-log-check.mjs` finds no `RED:` or `GREEN:` for it (0000410)
- Decision applied (initiative chart): Fast batches
- Scope lock, happy path: the scan names the cause and its three greps [source: draft-accepted (initiative)]
- Scope lock, first-run path: static text, no state [source: draft-accepted (initiative)]
- Scope lock, error path: a missing cause fails a test [source: draft-accepted (initiative)]
- Scope lock, cross-session path: committed text only [source: draft-accepted (initiative)]
- Design confirmation: draft-accepted (initiative)
- Complete: P0 (2026-11-15T16:05:09Z)

### P1: Plan

| Field | Value |
|-------|-------|
| Start | `2026-11-15T16:05:09Z` |
| End | `2026-11-15T16:05:09Z` |
| Wall clock | `1` |
| Model tier | primary |
| Skills loaded | ravintio-plan |
| Agents spawned | 0 |
| MCP calls | 0 |
| Parallel task batches | 0 |
| Notes | small change, units written inline |
- Complete: P1 (2026-11-15T16:05:09Z)

---

## Summary (filled at ship, P4)

| Metric | Value |
|--------|-------|
| Total phases completed | `PENDING` |
| Total wall clock | `PENDING` |
| Total agents spawned | `0` |
| Total MCP calls | `0` |
| Phases using parallelism | `0` |
| Primary tier agent calls | `0` |
| Cheaper tier agent calls | `0` |
| Self-corrections | `0` |
| Phases skipped | `none` |
