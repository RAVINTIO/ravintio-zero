---
title: "Build Log - 0000420-version-both-copies"
summary: "Working record of the pipeline run, maintained by the orchestrator."
---
# Build Log - 0000420-version-both-copies

> Created at discovery (P0). Appended by the orchestrator at each phase boundary. Survives session changes.

## Header

| Field | Value |
|-------|-------|
| Feature ID | `0000420-version-both-copies` |
| Pipeline start | `2026-11-10T00:25:25Z` |
| Tool | `claude-code` |
| Primary model | `claude-opus-5-5` |
| Cheaper model | `claude-sonnet-5-5` |
| Run speed | `fast` |

---

## Phase Log

### P0: Discovery

| Field | Value |
|-------|-------|
| Start | `2026-11-10T00:25:25Z` |
| End | `2026-11-10T00:25:25Z` |
| Wall clock | `0` |
| Model tier | primary |
| Skills loaded | ravintio-orchestrator |
| Agents spawned | `0` |
| MCP calls | `0` |
| Parallel task batches | `0` |
| Notes | Coordinator fix in initiative 0000360 while the driver is stopped, so step 21 can merge. Departure: no `plan/.orchestrator-ack`, because the initiative skill forbids it and the strict hook accepts `plan/.initiative-ack`. |

- Adoption mode: standard-iterative (signal: plan/_archive/ holds prior runs)

- Design confirmed under the human's standing approval for queue fixes (2026-11-10T00:25:25Z). Run mode: autonomous. Run speed: fast.

Complete: P0 (2026-11-10T00:25:25Z)

### P1: Plan

| Field | Value |
|-------|-------|
| Start | `2026-11-10T00:25:25Z` |
| End | `2026-11-10T00:27:17Z` |
| Wall clock | `2` |
| Model tier | primary |
| Skills loaded | ravintio-plan |
| Agents spawned | `0` |
| MCP calls | `0` |
| Parallel task batches | `0` |
| Notes | One requirement. No ADR, because the change extends 0000378 ADR-002 without changing it. |

- Consistency check: clean (2026-11-10T00:27:17Z). Autonomous run: the plan gate passes with no human stop.

Complete: P1 (2026-11-10T00:27:17Z)

### P2: Implement

| Field | Value |
|-------|-------|
| Start | `2026-11-10T00:27:17Z` |
| End | `2026-11-10T00:30:25Z` |
| Wall clock | `3` |
| Model tier | primary |
| Skills loaded | ravintio-implement |
| Agents spawned | `0` |
| MCP calls | `0` |
| Parallel task batches | `1` |
| Notes | Inline, one unit. RED: 8 failures. GREEN: 13 of 13. The source in `src/ravintio-zero/` changed, and `sync-installed.mjs` copied it to `ravintio-zero/`. The queue suites 0000378, 0000392, 0000405, and 0000411 pass. |

- Done: U-001 REQ-001 optional version files (2026-11-10T00:30:25Z)

Complete: P2 (2026-11-10T00:30:25Z)

### P3: Validate and Accept

| Field | Value |
|-------|-------|
| Start | `2026-11-10T00:30:25Z` |
| End | `2026-11-10T00:39:10Z` |
| Wall clock | `9` |
| Model tier | primary |
| Skills loaded | none |
| Agents spawned | `0` |
| Notes | Tests run: 395 suites in a clean clone in 4 shards, 393 passed. The two failures match `baseline-failures.md`. Security: `resolveInRoot` still checks optional paths, and a test covers an optional path outside the root. |

- Tests run: 395 suites, 393 passed, 2 inherited (2026-11-10T00:39:10Z)

Complete: P3 (2026-11-10T00:39:10Z)

### P4: Ship

| Field | Value |
|-------|-------|
| Start | `2026-11-10T00:39:10Z` |
| End | `2026-11-10T00:39:10Z` |
| Wall clock | `0` |
| Model tier | primary |
| Skills loaded | none |
| Agents spawned | `0` |
| Notes | No version bump: this PR is not a chart step. |

Complete: P4 (2026-11-10T00:39:10Z)

---

## Summary (filled at ship, P4)

| Metric | Value |
|--------|-------|
| Total phases completed | `5` |
| Total wall clock | `13` |
| Total agents spawned | `0` |
| Total MCP calls | `0` |
| Phases using parallelism | `0` |
| Primary tier agent calls | `0` |
| Cheaper tier agent calls | `0` |
| Self-corrections | `0` |
