---
title: "Risk Register - Scan new pack files for the wording allowlist"
summary: "Technical risks with their mitigations."
status: "active"
version: "0.1.0"
---
# Risk Register - Scan new pack files for the wording allowlist

**Skill:** [plan](../skills/ravintio-plan/SKILL.md)
**Feature:** 0000569-scan-new-pack-files-for-wording-allowlist
**Version:** 0.131.0
**Overall Risk Level:** low

## Risks

| ID | Category | Description | Likelihood | Impact | Mitigation | Status |
|----|----------|------------|------------|--------|-----------|--------|
| R-001 | technical | A suite pins the scan cap at 20 and fails when the cause lands. | high | low | Raise the cap to 21 in the three suites in the same unit, with a `Rework:` line. | open |
| R-002 | technical | The two pack trees drift apart. | medium | medium | Run `sync-installed.mjs` and its `--check` flag before commit. | open |
| R-003 | technical | The cause text trips the wording allowlist test. | low | low | Run `test-0000042-req-010` before commit. | open |

## Assumptions Logged as Risks

| ID | Assumption | Impact if Wrong | Status |
|----|-----------|----------------|--------|
| A-001 | The causes live in the reference file and not in `SKILL.md`. | None, because the test reads the scan text from both files. | open |
