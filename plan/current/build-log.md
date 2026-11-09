---
title: "Build Log - 0000395-pack-prose-to-the-standard"
summary: "Working record of the pipeline run, maintained by the orchestrator."
---
# Build Log - 0000395-pack-prose-to-the-standard

> Created at discovery (P0). Appended by the orchestrator at each phase boundary. Survives session changes.

## Header

| Field | Value |
|-------|-------|
| Feature ID | `0000395-pack-prose-to-the-standard` |
| Pipeline start | `2026-11-09T19:55:09Z` |
| Tool | `claude-code` |
| Primary model | `claude-sonnet-5-5` |
| Cheaper model | `claude-haiku-5-5` |
| Run speed | `standard` |

---

## Phase Log

### P0: Discovery

| Field | Value |
|-------|-------|
| Start | `2026-11-09T19:55:09Z` |
| End | |
| Wall clock | |
| Model tier | primary |
| Skills loaded | ravintio-orchestrator |
| Agents spawned | 0 |
| MCP calls | 0 |
| Parallel task batches | 0 |
| Notes | initiative step 19 |

Run mode: autonomous (2026-11-09T19:55:09Z)
Run speed: standard (2026-11-09T19:55:09Z)
Migration check: 0004, 0005, and 0008 stay pending because their Applies when line is false here. 0009 already took effect, because docs/adr/ exists.
Queue: acted on ci-gate-step-19. Skipped narrow-brand-guard-self-entry because it names step 18.
Scope Lock (happy path): Agents rewrite the files, the baseline reaches zero, and the suite passes. [source: draft-accepted (initiative)]
Scope Lock (first-run path): Not applicable. The pack already has a linter and a baseline. [source: draft-accepted (initiative)]
Scope Lock (error path): A rewrite breaks a wording pin. The step updates the pin and logs a Rework line. [source: draft-accepted (initiative)]
Scope Lock (cross-session continuity): Each batch commits with its baseline change, so a resume starts from the baseline. [source: draft-accepted (initiative)]
Scope Lock complete. All four scenario paths captured.
Decision applied (initiative chart): The pack prose rewrite breaks wording-pinned tests
Version: plan 0.75.0 (minor bump on 0.74.0). The merge queue sets the released version.
Complete: P0 (2026-11-09T19:56:18Z)

### P1: Plan

| Field | Value |
|-------|-------|
| Start | `2026-11-09T19:58:04Z` |
| End | |
| Wall clock | |
| Model tier | primary |
| Skills loaded | ravintio-plan |
| Agents spawned | 0 |
| MCP calls | 0 |
| Parallel task batches | 0 |
| Notes | none |


Complete: P1 (2026-11-09T19:58:30Z)

### P2: Implement

| Field | Value |
|-------|-------|
| Start | `2026-11-09T19:58:37Z` |
| End | |
| Wall clock | |
| Model tier | primary |
| Skills loaded | ravintio-implement |
| Agents spawned | 0 |
| MCP calls | 0 |
| Parallel task batches | 0 |
| Notes | none |

- In progress: U1 (2026-11-09T19:59:00Z)
- In progress: U2 (2026-11-09T19:59:00Z)
- In progress: U3 (2026-11-09T19:59:00Z)
- In progress: U4 (2026-11-09T19:59:00Z)
- In progress: U5 (2026-11-09T19:59:00Z)
- In progress: U6 (2026-11-09T19:59:00Z)
- In progress: U7 (2026-11-09T19:59:00Z)
- In progress: U8 (2026-11-09T20:05:25Z)
- In progress: U9 (2026-11-09T20:05:25Z)
- In progress: U10 (2026-11-09T20:05:25Z)
- In progress: U11 (2026-11-09T20:05:25Z)
- In progress: U12 (2026-11-09T20:05:25Z)
- In progress: U13 (2026-11-09T20:05:25Z)
- In progress: U14 (2026-11-09T20:05:25Z)
- Done: U1 (content, primary, high, 2026-11-09T20:06:43Z)
- Done: U2 (content, primary, high, 2026-11-09T20:06:43Z)
- Done: U3 (content, primary, high, 2026-11-09T20:06:43Z)
- Done: U4 (content, primary, high, 2026-11-09T20:06:43Z)
- Done: U5 (content, primary, high, 2026-11-09T20:06:43Z)
- Done: U6 (content, primary, high, 2026-11-09T20:06:43Z)
- Done: U7 (content, primary, high, 2026-11-09T20:06:43Z)
- Done: U14 (content, primary, high, 2026-11-09T20:07:30Z)
- Done: U8 (content, primary, high, 2026-11-09T20:11:11Z)
- Done: U10 (content, primary, high, 2026-11-09T20:11:11Z)
- Done: U12 (content, primary, high, 2026-11-09T20:11:11Z)
- Done: U13 (content, primary, high, 2026-11-09T20:11:11Z), six migrations/_done files kept as they were, because a test pins them to main
- Done: U9 (content, primary, high, 2026-11-09T20:30:55Z)
- Done: U11 part 1 (content, primary, high, 2026-11-09T20:30:55Z), 19 breaches left on lines that fixtures pin
- Done: U11 part 2 (content, primary, high, 2026-11-09T20:35:45Z)
- Rework: REQ-002: fixtures 0000151-orchestrator-skill-base.md and 0000243-resume-detection-base.md pinned the old orchestrator wording, so I updated both to the rewritten lines (2026-11-09T20:35:45Z)
- Rework: REQ-002: test-0000151-req-011 byte baseline 36,275 became 36,350 after the fixture rewrite (2026-11-09T20:35:45Z)
- Rework: REQ-002: test-0000151-req-007 now checks the phrase "stays the same". The old phrase broke the passive rule. (2026-11-09T20:35:45Z)
Decision applied (initiative chart): A test pins text that the step edits
- Rework: REQ-002: five tests pinned old wording, so I updated the needles in test-0000032-req-004, test-0000043-req-005, test-0000250-req-001, and test-0000318-req-001-002 (2026-11-09T20:59:09Z)
- Rework: REQ-002: the brand guard allowlist held a stale row for baseline keys of ADR files, so I removed the row and its comment. This narrows the guard (2026-11-09T20:59:09Z)
Complete: U15 baseline and pins (2026-11-09T20:59:09Z)

Complete: P2 (2026-11-09T20:59:43Z)

### P3: Validate and Accept

| Field | Value |
|-------|-------|
| Start | `2026-11-09T20:59:43Z` |
| End | |
| Wall clock | |
| Model tier | primary |
| Skills loaded | ravintio-validate-and-accept |
| Agents spawned | 0 |
| MCP calls | 0 |
| Parallel task batches | 0 |
| Notes | none |

Docs edit pass: reviewed docs/about.md, docs/architecture-overview.md, docs/dependency-graph.md, README.md, and three pack root docs. Fixed 4 spots in architecture-overview.md. Cycle count 1. prose-check exit 0. The 176 ADRs are historical records, and the pass skipped them because the linter covers their sentences (2026-11-09T21:01:09Z)
