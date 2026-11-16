---
title: "Risk Register - Plan lists the change shapes a diff reader must handle"
summary: "Technical risks with their mitigations."
status: "active"
version: "0.1.0"
---
# Risk Register - Plan lists the change shapes a diff reader must handle

**Skill:** [plan](../skills/ravintio-plan/SKILL.md)
**Feature:** 0000577-plan-lists-change-shapes
**Version:** 0.137.0
**Overall Risk Level:** low

## Risks

| ID | Category | Description | Likelihood | Impact | Mitigation | Status |
|----|----------|------------|------------|--------|-----------|--------|
| R-001 | technical | A size cap suite fails when the cause lands. | low | low | The merge frees one line, and the full suite checks the caps. | open |
| R-002 | technical | The two pack trees drift apart. | medium | medium | Run `sync-installed.mjs` and its `--check` flag before commit. | open |
| R-003 | technical | The new text trips the wording allowlist test. | low | low | Run `test-0000042-req-010` before commit. | open |

## Assumptions Logged as Risks

| ID | Assumption | Impact if Wrong | Status |
|----|-----------|----------------|--------|
| A-001 | The merged line keeps both cause names. | Suites that grep each name fail. | open |
