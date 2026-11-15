---
title: "Risk Register - A step session finds an unfinished step"
summary: "Technical risks with their mitigations."
status: "active"
version: "0.1.0"
---
# Risk Register - A step session finds an unfinished step

**Skill:** [plan](../skills/ravintio-plan/SKILL.md)
**Feature:** 0000556-step-session-finds-unfinished-step
**Version:** 0.130.0
**Overall Risk Level:** low

## Risks

| ID | Category | Description | Likelihood | Impact | Mitigation | Status |
|----|----------|------------|------------|--------|-----------|--------|
| R-001 | technical | A test pins the output of the script and fails on the new line. | low | low | Run the full suite. Update the pin in the same step and log a `Rework:` line. | open |
| R-002 | operational | A branch name outside `feat/` or `hotfix/` prints no finding. | low | low | The driver cuts `feat/` branches. The finding stays silent otherwise. | open |

## Assumptions Logged as Risks

| ID | Assumption | Impact if Wrong | Status |
|----|-----------|----------------|--------|
| A-001 | The feature id is the branch name without its prefix. | The finding misses a step. | open |
