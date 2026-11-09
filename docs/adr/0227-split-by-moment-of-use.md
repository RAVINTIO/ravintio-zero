---
title: "ADR 001: Split the orchestrator skill by moment of use"
summary: "Move the six task-bound sections to reference files grouped by the moment a session needs them."
status: "accepted"
version: "0.1.0"
component: "ravintio-zero"
feature: "0000244-split-orchestrator-skill"
---
# ADR-0227 - Split the orchestrator skill by moment of use

**Skill:** [plan](../skills/ravintio-plan/SKILL.md)
**Feature:** 0000244-split-orchestrator-skill
**Component:** ravintio-zero
**Date:** 2026-10-28

## Context

`SKILL.md` is 23,912 bytes and every session reads it all. Six sections apply at one moment: coaching, the fresh P0 start, the P0 gate, a phase transition, and an exception stop. Feature 0000151 moved eight sections to `references/` the same way.

## Decision

Move each task-bound section verbatim into a reference file named for its moment. Discovery Gate Checklist and Design Confirmation share one file because both apply at the P0 gate. Replace the template rows of the Pack Index with one rule and add one row per new file. Move the initiative prefix block to `roadmap-standards.md`.

## Alternatives Considered

| Alternative | Pros | Cons | Why Rejected |
|-------------|------|------|-------------|
| One file per section | Simple mapping | Two files load at the same moment | The gate sections always load together |
| Leave sections inline and trim wording | No new files | Changes rules and risks loss | The entry requires verbatim moves |

## Affected Components

| Component | Impact |
|-----------|--------|
| ravintio-zero | `SKILL.md` shrinks, five reference files and one standards section are added, tests change |

## Consequences

**Positive:**
- A session loads about 9,000 bytes and reads the rest on a trigger.
- Later steps gain room under the cap.

**Negative:**
- A session must read a file before it applies a moved rule.
- 39 tests that read `SKILL.md` need updating.

**Risks:**
- A vague trigger leaves a rule unread. Each row names a concrete moment.

## Related ADRs

- None

## Supersedes

- None

## Superseded By

- None
