---
title: "ADR 0344: Unit report fields"
summary: "A unit report holds a RED line, a GREEN line, a commit hash, and any deviation. The orchestrator rejects a report without one and resumes the unit once."
status: "proposed"
component: "ravintio-zero"
version: "0.1.0"
---
# ADR-0344 - Unit report fields

**Skill:** [plan](../skills/ravintio-plan/SKILL.md)
**Feature:** 0000573-require-unit-reports
**Component:** ravintio-zero
**File:** `docs/adr/0344-unit-report-fields.md`
**Date:** 2026-11-14T15:24:33Z

## Context

One dispatched unit ended with a report that held only the word "placeholder". The orchestrator could not log the RED result. It read the commit and reran the suite. The dispatch standard did not say what a report holds.

## Decision

The dispatch standard adds the rule `dispatch-unit-report`. A unit report holds the RED line, the GREEN line, the commit hash, and any deviation. The orchestrator rejects a report that lacks a field. It resumes the unit once. A second bad report takes the normal failure path.

## Alternatives Considered

| Alternative | Pros | Cons | Why Rejected |
|-------------|------|------|-------------|
| Read the commit and rerun the suite | No new rule | Costs a rerun each time | It is the cost the backlog entry reports |
| A script that checks reports | Mechanical | New code for a prose gap | Out of scope for this step |

## Affected Components

| Component | Impact |
|-----------|--------|
| ravintio-zero | The dispatch standard gains one rule and one test. |

## Consequences

**Positive:**
- The orchestrator logs a unit from its report alone.

**Negative:**
- A resume costs one more dispatch when a report is bad.
