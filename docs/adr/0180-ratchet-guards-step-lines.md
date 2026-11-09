---
title: "ADR 004: The ratchet guards Gherkin step lines"
summary: "While a loop is active, the ratchet blocks removal of a Gherkin step line as well as a checkbox line."
status: "accepted"
version: "0.1.0"
component: "ravintio-zero"
feature: "0000170-story-mapping-and-gherkin"
---
# ADR-0180 - The ratchet guards Gherkin step lines

**Skill:** [plan](../skills/ravintio-plan/SKILL.md)
**Feature:** 0000170-story-mapping-and-gherkin
**Component:** ravintio-zero
**Date:** 2026-10-25

## Context

The ratchet guards checkbox lines in `## Acceptance Criteria`. Under ADR-0179, the meaning of a criterion sits in its step lines. A loop could weaken a criterion by deleting a `Then` line and keeping the checkbox.

## Decision

The ratchet treats each `Given`, `When`, `Then`, `And`, or `But` bullet in `## Acceptance Criteria` as a guarded line. Adding a line passes. Removing or rewording one blocks unless a human approval marker names the file.

## Alternatives Considered

| Alternative | Pros | Cons | Why Rejected |
|-------------|------|------|-------------|
| Guard checkbox lines only | No hook change | A step edit weakens a criterion silently | Leaves the gap the ratchet exists to close |
| Hash each whole criterion | Catches any change | Blocks strengthening edits to a step | Strengthening must pass |

## Affected Components

| Component | Impact |
|-----------|--------|
| ravintio-zero | Ratchet hook parses one more line kind |

## Consequences

**Positive:**
- A loop can't weaken a criterion by editing its steps.

**Negative:**
- A reworded step needs the approval marker, even when the change is neutral.

**Risks:**
- None beyond the risk register.

## Related ADRs

- ADR-0179: a criterion stays one checkbox line with Gherkin steps under it

## Supersedes

- None

## Superseded By

- None
