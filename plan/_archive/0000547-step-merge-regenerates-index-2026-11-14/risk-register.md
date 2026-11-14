---
title: "Risk Register - Step base merge regenerates the backlog index"
summary: "Technical and operational risks with their mitigations."
status: "active"
version: "0.1.0"
---
# Risk Register - Step base merge regenerates the backlog index

**Skill:** [plan](../skills/ravintio-plan/SKILL.md)
**Feature:** 0000547-step-merge-regenerates-index
**Version:** 0.115.0
**Overall Risk Level:** low

## Risks

| ID | Category | Description | Likelihood | Impact | Mitigation | Status |
|----|----------|------------|------------|--------|-----------|--------|
| R-001 | technical | A test that pins I-D Advance text fails after the edit. | low | low | Keep every pinned phrase and add the rule as a new block. | open |
| R-002 | technical | The two pack trees drift apart. | medium | low | Edit `src/ravintio-zero/` and mirror to `ravintio-zero/`. `sync-installed.mjs --check` verifies it. | open |

## Assumptions Logged as Risks

| ID | Assumption | Impact if Wrong | Status |
|----|-----------|----------------|--------|
| A-001 | A step session reads I-D Advance before it merges the base branch by hand. | The step still fails CI once. | open |
