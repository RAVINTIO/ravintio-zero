---
title: "ADR 001: The scan stays a skill instruction"
summary: "The scan is skill text and adds no script."
status: "active"
version: "0.1.0"
---
# ADR-001 - The scan stays a skill instruction

**Skill:** [plan](../../../ravintio-zero/skills/ravintio-plan/SKILL.md)
**Feature:** 0000383-test-impact-scan
**Component:** ravintio-zero
**Date:** 2026-11-07

## Context

Five backlog entries ask for more scan causes. A script could run the greps, but each cause needs a judgement about the edit.

## Decision

Each cause is one bullet in the `## Test impact scan` of `ravintio-plan`. The planner runs the greps. No script is added.

## Alternatives Considered

| Alternative | Pros | Cons | Why Rejected |
|-------------|------|------|-------------|
| A scan script | Repeatable | Needs a diff of planned edits that does not exist at plan time | The plan lists edits as prose |

## Affected Components

| Component | Impact |
|-----------|--------|
| ravintio-zero | Plan, implement, test-writer, refactor, and validate skills gain text |

## Consequences

**Positive:**
- No new code to maintain.

**Negative:**
- The scan depends on the planner following the bullets.
