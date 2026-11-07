---
title: "Scope - Test helpers and rule anchors"
summary: "Boundaries of what step 4 delivers."
status: "active"
version: "0.1.0"
---
# Scope - Test helpers and rule anchors

**Skill:** [plan](../../ravintio-zero/skills/ravintio-plan/SKILL.md)
**Feature:** 0000380-test-helpers-and-rule-anchors
**Version:** 0.60.0

## In Scope

- `orch_section`, `rule_text`, `assert_rule`, and `with_timeout` helpers
- Anchors on orchestrator reference rules and roadmap standards rules
- Suites that extract orchestrator sections move onto the helpers
- Docs for the helpers in `testing-standards.md`, the tests README, and `component.yml`

## Out of Scope

- Anchors in `SKILL.md`, which has 369 bytes under its cap
- Regression copies under `tests/regression/`
- PowerShell suites

## Deferred

- Converting every other suite that pins whole sentences. A backlog entry records the remainder. Step 19 waits on none of it.
