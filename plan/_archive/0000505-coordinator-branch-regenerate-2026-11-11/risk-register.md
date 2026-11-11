---
title: "Risk Register - Coordinator branches regenerate shared files"
summary: "Technical and operational risks with their mitigations."
status: "active"
version: "0.96.0"
---
# Risk Register - Coordinator branches regenerate shared files

**Skill:** [plan](../../ravintio-zero/skills/ravintio-plan/SKILL.md)
**Feature:** 0000505-coordinator-branch-regenerate
**Version:** 0.96.0
**Overall Risk Level:** low

## Risks

| ID | Category | Description | Likelihood | Impact | Mitigation | Status |
|----|----------|------------|------------|--------|-----------|--------|
| R-001 | technical | A conflict outside the allowlist leaves a merge half done. | medium | low | The command runs `git merge --abort` and exits 1, so the branch stays as it was. | open |
| R-002 | operational | The coordinator runs the command with uncommitted work, and the merge mixes it in. | medium | medium | The command exits 1 on a dirty tree before it merges. | open |

## Assumptions Logged as Risks

| ID | Assumption | Impact if Wrong | Status |
|----|-----------|----------------|--------|
| A-001 | `shared-files.mjs` exports cover the resolve and regenerate steps. | The command needs new helpers. | open |
