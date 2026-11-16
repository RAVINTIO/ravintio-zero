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
- Decision applied (initiative chart): A docs unit has no failing test, so `build-log-check.mjs` finds no `RED:` or `GREEN:` for it (0000410)
- Decision applied (initiative chart): Fast batches

### P1: Plan

| Field | Value |
|-------|-------|
| Start | `2026-11-16T02:51:56Z` |
| End | `2026-11-16T02:51:56Z` |
| Wall clock | `1` |
| Model tier | primary |
| Skills loaded | ravintio-plan |
| Agents spawned | `0` |
| MCP calls | `0` |
| Parallel task batches | `0` |
| Notes | Artifacts written inline. Consistency check clean. Initiative gate self-confirmed. |

### P2: Implement

| Field | Value |
|-------|-------|
| Start | `2026-11-16T02:52:33Z` |
| End | `2026-11-16T03:24:32Z` |
| Wall clock | `32` |
| Model tier | primary |
| Skills loaded | ravintio-implement |
| Agents spawned | `0` |
| MCP calls | `0` |
| Parallel task batches | `0` |
| Notes | Four small units ran inline. Batches 1 to 3 ran in order because each unit is small. |

- RED: U1 (2026-11-16T02:52:33Z)
- GREEN: U1 (2026-11-16T02:54:16Z)
- Done: U1 (content, inline, none, 2026-11-16T02:54:16Z)
- RED: U2 (2026-11-16T02:54:17Z)
- GREEN: U2 (2026-11-16T02:54:17Z)
- Done: U2 (content, inline, none, 2026-11-16T02:54:17Z)
- RED: U3 (2026-11-16T02:54:17Z)
- GREEN: U3 (2026-11-16T02:54:17Z)
- Done: U3 (content, inline, none, 2026-11-16T02:54:17Z)
- RED: U4 (2026-11-16T02:55:49Z)
  - U4 has no executable check (0000410). The unit edits one living doc.
- GREEN: U4 (2026-11-16T02:55:49Z)
  - U4 passed the prose check on the living doc (0000410).
- Done: U4 (content, inline, none, 2026-11-16T02:55:49Z)
- Tests run: REQ-001, REQ-002: test-0000551-req-001-002-setup-sh.sh, test-0000551-req-001-002-setup-ps1.ps1 (2026-11-16T02:55:49Z)
- Units U2 and U3 take the U1 red run. Both scripts failed it before the edit.
- Tests run: full suite: 475 passed, 3 failed (2026-11-16T03:24:32Z)

### P3: Validate and Accept

| Field | Value |
|-------|-------|
| Start | `2026-11-16T03:25:10Z` |
| End | `2026-11-16T03:25:10Z` |
| Wall clock | `1` |
| Model tier | primary |
| Skills loaded | ravintio-validate-and-accept |
| Agents spawned | `0` |
| MCP calls | `0` |
| Parallel task batches | `0` |
| Notes | OS gap: local macos, CI ubuntu, windows. Docs edit pass ran inline, prose check exit 0. |

- Tests run: full suite: 475 passed, 3 failed (2026-11-16T03:25:10Z)
