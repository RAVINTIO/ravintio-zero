---
title: "Build Log - 0000381-setup-safety"
summary: "Working record of the pipeline run, maintained by the orchestrator."
---
# Build Log - 0000381-setup-safety

> Created at discovery (P0). Appended by the orchestrator at each phase boundary. Survives session changes.

## Header

| Field | Value |
|-------|-------|
| Feature ID | `0000381-setup-safety` |
| Pipeline start | `2026-11-07T21:30:12Z` |
| Tool | `claude-code` |
| Primary model | `claude-sonnet-5-5` |
| Cheaper model | `claude-haiku-5-5` |
| Run speed | `standard` |

---

## Phase Log

### P0: Discovery

| Field | Value |
|-------|-------|
| Start | `2026-11-07T21:30:12Z` |
| End | `2026-11-07T21:31:27Z` |
| Wall clock | `1` |
| Model tier | primary |
| Skills loaded | ravintio-orchestrator |
| Agents spawned | `0` |
| MCP calls | `0` |
| Parallel task batches | `0` |
| Notes | `Run mode: autonomous. Run speed: standard.` |

Complete: P0 (2026-11-07T21:31:27Z)

---

<!-- Copy and fill in this block at each phase boundary. Headings use the form
     "### P<n>: {Phase Name}" with n from 1 to 4 and the phase names
     P1: Plan, P2: Implement, P3: Validate and Accept, P4: Ship.

### P<n>: {Phase Name}

| Field | Value |
|-------|-------|
| Start | `2026-11-07T21:30:12Z` |
| End | `pending` |
| Wall clock | `pending` |
| Model tier | primary |
| Skills loaded | `{{skill names}}` |
| Agents spawned | `0` |
| MCP calls | `0` |
| Parallel task batches | `0` |
| Notes | `Run mode: autonomous. Run speed: standard.` |

-->

<!-- Skipped phase. A phase with no block needs a line "Skipped: P<n> ({reason})".
     Ship runs ravintio-zero/scripts/build-log-check.mjs, which fails a missing
     block that has no such line.
-->

<!-- Progress markers. Each dispatched unit adds these lines under its phase
     block, per "Progress Markers and Interrupted Units" in
     ravintio-zero/standards/agent-dispatch-standards.md:

- In progress: {unit} ({ISO-8601 timestamp})
- Done: {unit} ({ISO-8601 timestamp})
- Resumed after interruption: {unit} rerun, {stash note}

-->

---

## Summary (filled at ship, P4)

| Metric | Value |
|--------|-------|
| Total phases completed | `5` |
| Total wall clock | `70` |
| Total agents spawned | `0` |
| Total MCP calls | `0` |
| Phases using parallelism | `0` |
| Primary tier agent calls | `0` |
| Cheaper tier agent calls | `0` |
| Self-corrections | `0` |
| Phases skipped | `none` |

### P0 log

- Run mode: autonomous (2026-11-07T21:31:23Z, initiative step)
- Run speed: standard (2026-11-07T21:31:23Z, initiative step)
- Adoption mode: standard-iterative (signal: plan/_archive/ holds prior runs)
- Version: planned from 0.60.0 with a minor bump. The merge queue sets the released version.
- Decision applied (initiative chart): Confirmation: setup rerun at each Setup: stop
- Scope Lock (happy path): re-run reads a relative manifest, removes only listed folders under the skills directory, copies capability skills whole, prunes retired commands [source: draft-accepted (initiative)]
- Scope Lock (first-run path): with no manifest and a developer CLAUDE.md, setup moves its content to ravintio-overrides/instructions/ and prints the path [source: draft-accepted (initiative)]
- Scope Lock (error path): a manifest line outside the skills directory is skipped with a warning, and a folder with no SKILL.md warns and installs nothing [source: draft-accepted (initiative)]
- Scope Lock (cross-session continuity): setup is idempotent and never overwrites the preserved instructions file [source: draft-accepted (initiative)]
- Scope Lock complete. All four scenario paths captured.
Complete: P0 (2026-11-07T21:31:27Z)

### P1: Plan

| Field | Value |
|-------|-------|
| Start | `2026-11-07T21:31:46Z` |
| End | `2026-11-07T21:32:44Z` |
| Wall clock | `1` |
| Model tier | primary |
| Skills loaded | ravintio-orchestrator, ravintio-plan |
| Agents spawned | `0` |
| MCP calls | `0` |
| Parallel task batches | `0` |
| Notes | `Planned inline. Four small requirements share setup.sh and setup.ps1, so they cannot split across agents.` |

Complete: P1 (2026-11-07T21:32:44Z)

### P2: Implement

| Field | Value |
|-------|-------|
| Start | `2026-11-07T21:32:50Z` |
| End | `2026-11-07T21:55:53Z` |
| Wall clock | `23` |
| Model tier | primary |
| Skills loaded | ravintio-orchestrator, ravintio-implement |
| Agents spawned | `0` |
| MCP calls | `0` |
| Parallel task batches | `0` |
| Notes | `Units U1 to U4 edit setup.sh and setup.ps1, so they run in sequence inline. Tests come first in each unit.` |
- Done: U1 manifest confinement (2026-11-07T21:36:19Z)
- Done: U2 capability skill folders (2026-11-07T21:38:35Z)
- Done: U3 CLAUDE.md preserved (2026-11-07T21:38:35Z)
- Done: U4 retired commands (2026-11-07T21:40:45Z)
- Tests: full run 310 feature suites and 19 regression suites passed, including PowerShell

Complete: P2 (2026-11-07T21:55:53Z)

### P3: Validate and Accept

| Field | Value |
|-------|-------|
| Start | `2026-11-07T21:56:08Z` |
| End | `2026-11-07T21:56:24Z` |
| Wall clock | `0` |
| Model tier | primary |
| Skills loaded | ravintio-orchestrator, ravintio-validate-and-accept |
| Agents spawned | `0` |
| MCP calls | `0` |
| Parallel task batches | `0` |
| Notes | `Run inline. The full suite already ran green at the P2 close.` |

Complete: P3 (2026-11-07T21:56:24Z)

### P4: Ship

| Field | Value |
|-------|-------|
| Start | `2026-11-07T21:56:50Z` |
| End | `2026-11-07T21:56:55Z` |
| Wall clock | `0` |
| Model tier | primary |
| Skills loaded | ravintio-orchestrator, ravintio-ship, ravintio-retrospective |
| Agents spawned | `0` |
| MCP calls | `0` |
| Parallel task batches | `0` |
| Notes | `Initiative step. The merge queue sets the version.` |

Complete: P4 (2026-11-07T21:56:55Z)
