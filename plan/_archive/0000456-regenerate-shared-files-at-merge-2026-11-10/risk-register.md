---
title: "Risk Register - Regenerate shared files at merge"
summary: "Technical, operational, and security risks with their mitigations."
status: "active"
version: "0.1.0"
---
# Risk Register - Regenerate shared files at merge

**Skill:** [plan](../skills/ravintio-plan/SKILL.md)
**Feature:** 0000456-regenerate-shared-files-at-merge
**Version:** 0.81.0
**Overall Risk Level:** low

## Risks

| ID | Category | Description | Likelihood | Impact | Mitigation | Status |
|----|----------|------------|------------|--------|-----------|--------|
| R-001 | technical | A row union keeps a duplicate or loses an edit to an existing row | low | medium | Drop exact duplicates. Abort when both sides change the same existing row. | open |
| R-002 | technical | A prose edit in `architecture-overview.md` conflicts with another edit | medium | medium | The resolver acts only on `Last updated:` lines. It aborts on any other hunk. | open |
| R-003 | operational | The step edits `merge-queue.mjs`, so the running driver uses old code until a restart | high | low | The driver prints its Restart stop after the merge. | open |

## Assumptions Logged as Risks

| ID | Assumption | Impact if Wrong | Status |
|----|-----------|----------------|--------|
| A-001 | Conflicts on the listed files are mechanical | A wrong resolution merges silently. The resolver aborts on hunks it cannot read. | open |
