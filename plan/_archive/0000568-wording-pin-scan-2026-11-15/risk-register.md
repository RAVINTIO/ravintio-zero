---
title: "Risk Register - Scan for wording pins before a prose rewrite"
summary: "Technical risks with their mitigations."
status: "active"
version: "0.1.0"
---
# Risk Register - Scan for wording pins before a prose rewrite

**Skill:** [plan](../skills/ravintio-plan/SKILL.md)
**Feature:** 0000568-wording-pin-scan
**Version:** 0.129.0
**Overall Risk Level:** low

## Risks

| ID | Category | Description | Likelihood | Impact | Mitigation | Status |
|----|----------|------------|------------|--------|-----------|--------|
| R-001 | technical | A suite pins the cause text and fails when a cause changes. | low | low | Run the scan suites and update a pin in the same unit, with a `Rework:` line. | open |
| R-002 | technical | The two pack trees drift apart. | medium | medium | Run `sync-installed.mjs` and its `--check` flag before commit. | open |
| R-003 | technical | The scan grows past 20 lines. | low | medium | The scan holds 19 lines and the cause adds one. Steps 25 and 26 need their own plan for the cap. | open |

## Assumptions Logged as Risks

| ID | Assumption | Impact if Wrong | Status |
|----|-----------|----------------|--------|
| A-001 | The causes live in the reference file and not in `SKILL.md`. | None, because the test reads the scan text from both files. | open |
