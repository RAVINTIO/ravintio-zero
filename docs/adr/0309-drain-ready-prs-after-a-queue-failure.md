---
title: "ADR 309: Drain ready PRs after a queue failure"
summary: "The driver keeps queueing ready PRs after one queue failure, one attempt per step, and still starts no new step."
status: "proposed"
component: "ravintio-zero"
version: "0.1.0"
feature: "0000446-drain-ready-prs-after-a-stop"
---
# ADR-0309 - Drain ready PRs after a queue failure

**Skill:** [plan](../skills/ravintio-plan/SKILL.md)
**Feature:** 0000446-drain-ready-prs-after-a-stop
**Component:** ravintio-zero
**File:** `docs/adr/0309-drain-ready-prs-after-a-queue-failure.md`
**Date:** 2026-11-10

## Context

The concurrent driver runs the merge queue for one ready PR at a time. After a queue failure, the `schedule()` loop stops taking ready steps. Green PRs for independent steps then wait until a human restarts the driver. Initiative 0000360 lost time this way (evidence row 16 of its retrospective).

## Decision

After a queue failure, the driver keeps queueing the other ready steps. Each ready step gets one attempt per driver run. The failed step ends in state `stopped` and keeps its `ready` file. Each failure prints its own `I-D Advance: Blocked: queue stopped on step {n}` line. The first stop line still sets the exit message, and the driver still starts no new step.

A ready step is safe to queue. The scheduler starts a step only when its `After` steps have merged. It also needs a lane that no running or ready step holds.

## Alternatives Considered

| Alternative | Pros | Cons | Why Rejected |
|-------------|------|------|-------------|
| Keep the hold and add a manual drain command | No change to the driver loop | A human must notice the stop and run the command | The wait is the problem |
| Stop the queue on the first failure | Matches the old behaviour | Independent green PRs wait | The backlog entry asks to remove the wait |

## Affected Components

| Component | Impact |
|-----------|--------|
| ravintio-zero | `initiative-run.mjs` loop and the roadmap standards change |

## Consequences

**Positive:**
- Independent ready PRs merge with no human step.
- A restart queues only the failed PR again.

**Negative:**
- A failure that every PR shares, such as a CI outage, runs one CI watch for each ready PR.

**Risks:**
- A failed run can leave files in the queue worktree. Backlog 0000477 tracks that cleanup.

## Related ADRs

- 0000379 ADR-002 (concurrent scheduler) - extends

## Supersedes

- None.

## Superseded By

- None.
