---
title: "Build Log - 0000391-standards-archetypes"
summary: "Working record of the pipeline run, maintained by the orchestrator."
---
# Build Log - 0000391-standards-archetypes

> Created at discovery (P0). Appended by the orchestrator at each phase boundary. Survives session changes.

## Header

| Field | Value |
|-------|-------|
| Feature ID | `0000391-standards-archetypes` |
| Pipeline start | `2026-11-09T18:15:38Z` |
| Tool | `claude-code` |
| Primary model | `claude-sonnet-5-5` |
| Cheaper model | `claude-haiku-5-5` |
| Run speed | `standard` |

Run mode: autonomous (2026-11-09T18:15:38Z, initiative 0000360 step 15)

---

## Phase Log

### P0: Discovery

| Field | Value |
|-------|-------|
| Start | `2026-11-09T18:15:38Z` |
| End | `2026-11-09T18:23:17Z` |
| Wall clock | 0 |
| Model tier | primary |
| Skills loaded | ravintio-orchestrator |
| Agents spawned | 0 |
| MCP calls | 0 |
| Parallel task batches | 0 |
| Notes | Step 15 of initiative 0000360. The stale plan/.feature-id (0000386) is replaced. |

- Queue: read ci-gate-step-15 (CI before ready, restore route, block lines in the build log). This step skips the item narrow-brand-guard-self-entry, which names step 18.
- Migrations 0004, 0005, 0008, 0009: not run. A step session has no human to answer the migrator. Their Applies-when conditions are false here, or Safe to skip is Yes (0009, 0008). Tracked in backlog 0000403.
- Scope Lock (happy path): archetype use copies files into overrides, prints what it replaced, and the resolver then returns the override [source: draft-accepted (initiative)]
- Scope Lock (first-run path): the command creates ravintio-overrides/archetypes.json with the first pick [source: draft-accepted (initiative)]
- Scope Lock (error path): a clash or a lowered threshold prints the cause, exits 1, and copies nothing [source: draft-accepted (initiative)]
- Scope Lock (cross-session continuity): the command checks first, then writes the files and the record, and a rerun changes nothing [source: draft-accepted (initiative)]
- Scope Lock complete. All four scenario paths captured.
- Design confirmed: draft-accepted (initiative) (2026-11-09T18:17:52Z)

- Baseline: the clean-clone suite runs in the background (/tmp/step15-baseline.out). plan/current/baseline-failures.md follows when it ends.

### P1: Plan

| Field | Value |
|-------|-------|
| Start | `2026-11-09T18:18:21Z` |
| End | `2026-11-09T18:23:17Z` |
| Wall clock | 0 |
| Model tier | primary |
| Skills loaded | ravintio-plan |
| Agents spawned | 1 |
| MCP calls | 0 |
| Parallel task batches | 0 |
| Notes | One primary-tier subagent wrote the artifact set. Consistency check clean. Human settings check passed. |
- Done: P1 artifact set (content, primary, medium, 2026-11-09T18:23:17Z)

### P2: Implement

| Field | Value |
|-------|-------|
| Start | `2026-11-09T18:23:25Z` |
| End | |
| Wall clock | |
| Model tier | primary |
| Skills loaded | ravintio-implement |
| Agents spawned | 0 |
| MCP calls | 0 |
| Parallel task batches | 0 |
| Notes | Batches follow the concurrency plan: batch 1 is U1, U4, U5. Batch 2 is U2, U6, U7. Batch 3 is U3. Batch 4 is U8 and U9. Each unit writes its test first and confirms RED before the code. |

- In progress: batch 1 U1 U4 U5 (2026-11-09T18:23:25Z)
- RED: U1 REQ-001 REQ-002 resolver (2026-11-09T18:25:26Z)
- GREEN: U1 REQ-001 REQ-002 resolver (2026-11-09T18:25:26Z)
- Done: U1 resolver and protected list (code, primary, medium, 2026-11-09T18:25:26Z)
- Tests run: REQ-001, REQ-002: test-0000391-req-001-002-resolver.sh (2026-11-09T18:25:26Z)
- RED: U4 REQ-006 gate check (2026-11-09T18:25:26Z)
- GREEN: U4 REQ-006 gate check (2026-11-09T18:25:26Z)
- Done: U4 gate check (code, primary, medium, 2026-11-09T18:25:26Z)
- Tests run: REQ-006: test-0000391-req-006-gates.sh (2026-11-09T18:25:26Z)
- RED: U5 REQ-005 starter archetypes (2026-11-09T18:27:03Z)
- GREEN: U5 REQ-005 starter archetypes (2026-11-09T18:27:03Z)
- Done: U5 starter archetypes (content, primary, medium, 2026-11-09T18:27:03Z)
- Tests run: REQ-005: test-0000391-req-005-archetypes.sh (2026-11-09T18:27:03Z)
- In progress: batch 2 U2 U6 U7 (2026-11-09T18:27:03Z)
- RED: U3 REQ-003 setup dispatch (2026-11-09T18:31:48Z)
- GREEN: U3 REQ-003 setup dispatch (2026-11-09T18:31:48Z)
- Done: U3 setup dispatch (code, primary, low, 2026-11-09T18:31:48Z)
- Tests run: REQ-003: test-0000391-req-003-archetype-dispatch.sh (2026-11-09T18:31:48Z)
- Done: U2 archetype command (code, primary, medium, 2026-11-09T18:31:48Z). The U2 subagent sent no report and no RED result. The suite shows 38 passed.
- Done: U6 writing outputs (code, primary, low, 2026-11-09T18:31:48Z)
- Done: U7 standard text and skill pointers (content, primary, low, 2026-11-09T18:31:48Z)
- In progress: batch 4 U8 U9 (2026-11-09T18:31:48Z)
