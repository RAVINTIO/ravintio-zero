---
title: "Risk Register - CI duration metric"
summary: "Technical, operational, and security risks with their mitigations."
status: "active"
version: "0.1.0"
---
# Risk Register - CI duration metric

**Skill:** [plan](../skills/ravintio-plan/SKILL.md)
**Feature:** 0000472-ci-duration-metric
**Version:** 0.87.0
**Overall Risk Level:** low

## Risks

| ID | Category | Description | Likelihood | Impact | Mitigation | Status |
|----|----------|------------|------------|--------|-----------|--------|
| R-001 | technical | Existing suites pass a custom standards file with no `ci-duration-seconds` key, so the script exits 1 | medium | medium | P2 greps the suites for `--standard` fixtures and adds the key to each | open |
| R-002 | technical | The skill-text total passes its 1720-line cap | low | low | The ship skill gains about 3 lines and the total stands at 1682 | open |
| R-003 | operational | `gh run view` fails or has no run to read | low | low | The ship skill writes no marker, and the script reports 0 with `ok` | open |

## Assumptions Logged as Risks

| ID | Assumption | Impact if Wrong | Status |
|----|-----------|----------------|--------|
| A-001 | The ship skill can read a CI run's start and end with `gh` | The metric skips the run | open |
| A-002 | The target is 420 seconds | One table cell changes | open |
