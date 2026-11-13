---
title: "ADR 003: A criterion stays one checkbox line with Gherkin steps under it"
summary: "Each acceptance criterion keeps its checkbox line and gains indented Given, When, and Then lines."
status: "accepted"
version: "0.1.0"
component: "ravintio-zero"
feature: "0000170-story-mapping-and-gherkin"
---
# ADR-0179 - A criterion stays one checkbox line with Gherkin steps under it

**Skill:** [plan](../skills/ravintio-plan/SKILL.md)
**Feature:** 0000170-story-mapping-and-gherkin
**Component:** ravintio-zero
**Date:** 2026-10-25

## Context

The test writer maps one criterion to one test. The P3 coverage table maps each criterion to a test. The three-criteria limit and the ratchet both count checkbox lines. Backlog 0000165 asks whether Gherkin criteria still count against the limit.

## Decision

Each criterion is `- [ ] AC-{n}: {name}` with indented `Given`, `When`, and `Then` bullets. `And` and `But` continue the step above. The limit of three counts checkbox lines, so one scenario counts once.

## Alternatives Considered

| Alternative | Pros | Cons | Why Rejected |
|-------------|------|------|-------------|
| One line per criterion, `Given ..., when ..., then ...` | No parser change | Long lines, and no step can be checked or guarded alone | Backlog asks for separate lines |
| Fenced `gherkin` code blocks | Matches `.feature` syntax | No checkbox, so the coverage table and ratchet lose their unit | Breaks every consumer of the checkbox |

## Affected Components

| Component | Impact |
|-----------|--------|
| ravintio-zero | Template, plan skill, and consistency check |

## Consequences

**Positive:**
- Existing readers of the checkbox keep working.

**Negative:**
- Old-format criteria in a run in flight fail the new rule until they gain steps.

**Risks:**
- None beyond the risk register.

## Related ADRs

- None

## Supersedes

- None

## Superseded By

- None
