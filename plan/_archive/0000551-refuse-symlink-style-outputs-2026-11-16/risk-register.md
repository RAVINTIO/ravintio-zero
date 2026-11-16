---
title: "Risk Register - Refuse a symlink at the writing style output paths"
summary: "Technical and security risks with their mitigations."
status: "active"
version: "0.1.0"
---
# Risk Register - Refuse a symlink at the writing style output paths

**Skill:** [plan](../skills/ravintio-plan/SKILL.md)
**Feature:** 0000551-refuse-symlink-style-outputs
**Version:** 0.137.0
**Overall Risk Level:** low

## Risks

| ID | Category | Description | Likelihood | Impact | Mitigation | Status |
|----|----------|------------|------------|--------|-----------|--------|
| R-001 | security | The boot file write still goes through a linked `AGENTS.md`. | medium | medium | Deferred and named in scope. The writing block never reaches the target. | accepted |
| R-002 | technical | The PowerShell test cannot run on the local macOS host without `pwsh`. | medium | low | CI runs the Windows job. The test skips with a note when `pwsh` is absent. | open |

## Assumptions Logged as Risks

| ID | Assumption | Impact if Wrong | Status |
|----|-----------|----------------|--------|
| A-001 | A broken link counts as a link. | Setup skips a write that could succeed. | open |
