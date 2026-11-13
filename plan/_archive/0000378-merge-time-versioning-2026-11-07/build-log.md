---
title: "Build Log - 0000378-merge-time-versioning"
summary: "Working record of the pipeline run, maintained by the orchestrator."
---
# Build Log - 0000378-merge-time-versioning

> Created at discovery (P0). Appended by the orchestrator at each phase boundary. Survives session changes.

## Header

| Field | Value |
|-------|-------|
| Feature ID | `0000378-merge-time-versioning` |
| Pipeline start | `2026-11-07T16:25:21Z` |
| Tool | `Claude Code` |
| Primary model | `claude-sonnet-5-5` |
| Cheaper model | `claude-haiku-5-5` |
| Run speed | `standard` |

Run mode: autonomous (2026-11-07T16:25:21Z, initiative step 2)

---

## Phase Log

### P0: Discovery

| Field | Value |
|-------|-------|
| Start | `2026-11-07T16:25:21Z` |
| End | `2026-11-07T16:27:14Z` |
| Wall clock | 2 |
| Model tier | primary |
| Skills loaded | ravintio-orchestrator |
| Agents spawned | 0 |
| MCP calls | 0 |
| Parallel task batches | 0 |
| Notes | initiative step 2 of 21. Migrations 0004 and 0005 stay pending (Applies when is false in the pack source). |

Scope Lock (happy path): Two ready step PRs in reverse chart order merge one at a time with consecutive versions in merge order [source: draft-accepted (initiative)]
Scope Lock (first-run path): With no step version yet, the queue starts from the initiative branch version [source: draft-accepted (initiative)]
Scope Lock (error path): A bad title, a differing version file, or red CI stops the queue before the merge with a named error [source: draft-accepted (initiative)]
Scope Lock (cross-session continuity): The queue commits version and chart row onto the PR branch before the merge, so a rerun finds them applied [source: draft-accepted (initiative)]
Scope Lock complete. All four scenario paths captured.
Decision applied (initiative chart): Steps 1 and 2 still bump in P4
Decision applied (initiative chart): Where the PR title check runs (0000372)
Decision applied (initiative chart): Version files differ after a bump (0000368)
Version: 0.58.0 (minor bump from 0.57.0, initiative row Bump)
Backlog pulled in: 0000374, 0000376, 0000372, 0000368 (folders deleted in f77ab590)
Complete: P0 (2026-11-07T16:27:14Z)

### P1: Plan

| Field | Value |
|-------|-------|
| Start | `2026-11-07T16:27:14Z` |
| End | `2026-11-07T16:29:00Z` |
| Wall clock | 2 |
| Model tier | primary |
| Skills loaded | ravintio-plan |
| Agents spawned | 0 |
| MCP calls | 0 |
| Parallel task batches | 0 |
| Notes | none |

Complete: P1 (2026-11-07T16:29:00Z)

### P2: Implement

| Field | Value |
|-------|-------|
| Start | `2026-11-07T16:29:00Z` |
| End | `2026-11-07T16:48:23Z` |
| Wall clock | 19 |
| Model tier | primary |
| Skills loaded | ravintio-implement |
| Agents spawned | 4 |
| MCP calls | 0 |
| Parallel task batches | 2 |
| Notes | none |

Parallel batches: batch 1 U1 and U3, batch 2 U2 and U4 (U2 started once U1 finished, U4 once U3 finished), batch 3 U5 docs inline. Tier: primary (sonnet), class code.
Rework: REQ-005: U4 changed the req-003 AC-1 fixture in test-0000353-req-001-004-reshape-script.sh because the fold now clears its conflict (2026-11-07T16:48:23Z)
Complete: P2 (2026-11-07T16:48:23Z)

### P3: Validate and Accept

| Field | Value |
|-------|-------|
| Start | `2026-11-07T16:48:23Z` |
| End | `2026-11-07T16:49:02Z` |
| Wall clock | 1 |
| Model tier | primary |
| Skills loaded | ravintio-validate-and-accept |
| Agents spawned | 0 |
| MCP calls | 0 |
| Parallel task batches | 0 |
| Notes | none |

Complete: P3 (2026-11-07T16:49:02Z)

### P4: Ship

| Field | Value |
|-------|-------|
| Start | `2026-11-07T16:49:02Z` |
| End | `2026-11-07T16:49:11Z` |
| Wall clock | 0 |
| Model tier | primary |
| Skills loaded | ravintio-ship |
| Agents spawned | 0 |
| MCP calls | 0 |
| Parallel task batches | 0 |
| Notes | none |

Complete: P4 (2026-11-07T16:49:11Z)

---

## Summary

| Metric | Value |
|--------|-------|
| Total phases completed | `5` |
| Total wall clock | `24` |
| Total agents spawned | `4` |
| Total MCP calls | `0` |
| Phases using parallelism | `1` |
| Primary tier agent calls | `4` |
| Cheaper tier agent calls | `0` |
| Self-corrections | `0` |
| Phases skipped | none |
