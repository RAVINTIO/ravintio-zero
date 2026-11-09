---
title: "ADR 002: P1 owns the story mapping pass"
summary: "The plan phase writes the story map before it writes requirements."
status: "accepted"
version: "0.1.0"
component: "ravintio-zero"
feature: "0000170-story-mapping-and-gherkin"
---
# ADR-0178 - P1 owns the story mapping pass

**Skill:** [plan](../skills/ravintio-plan/SKILL.md)
**Feature:** 0000170-story-mapping-and-gherkin
**Component:** ravintio-zero
**Date:** 2026-10-25

## Context

Backlog 0000165 asks whether P0 or P1 owns the mapping pass. P0 coaches the brief with the human. P1 derives requirements from the confirmed design. A roadmap step self-confirms P0, so P0 has no human to coach in that case.

## Decision

P1 runs the story mapping pass first and writes `plan/current/story-map.md`. A gap the brief states or implies becomes a new story and a requirement. Any other gap goes to the out-of-scope list. In a gated run, P1 asks the human about it one question at a time.

## Alternatives Considered

| Alternative | Pros | Cons | Why Rejected |
|-------------|------|------|-------------|
| P0 owns the pass | The human sees gaps while coaching | Lengthens every P0 and adds an artifact before the design exists | P1 already reads the full design |
| No artifact, a checklist in the plan skill | Less to write | Nothing for the check to verify | The check needs a file |

## Affected Components

| Component | Impact |
|-----------|--------|
| ravintio-zero | Plan skill and a new template |

## Consequences

**Positive:**
- Every run, gated or autonomous, gets the same gap check.

**Negative:**
- A gap found in P1 can't change the confirmed design, so an unimplied gap waits for a later release.

**Risks:**
- None beyond the risk register.

## Related ADRs

- None

## Supersedes

- None

## Superseded By

- None
