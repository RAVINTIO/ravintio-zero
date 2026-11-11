---
title: "Build Log - 0000493-driver-starts-after-restart"
summary: "Working record of the pipeline run, maintained by the orchestrator."
---
# Build Log - 0000493-driver-starts-after-restart

> Created at discovery (P0). Appended by the orchestrator at each phase boundary. Survives session changes.

## Header

| Field | Value |
|-------|-------|
| Feature ID | `0000493-driver-starts-after-restart` |
| Pipeline start | `2026-11-11T20:14:30Z` |
| Tool | `claude-code` |
| Primary model | `claude-sonnet-5-5` |
| Cheaper model | `claude-haiku-5-5` |
| Run speed | `standard` |

Run mode: autonomous (initiative step 48)

---

## Phase Log

### P0: Discovery

| Field | Value |
|-------|-------|
| Start | `2026-11-11T20:14:30Z` |
| End | `` |
| Wall clock | `` |
| Model tier | primary |
| Skills loaded | ravintio-orchestrator |
| Agents spawned | `0` |
| MCP calls | `0` |
| Parallel task batches | `0` |
| Notes | none |

- Interrupted ship detected: step 47 left the sentinels `plan/.orchestrator-active` and `plan/.run-mode`. Cleaned up and started fresh.
- Pending migration 0009 (ADRs in `docs/adr/`) not run. The repo already holds `docs/adr/`, and a step session has no human to confirm it.
- Decisions: none name step 48
- Queue: no item names step 48
- Adoption mode: standard-iterative (signal: `plan/_archive/` beside source in `src/`)
- Last known version: 0.104.0 (`product.yml`, tag `v0.104.0`). Step bump `minor` plans 0.105.0. The merge queue writes the released version.
- Track: full
- Backlog: pulled in 0000494-driver-starts-after-restart. Folder deleted and index rebuilt in the same commit.
- Scope Lock (happy path): a Restart-only merge hands new starts to a successor driver that adopts running and ready steps [source: draft-accepted (initiative)]
- Scope Lock (first-run path): with no merge that changes a watched file, no handoff happens and the driver behaves as today [source: draft-accepted (initiative)]
- Scope Lock (error path): a failed spawn, a failed fast-forward, or a Setup hit keeps the existing stop. A handed-over block reaches the successor through a `stopped` file [source: draft-accepted (initiative)]
- Scope Lock (cross-session continuity): a dead supervisor pid makes the successor restart that step's session in its worktree [source: draft-accepted (initiative)]
- Scope Lock complete. All four scenario paths captured.
- Design confirmed: draft-accepted (initiative)

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
