---
title: "Build Log - 0000446-drain-ready-prs-after-a-stop"
summary: "Working record of the pipeline run, maintained by the orchestrator."
---
# Build Log - 0000446-drain-ready-prs-after-a-stop

> Created at discovery (P0). Appended by the orchestrator at each phase boundary. Survives session changes.

## Header

| Field | Value |
|-------|-------|
| Feature ID | `0000446-drain-ready-prs-after-a-stop` |
| Pipeline start | `2026-11-10T23:21:38Z` |
| Tool | `Claude Code` |
| Primary model | `claude-sonnet-5-5` |
| Cheaper model | `claude-haiku-5-5` |
| Run speed | `standard` |

---

## Phase Log

### P0: Discovery

| Field | Value |
|-------|-------|
| Start | `2026-11-10T23:21:38Z` |
| End | `` |
| Wall clock | `` |
| Model tier | primary |
| Skills loaded | ravintio-orchestrator |
| Agents spawned | 0 |
| MCP calls | 0 |
| Parallel task batches | 0 |
| Notes | Initiative 0000360 step 27. Migration 0009 stays pending. |

- Run mode: autonomous (2026-11-10T23:21:38Z)
- Run speed: standard (2026-11-10T23:21:38Z)
- Skipped: migration 0009. A step session has no human to answer its `Proceed? (y/n)`. The migration is safe to skip. See backlog entry 0000403.
- Stale `plan/.feature-id` held 0000472-ci-duration-metric. Overwritten with 0000446-drain-ready-prs-after-a-stop.
- Track: light (initiative chart accepts the track)
- Backlog 0000426 pulled in from the step row and deleted with the index rebuilt.
- Scope Lock Challenge skipped (light track). Scope lines: in, out, deferred set in design.md [source: draft-accepted (initiative)]
- Design confirmed: draft-accepted (initiative)
