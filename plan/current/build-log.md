---
title: "Build Log - 0000409-ci-shards"
summary: "Working record of the pipeline run, maintained by the orchestrator."
---
# Build Log - 0000409-ci-shards

> Created at discovery (P0). Appended by the orchestrator at each phase boundary. Survives session changes.

## Header

| Field | Value |
|-------|-------|
| Feature ID | `0000409-ci-shards` |
| Pipeline start | `2026-11-09T14:10:20Z` |
| Tool | `claude-code` |
| Primary model | `claude-opus-5-5` |
| Cheaper model | `claude-sonnet-5-5` |
| Run speed | `fast` |

---

## Phase Log

### P0: Discovery

| Field | Value |
|-------|-------|
| Start | `2026-11-09T14:10:20Z` |
| End | `2026-11-09T14:10:20Z` |
| Wall clock | `0` |
| Model tier | primary |
| Skills loaded | ravintio-orchestrator |
| Agents spawned | `0` |
| MCP calls | `0` |
| Parallel task batches | `0` |
| Notes | Hotfix in the coordinator session of initiative 0000360, while the driver is stopped. The human chose the route in three questions. Departure: no `plan/.orchestrator-ack`, because the initiative skill forbids it and the strict hook accepts `plan/.initiative-ack`. |

- Adoption mode: standard-iterative (signal: plan/_archive/ holds prior runs)

- Design confirmed by the human (2026-11-09T14:10:20Z). Run mode: autonomous. Run speed: fast.

Complete: P0 (2026-11-09T14:10:20Z)

### P1: Plan

| Field | Value |
|-------|-------|
| Start | `2026-11-09T14:10:20Z` |
| End | `2026-11-09T14:13:09Z` |
| Wall clock | `3` |
| Model tier | primary |
| Skills loaded | ravintio-plan |
| Agents spawned | `0` |
| MCP calls | `0` |
| Parallel task batches | `1` |
| Notes | Two requirements and ADR-0284, which supersedes ADR-0126. Consistency check clean. Autonomous run, so the plan gate does not stop. |

- Consistency check: clean (2026-11-09T14:13:09Z). Autonomous run: the plan gate passes with no human stop.

Complete: P1 (2026-11-09T14:13:09Z)

### P2: Implement

| Field | Value |
|-------|-------|
| Start | `2026-11-09T14:13:09Z` |
| End | `2026-11-09T14:18:34Z` |
| Wall clock | `5` |
| Model tier | primary |
| Skills loaded | ravintio-implement |
| Agents spawned | `0` |
| MCP calls | `0` |
| Parallel task batches | `2` |
| Notes | Inline, because U-002 depends on U-001 and both are small. REQ-001 RED with 19 failures, then GREEN. One test expectation was wrong (shard 3 of 3 runs one suite of five), so the test now checks shard 2 of 3. REQ-002 updated the three CI-shape tests to read the shard jobs, and the summary jobs carry the job-guard marker because their `if` adds `always()`. |

- Rework: REQ-001: the test expected two suites in shard 3 of 3, where five suites give one (2026-11-09T14:15:40Z)
- Done: U-001 REQ-001 runner shards, GREEN at `64544398`. U-002 REQ-002 workflow shards, GREEN at `11f02108` (2026-11-09T14:18:34Z)

Complete: P2 (2026-11-09T14:18:34Z)

- Rework: REQ-002: CI on PR #144 took 7m23s on Windows shard 3, over the 7-minute AC-3 target. The Windows matrix grows from 3 shards to 4, and the design, brief, requirement, ADR, tests, and docs now say 4 (2026-11-09T14:38:14Z)
