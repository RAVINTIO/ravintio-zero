---
title: "ADR 305: Reply time clock check"
summary: "The Stop hook compares a leading hh:mm with the local clock and warns when it differs by more than 5 minutes."
status: "accepted"
component: "ravintio-zero"
version: "0.1.0"
feature: "0000468-reply-time-matches-the-clock"
---
# ADR-0305 - Reply time clock check

**Skill:** [plan](../skills/ravintio-plan/SKILL.md)
**Feature:** 0000468-reply-time-matches-the-clock
**Component:** ravintio-zero
**File:** `docs/adr/0305-reply-time-clock-check.md`
**Date:** 2026-11-10

## Context

Steps 14, 15, and 19 of initiative 0000360 typed reply times up to an hour off. `check-reply-prefix.mjs` accepted any `hh:mm` because it checked the shape only. The injected time was context and the rule did not tell the step to read the clock.

## Decision

The hook compares the leading time with the local clock. It takes the shorter way round the day and warns when the difference is over 5 minutes. The hook logs a miss as before. `RAVINTIO_REPLY_CLOCK` and `RAVINTIO_REPLY_MARGIN_MIN` override the clock and the margin, so a suite can fix both. The rule text tells the step to read `date +%H:%M` before each reply. The hook still warns and never blocks (ADR-0207).

Oldest shell: not applicable, the change is Node.

## Alternatives Considered

| Alternative | Pros | Cons | Why Rejected |
|-------------|------|------|-------------|
| Block the turn on a wrong time | Forces a fix | A Stop block can loop a step session, and ADR-0207 forbids it | It breaks the no-block rule |
| Check the injected time in the transcript | No clock read | The injected time is stale in a long turn | It fails on long steps |
| Rule text only | No code | The rule already failed three times | It does not catch a wrong time |

## Affected Components

| Component | Impact |
|-----------|--------|
| ravintio-zero | The Stop hook, the rule text, and two older suites |

## Consequences

**Positive:**
- A wrong reply time draws a warning and a log line.

**Negative:**
- A long Stop delay can warn on a correct time.

**Risks:**
- A session on another clock, such as a container, warns on every reply until the user sets `RAVINTIO_REPLY_CLOCK`.

## Related ADRs

- ADR-0207 - related-to, the Stop hook warns and never blocks

## Supersedes

- None

## Superseded By

- None
