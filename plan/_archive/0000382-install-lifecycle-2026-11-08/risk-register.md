---
title: "Risk Register - Install lifecycle"
summary: "Risks of the install lifecycle change."
status: "active"
version: "0.1.0"
---
# Risk Register - Install lifecycle

**Skill:** [plan](../../ravintio-zero/skills/ravintio-plan/SKILL.md)
**Feature:** 0000382-install-lifecycle
**Version:** 0.61.0
**Overall Risk Level:** medium

## Risks

| ID | Category | Description | Likelihood | Impact | Mitigation | Status |
|----|----------|------------|------------|--------|-----------|--------|
| R-001 | technical | The clean-tree check breaks about 90 suites that run setup in a workspace | high | medium | A shared helper commits the pack in each workspace. Run the full suite before the P2 close. | open |
| R-002 | security | Uninstall removes a developer's own settings entry or file | low | high | Remove only manifest paths and hook commands that point at `.claude/hooks/enforcement/`. Test a developer entry. | open |
| R-003 | security | Uninstall removes a guard during a driver run | low | high | Refuse while `plan/.orchestrator-active` or `plan/.initiative-runner.lock` exists. | open |
| R-004 | technical | `setup.sh` and `setup.ps1` drift apart | medium | medium | Pair every test and run `pwsh` locally. | open |
| R-005 | operational | The update commit trips a repo hook | medium | low | Report the hook output and stop. Leave the copied files in place. | open |

## Assumptions Logged as Risks

| ID | Assumption | Impact if Wrong | Status |
|----|-----------|----------------|--------|
| A-001 | A test workspace can commit its pack | A suite fails and gets the helper | open |
| A-002 | The manifest lists every setup write | Uninstall leaves a file and prints it | open |
