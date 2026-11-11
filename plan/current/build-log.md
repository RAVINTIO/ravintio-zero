---
title: "Build Log - 0000501-remove-merged-worktrees"
summary: "Working record of the pipeline run, maintained by the orchestrator."
---
# Build Log - 0000501-remove-merged-worktrees

> Created at discovery (P0). Appended by the orchestrator at each phase boundary. Survives session changes.

## Header

| Field | Value |
|-------|-------|
| Feature ID | `0000501-remove-merged-worktrees` |
| Pipeline start | `2026-11-11T23:55:14Z` |
| Tool | `claude-code` |
| Primary model | `claude-sonnet-5-5` |
| Cheaper model | `claude-haiku-5-5` |
| Run speed | `standard` |

---

## Phase Log

### P0: Discovery

| Field | Value |
|-------|-------|
| Start | `2026-11-11T23:55:14Z` |
| End | `PENDING` |
| Wall clock | `0` |
| Model tier | primary |
| Skills loaded | ravintio-orchestrator |
| Agents spawned | `0` |
| MCP calls | `0` |
| Parallel task batches | `0` |
| Notes | Initiative 0000360 step 52. Light track. |

- Migration 0009 pending: skipped in this step session. The step has no human to confirm it, and `docs/adr/` already holds the ADRs. The migration is safe to skip.
- Decisions: none name step 52
- Queue: no item names step 52
- Run mode: autonomous (2026-11-11T23:55:14Z, initiative step)
- Run speed: standard (2026-11-11T23:55:14Z, initiative step)
- Adoption mode: standard-iterative (signal: `plan/_archive/` and `src/` both exist)
- Version: last known 0.107.0, step bump minor, planned 0.108.0 (the merge queue sets the released version)
- Stale `plan/.feature-id` held 0000497-keep-worktree-entries. Replaced with this step's id.
- Scope Lock (happy path): the driver removes a merged step's clean worktree at start [source: draft-accepted (initiative)]
- Scope Lock (first-run path): no merged step has a worktree, so the sweep does nothing [source: draft-accepted (initiative)]
- Scope Lock (error path): the driver keeps and reports a worktree with unsafe state [source: draft-accepted (initiative)]
- Scope Lock (cross-session continuity): the sweep is stateless, so each driver start repeats it [source: draft-accepted (initiative)]
- Design confirmation: draft-accepted (initiative)
