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

### P1: Plan

| Field | Value |
|-------|-------|
| Start | `2026-11-18T07:50:14Z` |
| End | `2026-11-18T07:51:39Z` |
| Wall clock | `2` |
| Model tier | primary |
| Skills loaded | ravintio-plan |
| Agents spawned | `0` |
| MCP calls | `0` |
| Parallel task batches | `0` |
| Notes | 2 requirements, no ADR (no decision meets an ADR criterion), consistency check clean, human-settings-check passed |

- Complete: P1 (2026-11-18T07:51:39Z)

### P2: Implement

| Field | Value |
|-------|-------|
| Start | `2026-11-18T07:51:39Z` |
| End | `2026-11-18T08:35:19Z` |
| Wall clock | `44` |
| Model tier | primary |
| Skills loaded | ravintio-implement |
| Agents spawned | `0` |
| MCP calls | `0` |
| Parallel task batches | `0` |
| Notes | U1 inline. No batch departs from the plan. Units are sequential: the sync, the docs, and the full run depend on U1. Deviation: the cause is a flaky allowlist match, not a changed tree. The design, REQ-001, REQ-002, ADR-0196, and the changelog record it. |

- RED: U1 (2026-11-18T07:54:59Z)
- GREEN: U1 (2026-11-18T07:55:09Z)
- Done: U1 (content, inline, none, 2026-11-18T07:55:09Z)
- Tests run: REQ-001: test-0000189-req-007-old-name-guard.sh (2026-11-18T07:55:09Z)
- Tests run: REQ-002: test-0000189-req-007-old-name-guard.sh (2026-11-18T07:55:09Z)
- Tests run: full suite: 500 passed, 3 failed (2026-11-18T08:35:19Z)
- Baseline: clean-clone suite ended with 3 inherited failures, recorded in `plan/current/baseline-failures.md`
- Complete: P2 (2026-11-18T08:35:19Z)

### P3: Validate and Accept

| Field | Value |
|-------|-------|
| Start | `2026-11-18T08:35:19Z` |
| End | `2026-11-18T08:36:22Z` |
| Wall clock | `2` |
| Model tier | primary |
| Skills loaded | ravintio-validate-and-accept |
| Agents spawned | `1` |
| MCP calls | `0` |
| Parallel task batches | `0` |
| Notes | Fast batch not used: the full suite had already run in P2 on the same commit. Docs edit pass ran 1 cycle on a sonnet subagent. |

- Tests run: full suite: 500 passed, 3 failed, all 3 inherited (2026-11-18T08:35:19Z)
- Docs edit pass: changelog split one sentence, ADR-0196 paragraph unchanged, prose-check exit 0
- Execution verification: 15 solo guard runs passed, see `plan/current/verification-report.md`
- Security: 0 critical or high findings
- Acceptance: autonomous, evidence in `plan/current/acceptance-evidence.md`
- Complete: P3 (2026-11-18T08:36:22Z)

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
