---
title: "Risk Register - Parallel steps reserve distinct ids"
summary: "Technical and operational risks with their mitigations."
status: "active"
version: "0.1.0"
---
# Risk Register - Parallel steps reserve distinct ids

**Skill:** [plan](../skills/ravintio-plan/SKILL.md)
**Feature:** 0000485-adr-number-collision
**Version:** 0.92.0
**Overall Risk Level:** low

## Risks

| ID | Category | Description | Likelihood | Impact | Mitigation | Status |
|----|----------|------------|------------|--------|-----------|--------|
| R-001 | technical | A reference to the old number sits in a file the PR did not change, so it goes stale. | medium | low | The module rewrites only files the PR changed and prints each. The retrospective checks the rest. | open |
| R-002 | technical | The module renames a number in prose that does not mean the ADR, such as a version. | low | low | The pattern matches `ADR-{NNNN}` and `{NNNN}-{slug}` only, with a digit boundary. | open |
| R-003 | operational | The queue pushes a renumber commit and CI fails on the new head. | low | medium | The existing CI wait runs after the commit. A failure stops the queue as before. | open |

## Assumptions Logged as Risks

| ID | Assumption | Impact if Wrong | Status |
|----|-----------|----------------|--------|
| A-001 | A PR's references to its own colliding number sit in files the PR changed. | A stale reference stays. | open |
| A-002 | A PR cannot cite a base ADR that the base added after the PR branched. | The module renumbers a reference it should keep. | open |
