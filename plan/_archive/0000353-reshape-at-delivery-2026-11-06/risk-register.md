---
title: "Risk Register - Reshape at delivery"
summary: "Technical and operational risks with their mitigations."
status: "active"
version: "0.1.0"
---
# Risk Register - Reshape at delivery

**Skill:** [plan](../../ravintio-zero/skills/ravintio-plan/SKILL.md)
**Feature:** 0000353-reshape-at-delivery
**Version:** 0.51.0
**Overall Risk Level:** medium

## Risks

| ID | Category | Description | Likelihood | Impact | Mitigation | Status |
|----|----------|------------|------------|--------|-----------|--------|
| R-001 | technical | A replay conflicts on a file that an assigned admin commit and a step both change. | medium | low | The script exits 1, names the commit, and writes nothing. The coordinator stops for the human. | open |
| R-002 | technical | A step tag points at a tree that the step never tested, because unassigned admin is missing from it. | high | low | The final tree is identical and CI runs on it. The delivery rules state the trade-off. | accepted |
| R-003 | security | A branch, tag, or hash from the chart or the caller carries git option text. | low | medium | The script checks each name against a pattern and passes every value as an argument after `--` where git allows it. | open |
| R-004 | operational | `--push` deletes a remote tag, then the push of the new tag fails. | low | medium | The script pushes the branch first, checks the new tag locally, and prints the exact remaining commands on failure. | open |
| R-005 | technical | `git merge-tree --write-tree` is missing from an old git. | low | low | The script checks `git merge-tree --write-tree` support first and exits 1 with the needed version. | open |

## Assumptions Logged as Risks

| ID | Assumption | Impact if Wrong | Status |
|----|-----------|----------------|--------|
| A-001 | Each merged step has a tag `v{Version}` at its squash commit. | The script cannot find the step commit and exits 1. | open |
| A-002 | An old step subject ends with ` (#{n})`. | The script exits 1 and names the commit. | open |
