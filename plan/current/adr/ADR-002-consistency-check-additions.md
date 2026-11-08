---
title: "ADR 002: Consistency check additions"
summary: "Checks 9 and 10 are new, check 8 gains an optional column, and reference resolution reads docs/adr."
status: "proposed"
version: "0.1.0"
---
# ADR-002 - Consistency check additions

**Skill:** [plan](../skills/ravintio-plan/SKILL.md)
**Feature:** 0000384-plan-checks
**Component:** ravintio-zero
**Date:** 08 Nov 2026

## Context

Four backlog entries ask `consistency-check.mjs` to catch a plan gap: a shell feature absent from Bash 3.2, a missing living docs unit, a shared resource in one batch, and ADR references that no longer sit in `plan/current/adr/`.

## Decision

- Check 9 scans ADR text for a fixed list of Bash 4 features. A match needs a line that starts `Oldest shell:`.
- Check 10 needs one Concurrency plan unit that writes a path under `docs/`.
- Check 8 reads a `Shared resources` column when the header holds it. A missing column adds no finding.
- Check 3 resolves `ADR-NNN` and `ADR-NNNN` against `plan/current/adr/` and `docs/adr/`.
- Oldest shell: Bash 3.2. The script is Node and uses no shell feature.

## Alternatives Considered

| Alternative | Pros | Cons | Why Rejected |
|-------------|------|------|-------------|
| Require the column in every plan | One format | Breaks every older plan | Optional keeps older plans valid |
| Check shell features in a hook | Earlier feedback | Widens a hook | The chart bars hook changes |

## Affected Components

| Component | Impact |
|-----------|--------|
| ravintio-zero | `consistency-check.mjs`, the execution plan template, and fixtures |

## Consequences

**Positive:**
- Four plan gaps fail before P2.

**Negative:**
- Existing fixtures need a docs unit.

**Risks:**
- The feature list misses a Bash 4 feature. The list is a constant that a later step extends.

## Related ADRs

- ADR-001 - related-to

## Supersedes

- None

## Superseded By

- None
