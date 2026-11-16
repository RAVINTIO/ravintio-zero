---
title: "Build Log - 0000551-refuse-symlink-style-outputs"
summary: "Working record of the pipeline run, maintained by the orchestrator."
---
# Build Log - 0000551-refuse-symlink-style-outputs

> Created at discovery (P0). Appended by the orchestrator at each phase boundary. Survives session changes.

## Header

| Field | Value |
|-------|-------|
| Feature ID | `0000551-refuse-symlink-style-outputs` |
| Pipeline start | `2026-11-16T02:49:58Z` |
| Tool | `claude-code` |
| Primary model | `claude-sonnet-5-5` |
| Cheaper model | `claude-haiku-5-5` |
| Run speed | `fast` |

Run mode: autonomous (2026-11-16T02:49:58Z, initiative step 7)

---

## Phase Log

### P0: Discovery

| Field | Value |
|-------|-------|
| Start | `2026-11-16T02:49:58Z` |
| End | `2026-11-16T02:50:26Z` |
| Wall clock | `1` |
| Model tier | primary |
| Skills loaded | ravintio-orchestrator |
| Agents spawned | `0` |
| MCP calls | `0` |
| Parallel task batches | `0` |
| Notes | Initiative 0000544 step 7. Baseline suite runs in a clean clone. |

- Decision applied (initiative chart): Confirmation: setup rerun at each `Setup:` stop
- Decision not applicable (initiative chart): The step PR fails CI or conflicts after ship archived the run: no PR exists yet
- Decision applied (initiative chart): When to write `ready`
- Decision applied (initiative chart): A test pins text that the step edits
- Decision applied (initiative chart): Pack edits
- Decision applied (initiative chart): Known baseline failures
- Decision not applicable (initiative chart): A docs unit has no failing test (0000410): every unit here has one
- Decision applied (initiative chart): Fast batches
