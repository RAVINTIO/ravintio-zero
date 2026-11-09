---
title: "ADR-0215 - One retrospective skill with two modes, records in plan/retrospectives"
status: "accepted"
component: "ravintio-zero"
feature: "0000204-run-and-initiative-retrospectives"
---
# ADR-0215 - One retrospective skill with two modes, records in plan/retrospectives

**Skill:** [plan](../skills/ravintio-plan/SKILL.md)
**Feature:** 0000204-run-and-initiative-retrospectives
**Component:** ravintio-zero
**Date:** 2026-10-27

## Context

The entry asks for a run retrospective at ship and an initiative retrospective at delivery. Both follow the same blameless rules, the same keep and change shape, and the same filing step. Ship archives `plan/current/`, so a record kept there ends up buried in one archived run. The postmortem feature (ADR-0213) solved the same problem with `plan/postmortems/`.

## Decision

Ship one `ravintio-retrospective` skill with a run mode and an initiative mode. Write each record to `plan/retrospectives/`. A run record is `{feature-id}-{date}.md`. An initiative record is `{id}-{slug}-initiative-{date}.md`. The initiative record is committed on the initiative branch before the PR, so the PR to `main` carries it.

## Alternatives Considered

| Alternative | Pros | Cons | Why Rejected |
|-------------|------|------|-------------|
| Two skills, one per level | Each skill is shorter | Duplicates the blameless rules and filing step, and raises the skill count by two | One skill under 120 lines covers both |
| Keep run records in `plan/current/` | Archived with the run | Scattered across the archive, hard to read together | Hides lessons from later P0 and chart reads |

## Affected Components

| Component | Impact |
|-----------|--------|
| ravintio-zero | The skill, the template, the ship step, I-E Delivery, and the P0 and chart reads |

## Consequences

**Positive:**
- One folder holds every record, and P0 and chart read it in one place.

**Negative:**
- The folder grows with each run.

**Risks:**
- A record names a credential or a person. The skill forbids both.

## Related ADRs

- ADR-0214

## Supersedes

None.

## Superseded By

None.
