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
| End | `2026-11-16T07:05:23Z` |
| Wall clock | `3` |
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
- Backlog: pulled in 0000543 (initiative row), folder deleted, index regenerated
- Scope Lock (happy path): the coordinator runs the script and pastes the version-ordered table [source: draft-accepted (initiative)]
- Scope Lock (first-run path): not applicable, the script keeps no state [source: draft-accepted (initiative)]
- Scope Lock (error path): a chart with no usable Version fails before any table prints [source: draft-accepted (initiative)]
- Scope Lock (cross-session continuity): not applicable, the script writes no state besides the new branch [source: draft-accepted (initiative)]
- Version: plan 0.143.0 (minor on 0.142.0)
- Complete: P0 (2026-11-16T07:05:23Z)

### P1: Plan

| Field | Value |
|-------|-------|
| Start | `2026-11-16T07:05:52Z` |
| End | `2026-11-16T07:07:18Z` |
| Wall clock | `1` |
| Model tier | primary |
| Skills loaded | ravintio-plan |
| Agents spawned | `0` |
| MCP calls | `0` |
| Parallel task batches | `0` |
| Notes | none |

- Skipped: ADRs (no decision meets an ADR criterion)
- Audit: no advisory requirement

- Complete: P1 (2026-11-16T07:07:18Z)

### P2: Implement

| Field | Value |
|-------|-------|
| Start | `2026-11-16T07:07:31Z` |
| End | `` |
| Wall clock | `` |
| Model tier | primary |
| Skills loaded | ravintio-implement |
| Agents spawned | `0` |
| MCP calls | `0` |
| Parallel task batches | `0` |
| Notes | Units are small and share files with their tests, so the agent ran both inline. |
- RED: U2-rule-6-order (2026-11-16T07:09:08Z)
- RED: U1-printed-table (2026-11-16T07:09:08Z)
- GREEN: U2-rule-6-order (2026-11-16T07:09:09Z)
- GREEN: U1-printed-table (2026-11-16T07:09:09Z)
- Done: U2-rule-6-order (content, inline, none, 2026-11-16T07:09:09Z)
- Done: U1-printed-table (content, inline, none, 2026-11-16T07:09:09Z)
- RED: U3 sync both trees (no executable check, 0000410) (2026-11-16T07:09:22Z)
- GREEN: U3 sync both trees (no executable check, 0000410, passed: sync-installed.mjs --check exit 0) (2026-11-16T07:09:23Z)
- Done: U3 sync both trees (content, inline, none, 2026-11-16T07:09:23Z)
- RED: U4 living docs (no executable check, 0000410) (2026-11-16T07:09:23Z)
- GREEN: U4 living docs (no executable check, 0000410, passed: the prose check on commit) (2026-11-16T07:09:23Z)
- Done: U4 living docs (content, inline, none, 2026-11-16T07:09:23Z)
- Note: the agent wrote the U1 and U2 markers after the unit runs. The suites showed 8 FAIL lines at 2026-11-16T07:08Z before the edits and 0 after. The marker times show when the agent logged them.
- Tests run: REQ-001: test-0000574-req-001-rule-6-order.sh (2026-11-16T07:09:23Z)
- Tests run: REQ-002, REQ-003: test-0000574-req-002-003-printed-table.sh, test-0000353-req-001-004-reshape-script.sh, test-0000378-req-004-merge-order.sh, test-0000378-req-005-reshape-folds.sh (2026-11-16T07:09:23Z)
