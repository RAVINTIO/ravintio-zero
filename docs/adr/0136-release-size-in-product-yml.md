---
title: "ADR 004: The release budget lives in product.yml"
summary: "The release budget lives in an optional releaseSize field in product.yml. The size classes, budgets, and the medium default live in the orchestrator skill."
status: "accepted"
version: "0.1.0"
component: "ravintio-zero"
feature: "0000039-setup-hardening-release-sizing"
---
# ADR-0136 - The release budget lives in product.yml

**Skill:** [adr-agent](../../../.claude/skills/planifest-adr-agent/SKILL.md)
**Feature:** 0000039-setup-hardening-release-sizing
**Component:** planifest-zero
**Date:** 2026-10-19

## Context

Discovery sizes every release with a fixed 3-story rule that no repo can change (backlog 0000109). A repo needs a setting it can own and version. `planifest-overrides/` holds prose instructions for agents, not values that a skill reads as a number. `product.yml` already holds product-level settings.

## Decision

The release budget lives in an optional `releaseSize` field in `product.yml`. It is not a file in `planifest-overrides/`.

| `releaseSize` | Budget (points) |
|---------------|-----------------|
| `small` | 4 |
| `medium` (default) | 8 |
| `large` | 14 |

| Class | Files touched | Points |
|-------|---------------|--------|
| S | 1 to 2 | 1 |
| M | 3 to 6 | 2 |
| L | 7 or more | 4 |

If the field is absent, discovery uses `medium`. If the value is unknown, discovery notes it and uses `medium`. Discovery estimates a class for each candidate, recommends a fill up to the budget, and the human confirms. Above the budget, it recommends a split. Every later discovery run follows this decision.

## Alternatives Considered

| Alternative | Pros | Cons | Why Rejected |
|-------------|------|------|-------------|
| Keep the fixed 3-story rule | No change | No repo can tune it, and a story can be large or small | Does not fix 0000109 |
| Put the budget in `planifest-overrides/` | Reuses an existing folder | It holds prose instructions, so the value has no fixed place or shape | Wrong kind of content |
| Accept any number of points | Full control | The sizing text has no shared scale, so runs differ | Three named sizes are easier to compare |

## Affected Components

| Component | Impact |
|-----------|--------|
| planifest-zero | The orchestrator skill, the feature brief template, and the feature brief guide point to the setting. A new suite checks the sizing text |

## Consequences

**Positive:**
- A maintainer tunes the release size in one field that every session reads.
- Story size now counts, so one large story no longer fills a release by count alone.
- A repo with no field keeps working with the `medium` default.

**Negative:**
- Discovery estimates file counts, so a class can be wrong. The human corrects the fill at confirmation.
- A new field in `product.yml` is one more thing for a maintainer to learn.

**Risks:**
- An unknown value silently changes the budget. Discovery notes it and asks the human to fix the field.
- This release scores 9 points against the `medium` budget of 8 (R-004). The human confirmed the scope before the rule existed.

## Related ADRs

- ADR-0133 - related-to (the field adds no tool)

## Supersedes

- None

## Superseded By

- None
