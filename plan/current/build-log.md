---
title: "Build Log - 0000380-test-helpers-and-rule-anchors"
summary: "Working record of the pipeline run, maintained by the orchestrator."
---
# Build Log - 0000380-test-helpers-and-rule-anchors

## Header

| Field | Value |
|-------|-------|
| Feature ID | `0000380-test-helpers-and-rule-anchors` |
| Pipeline start | `2026-11-07T20:18:17Z` |
| Tool | `claude-code` |
| Primary model | `claude-sonnet-5-5` |
| Cheaper model | `claude-haiku-5-5` |
| Run speed | `standard` |

---

## Phase Log

### P0: Discovery

| Field | Value |
|-------|-------|
| Start | `2026-11-07T20:18:17Z` |
| End | |
| Wall clock | |
| Model tier | primary |
| Skills loaded | ravintio-orchestrator |
| Agents spawned | 0 |
| MCP calls | 0 |
| Parallel task batches | 0 |
| Notes | initiative 0000360 step 4 |

Run mode: autonomous (2026-11-07T20:18:17Z)
Skipped migrations: 0004, 0005 (Applies when is false in the pack source)
Decision applied (initiative chart): Rule anchors touch most tests and skills: step 4 runs alone
Scope Lock (happy path): a maintainer moves an anchored rule and its suite stays green [source: draft-accepted (initiative)]
Scope Lock (first-run path): a rule with no anchor fails its test and names the anchor [source: draft-accepted (initiative)]
Scope Lock (error path): duplicate anchor ids fail the anchor suite and name both files [source: draft-accepted (initiative)]
Scope Lock (cross-session continuity): the helpers hold no state between runs [source: draft-accepted (initiative)]
Scope Lock complete. All four scenario paths captured.
Backlog pulled in: 0000261, 0000308, 0000337
Version: plan 0.60.0 (minor on 0.59.0); the merge queue sets the released version
Complete: P0 (2026-11-07T20:19:24Z)
