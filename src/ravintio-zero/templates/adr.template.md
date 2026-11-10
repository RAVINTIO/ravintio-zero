---
title: "ADR {{NNN}}: {{title}}"
summary: "One paragraph summary of the decision and its impact."
status: "proposed | accepted | deprecated | superseded"
component: "{{component-id}}"
version: "0.1.0"
---
# ADR-{{NNN}} - {{title}}

**Skill:** [plan](../skills/ravintio-plan/SKILL.md)
**Feature:** {{feature-id}}
**Component:** {{component-id}} (if scoped to one)
**File:** `docs/adr/{NNNN}-{slug}.md`. The number is repo-wide, four digits, reserved with `node ravintio-zero/scripts/reserve-id.mjs --file docs/adr/.next-id`.
**Date:** {{ISO-8601}}

## Context

{{context}}

## Decision

{{decision}}

## Alternatives Considered

| Alternative | Pros | Cons | Why Rejected |
|-------------|------|------|-------------|
| {{option}} | {{pros}} | {{cons}} | {{reason}} |

## Affected Components

| Component | Impact |
|-----------|--------|
| {{component-id}} | {{how this decision affects the component}} |

## Consequences

**Positive:**
- {{what becomes easier or better}}

**Negative:**
- {{what becomes harder or worse}}

**Risks:**
- {{what could go wrong as a result of this decision}}

## Related ADRs

- {{ADR-id}} - {{relationship: extends | conflicts-with | depends-on | related-to}}

## Supersedes

- {{ADR-id this supersedes, if any}}

## Superseded By

- Superseded by {number}

