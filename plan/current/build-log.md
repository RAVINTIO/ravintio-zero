---
title: "Build Log - 0000549-baseline-record-checks"
summary: "Working record of the pipeline run, maintained by the orchestrator."
---
# Build Log - 0000549-baseline-record-checks

> Created at discovery (P0). Appended by the orchestrator at each phase boundary. Survives session changes.

## Header

| Field | Value |
|-------|-------|
| Feature ID | `0000549-baseline-record-checks` |
| Pipeline start | `2026-11-14T15:23:23Z` |
| Tool | `claude-code` |
| Primary model | `claude-sonnet-5-5` |
| Cheaper model | `claude-haiku-5-5` |
| Run speed | `fast` |

---

## Phase Log

### P0: Discovery

| Field | Value |
|-------|-------|
| Start | `2026-11-14T15:23:23Z` |
| End | `` |
| Wall clock | `` |
| Model tier | primary |
| Skills loaded | ravintio-orchestrator |
| Agents spawned | `0` |
| MCP calls | `0` |
| Parallel task batches | `0` |
| Notes | initiative 0000544 step 5 |

- Run mode: autonomous (2026-11-14T15:23:23Z)
- Run speed: fast (2026-11-14T15:23:23Z)
- Decision applied (initiative chart): Confirmation: setup rerun at each `Setup:` stop
- Decision applied (initiative chart): The step PR fails CI or conflicts after ship archived the run
- Decision applied (initiative chart): When to write `ready`
- Decision applied (initiative chart): A test pins text that the step edits
- Decision applied (initiative chart): Pack edits
- Decision applied (initiative chart): Known baseline failures
- Decision applied (initiative chart): Fast batches
- Migration pending: none found by resume detection
- Adoption mode: standard-iterative (source in src/ beside plan/_archive/)
- Version: last known 0.114.0 in docs/about.md. Step bump minor, plan version 0.115.0. The merge queue sets the released version.
- Queue: no items name step 5.
- Feature id: plan/.feature-id held 0000536-pending-migrations-reach-the-human-early. Step 1 (0000545) deletes that tracked file. This step overwrites it with its own id.

- Scope Lock (happy path): A finished run records its failures and check compares against them. [source: draft-accepted (initiative)]
- Scope Lock (first-run path): With no baseline file, check exits 1 with no baseline recorded. [source: draft-accepted (initiative)]
- Scope Lock (error path): Runner output with no totals line makes record exit 2 and write no file. [source: draft-accepted (initiative)]
- Scope Lock (cross-session continuity): The baseline file is a committed artifact, so a resumed session reads it or check reports it missing. [source: draft-accepted (initiative)]
- Scope Lock complete. All four scenario paths captured.
- Design confirmed: draft-accepted (initiative) (2026-11-14T15:24:11Z)
