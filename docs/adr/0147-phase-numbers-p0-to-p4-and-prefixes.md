---
title: "ADR 003: Phase numbers P0 to P4 and number-plus-name prefixes"
summary: "The five phases take the numbers P0 to P4, matching Planifest Framework. Build-log headings and message prefixes carry the number and name. The letter prefixes retire, and a grep guard test blocks stale cites outside history."
status: "accepted"
version: "0.1.0"
component: "ravintio-zero"
feature: "0000042-autonomous-mode-and-prefixes"
---
# ADR-0147 - Phase numbers P0 to P4 and number-plus-name prefixes

**Skill:** [plan](../skills/planifest-plan/SKILL.md)
**Feature:** 0000042-autonomous-mode-and-prefixes
**Component:** planifest-zero
**Date:** 2026-10-23

## Context

ADR-0108 set the pipeline at five phases and kept the old numbering style. The skills number them P1 to P5. Messages use the letter prefixes `D:`, `PL:`, `IM:`, `VA:`, and `SH:`.

Planifest Framework is a separate product. It starts at P0 and prefixes messages with `P0:` to `P9:`. A person who uses both products reads two numbering schemes.

The letter prefixes also need a legend. The orchestrator uses a colon after the status and the pipeline reference uses a comma, so the two copies of the form disagree.

Old cites survive the five-phase cut in several files. Examples are "P0 briefing" and "P9 push", and the file `custom-004-p9-push-and-raise-pr.md`. Orchestrator Hard Limit 10 also claims that a hook parses the build-log heading form. No source hook does.

During P1 the human asked for the P0 to P4 numbering and chose the number-plus-name prefix.

## Decision

The phases are P0 Discovery, P1 Plan, P2 Implement, P3 Validate and Accept, and P4 Ship. The numbers match Planifest Framework, which starts at P0.

Build-log headings use `### P<n>: {Phase Name}`, with n from 0 to 4. Hard Limit 10 uses this form and drops its claim that a hook parses it.

Every message starts with one of these prefixes, then `{Status}: {one-liner}`:

| Phase | Prefix |
|-------|--------|
| P0 | `P0 Discovery:` |
| P1 | `P1 Plan:` |
| P2 | `P2 Implement:` |
| P3 | `P3 Validate:` |
| P4 | `P4 Ship:` |

Messages shorten P3 to "Validate". Skills and the build log keep the full name "Validate and Accept". The letter prefixes `D:`, `PL:`, `IM:`, `VA:`, and `SH:` retire.

`custom-004-p9-push-and-raise-pr.md` becomes `custom-004-ship-push-and-raise-pr.md`. Its text and every reference to the old name take the new numbers.

A grep guard test fails on a phase number outside P0 to P4 or on a retired letter prefix. It excludes history:

- `plan/_archive/`
- `plan/changelog/`
- `planifest-zero/migrations/_done/`
- existing `plan/backlog/` entries
- `plan/current/`, which the ship phase archives

This run's own build log keeps P1 to P5 headings. The 0.8.0 skills drive this run and parse that form. The new numbers take effect for the next feature.

## Alternatives Considered

| Alternative | Pros | Cons | Why Rejected |
|-------------|------|------|--------------|
| Bare `P0:` prefix, as in Planifest Framework | Shortest prefix, identical to the other product | The reader needs a legend to map a number to a phase | The human wants to read the phase without a legend |
| Keep the letter codes and fix the separator | No renumbering, so no breaking change | The two products keep different schemes, and the codes still need a legend | It fixes the colon and comma mismatch but not the legend |
| Full name `P3 Validate and Accept:` in messages | Matches the skill and build-log name exactly | The longest prefix, repeated on every message | The shorter "Validate" is clear in context |

## Affected Components

| Component | Impact |
|-----------|--------|
| planifest-zero | Skills, templates, docs, hooks, standards, and workflows take the new numbers. The `custom-004` override file is renamed. A new guard test holds the rule, and 23 test files change their assertions |

## Consequences

**Positive:**
- The phase numbers match Planifest Framework, so a reader moves between the products without a mapping.
- A message names its phase without a legend.
- One status form replaces the two that disagreed.
- The guard test blocks stale cites from returning.

**Negative:**
- The prefixes are longer than the letter codes.
- Every phase cite changes, so this is a breaking change for anyone who reads the old numbers.
- The 23 test files that assert old numbers need rewriting.
- This run's build log uses P1 to P5 while its messages use P0 to P4. A reader maps one to the other for this run.

**Risks:**
- A cite outside the guard test's scope keeps an old number. The test covers skills, docs, templates, hooks, and standards, and a review of the diff covers the rest.
- A person still searches for an old letter prefix. The changelog records the retirement.

## Related ADRs

- ADR-0108 - extends (the five-phase contract stays)

## Supersedes

- ADR-0108 in part. It set five phases numbered P1 to P5 with letter prefixes, and this ADR replaces that numbering and those prefixes. The five-phase contract and the skill consolidation stand.

## Superseded By

- None
