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
| End | `2026-11-07T20:19:24Z` |
| Wall clock | 1 |
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

### P1: Plan

| Field | Value |
|-------|-------|
| Start | `2026-11-07T20:20:21Z` |
| End | `2026-11-07T20:20:21Z` |
| Wall clock | 0 |
| Model tier | primary |
| Skills loaded | ravintio-plan |
| Agents spawned | 0 |
| MCP calls | 0 |
| Parallel task batches | 0 |
| Notes | artifacts written inline, no subagents: the artifacts share one design |

Complete: P1 (2026-11-07T20:20:21Z)

### P2: Implement

| Field | Value |
|-------|-------|
| Start | `2026-11-07T20:42:23Z` |
| End | `2026-11-07T20:42:23Z` |
| Wall clock | 0 |
| Model tier | primary and cheaper |
| Skills loaded | ravintio-implement |
| Agents spawned | 3 |
| MCP calls | 0 |
| Parallel task batches | 1 |
| Notes | helpers and anchors inline, suite conversion by 3 sonnet subagents |

Done: U1 timeout helper (2026-11-07T20:42:23Z)
Done: U2 section helper (2026-11-07T20:42:23Z)
Done: U3 rule helper and anchors (2026-11-07T20:42:23Z)
Done: U4 suite conversion (2026-11-07T20:42:23Z)
Done: U5 docs (2026-11-07T20:42:23Z)
Deviation: test-0000243-req-003-004-hook-injection.sh stays as is. Its time limit lives inside the hook under test, so the suite has no test-level cap to move.
Deviation: orch_section also returns text under the new "### Adoption Modes" subsections, so those assertions now read slightly wider text. Every needle is unchanged.
Rework: tests pinning numbered-step lines (0000031, 0000037, 0000039, 0000040, 0000042, 0000151-req-011, 0000243-req-005) updated to anchors
Tests run: full Bash suite, 302 feature and 19 regression passed, 0 failed
Rework: test-0000172-req-001-run-speed.sh: CI failed on Linux because the I-C Run section outgrew one awk write buffer and grep -q ended the pipe early under pipefail. The suite now reads the section through orch_section (2026-11-07T21:00:50Z)
Complete: P2 (2026-11-07T20:42:23Z)

### P3: Validate and Accept

| Field | Value |
|-------|-------|
| Start | `2026-11-07T20:42:54Z` |
| End | `2026-11-07T20:42:54Z` |
| Wall clock | 0 |
| Model tier | primary |
| Skills loaded | ravintio-validate-and-accept |
| Agents spawned | 0 |
| MCP calls | 0 |
| Parallel task batches | 0 |
| Notes | CI, verification, and security review done inline |

Complete: P3 (2026-11-07T20:42:54Z)

### P4: Ship

| Field | Value |
|-------|-------|
| Start | `2026-11-07T20:43:09Z` |
| End | `2026-11-07T20:43:16Z` |
| Wall clock | 0 |
| Model tier | primary |
| Skills loaded | ravintio-ship |
| Agents spawned | 0 |
| MCP calls | 0 |
| Parallel task batches | 0 |
| Notes | initiative step: the merge queue sets the version |

Complete: P4 (2026-11-07T20:43:16Z)

---

## Summary (filled at ship, P4)

| Metric | Value |
|--------|-------|
| Total phases completed | 5 |
| Total wall clock | 24 |
| Total agents spawned | 3 |
| Total MCP calls | 0 |
| Phases using parallelism | 1 |
| Primary tier agent calls | 0 |
| Cheaper tier agent calls | 3 |
| Self-corrections | 0 |
| Phases skipped | none |
