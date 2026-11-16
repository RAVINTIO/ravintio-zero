---
title: "Risk Register - Start the baseline run before the P0 artifacts"
summary: "Technical risks with their mitigations."
status: "active"
version: "0.1.0"
---
# Risk Register - Start the baseline run before the P0 artifacts

**Skill:** [plan](../skills/ravintio-plan/SKILL.md)
**Feature:** 0000559-start-baseline-first
**Version:** 0.141.0
**Overall Risk Level:** low

## Risks

| ID | Category | Description | Likelihood | Impact | Mitigation | Status |
|----|----------|------------|------------|--------|-----------|--------|
| R-001 | technical | A cross-reference keeps an old number. | medium | low | The new suite checks the known citations. | open |
| R-002 | technical | The two pack trees drift apart. | medium | medium | Run `sync-installed.mjs` and its `--check` flag before commit. | open |
| R-003 | technical | The wait suite no longer finds the wait bullet. | low | low | Keep the bullet within four lines of the anchor. | open |

## Assumptions Logged as Risks

| ID | Assumption | Impact if Wrong | Status |
|----|-----------|----------------|--------|
| A-001 | Tests pin start actions by anchor, not by number. | A suite fails on the renumbering. | open |
