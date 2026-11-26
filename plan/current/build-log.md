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
| End | `2026-11-26T10:03:40Z` |
| Wall clock | 2 |
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

### P1: Plan

| Field | Value |
|-------|-------|
| Start | `2026-11-26T10:03:57Z` |
| End | `2026-11-26T10:05:13Z` |
| Wall clock | 2 |
| Model tier | primary |
| Skills loaded | ravintio-plan |
| Agents spawned | 0 |
| MCP calls | 0 |
| Parallel task batches | 0 |
| Notes | Artifacts written inline. The fast batch gave no gain for six small files. |

- Plan: consistency-check clean, human-settings-check none
- Plan: git fetch failed in the sandbox (github.com:22 denied), so branch-point reads use the local tracking ref

---

### P2: Implement

| Field | Value |
|-------|-------|
| Start | `2026-11-26T10:05:46Z` |
| End | `2026-11-26T11:07:40Z` |
| Wall clock | 61 |
| Model tier | primary |
| Skills loaded | ravintio-implement |
| Agents spawned | 0 |
| MCP calls | 0 |
| Parallel task batches | 0 |
| Notes | Units run inline in one tree. Each unit is one small file change, so a subagent costs more than it saves. |

- In progress: U-001 (2026-11-26T10:05:46Z)
- In progress: U-002 (2026-11-26T10:05:46Z)
- In progress: U-003 (2026-11-26T10:05:46Z)
- In progress: U-004 (2026-11-26T10:05:46Z)

---
- RED: U-001 (2026-11-26T10:05:55Z)
- RED: U-002 (2026-11-26T10:05:55Z)
- RED: U-003 (2026-11-26T10:05:55Z)
- RED: U-004 (2026-11-26T10:05:55Z)
- GREEN: U-001 (2026-11-26T10:07:07Z)
- GREEN: U-002 (2026-11-26T10:07:07Z)
- GREEN: U-003 (2026-11-26T10:07:07Z)
- GREEN: U-004 (2026-11-26T10:07:07Z)
- Done: U-001 (content, inline, none, 2026-11-26T10:07:07Z)
- Done: U-002 (code, inline, none, 2026-11-26T10:07:08Z)
- Done: U-003 (code, inline, none, 2026-11-26T10:07:08Z)
- Done: U-004 (code, inline, none, 2026-11-26T10:07:08Z)
- RED: U-005 living docs (docs, no executable check, 0000410, 2026-11-26T10:07:12Z)
- GREEN: U-005 living docs (docs, no executable check, 0000410, prose check passed at commit, 2026-11-26T10:07:26Z)
- Done: U-005 living docs (docs, inline, none, 2026-11-26T10:07:26Z)

- Tests run: impact suites 0000580, 0000386, 0000575, 0000358, 0000173, 0000043 req-012, 0000493 req-004, 0000164 req-008: all passed (2026-11-26T11:07:40Z)
- Tests run: full suite: not completed locally. The run passed the 10-minute background limit. Shard 1 of 4 ended with 17 failed suites and 3 failed regression suites. None covers a file this step changes. Four sampled failures (0000248 req-001, 0000248 req-002, 0000019 req-005, 0000388 req-001) fail the same way on the base commit in this sandbox. Causes are EPERM writes, a blocked network, and mktemp. Shard 2 stopped at the limit. CI runs the full suite at P4 (2026-11-26T11:07:40Z)

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
