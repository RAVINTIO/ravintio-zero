---
title: "ADR 0353: Docs class for units with no test"
summary: "A unit with no executable check logs class docs. It still logs RED and GREEN lines that carry the class."
status: "proposed"
component: "ravintio-zero"
version: "0.1.0"
feature: "0000580-log-non-tdd-units"
---
# ADR-0353 - Docs class for units with no test

**Skill:** [plan](../skills/ravintio-plan/SKILL.md)
**Feature:** 0000580-log-non-tdd-units
**Component:** ravintio-zero
**File:** `docs/adr/0353-docs-class-for-units-with-no-test.md`
**Date:** 2026-11-26T10:04:00Z

## Context

A living-docs unit has no test. `build-log-check.mjs` needs a `RED:` and a `GREEN:` line for each `inline` unit, so such a unit had no valid form. Step 10 logged `U-004` with no class fields, and the metrics report counted it as `unclassified`. The initiative chart ruled that no check relaxes.

## Decision

Add a fifth class, `docs`, for a unit that changes living documents and has no executable check.

- A `docs` unit logs `RED:` and `GREEN:` lines with the class, at the real time. The `GREEN:` line names the check that passed, such as a prose check.
- `build-log-mark.mjs` takes `--class` for `RED` and `GREEN`.
- Check 7 requires both markers for a `docs` `Done:` line, as for tier `inline`.
- `workflow-metrics.mjs` prints `docs` in its own row.
- The tier row for `docs` matches `content`.

## Alternatives Considered

| Alternative | Pros | Cons | Why Rejected |
|-------------|------|------|--------------|
| A tier value that needs no markers | One field | Relaxes check 7 | The chart forbids relaxing a check |
| Reuse class `content` | No new class | The report cannot show docs units apart | The wanted outcome needs a named row |

## Consequences

- Positive: a docs unit has a valid form and its own row in the report.
- Positive: no check relaxes.
- Negative: the class list grows to five, so each pin on the list needs a check.
- Negative: an agent must log a marker pair for a unit that has no test.
