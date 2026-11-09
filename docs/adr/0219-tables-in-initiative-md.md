---
title: "ADR-0219 - Keep the decision tables in initiative.md"
status: "accepted"
component: "ravintio-zero"
feature: "0000206-chart-time-decisions"
---
# ADR-0219 - Keep the decision tables in initiative.md

**Skill:** [plan](../skills/ravintio-plan/SKILL.md)
**Feature:** 0000206-chart-time-decisions
**Component:** ravintio-zero
**Date:** 2026-10-27

## Context

Chart already stores schema and dependency approvals as tables in `initiative.md`. Every step session reads that file.

## Decision

Add the decisions, baselines, and criteria tables to `initiative.md`, after `## Dependencies`. The human's confirmation of the chart approves every row left in them.

## Alternatives Considered

| Alternative | Pros | Cons | Why Rejected |
|-------------|------|------|-------------|
| A separate decisions file per initiative | Keeps `initiative.md` short | A second file to read, archive, and keep in step | Steps already read `initiative.md`. |

## Affected Components

| Component | Impact |
|-----------|--------|
| ravintio-zero | The template and the roadmap standards |

## Consequences

**Positive:**
- One approval covers every table, and no new read path.

**Negative:**
- `initiative.md` grows with each table.

**Risks:**
- A long table hides a broad row. The human reads each row at Chart.

## Related ADRs

- ADR-0218

## Supersedes

None.

## Superseded By

None.
