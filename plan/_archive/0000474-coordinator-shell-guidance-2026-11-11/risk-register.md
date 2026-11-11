---
title: "Risk Register - Coordinator shell guidance"
summary: "Technical and operational risks with their mitigations."
status: "active"
version: "0.98.0"
---
# Risk Register - Coordinator shell guidance

**Skill:** [plan](../../ravintio-zero/skills/ravintio-plan/SKILL.md)
**Feature:** 0000474-coordinator-shell-guidance
**Version:** 0.98.0
**Overall Risk Level:** low

## Risks

| ID | Category | Description | Likelihood | Impact | Mitigation | Status |
|----|----------|------------|------------|--------|-----------|--------|
| R-001 | technical | The drain removes an item that names a step still running. | low | medium | The command takes one step number and removes only items whose `**Step:**` line holds it. It skips a symlink. | open |
| R-002 | security | A bulk-edit spec names a path outside the repository. | low | medium | The script rejects an absolute path, a `..` segment, and a symlink. | open |
| R-003 | operational | The initiative skill passes its line cap. | low | low | The skill gets a pointer of a few lines. The text lives in the roadmap standards. | open |

## Assumptions Logged as Risks

| ID | Assumption | Impact if Wrong | Status |
|----|-----------|----------------|--------|
| A-001 | `coordinator-pr-check.mjs` covers the overlap check. | The change adds a new script. | open |
