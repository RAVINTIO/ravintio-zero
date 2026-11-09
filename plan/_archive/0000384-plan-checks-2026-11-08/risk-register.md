---
title: "Risk Register - Plan checks"
summary: "Technical and operational risks with their mitigations."
status: "active"
version: "0.1.0"
---
# Risk Register - Plan checks

**Skill:** [plan](../skills/ravintio-plan/SKILL.md)
**Feature:** 0000384-plan-checks
**Version:** 0.63.0
**Overall Risk Level:** medium

## Risks

| ID | Category | Description | Likelihood | Impact | Mitigation | Status |
|----|----------|------------|------------|--------|-----------|--------|
| R-001 | technical | Migration 0009 renumbers 164 or more ADRs and rewrites references, and a wrong rewrite corrupts a supersession chain | medium | high | Dry-run flag, idempotence suite, reference check over the result, one commit per phase | open |
| R-002 | technical | Check 10 fails existing plan fixtures that hold no docs unit | high | low | Update the fixtures in the same unit and log a Rework line | open |
| R-003 | technical | Tests pin text in the plan, ship, and ADR template files that this step edits | high | low | Update each pin in the same unit | open |
| R-004 | security | `human-settings-check.mjs` runs `gh api` with text from a chart row | low | medium | GET only, endpoint allowlist, argument array with no shell | open |
| R-005 | operational | The restore from git history misses a feature whose ADR was never committed | medium | low | The migration lists each feature it could not restore and continues | open |

## Assumptions Logged as Risks

| ID | Assumption | Impact if Wrong | Status |
|----|-----------|----------------|--------|
| A-001 | Git history holds the ADRs of features 0000001 to 0000029 | The migration skips the missing features and lists them | open |
| A-002 | Four digits is wide enough for the ADR number | File names stop sorting past 9999 ADRs | open |
