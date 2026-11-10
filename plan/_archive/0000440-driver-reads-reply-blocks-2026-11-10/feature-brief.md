---
title: "Feature Brief - Driver reads blocks from the reply"
summary: "The driver stops on a Blocked or Question line in the step session's final reply, not only in the build log."
status: "approved"
version: "0.1.0"
---
# Feature Brief - Driver reads blocks from the reply

**Feature ID:** 0000440-driver-reads-reply-blocks

Pulled in from backlog entry 0000413. Chart accepted the light track.

## Business Goal

A step that cannot write the build log gives its `I-D Advance: Blocked:` reply, and the driver never sees it. The driver then resumes the session twice. Step 6 of initiative 0000360 gave the same block three times in 25 seconds. The driver must stop on the first block.

## Features

| Feature | User Stories | Priority | Wave |
|---------|-------------|----------|------|
| Reply block read | As the human on the loop, I want the driver to stop on a `Blocked:` or `Question:` line in the step's final reply, so that a step that cannot write the build log still stops the run. | must-have | 1 |
| Prefixed block match | As the human on the loop, I want `I-D Advance: Blocked:` in the build log to count as a block, so that the driver does not resume a blocked step. | must-have | 1 |
| Continue prompt | As a step session, I want the continue prompt to name the archived log or none when `plan/current/build-log.md` is missing, so that I do not read a file that does not exist. | should-have | 1 |

## Target Architecture

### Components

| Component | Type | New or Existing | Responsibility |
|-----------|------|-----------------|---------------|
| ravintio-zero driver | script | existing | `ravintio-zero/scripts/initiative-run.mjs` starts step sessions, reads blocks, and resumes |

### Data Ownership

| Data Store | Owner Component | Shared With |
|------------|----------------|-------------|
| Step log `plan/.initiative-logs/step-{n}.log` | driver | watcher, coordinator (read only) |

### Integration Points

| From | To | Method | Contract |
|------|-----|--------|----------|
| driver | `claude -p` | child process | `stream-json` events on stdout, one JSON object per line |

## Stack

| Concern | Decision |
|---------|----------|
| Language | Node.js (ES modules), no packages |
| Testing | Bash tests under `ravintio-zero/tests/` with a stub `claude` |
| CI | GitHub Actions |
| Build target | local |

## Scope Boundaries

### In Scope
- Read the `result` text of the final `result` stream event and apply `blockIn` to it.
- Accept a short prefix before `Blocked:`, as `Question:` already does.
- Name the archived log, or none, in the continue prompt when `plan/current/build-log.md` is missing.
- Update the roadmap standards text for the driver block read.

### Out of Scope
- Any change to the merge queue, the watcher, or the ready-file helper (step 25).
- A change to what counts as a `Resolved:` line.

### Deferred
- Nothing deferred.

## Non-Functional Requirements

| NFR | Target | Measurement |
|-----|--------|-------------|
| Safety | The driver never passes reply text to a shell or a path | Test: a reply that holds shell characters changes nothing |
| Bound | A stop line holds at most 500 characters | Existing `MAX_LINE` |

## Constraints and Assumptions

### Constraints
- The driver loads its code once, so this step triggers the Restart stop after it merges.

### Assumptions
- The `result` event carries the final reply in a `result` string field.

## Scenario Paths

**Happy path:** A step ends with a reply that holds `I-D Advance: Blocked: CI failed`. The driver finds it in the step log and stops with no resume.

> As described.

**First-run path:** A step log with no `result` event, such as a killed session, adds no block. The existing build-log read still applies.

> As described.

**Error / sad path:** A malformed JSON line, or a `result` that is not a string, adds no block and does not stop the driver.

> As described.

**Cross-session continuity:** A resume appends to the same log. The driver reads only events written since the session started, so an old reply never blocks a later session.

> As described.

## Acceptance Criteria

- [ ] A stub session that ends with a `result` of `I-D Advance: Blocked: ...` and writes no build log stops the driver with no resume.
- [ ] A build-log line `I-D Advance: Blocked: ...` counts as a block.
- [ ] If `plan/current/build-log.md` is missing, the continue prompt names the archived log or none.
