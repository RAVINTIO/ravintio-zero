---
title: "ADR 0279: Dates and semicolons follow the writing standard"
summary: "Body-text dates move to ISO or long form, and the semicolon leaves the em dash replacements."
status: "accepted"
component: "ravintio-zero"
feature: "0000389-writing-standard"
version: "0.1.0"
---
# ADR-0279 - Dates and semicolons follow the writing standard

**Skill:** [plan](../../ravintio-zero/skills/ravintio-plan/SKILL.md)
**Feature:** 0000389-writing-standard
**Component:** ravintio-zero
**Date:** 2026-11-08

## Context

`formatting-standards.md` requires `DD MMM YYYY` in body text and forbids ISO dates. It offers the semicolon as an em dash replacement. The writing standard asks for `2026-08-18` or "August 18, 2026" and bans semicolons.

## Decision

`formatting-standards.md` adopts the writing standard's rules for body text. Filename prefixes stay `YYYY-MM-DD`. The pack does not rewrite existing artifacts or templates in this step. Step 19 rewrites pack prose. Tests that pin `DD MMM YYYY` change in the same step.

## Alternatives Considered

| Alternative | Pros | Cons | Why Rejected |
|-------------|------|------|-------------|
| Keep `DD MMM YYYY` | No churn | Two standards disagree | The entry asks them to agree |
| Rewrite all artifacts now | One format | A large diff in a step that has another purpose | Step 19 owns the rewrite |

## Affected Components

| Component | Impact |
|-----------|--------|
| ravintio-zero | Edits `formatting-standards.md` and the `em-dash-guard.mjs` message. |

## Consequences

**Positive:**
- The agent receives one rule for dates and for the em dash.

**Negative:**
- Existing artifacts and templates keep `DD MMM YYYY` until step 19. The standard says a new sentence follows the new rule.

**Risks:**
- A pinned test fails. The plan lists the tests in the test impact table.

## Related ADRs

- ADR-001 - related-to

## Supersedes

- none

## Superseded By

- none
