---
title: "Build Log - 0000394-github-security-and-ci-lint"
summary: "Working record of the pipeline run, maintained by the orchestrator."
---
# Build Log - 0000394-github-security-and-ci-lint

> Created at discovery (P0). Appended by the orchestrator at each phase boundary. Survives session changes.

## Header

| Field | Value |
|-------|-------|
| Feature ID | `0000394-github-security-and-ci-lint` |
| Pipeline start | `2026-11-08T01:05:38Z` |
| Tool | `claude-code` |
| Primary model | `claude-sonnet-5-5` |
| Cheaper model | `claude-haiku-5-5` |
| Run speed | `standard` |

---

## Phase Log

### P0: Discovery

| Field | Value |
|-------|-------|
| Start | `2026-11-08T01:05:38Z` |
| End | `2026-11-08T01:06:29Z` |
| Wall clock | 1 |
| Model tier | primary |
| Skills loaded | ravintio-orchestrator |
| Agents spawned | 0 |
| MCP calls | 0 |
| Parallel task batches | 0 |
| Notes | initiative 0000360 step 18 |

Run mode: autonomous (2026-11-08T01:05:38Z)
Skipped migrations: 0004, 0005 (Applies when is false in the pack source)
Decision applied (initiative chart): Human-only settings (0000323, 0000325): the step prints a checklist and waits
Scope Lock (happy path): a clean change passes lint and the brand guard, and the settings read on [source: draft-accepted (initiative)]
Scope Lock (first-run path): the first lint run finds existing issues, which the step fixes first [source: draft-accepted (initiative)]
Scope Lock (error path): a floating action tag or the old name fails the pin suite, zizmor, or pre-push [source: draft-accepted (initiative)]
Scope Lock (cross-session continuity): the checklist and stop line sit in the build log and a resumed session runs gh api [source: draft-accepted (initiative)]
Scope Lock complete. All four scenario paths captured.
Backlog pulled in: 0000323, 0000324, 0000325
Version: plan 0.61.0 (minor on 0.60.0); the merge queue sets the released version
Complete: P0 (2026-11-08T01:06:29Z)

### P1: Plan

| Field | Value |
|-------|-------|
| Start | `2026-11-08T01:07:58Z` |
| End | `2026-11-08T01:09:03Z` |
| Wall clock | 1 |
| Model tier | primary |
| Skills loaded | ravintio-plan |
| Agents spawned | 0 |
| MCP calls | 0 |
| Parallel task batches | 0 |
| Notes | artifacts written inline: they share one design |

Complete: P1 (2026-11-08T01:09:03Z)

### P2: Implement

| Field | Value |
|-------|-------|
| Start | `2026-11-08T01:09:14Z` |
| End | `2026-11-08T01:29:45Z` |
| Wall clock | 21 |
| Model tier | primary and cheaper |
| Skills loaded | ravintio-implement |
| Agents spawned | 1 |
| MCP calls | 0 |
| Parallel task batches | 1 |
| Notes | U2 by a sonnet subagent, U1, U3, and U4 inline |

In progress: U2 community files (2026-11-08T01:09:14Z)
Done: U2 community files (2026-11-08T01:10:23Z)
Done: U3 brand guard before push (2026-11-08T01:12:00Z)
Done: U4 settings checklist script (2026-11-08T01:12:30Z)
Done: U1 pinned actions, lint job, supply-chain workflows (2026-11-08T01:13:30Z)
Done: U5 docs, manifest, and reworked tests (2026-11-08T01:29:45Z)
Rework: test-0000355-req-005 read the pulled-in entry 0000323, so the step removed it (2026-11-08T01:29:45Z)
Rework: test-0000042-req-010, test-0000160-req-003, and run-tests.sh now cover the shared allowlist file (2026-11-08T01:29:45Z)
Deviation: design.md `## Component Paths` listed two paths on one line, so the write guard read one. The step put one path on each line. Scope is unchanged.
Deviation: attestations for release-tag stay deferred, as the brief says. The step added no dependency beyond the approved list.

Complete: P2 (2026-11-08T01:29:45Z)

### P3: Validate and Accept

| Field | Value |
|-------|-------|
| Start | `2026-11-08T01:29:56Z` |
| End | `2026-11-08T09:18:44Z` |
| Wall clock | 469 |
| Model tier | primary |
| Skills loaded | ravintio-validate-and-accept |
| Agents spawned | 0 |
| MCP calls | 0 |
| Parallel task batches | 0 |
| Notes | includes a human stop for GitHub settings, about 453 minutes |

Checks: full suite 305 feature and 19 regression suites passed (2026-11-08T01:43:49Z)
Question: P3 Validate: Question: Human stop (chart row, step 18). Turn on secret-scanning, push-protection, and topics, then tell me to resume. Run `node ravintio-zero/scripts/github-settings.mjs list` for the steps. The `workflow-lint-required` item waits until `workflow-lint` runs on `main`. (2026-11-08T01:44:09Z)

Complete: P3 (2026-11-08T09:18:44Z)

### P4: Ship

| Field | Value |
|-------|-------|
| Start | `2026-11-08T09:19:03Z` |
| End | `2026-11-08T09:19:08Z` |
| Wall clock | 1 |
| Model tier | primary |
| Skills loaded | ravintio-ship |
| Agents spawned | 0 |
| MCP calls | 0 |
| Parallel task batches | 0 |
| Notes | none |

Complete: P4 (2026-11-08T09:19:08Z)

---

---

## Summary (filled at ship, P4)

| Metric | Value |
|--------|-------|
| Total phases completed | 5 |
| Total wall clock | 475 |
| Total agents spawned | 1 |
| Total MCP calls | 0 |
| Phases using parallelism | 1 |
| Primary tier agent calls | 0 |
| Cheaper tier agent calls | 1 |
| Self-corrections | 2 |
| Phases skipped | none |

Resolved: human stop for step 18 (2026-11-08T09:17:47Z, the human turned on secret scanning, push protection, and topics. workflow-lint-required waits for workflow-lint to run on main.)
