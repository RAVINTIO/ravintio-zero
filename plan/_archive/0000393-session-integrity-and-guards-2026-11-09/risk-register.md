---
title: "Risk Register - Session integrity and guards"
summary: "Technical, operational, and security risks with their mitigations."
status: "active"
version: "0.1.0"
---
# Risk Register - Session integrity and guards

**Skill:** [plan](../../ravintio-zero/skills/ravintio-plan/SKILL.md)
**Feature:** 0000393-session-integrity-and-guards
**Version:** 0.65.0
**Overall Risk Level:** medium

## Risks

| ID | Category | Description | Likelihood | Impact | Mitigation | Status |
|----|----------|------------|------------|--------|-----------|--------|
| R-001 | technical | The shell parser reads heredoc body text as a redirect and blocks a valid write | medium | medium | Strip heredoc bodies and quoted text before scanning, and test a body with a leading `>` | open |
| R-002 | security | A shell write built from a variable passes | high | low | It passes today. Documented limit, and CI still checks tracked files | accepted |
| R-003 | operational | Wiring gate-write on Bash breaks tests that count hook entries | medium | low | Run the full suite and update pins in the same unit | open |
| R-004 | technical | `sed -i ''` on macOS makes the script look like a file | medium | low | Skip an empty word after a bare `-i` | open |

## Assumptions Logged as Risks

| ID | Assumption | Impact if Wrong | Status |
|----|-----------|----------------|--------|
| A-001 | Claude Code sends `tool_input.command` for Bash | The shell check never runs | open |
