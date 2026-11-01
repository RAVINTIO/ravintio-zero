---
title: "Risk Register - isolated test state"
summary: "Risks for the test isolation work."
status: "active"
version: "0.41.2"
---
# Risk Register - isolated test state

**Skill:** [plan](../skills/ravintio-plan/SKILL.md)
**Feature:** 0000315-isolated-test-state
**Version:** 0.41.2
**Overall Risk Level:** low

## Risks

| ID | Category | Description | Likelihood | Impact | Mitigation | Status |
|----|----------|------------|------------|--------|-----------|--------|
| R-001 | technical | A suite relied on an inherited `RAVINTIO_*` variable and now fails. | medium | low | P2 runs the full suite and sets the variable in that suite. | open |
| R-002 | technical | The tree check fails on a file a suite leaves behind. | medium | low | The check names the path, and P2 fixes the suite. | open |
| R-003 | operational | The tree check reports a change a developer makes during the run. | low | low | The check compares two snapshots taken seconds apart. | accepted |

## Assumptions Logged as Risks

| ID | Assumption | Impact if Wrong | Status |
|----|-----------|----------------|--------|
| A-001 | Few suites need a `RAVINTIO_*` variable beyond those they set. | U1 sets the variable in each failing suite. | open |
