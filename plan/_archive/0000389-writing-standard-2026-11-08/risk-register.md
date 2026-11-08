---
title: "Risk Register - Writing standard"
summary: "Technical and operational risks with their mitigations."
status: "active"
version: "0.1.0"
---
# Risk Register - Writing standard

**Skill:** [plan](../../ravintio-zero/skills/ravintio-plan/SKILL.md)
**Feature:** 0000389-writing-standard
**Version:** 0.61.0
**Overall Risk Level:** low

## Risks

| ID | Category | Description | Likelihood | Impact | Mitigation | Status |
|----|----------|------------|------------|--------|-----------|--------|
| R-001 | technical | Tests that pin `DD MMM YYYY` or the semicolon suggestion fail after the edit | medium | low | Update each pin in the same step and log a `Rework:` line | open |
| R-002 | technical | `setup.sh` and `setup.ps1` write different output | medium | medium | One test per shell checks the same cases, and the generator output is shared | open |
| R-003 | operational | The installed output style overrides a user-level style the developer chose | low | medium | `--no-writing-style`, and setup leaves a project `outputStyle` already set | accepted |
| R-004 | technical | A settings write corrupts `settings.json` | low | high | Reuse the atomic writer and the invalid JSON stop | open |

## Assumptions Logged as Risks

| ID | Assumption | Impact if Wrong | Status |
|----|-----------|----------------|--------|
| A-001 | Claude Code loads `.claude/output-styles/ravintio-writing.md` and reads `outputStyle` by name from project settings | The style installs and the session ignores it. The Claude Code docs confirm both. | open |
| A-002 | Node exists wherever setup runs for these tools | Setup skips the writing outputs with a warning | open |
