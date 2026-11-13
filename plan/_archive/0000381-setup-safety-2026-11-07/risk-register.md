---
title: "Risk Register - Setup safety"
summary: "Risks of the four setup fixes."
status: "active"
version: "0.1.0"
---
# Risk Register - Setup safety

**Skill:** [plan](../../ravintio-zero/skills/ravintio-plan/SKILL.md)
**Feature:** 0000381-setup-safety
**Version:** 0.60.0
**Overall Risk Level:** medium

## Risks

| ID | Category | Description | Likelihood | Impact | Mitigation | Status |
|----|----------|------------|------------|--------|-----------|--------|
| R-001 | security | The confinement check misses a symlink or `..` path | low | high | Resolve the physical path and compare it to the skills directory. Test absolute, `..`, and symlink lines. | open |
| R-002 | operational | Setup treats the pack's own `CLAUDE.md` as a developer file and moves it | medium | medium | Compare with the template and the regenerated marker. Move content only when it differs and no pack marker exists. | open |
| R-003 | technical | `setup.sh` and `setup.ps1` drift apart | medium | medium | Pair every test. Run the PowerShell suites in CI. | open |
| R-004 | operational | Pruning removes a developer command named like a retired one | low | medium | Prune the three names only when the command manifest or migration 0008 lists them as pack-shipped, and ask in the migration. | open |

## Assumptions Logged as Risks

| ID | Assumption | Impact if Wrong | Status |
|----|-----------|----------------|--------|
| A-001 | A legacy manifest holds absolute paths | A legacy line is skipped and its folder stays until the next prune by name | open |
| A-002 | `pwsh` is absent on this machine, so PowerShell suites skip locally | PowerShell defects show first in CI | open |
