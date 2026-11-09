---
title: "ADR 001: Rule anchor format and lookup"
summary: "Rules carry an HTML comment anchor and tests read them through helpers in assert.sh."
status: "accepted"
version: "0.1.0"
component: "ravintio-zero"
feature: "0000380-test-helpers-and-rule-anchors"
---
# ADR-0266 - Rule anchor format and lookup

**Skill:** [plan](../../../ravintio-zero/skills/ravintio-plan/SKILL.md)
**Feature:** 0000380-test-helpers-and-rule-anchors
**Component:** ravintio-zero
**Date:** 2026-11-07

## Context

Tests pin whole sentences and section positions. Moving or rewording a rule broke 10 to 29 suites in earlier features.

## Decision

A rule carries `<!-- rule: {id} -->` on its own line. The rule text is the paragraph or list item that follows, up to a blank line or the next anchor or heading. `rule_text` searches `skills/`, `standards/`, and `templates/`. `orch_section` searches `SKILL.md`, the orchestrator references, and the roadmap standards. Both live in `tests/helpers/assert.sh`. `SKILL.md` carries no anchors because it has 369 bytes under its cap.

## Alternatives Considered

| Alternative | Pros | Cons | Why Rejected |
|-------------|------|------|-------------|
| Anchor as a heading id | Visible in rendered Markdown | Rules are not all headings | Does not fit list items |
| A separate rules index file | No edits in skills | Drifts from the rule text | Defeats a stable pointer |

## Affected Components

| Component | Impact |
|-----------|--------|
| ravintio-zero | Comments appear in references and standards. Tests gain helpers. |

## Consequences

**Positive:**
- A rule moves or changes wording without breaking its tests.

**Negative:**
- Maintainers keep anchors when they edit a rule.

**Risks:**
- A rule rewritten without its anchor fails its test, which names the anchor.

## Related ADRs

- ADR-0267 - related-to

## Supersedes

- None

## Superseded By

- None
