---
title: "ADR 001: Coordinator skip uses env marker and lock"
summary: "The prefix hook skips its check when RAVINTIO_INITIATIVE_STEP is not 1 and the driver lock exists under the working directory."
status: "proposed"
version: "0.1.0"
---
# ADR-001 - Coordinator skip uses env marker and lock

**Skill:** [plan](../../../ravintio-zero/skills/ravintio-plan/SKILL.md)
**Feature:** 0000388-replies-and-questions
**Component:** ravintio-zero
**Date:** 2026-11-07T22:01:39Z

## Context

A coordinator session shares the working tree with a running driver. The prefix hook warns the coordinator about replies that the driver watch output causes. The human reads those warnings as a stopped run (entry 0000258). The chart pre-approves a skip that uses the step session's environment marker. The marker alone is not enough. A session outside any initiative also lacks the marker and still needs the check.

## Decision

The `check-reply-prefix.mjs` hook skips the check when both conditions hold:

- `RAVINTIO_INITIATIVE_STEP` is not `1`.
- `plan/.initiative-runner.lock` exists under the working directory.

In any other case the hook runs the check as today. The skip never blocks and never logs a miss.

## Alternatives Considered

| Alternative | Pros | Cons | Why Rejected |
|-------------|------|------|-------------|
| Env marker alone | No file read | Turns the check off in every session outside an initiative | Weakens the check for the common case |
| Lock alone | No env dependence | Skips the check in the step session too, which runs under the same lock | Removes the check where it matters |
| Keep the warning, reword only | No logic change | The coordinator still sees a warning for each reply while a step runs | Leaves the confusion in place |

## Affected Components

| Component | Impact |
|-----------|--------|
| ravintio-zero | `check-reply-prefix.mjs` gains one condition. `hook-enforcement.md` records it. |

## Consequences

**Positive:**
- The coordinator session sees no false warning while a step runs.
- The check stays on in step sessions and in sessions outside an initiative.
- The change touches a warn-only hook and no fail-closed hook.

**Negative:**
- The hook now reads the file system and the environment, so it has two more inputs to test.
- Coordinator replies go unchecked while the lock exists.

**Risks:**
- A stale lock keeps the check off after the driver ends (R-007).
- A step session that lacks the marker loses its check.

## Related ADRs

- None.

## Supersedes

- None.

## Superseded By

- None.
