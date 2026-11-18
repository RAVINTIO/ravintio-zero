---
title: "Risk Register - 0000576-phase-start-time-at-phase-start"
summary: "Risks and assumptions for check 10."
status: "active"
version: "0.1.0"
---
# Risk Register - 0000576-phase-start-time-at-phase-start

**Skill:** [plan](../skills/ravintio-plan/SKILL.md)
**Feature:** 0000576-phase-start-time-at-phase-start
**Version:** 0.143.0
**Overall Risk Level:** low

## Risks

| ID | Category | Description | Likelihood | Impact | Mitigation | Status |
|----|----------|------------|------------|--------|-----------|--------|
| R-001 | technical | Check 10 fails an older fixture log that sits in a git repo with phase artifacts | low | medium | The full suite runs at P2 and a failing suite gets a fixture fix | open |
| R-002 | technical | Archived runs rename artifact paths, so the first commit moves | low | low | Ship runs the check before the archive, so plan/current paths still apply | open |

## Assumptions Logged as Risks

| ID | Assumption | Impact if Wrong | Status |
|----|-----------|----------------|--------|
| A-001 | Each phase writes its artifacts under the listed paths | The check skips that phase and passes | open |
