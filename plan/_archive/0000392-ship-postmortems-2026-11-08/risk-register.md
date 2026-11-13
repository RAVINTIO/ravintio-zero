---
title: "Risk Register - Ship postmortems"
summary: "Risks of the postmortem check and the queue wait."
status: "active"
version: "0.1.0"
---
# Risk Register - Ship postmortems

**Skill:** [plan](../../ravintio-zero/skills/ravintio-plan/SKILL.md)
**Feature:** 0000392-ship-postmortems
**Version:** 0.60.0
**Overall Risk Level:** low

## Risks

| ID | Category | Description | Likelihood | Impact | Mitigation | Status |
|----|----------|------------|------------|--------|-----------|--------|
| R-001 | operational | The poll sees an empty check list before GitHub registers the new run | medium | medium | An empty list counts as pending until the timeout | open |
| R-002 | operational | Ship now blocks runs that have many reworks | medium | low | One record may name several requirements | open |
| R-003 | technical | A stub `gh` test passes while real `gh` output differs | low | medium | The stub copies the documented `--json name,bucket` shape | open |

## Assumptions Logged as Risks

| ID | Assumption | Impact if Wrong | Status |
|----|-----------|----------------|--------|
| A-001 | `gh pr checks --json name,bucket` exists in the installed `gh` | The queue stops with the `gh` error | open |
| A-002 | A postmortem line names a rework requirement by its `REQ-nnn` id | The check reports an uncovered requirement | open |
