---
title: "ADR-0209 - The concurrency table lives in the execution plan"
status: "accepted"
component: "ravintio-zero"
feature: "0000201-plan-concurrent-work"
---
# ADR-0209 - The concurrency table lives in the execution plan

**Skill:** [plan](../skills/ravintio-plan/SKILL.md)
**Feature:** 0000201-plan-concurrent-work
**Component:** ravintio-zero
**Date:** 2026-10-27

## Context

The orchestrator picks batches one phase at a time. The plan needs to record the batches before work starts, in a place that survives a session change and that the consistency check already reads.

## Decision

Add a `## Concurrency plan` section to `execution-plan.md` with the columns `Unit`, `Depends on`, `Writes`, `Batch`, and `Sequential reason`. Check 8 of `consistency-check.mjs` validates it. The check skips a missing `execution-plan.md`, so a fixture without one still passes. A plan that exists without the section fails.

## Alternatives Considered

| Alternative | Pros | Cons | Why Rejected |
|-------------|------|------|-------------|
| A separate `concurrency.md` file | Keeps the plan short | A new artifact for the ratchet, the archive, and the gate to track | The plan is the central artifact |
| Prose in the plan skill only | No format to check | No gate can fail a plan without it | The entry asks for a failing check |
| A hook that blocks dispatch | Strong enforcement | A false positive stops a run | Out of scope. R-002 records the gap. |

## Affected Components

| Component | Impact |
|-----------|--------|
| ravintio-zero | The template, the guide, the plan skill, the dispatch standard, the implement skill, and the check |

## Consequences

**Positive:**
- Batches are visible at the plan gate and survive a session change.

**Negative:**
- Every plan carries one more table to keep right.

**Risks:**
- The implement phase can ignore the table. R-002 records this.

## Related ADRs

- ADR-0208

## Supersedes

None.

## Superseded By

None.
