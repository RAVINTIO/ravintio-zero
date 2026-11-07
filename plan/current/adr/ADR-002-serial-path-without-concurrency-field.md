---
title: "ADR 002: A chart without a Concurrency field keeps the serial path"
summary: "A chart without a Concurrency field keeps the serial path"
status: "accepted"
version: "0.1.0"
---
# ADR-002 - A chart without a Concurrency field keeps the serial path

**Skill:** [plan](../skills/ravintio-plan/SKILL.md)
**Feature:** 0000379-parallel-steps-on-worktrees
**Component:** ravintio-zero
**Date:** 2026-11-07

## Context

Twenty-five driver suites and live charts rely on one step at a time, a `**Position:**` field, and a step that merges its own PR.

## Decision

`initiative-run.mjs` runs the scheduler only when the chart holds a `**Concurrency:**` field. Without it, the driver runs the existing serial path unchanged. A value of 1 uses the scheduler with one slot.

## Alternatives Considered

| Alternative | Pros | Cons | Why Rejected |
|-------------|------|------|-------------|
| Replace the serial path | One code path | Breaks every existing suite and chart | Too much change in one step |
| Default to 3 when absent | Concurrent by default | Changes behaviour of old charts silently | The template default already covers new charts |

## Affected Components

| Component | Impact |
|-----------|--------|
| ravintio-zero | `initiative-run.mjs` holds two paths. |

## Consequences

**Positive:**
- Old charts and suites keep working.

**Negative:**
- Two paths cost more to maintain.

**Risks:**
- A fix to one path misses the other. Tests cover both.

## Related ADRs

- None

## Supersedes

- None

## Superseded By

- None
