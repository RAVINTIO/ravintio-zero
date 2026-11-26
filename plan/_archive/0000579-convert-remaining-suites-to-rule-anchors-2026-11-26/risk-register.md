---
title: "Risk Register - Convert remaining suites to rule anchors"
summary: "Technical risks with their mitigations."
status: "active"
version: "0.1.0"
---
# Risk Register - Convert remaining suites to rule anchors

**Skill:** [plan](../skills/ravintio-plan/SKILL.md)
**Feature:** 0000579-convert-remaining-suites-to-rule-anchors
**Version:** 0.149.0
**Overall Risk Level:** medium

## Risks

| ID | Category | Description | Likelihood | Impact | Mitigation | Status |
|----|----------|------------|------------|--------|-----------|--------|
| R-001 | technical | Parallel batches edit one markdown file and one overwrites the other. | medium | medium | Each batch inserts anchors with single-line edits, re-reads before each edit, and uses its own anchor id prefix. The full suite runs before P3. | open |
| R-002 | technical | An anchor changes a line that another suite freezes or compares. | medium | low | The batch runs the impacted suites after each file edit. It updates the pin and logs a `Rework:` line. | open |
| R-003 | technical | A key term spans a phrase that a reword changes. | medium | low | The probe rewords every anchored rule and reruns a sample. | open |
| R-004 | technical | The two pack trees drift apart. | medium | medium | Run `sync-installed.mjs` and its `--check` flag before each commit. | open |
| R-005 | technical | A suite loses coverage because a key term is too loose. | low | medium | Each key term set holds the terms that the old pin held, and a reviewer reads a sample. | open |

## Assumptions Logged as Risks

| ID | Assumption | Impact if Wrong | Status |
|----|-----------|----------------|--------|
| A-001 | Anchors add no sentences and the prose check stays at its baseline. | The step trims text. | open |
| A-002 | About half of the 206 scanned suites pin prose. | The ledger records the real count. | open |
