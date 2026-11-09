---
title: "ADR-0204 - Stack choice"
status: "accepted"
component: "ravintio-zero"
feature: "0000199-reserve-ids-from-counter"
---
# ADR-0204 - Stack choice

**Skill:** [plan](../skills/ravintio-plan/SKILL.md)
**Feature:** 0000199-reserve-ids-from-counter
**Component:** ravintio-zero
**Date:** 2026-10-27

## Context

The change adds one Node.js program and a Bash test suite, and edits Markdown docs. The design declares the stack as Node.js and Bash with the pack's test runners.

## Decision

Write `reserve-id.mjs` in Node.js ESM with built-in modules only. Test it from a Bash suite, as the other pack scripts are. Add no library or service.

## Alternatives Considered

| Alternative | Pros | Cons | Why Rejected |
|-------------|------|------|-------------|
| A lock library such as `proper-lockfile` | Stale-lock handling | A new dependency in a pack that ships none | The Dependencies table lists none |
| A Bash script with `flock` | No Node.js | `flock` is missing on macOS, and the pack runs on Windows too | The pack's scripts are Node.js |

## Affected Components

| Component | Impact |
|-----------|--------|
| ravintio-zero | One script, one counter file, six docs, and three test suites |

## Consequences

**Positive:**
- Reservation needs no library and runs on every platform that has Node.js.

**Negative:**
- The script never clears a stale lock, so the human removes one.

**Risks:**
- A test that starts processes at once could be flaky. The test checks only the invariant, which holds in every order.

## Related ADRs

- ADR-0205

## Supersedes

None.

## Superseded By

None.
