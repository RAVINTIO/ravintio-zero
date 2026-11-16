---
title: "Risk Register - Two open entries share one backlog id"
summary: "Technical risks with their mitigations."
status: "active"
version: "0.1.0"
---
# Risk Register - Two open entries share one backlog id

**Skill:** [plan](../skills/ravintio-plan/SKILL.md)
**Feature:** 0000552-duplicate-backlog-ids
**Version:** 0.139.0
**Overall Risk Level:** low

## Risks

| ID | Category | Description | Likelihood | Impact | Mitigation | Status |
|----|----------|------------|------------|--------|-----------|--------|
| R-001 | operational | A duplicate in a PR that is not yet renumbered fails CI on the step PR. | medium | low | The merge queue renumbers after the base merge and the next push runs `--check` on unique ids. | open |
| R-002 | technical | The two pack trees drift apart. | medium | medium | Run `sync-installed.mjs` and its `--check` flag before commit. | open |
| R-003 | technical | An existing suite builds duplicate ids and then runs `--check`. | low | low | The full suite finds it, and the unit fixes the fixture. | open |

## Assumptions Logged as Risks

| ID | Assumption | Impact if Wrong | Status |
|----|-----------|----------------|--------|
| A-001 | The merge queue runs the generate mode before `renumberCollisions`. | The check could also cover the generate mode. | open |
