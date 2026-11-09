---
title: "ADR 001: Resume with the session id from the stream"
summary: "The driver reads the session id from stream events and resumes at most twice."
status: "active"
version: "0.1.0"
component: "ravintio-zero"
feature: "0000354-steps-run-to-the-end"
---
# ADR-0249 - Resume with the session id from the stream

**Skill:** [plan](../../ravintio-zero/skills/ravintio-plan/SKILL.md)
**Feature:** 0000354-steps-run-to-the-end
**Version:** 0.52.0
**Component:** ravintio-zero
**Date:** 2026-11-06

## Context

A step session can exit 0 after P2 with no pending task. The driver then stops with a block that names no cause. Entry 0000334 describes it.

## Decision

The driver watches the child's stdout for the first `session_id` value and validates it. After an unmerged exit 0, it runs `claude -p --resume {session}` with the same flags and a continue prompt, up to two times. It keeps the session id in memory only. The chart sets the cap of two.

## Alternatives Considered

| Alternative | Pros | Cons | Why Rejected |
|-------------|------|------|-------------|
| Rule in the skill only | No driver change | Relies on the model following it | Does not recover a step that ends early |
| Start a fresh session per retry | No session id needed | Loses context and repeats work | Wastes turns |

## Affected Components

| Component | Impact |
|-----------|--------|
| ravintio-zero | `initiative-run.mjs` gains the resume loop. |

## Consequences

**Positive:**
- An early end of turn needs no human.

**Negative:**
- The driver depends on the `session_id` field of the stream format.

**Risks:**
- See R-001, R-002, and A-001.

## Related ADRs

- ADR-0250 - related

## Supersedes

- None.

## Superseded By

- None.
