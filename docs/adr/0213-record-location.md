---
title: "ADR-0213 - Postmortem records live in plan/postmortems"
status: "accepted"
component: "ravintio-zero"
feature: "0000203-blameless-postmortems"
---
# ADR-0213 - Postmortem records live in plan/postmortems

**Skill:** [plan](../skills/ravintio-plan/SKILL.md)
**Feature:** 0000203-blameless-postmortems
**Component:** ravintio-zero
**Date:** 2026-10-27

## Context

Ship moves `plan/current/` to `plan/_archive/{feature-id}-{date}/`. A record kept in `plan/current/` ends up buried in one archived run. Later runs and the retrospectives in step 9 need to read all records in one place.

## Decision

Write each record to `plan/postmortems/{date}-{slug}.md`. The skill writes nothing under `plan/current/`. The build report lists the records the run wrote.

## Alternatives Considered

| Alternative | Pros | Cons | Why Rejected |
|-------------|------|------|-------------|
| Keep records in `plan/current/` | Archived with the run | Scattered across the archive, hard to read together | Hides lessons from later runs |

## Affected Components

| Component | Impact |
|-----------|--------|
| ravintio-zero | The skill, the template, and the ship build report line |

## Consequences

**Positive:**
- One folder holds every record, and the ship archive step leaves it in place.

**Negative:**
- The folder grows with each stop.

**Risks:**
- A record names a credential or a person. The skill forbids both.

## Related ADRs

- ADR-0212

## Supersedes

None.

## Superseded By

None.
