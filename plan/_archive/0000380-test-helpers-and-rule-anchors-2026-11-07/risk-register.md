---
title: "Risk Register - Test helpers and rule anchors"
summary: "Risks of the helper and anchor change."
status: "active"
version: "0.1.0"
---
# Risk Register - Test helpers and rule anchors

**Skill:** [plan](../../ravintio-zero/skills/ravintio-plan/SKILL.md)
**Feature:** 0000380-test-helpers-and-rule-anchors
**Version:** 0.60.0
**Overall Risk Level:** low

## Risks

| ID | Category | Description | Likelihood | Impact | Mitigation | Status |
|----|----------|------------|------------|--------|-----------|--------|
| R-001 | technical | A converted suite asserts fewer key terms than before | low | medium | Keep every term the old assertion held | open |
| R-002 | technical | A Bash 3.2 incompatibility in a helper breaks every suite | low | high | Run the full Bash suite on macOS before the PR | open |
| R-003 | operational | The timeout helper leaves an orphan process | low | low | The helper stops the child on expiry and the suite checks it | open |

## Assumptions Logged as Risks

| ID | Assumption | Impact if Wrong | Status |
|----|-----------|----------------|--------|
| A-001 | `perl` exists on macOS and Linux | The Bash watchdog path runs | open |
| A-002 | An anchored rule is the paragraph or item after the anchor | A rule split by a blank line loses its tail | open |
