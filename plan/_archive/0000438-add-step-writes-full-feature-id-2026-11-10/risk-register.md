---
title: "Risk Register - Add-step writes the full feature id"
summary: "Technical risks with their mitigations."
status: "active"
version: "0.1.0"
---
# Risk Register - Add-step writes the full feature id

**Skill:** [plan](../skills/ravintio-plan/SKILL.md)
**Feature:** 0000438-add-step-writes-full-feature-id
**Version:** 0.77.2
**Overall Risk Level:** low

## Risks

| ID | Category | Description | Likelihood | Impact | Mitigation | Status |
|----|----------|------------|------------|--------|-----------|--------|
| R-001 | technical | A later edit changes the driver pattern and the exported pattern drifts apart | medium | low | AC-3 compares the two sources and fails the suite | open |
| R-002 | technical | The test reads the `FEATURE` line from `initiative-run.mjs` by regex, so a rename of the constant breaks it | low | low | The test names the constant in its failure message | open |

## Assumptions Logged as Risks

| ID | Assumption | Impact if Wrong | Status |
|----|-----------|----------------|--------|
| A-001 | The helper slug is a valid feature slug | The helper check on the full id fails and the helper exits 1 before it writes | open |
