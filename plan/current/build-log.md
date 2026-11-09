---
title: "Build Log - 0000397-pack-source-in-src"
summary: "Working record of the pipeline run, maintained by the orchestrator."
---
# Build Log - 0000397-pack-source-in-src

> Created at discovery (P0). Appended by the orchestrator at each phase boundary. Survives session changes.

## Header

| Field | Value |
|-------|-------|
| Feature ID | `0000397-pack-source-in-src` |
| Pipeline start | `2026-11-09T21:38:20Z` |
| Tool | `claude-code` |
| Primary model | `claude-sonnet-5-5` |
| Cheaper model | `claude-haiku-5-5` |
| Run speed | `standard` |

---

## Phase Log

### P0: Discovery

| Field | Value |
|-------|-------|
| Start | `2026-11-09T21:38:20Z` |
| End | `2026-11-09T21:40:03Z` |
| Wall clock | `2` |
| Model tier | primary |
| Skills loaded | ravintio-orchestrator |
| Agents spawned | `0` |
| MCP calls | `0` |
| Parallel task batches | `0` |
| Notes | `Decisions applied (initiative chart): how the pack source moves, consumer paths, divergence, guards. Run mode autonomous, speed standard, version plan 0.75.0 to minor bump.` |

---

Complete: P0 (2026-11-09T21:40:03Z)

---

### P1: Plan

| Field | Value |
|-------|-------|
| Start | `2026-11-09T21:40:30Z` |
| End | `2026-11-09T21:42:32Z` |
| Wall clock | `3` |
| Model tier | primary |
| Skills loaded | ravintio-plan |
| Agents spawned | `0` |
| MCP calls | `0` |
| Parallel task batches | `0` |
| Notes | Inline. ADR 0295 proposed. Consistency check clean. Gate self-confirmed for the initiative. |

Complete: P1 (2026-11-09T21:42:32Z)

---

### P2: Implement

| Field | Value |
|-------|-------|
| Start | `2026-11-09T21:42:43Z` |
| End | `2026-11-09T23:37:56Z` |
| Wall clock | `38` |
| Model tier | primary |
| Skills loaded | ravintio-implement |
| Agents spawned | `7` |
| MCP calls | `0` |
| Parallel task batches | `2` |
| Notes | Two suites fail in any clone at base and here: 0000037-req-004 needs local git config and 0000318-req-004 needs an origin ref. |

- In progress: U1 move (2026-11-09T21:42:43Z)
- Done: U1 move (code, inline, none, 2026-11-09T21:42:49Z)
- Done: U2 copy (code, inline, none, 2026-11-09T21:42:58Z)
- Done: U4 guards (code, sonnet, standard, 2026-11-09T22:16:54Z)
- Done: U5 ci-and-sync (code, sonnet, standard, 2026-11-09T22:16:54Z)
- Done: U6 docs (content, sonnet, standard, 2026-11-09T22:16:54Z)
- Done: U3 tests (test, sonnet, standard, 2026-11-09T22:16:54Z)
- Done: U7 refresh (2026-11-09T22:16:54Z)
- Rework: REQ-003: the first suite run from the source failed 43 suites on repo-root paths. U3 split them into four tracks (2026-11-09T22:16:54Z)
- Rework: REQ-005: prose baseline keys for migrations/_done moved with the path. prose-check diff now lets src/ravintio-zero keep the old count (2026-11-09T22:16:54Z)
- Deviation: U3 ran as four tracks (U3a to U3d), not one unit, after the first suite run showed the failing set. Plan batch 3 held U3 beside U4, U5, and U6, so the four tracks ran after them (2026-11-09T22:16:54Z)

- Tests run: full suite: 372 passed, 3 failed (2026-11-09T23:37:56Z)

Complete: P2 (2026-11-09T23:37:56Z)

---

### P3: Validate and Accept

| Field | Value |
|-------|-------|
| Start | `2026-11-09T23:38:04Z` |
| End | `{{timestamp, filled when the phase completes}}` |
| Wall clock | `0` |
| Model tier | primary |
| Skills loaded | ravintio-validate-and-accept |
| Agents spawned | `0` |
| MCP calls | `0` |
| Parallel task batches | `0` |
| Notes | none |

---

<!-- Copy and fill in this block at each phase boundary. Headings use the form
     "### P<n>: {Phase Name}" with n from 1 to 4 and the phase names
     P1: Plan, P2: Implement, P3: Validate and Accept, P4: Ship.

### P<n>: {Phase Name}

| Field | Value |
|-------|-------|
| Start | `{{timestamp}}` |
| End | `{{timestamp, filled when the phase completes}}` |
| Wall clock | `{{whole minutes from Start to End}}` |
| Model tier | primary / cheaper |
| Skills loaded | `{{skill names}}` |
| Agents spawned | `{{count}}` |
| MCP calls | `{{count}}` |
| Parallel task batches | `{{count}}` |
| Notes | `{{free text or "none"}}` |

-->

<!-- Skipped phase. A phase with no block needs a line "Skipped: P<n> ({reason})".
     Ship runs ravintio-zero/scripts/build-log-check.mjs, which fails a missing
     block that has no such line.
-->

<!-- Progress markers. Each dispatched unit adds these lines under its phase
     block, per "Progress Markers and Interrupted Units" in
     ravintio-zero/standards/agent-dispatch-standards.md:

- In progress: {unit} ({ISO-8601 timestamp})
- RED: {unit} ({ISO-8601 timestamp})
- GREEN: {unit} ({ISO-8601 timestamp})
- Done: {unit} ({class}, {tier}, {effort}, {ISO-8601 timestamp})
- Resumed after interruption: {unit} rerun, {stash note}
- Tests run: REQ-{nnn}: {test files} ({ISO-8601 timestamp})
- Tests run: full suite: {n} passed, {m} failed ({ISO-8601 timestamp})
- Audit: re-run at P1 ({result})

-->

---

## Summary (filled at ship, P4)

| Metric | Value |
|--------|-------|
| Total phases completed | `{{count}}` |
| Total wall clock | `{{minutes from pipeline start to the P4 End}}` |
| Total agents spawned | `{{count}}` |
| Total MCP calls | `{{count}}` |
| Phases using parallelism | `{{count}}` |
| Primary tier agent calls | `{{count}}` |
| Cheaper tier agent calls | `{{count}}` |
| Self-corrections | `{{count}}` |
| Phases skipped | `{{list or "none"}}` |
