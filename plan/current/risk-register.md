---
title: "Risk Register - Backlog triage"
summary: "Technical, operational, and security risks with their mitigations."
status: "active"
version: "0.1.0"
---
# Risk Register - Backlog triage

**Skill:** [plan](../skills/ravintio-plan/SKILL.md)
**Feature:** 0000321-backlog-triage
**Version:** 0.47.0
**Overall Risk Level:** low

## Risks

| ID | Category | Description | Likelihood | Impact | Mitigation | Status |
|----|----------|------------|------------|--------|-----------|--------|
| R-001 | operational | A branch adds or removes an entry without regenerating the index, so CI fails | medium | low | The CI message names the command that regenerates it | open |
| R-002 | security | Crafted entry text injects instructions or control characters into the index | low | medium | The script reads frontmatter and the date line only, prints no body text, and rejects values outside the allowed set | open |
| R-003 | operational | Most entries pass the 5-day review age, so the review lists nearly all of them | high | low | The human chose the age on 2026-10-31. The review informs and never blocks | accepted |
| R-004 | technical | The migration helper edits frontmatter wrongly in an entry with an unusual layout | low | medium | The helper edits only the first frontmatter block, skips an entry that has none, and the test covers both | open |
| R-005 | operational | Entries queued during the initiative run lack both fields | high | low | The script reads missing fields as defaults. I-E Delivery adds them | accepted |

## Assumptions Logged as Risks

| ID | Assumption | Impact if Wrong | Status |
|----|-----------|----------------|--------|
| A-001 | Every entry has a `**Date filed:**` line | The entry shows as undated | open |
