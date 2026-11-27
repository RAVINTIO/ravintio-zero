---
title: "Risk Register - Log a non-TDD unit with a class"
summary: "Technical risks and assumptions for the docs class."
status: "active"
version: "0.1.0"
---
# Risk Register - Log a non-TDD unit with a class

**Skill:** [plan](../skills/ravintio-plan/SKILL.md)
**Feature:** 0000580-log-non-tdd-units
**Version:** 0.151.0
**Overall Risk Level:** low

## Risks

| ID | Category | Description | Likelihood | Impact | Mitigation | Status |
|----|----------|------------|------------|--------|-----------|--------|
| R-001 | technical | A test pins the class list and fails when `docs` joins it. | medium | low | The scan found `test-0000386-req-002`. It checks rule words, so it still passes. The unit reruns it. | open |
| R-002 | technical | The `src/ravintio-zero/` and `ravintio-zero/` trees drift. | low | medium | Each unit edits both trees. `test-0000493-req-004` and a final diff catch drift. | open |
| R-003 | technical | A stricter check 7 fails a log that lists a `docs` unit with no markers. | low | medium | No archived log uses class `docs`. The unit tests an older line. | open |

## Assumptions Logged as Risks

| ID | Assumption | Impact if Wrong | Status |
|----|-----------|----------------|--------|
| A-001 | The `docs` tier row matches the `content` row. | A docs unit runs on the wrong model tier. | open |
