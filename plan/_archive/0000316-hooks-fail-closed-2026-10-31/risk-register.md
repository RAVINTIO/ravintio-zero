---
title: "Risk Register - hooks fail closed"
summary: "Risks for the hook wiring work."
status: "active"
version: "0.42.0"
---
# Risk Register - hooks fail closed

**Skill:** [plan](../skills/ravintio-plan/SKILL.md)
**Feature:** 0000316-hooks-fail-closed
**Version:** 0.42.0
**Overall Risk Level:** medium

## Risks

| ID | Category | Description | Likelihood | Impact | Mitigation | Status |
|----|----------|------------|------------|--------|-----------|--------|
| R-001 | security | A launcher bug lets a blocked call pass. | low | high | Tests run each guard through the launcher on every blocking case it has today. | open |
| R-002 | operational | A guard crash now blocks work. | low | medium | The message names the script and the exit code. | open |
| R-003 | security | The launcher is missing, so its command exits 1 and the guard allows. | low | high | Setup copies it with the hooks, and the setup rerun check runs every hook. The build report records the gap. | accepted |
| R-004 | technical | Windows quoting of `${CLAUDE_PROJECT_DIR}` differs. | medium | medium | `setup.ps1` writes the same command, and CI runs the PowerShell tests. | open |

## Assumptions Logged as Risks

| ID | Assumption | Impact if Wrong | Status |
|----|-----------|----------------|--------|
| A-001 | Claude Code substitutes `${CLAUDE_PROJECT_DIR}` in the command string. | The setup rerun check finds a hook that does not run, and the initiative stops. | open |
