---
title: "Risk Register - Test impact scan covers skill-wide grep pins"
summary: "Technical risks with their mitigations."
status: "active"
version: "0.1.0"
---
# Risk Register - Test impact scan covers skill-wide grep pins

**Skill:** [plan](../skills/ravintio-plan/SKILL.md)
**Feature:** 0000571-scan-cause-skill-wide-grep-pins
**Version:** 0.135.0
**Overall Risk Level:** low

## Risks

| ID | Category | Description | Likelihood | Impact | Mitigation | Status |
|----|----------|------------|------------|--------|-----------|--------|
| R-001 | technical | A size cap suite fails when the sentence lands. | low | low | The sentence extends an existing line, and the full suite checks the caps. | open |
| R-002 | technical | The two pack trees drift apart. | medium | medium | Run `sync-installed.mjs` and its `--check` flag before commit. | open |
| R-003 | technical | The sentence trips the wording allowlist test. | low | low | Run `test-0000042-req-010` before commit. | open |

## Assumptions Logged as Risks

| ID | Assumption | Impact if Wrong | Status |
|----|-----------|----------------|--------|
| A-001 | The sentence extends the existing cause line. | Five suites need a higher scan cap. | open |
