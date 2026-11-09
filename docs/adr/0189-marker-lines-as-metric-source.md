---
title: "ADR 002: Fixed marker lines are the only metric source"
summary: "The script counts four fixed line forms in the build log and loop-state files, and never reads free text."
status: "accepted"
version: "0.1.0"
component: "ravintio-zero"
feature: "0000173-workflow-governance-gates"
---
# ADR-0189 - Fixed marker lines are the only metric source

**Skill:** [plan](../skills/ravintio-plan/SKILL.md)
**Feature:** 0000173-workflow-governance-gates
**Component:** ravintio-zero
**Date:** 2026-10-25

## Context

Backlog entry 0000100 asks for metrics derived from the build log and iteration logs. Only `Blocked:` has a fixed line form today. Rework, design changes, and gate revisions appear as free text, if at all. A count from free text would guess.

## Decision

The governance standard defines four marker lines: `Rework:`, `Blocked:`, `Requirement change:`, and `Gate revised:`. The phase skills write them. The script counts a marker only at the start of a line or list item, outside fenced code. It reads `build-log.md` and every `loop-state-*.md`, which are the run's iteration logs.

## Alternatives Considered

| Alternative | Pros | Cons | Why Rejected |
|-------------|------|------|-------------|
| Infer counts from free text | Works on old runs | Guesses, and a prose mention counts | The script must never infer, as ship Step 5 requires of the build report |
| Count loop-state iterations as rework | No new marker | Loop iterations do not name a requirement | The metric is per requirement |

## Affected Components

| Component | Impact |
|-----------|--------|
| ravintio-zero | Implement, validate, orchestrator, and the mid-pipeline reference gain one marker rule each |

## Consequences

**Positive:**
- Counts are exact and testable.

**Negative:**
- Runs that predate the markers report 0 for three metrics.

**Risks:**
- An agent skips a marker, and the metric reads low.

## Related ADRs

- ADR-0190

## Supersedes

- None

## Superseded By

- None
