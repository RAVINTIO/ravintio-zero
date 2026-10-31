---
title: "Risk Register - step logs stay in place"
summary: "Risks for the step log fix."
status: "active"
version: "0.41.1"
---
# Risk Register - step logs stay in place

**Skill:** [plan](../skills/ravintio-plan/SKILL.md)
**Feature:** 0000314-step-logs-stay-in-place
**Version:** 0.41.1
**Overall Risk Level:** low

## Risks

| ID | Category | Description | Likelihood | Impact | Mitigation | Status |
|----|----------|------------|------------|--------|-----------|--------|
| R-001 | technical | Skipping `plan/.initiative-logs` hides a real stale cite. | low | medium | The skip names that folder only, and a planted-cite test proves a tracked skill still fails. | open |
| R-002 | technical | Another suite also fails on a populated step log. | medium | low | P2 runs the full suite with a populated log and widens the fix to that suite. | open |
| R-003 | operational | The skill rule reaches installed copies only after setup. | high | low | The initiative plans a `Setup:` stop after this step. | accepted |

## Assumptions Logged as Risks

| ID | Assumption | Impact if Wrong | Status |
|----|-----------|----------------|--------|
| A-001 | Only the phase guard reads step logs as a scan target. | Another suite still fails. | open |
