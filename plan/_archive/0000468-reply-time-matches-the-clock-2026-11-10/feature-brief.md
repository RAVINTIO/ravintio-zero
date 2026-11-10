---
title: "Feature Brief - Reply time matches the clock"
summary: "The reply check rejects an hh:mm that differs from the clock by more than a margin, and the rule tells steps to read the clock."
status: "approved"
version: "0.1.0"
---
# Feature Brief - Reply time matches the clock

**Feature ID:** 0000468-reply-time-matches-the-clock

Source: backlog entry 0000434, from the initiative 0000360 retrospective (`plan/retrospectives/0000360-backlog-sweep-retrospective.md`, evidence row 24).

## Business Goal

Steps 14, 15, and 19 typed reply times that ran up to an hour off. `check-reply-prefix.mjs` checks the shape of the time only, so a wrong time passes. The check now compares the time with the clock, and the reply rule tells the step to read the clock before each reply.

## Features

| Feature | User Stories | Priority | Wave |
|---------|-------------|----------|------|
| Clock check | As a human on the loop, I see a warning when a reply time differs from the clock by more than the margin, so that a wrong time does not pass. | must-have | 1 |
| Read-the-clock rule | As a human on the loop, I find the instruction to read `date +%H:%M` before each reply in every place that states the reply form, so that steps read the clock. | must-have | 1 |

## Wanted outcome

- A reply that leads with a time more than 5 minutes from the clock draws the prefix-check warning and a log line.

## Target Architecture

### Components

| Component | Type | New or Existing | Responsibility |
|-----------|------|-----------------|---------------|
| ravintio-zero | component-pack | existing | Holds the Stop hook, the standards, the skills, and the boot templates |

### Data Ownership

No data store. The hook appends to the existing `plan/.prefix-misses.log`.

### Integration Points

None.

## Stack

| Concern | Decision |
|---------|----------|
| Language | Node hook, bash suites, already in the pack |
| Testing | Bash suites under `src/ravintio-zero/tests/` |
| CI | GitHub Actions, already configured |
| Build target | local |

## Scope Boundaries

### In Scope
- `check-reply-prefix.mjs` compares a leading `hh:mm` with the local clock. A difference over the margin, taken around midnight, is a miss. The margin is 5 minutes.
- A clock override and a margin override through environment variables, for tests.
- A rule line that tells the step to read `date +%H:%M` before each reply. It goes in the roadmap standards, both skills, and the boot templates.
- Fixed clocks in the two 0000388 suites that use fixed times.
- A new suite, an ADR, docs, a changelog entry, and the sync of `ravintio-zero/`.

### Out of Scope
- Blocking a turn. The hook still warns and logs only (ADR-002 of 0000200).
- Changes to `check-design.mjs`.

### Deferred
- None.

## Non-Functional Requirements

| NFR | Target | Measurement |
|-----|--------|-------------|
| Latency | The hook adds no file or process work | Code review |

## Constraints and Assumptions

### Constraints
- No new library or service.
- The hook exits 0 on every path.

### Assumptions
- The hook runs on the same machine and clock as the session. Impact if wrong: the check warns on a correct time.
- The hook runs right after the final reply. Impact if wrong: a slow Stop hook adds to the difference, and the 5-minute margin absorbs it.

## Scenario Paths

**Happy path:** The step reads `date +%H:%M`, leads the reply with that time, and the hook passes.

> The hook reads the first line, strips the time, and finds the time within 5 minutes of the clock.

**First-run path:** A run has no `plan/.prefix-misses.log` yet.

> The hook creates the log on the first miss, as it does today.

**Error / sad path:** The reply leads with a time an hour off.

> The hook warns, names the time and the clock, and logs one line.

**Cross-session continuity:** The hook keeps no state.

> No state is at risk.

## Acceptance Criteria

- [ ] A reply with a time within 5 minutes of the clock passes, including across midnight.
- [ ] A reply with a time more than 5 minutes off draws the warning and one log line.
- [ ] A time with no prefix is still a miss.
- [ ] Every place that states the reply form tells the step to read `date +%H:%M`.
