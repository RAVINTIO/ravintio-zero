---
title: "Risk Register - Step sessions meet pending migrations"
summary: "Technical risks with their mitigations."
status: "active"
version: "0.1.0"
---
# Risk Register - Step sessions meet pending migrations

**Skill:** [plan](../skills/ravintio-plan/SKILL.md)
**Feature:** 0000560-step-sessions-and-pending-migrations
**Version:** 0.141.0
**Overall Risk Level:** low

## Risks

| ID | Category | Description | Likelihood | Impact | Mitigation | Status |
|----|----------|------------|------------|--------|-----------|--------|
| R-001 | technical | The two pack trees drift apart. | medium | medium | Run `sync-installed.mjs` and its `--check` flag before commit. | open |
| R-002 | technical | The new suite trips a repo-wide style test. | low | low | Run `test-0000164-req-008` before commit. | open |

## Assumptions Logged as Risks

| ID | Assumption | Impact if Wrong | Status |
|----|-----------|----------------|--------|
| A-001 | 0000536 and 0000399 cover the rest of entry 0000403. | A step session still stops on a migration. | open |
