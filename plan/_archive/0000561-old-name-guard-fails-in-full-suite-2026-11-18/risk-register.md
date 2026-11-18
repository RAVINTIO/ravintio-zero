---
title: "Risk Register - Old-name guard fails in the full suite"
summary: "Technical risks with their mitigations."
status: "active"
version: "0.1.0"
---
# Risk Register - Old-name guard fails in the full suite

**Skill:** [plan](../skills/ravintio-plan/SKILL.md)
**Feature:** 0000561-old-name-guard-fails-in-full-suite
**Version:** 0.144.0
**Overall Risk Level:** medium

## Risks

| ID | Category | Description | Likelihood | Impact | Mitigation | Status |
|----|----------|------------|------------|--------|-----------|--------|
| R-001 | technical | The failure does not reproduce on this machine. | medium | medium | Read the logs of steps 4, 30, 47, and 51, and test each cause by a scratch planted change. | open |
| R-002 | technical | A guard that reads `HEAD` misses an uncommitted old name. | medium | low | CI reads committed files, so the miss shows there. | open |
| R-003 | technical | The two pack trees drift apart. | medium | medium | Run `sync-installed.mjs` and its `--check` flag before commit. | open |

## Assumptions Logged as Risks

| ID | Assumption | Impact if Wrong | Status |
|----|-----------|----------------|--------|
| A-001 | An earlier suite changes the tree, or the guard races with the runner. | Reproduction finds another cause and the fix targets it. | open |
