---
title: "Risk Register - Plan lists every way a check can pass"
summary: "Technical risks with their mitigations."
status: "active"
version: "0.1.0"
---
# Risk Register - Plan lists every way a check can pass

**Skill:** [plan](../skills/ravintio-plan/SKILL.md)
**Feature:** 0000578-plan-lists-pass-signals
**Version:** 0.145.0
**Overall Risk Level:** low

## Risks

| ID | Category | Description | Likelihood | Impact | Mitigation | Status |
|----|----------|------------|------------|--------|-----------|--------|
| R-001 | technical | The combined skill text passes the 1720-line cap. | low | low | The section adds about 8 lines to 1690. The size suites check it. | open |
| R-002 | technical | The two pack trees drift apart. | medium | medium | Run `sync-installed.mjs` and its `--check` flag before commit. | open |
| R-003 | technical | The new text trips the wording allowlist test. | low | low | Run `test-0000042-req-010` before commit. | open |

## Assumptions Logged as Risks

| ID | Assumption | Impact if Wrong | Status |
|----|-----------|----------------|--------|
| A-001 | About 8 lines fit under the cap. | The step moves the text to a reference file. | open |
