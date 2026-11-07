---
title: "Build Log - 0000351-step-titles-and-history-shape"
summary: "Working record of the pipeline run, maintained by the orchestrator."
---
# Build Log - 0000351-step-titles-and-history-shape

> Created at discovery (P0). Appended by the orchestrator at each phase boundary. Survives session changes.

## Header

| Field | Value |
|-------|-------|
| Feature ID | `0000351-step-titles-and-history-shape` |
| Pipeline start | `2026-11-05T23:51:38Z` |
| Tool | `claude-code` |
| Primary model | `claude-sonnet-5-5` |
| Cheaper model | `claude-haiku-5-5` |
| Run speed | `standard` |

---

## Phase Log

### P0: Discovery

| Field | Value |
|-------|-------|
| Start | `2026-11-05T23:51:38Z` |
| End | `2026-11-05T23:52:36Z` |
| Wall clock | `1` |
| Model tier | primary |
| Skills loaded | ravintio-orchestrator |
| Agents spawned | 0 |
| MCP calls | 0 |
| Parallel task batches | 0 |
| Notes | Initiative 0000349 step 1. Migrations 0004 and 0005 hold ledger rows (not applicable), so none ran. |

Run mode: autonomous (2026-11-05T23:51:38Z)
Run speed: standard (2026-11-05T23:51:38Z)
Backlog pull-in (initiative row): 0000350, 0000339, 0000268 pulled in and deleted. 0000345 pulled in for rule 4 only and kept for steps 2 and 3.
Version: 0.49.0 (step Bump minor, from 0.48.1)
Scope Lock (happy path): chart fills Title, P0 uses it, ship titles the PR, the check passes N + 1 [source: draft-accepted (initiative)]
Scope Lock (first-run path): a chart without a Title column fails the check with a clear message [source: draft-accepted (initiative)]
Scope Lock (error path): a mistitled step or extra commit exits 1 and prints it [source: draft-accepted (initiative)]
Scope Lock (cross-session continuity): the check keeps no state [source: draft-accepted (initiative)]
Scope Lock complete. All four scenario paths captured.

### P1: Plan

| Field | Value |
|-------|-------|
| Start | `2026-11-05T23:53:50Z` |
| End | `2026-11-05T23:53:55Z` |
| Wall clock | `0` |
| Model tier | primary |
| Skills loaded | ravintio-plan |
| Agents spawned | 0 |
| MCP calls | 0 |
| Parallel task batches | 0 |
| Notes | Artifacts written inline. The units are small and share `roadmap-standards.md`, so a subagent split adds overhead. |

Complete: P1 (autonomous, no gate stop)

### P2: Implement

| Field | Value |
|-------|-------|
| Start | `2026-11-05T23:54:02Z` |
| End | `2026-11-06T00:18:31Z` |
| Wall clock | `24` |
| Model tier | primary (orchestration), sonnet (units) |
| Skills loaded | ravintio-implement |
| Agents spawned | 2 |
| MCP calls | 0 |
| Parallel task batches | 1 |
| Notes | Batches follow the Concurrency plan: batch 1 holds U1 and U2 in parallel, batch 2 holds U3. |

Deviation: archived chart lookup takes the first `plan/_archive/{id}-*/initiative.md`, because real archive folders don't hold `-initiative-`. REQ-003 and ADR-001 updated.
Deviation: one start-action line stays frozen (test 0000151-req-011), so the brief-title note is a new line.
Complete: P2 (full suite 262 feature and 19 regression suites pass)

### P3: Validate and Accept

| Field | Value |
|-------|-------|
| Start | `2026-11-06T00:18:37Z` |
| End | `2026-11-06T00:18:57Z` |
| Wall clock | `0` |
| Model tier | primary |
| Skills loaded | ravintio-validate-and-accept |
| Agents spawned | 0 |
| MCP calls | 0 |
| Parallel task batches | 0 |
| Notes | none |

Rework: REQ-001: frozen start-action line changed in place (2026-11-06T00:18:57Z)
Complete: P3 (autonomous, evidence in acceptance-evidence.md)

### P4: Ship

| Field | Value |
|-------|-------|
| Start | `2026-11-06T00:19:11Z` |
| End | `2026-11-06T00:19:18Z` |
| Wall clock | `0` |
| Model tier | primary |
| Skills loaded | ravintio-ship, ravintio-retrospective |
| Agents spawned | 0 |
| MCP calls | 0 |
| Parallel task batches | 0 |
| Notes | none |

Complete: P4 (autonomous)

---

## Summary (filled at ship, P4)

| Metric | Value |
|--------|-------|
| Total phases completed | `5` |
| Total wall clock | `28` |
| Total agents spawned | `2` |
| Total MCP calls | `0` |
| Phases using parallelism | `1` |
| Primary tier agent calls | `0` |
| Cheaper tier agent calls | `2` |
| Self-corrections | `1` |
| Phases skipped | `none` |
