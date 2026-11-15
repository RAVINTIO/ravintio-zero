---
title: "Build Log - 0000546-queue-failure-leaves-dirty-files"
summary: "Working record of the pipeline run, maintained by the orchestrator."
---
# Build Log - 0000546-queue-failure-leaves-dirty-files

> Created at discovery (P0). Appended by the orchestrator at each phase boundary. Survives session changes.

## Header

| Field | Value |
|-------|-------|
| Feature ID | `0000546-queue-failure-leaves-dirty-files` |
| Pipeline start | `2026-11-15T19:17:07Z` |
| Tool | `claude-code` |
| Primary model | `sonnet` |
| Cheaper model | `haiku` |
| Run speed | `fast` |

---

## Phase Log

### P0: Discovery

| Field | Value |
|-------|-------|
| Start | `2026-11-15T19:17:07Z` |
| End | `2026-11-15T19:18:58Z` |
| Wall clock | 2 |
| Model tier | primary |
| Skills loaded | ravintio-orchestrator |
| Agents spawned | 0 |
| MCP calls | 0 |
| Parallel task batches | 0 |
| Notes | initiative 0000544 step 2 |

- Run mode: autonomous (2026-11-15T19:17:07Z)
- Run speed: fast (2026-11-15T19:17:07Z)
- Adoption mode: standard-iterative (signal: source in `src/` beside an archive)
- Track: light (the entry is a fix, the chart accepts the track)
- Decision applied (initiative chart): Confirmation: setup rerun at each `Setup:` stop
- Decision applied (initiative chart): The step PR fails CI or conflicts after ship archived the run
- Decision applied (initiative chart): When to write `ready`
- Decision applied (initiative chart): A test pins text that the step edits
- Decision applied (initiative chart): Pack edits
- Decision applied (initiative chart): Known baseline failures
- Decision applied (initiative chart): How much the queue may reset (0000477)
- Decision applied (initiative chart): A docs unit has no failing test, so `build-log-check.mjs` finds no `RED:` or `GREEN:` for it (0000410)
- Decision applied (initiative chart): Fast batches
- Queue: no items name step 2
- Bump: minor (row), version to plan with 0.125.0 to 0.126.0
- Scope Lock: skipped on the light track. The chart accepted the draft [source: draft-accepted (initiative)]

- Complete: P0 (2026-11-15T19:18:58Z)

---

### P1: Plan

| Field | Value |
|-------|-------|
| Start | `2026-11-15T19:18:58Z` |
| End | `2026-11-15T19:19:01Z` |
| Wall clock | 1 |
| Model tier | primary |
| Skills loaded | ravintio-plan |
| Agents spawned | 0 |
| MCP calls | 0 |
| Parallel task batches | 0 |
| Notes | inline, one requirement |

- Complete: P1 (2026-11-15T19:19:01Z)

---

### P2: Implement

| Field | Value |
|-------|-------|
| Start | `2026-11-15T19:19:28Z` |
| End | `2026-11-15T19:45:32Z` |
| Wall clock | 27 |
| Model tier | primary |
| Skills loaded | ravintio-implement |
| Agents spawned | 0 |
| MCP calls | 0 |
| Parallel task batches | 0 |
| Notes | inline units, batches are sequential (U2 test, U1 script, U3 docs) |

- Batches: 3, sequential, each depends on the one before it. No parallel batch applies.
- Baseline: the clean-clone run stopped after test-0000037-req-004 with no Failed suites list. The baseline file lists the three known failures from the chart Decisions row (2026-11-15T19:19:28Z)
- In progress: REQ-001 U2 test (2026-11-15T19:19:52Z)
- RED: REQ-001 U2 test (2026-11-15T19:19:52Z)
- In progress: REQ-001 U1 script (2026-11-15T19:22:00Z)
- RED: REQ-001 U1 script (the U2 test failed before the change, 2026-11-15T19:22:00Z)
- GREEN: REQ-001 U1 script (2026-11-15T19:22:00Z)
- Tests run: REQ-001: test-0000546-req-001-restore-written-files.sh, test-0000454-req-001, test-0000493-req-004, test-0000446-req-001, test-0000450-req-003, test-0000379-req-004, test-0000164-req-008, and every suite that names merge-queue, all passed (2026-11-15T19:22:00Z)
- Done: REQ-001 U1 script (code, inline, none, 2026-11-15T19:22:00Z)
- In progress: REQ-001 U3 docs (2026-11-15T19:22:16Z)
- RED: REQ-001 U3 docs (2026-11-15T19:22:16Z). The docs unit has no executable check (0000410, chart Decisions row).
- GREEN: REQ-001 U3 docs (2026-11-15T19:22:16Z). The consistency check and the prose check pass.
- Deviation: U3 writes `docs/decisions-index.md` and not `docs/about.md`. The about file says not to edit it by hand, and the queue sets the version. The execution plan names the written files (2026-11-15T19:22:16Z)
- Deviation: ADR-0347 has status accepted now, not at ship, because the decisions index row needs the status (2026-11-15T19:22:16Z)
- Done: REQ-001 U3 docs (content, inline, none, 2026-11-15T19:22:16Z)
- Tests run: full suite start (2026-11-15T19:22:29Z)
- Tests run: full suite, 463 feature suites passed, 1 failed (test-0000450-req-004-report-format.sh, inherited baseline), regression 19 passed (2026-11-15T19:45:32Z)
- Complete: P2 (2026-11-15T19:45:32Z)

---

### P3: Validate and Accept

| Field | Value |
|-------|-------|
| Start | `2026-11-15T19:45:32Z` |
| End | `2026-11-15T20:07:48Z` |
| Wall clock | 22 |
| Model tier | primary |
| Skills loaded | ravintio-validate-and-accept |
| Agents spawned | 0 |
| MCP calls | 0 |
| Parallel task batches | 0 |
| Notes | inline, clean-clone suite in the background |

- Tests run: clean clone, 461 feature suites passed, 3 failed, all inherited (test-0000037-req-004, test-0000318-req-004, test-0000450-req-004), regression 19 passed. `baseline-failures.mjs check` exit 0 (2026-11-15T20:07:48Z)
- OS gap: local macos, CI ubuntu, windows
- Library audit: no library added. Archetype gates: no gates installed. Security: low, no findings above informational
- Skipped: docs edit subagent (`prose-check.mjs` exits 0 for the three changed docs)
- Complete: P3 (2026-11-15T20:07:48Z)

---

### P4: Ship

| Field | Value |
|-------|-------|
| Start | `2026-11-15T20:07:48Z` |
| End | `2026-11-15T20:07:54Z` |
| Wall clock | 0 |
| Model tier | primary |
| Skills loaded | ravintio-ship |
| Agents spawned | 0 |
| MCP calls | 0 |
| Parallel task batches | 0 |
| Notes | initiative step, PR before archive |
- Deviation: CI `validate-branch` failed the sync check because the new test sat only in `ravintio-zero/tests/`. The agent copied it to `src/ravintio-zero/tests/` and updated the plan records (2026-11-15T20:09:57Z)
- Complete: P4 (2026-11-15T20:07:54Z)

---

## Summary (filled at ship, P4)

| Metric | Value |
|--------|-------|
| Total phases completed | `5` |
| Total wall clock | `52` |
| Total agents spawned | `0` |
| Total MCP calls | `0` |
| Phases using parallelism | `0` |
| Primary tier agent calls | `0` |
| Cheaper tier agent calls | `0` |
| Self-corrections | `0` |
| Phases skipped | `none` |
