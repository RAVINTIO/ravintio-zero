---
title: "ADR 006: Orchestrator references split"
summary: "Rarely used orchestrator sections move verbatim to references/orchestrator-*.md files listed in the Pack Index. Core sections stay inline, and a line-preservation check proves no rule was lost."
status: "accepted"
version: "0.1.0"
component: "ravintio-zero"
feature: "0000151-hardening-efficiency-and-ci"
---
# ADR-0161 - Orchestrator references split

**Skill:** [plan](../../../.claude/skills/planifest-plan/SKILL.md)
**Feature:** 0000151-hardening-efficiency-and-ci
**Component:** planifest-zero
**Date:** 2026-10-24

## Context

The orchestrator `SKILL.md` loads in full at the start of every session. Many sections apply only in rare cases, such as retrofit or roadmap charting. They add to the starting context for every run, which raises token cost.

Tests grep `SKILL.md` for rule text, so a move can silently drop an assertion.

## Decision

Move rarely used sections verbatim into `references/orchestrator-*.md` files under the orchestrator skill.

- **Index.** The Pack Index lists each reference file with a one-line purpose, so the orchestrator loads one on demand.
- **Inline.** Core sections stay in `SKILL.md`. The Exception Stops table stays inline.
- **Verbatim.** The move changes no wording.
- **Check.** A line-preservation test confirms every moved line appears in a reference file. The test fails if a line is lost.
- **Tests.** Tests that grep `SKILL.md` read the new file instead. No assertion is dropped.
- **Measure.** The starting context is measured before and after.

## Alternatives Considered

| Alternative | Pros | Cons | Why Rejected |
|-------------|------|------|-------------|
| Keep one large `SKILL.md` | No test changes | Every session pays for rare sections | The cost is the problem the requirement targets |
| Trim the text | Smaller file | Risks dropping a rule | The rules must all survive |
| Split into several skills | Native loading | Adds skill descriptions to every session and changes triggers | References load only when named |

## Affected Components

| Component | Impact |
|-----------|--------|
| planifest-zero | New `references/` files, a longer Pack Index, updated tests, and a line-preservation check |

## Consequences

**Positive:**
- Every session starts with less context.
- Each moved rule stays readable in one place.

**Negative:**
- The orchestrator must remember to load a reference when a rare case arises.
- Tests that grep `SKILL.md` need updating.

**Risks:**
- The orchestrator may skip a needed reference. The Pack Index lists each file with its trigger to reduce this.
- A move may drop a line. The preservation check catches this.

## Related ADRs

- ADR-0159 - related-to (the Exception Stops table stays inline)

## Supersedes

- None

## Superseded By

- None
