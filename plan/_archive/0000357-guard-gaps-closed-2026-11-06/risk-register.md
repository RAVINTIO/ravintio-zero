---
title: "Risk Register - Guard gaps closed"
summary: "Technical, operational, and security risks with their mitigations."
status: "active"
version: "0.1.0"
---
# Risk Register - Guard gaps closed

**Skill:** [plan](../skills/ravintio-plan/SKILL.md)
**Feature:** 0000357-guard-gaps-closed
**Version:** 0.54.0
**Overall Risk Level:** medium

## Risks

| ID | Category | Description | Likelihood | Impact | Mitigation | Status |
|----|----------|------------|------------|--------|-----------|--------|
| R-001 | technical | The suffix changes command text that tests and hook filters match. | medium | low | The prefix stays the same. The suite run finds each pinned string. | open |
| R-002 | security | A form of forced add still passes the widened guard. | medium | medium | The CI ignored-file check stays as the backstop. Each form has a test. | open |
| R-003 | operational | The `$` rule blocks a harmless `git add "$f"`. | medium | low | The message tells the caller to name the path. | accepted |
| R-004 | technical | A hook shell that lacks `\|\|` fails to parse the command. | low | high | A test runs the wired command with `sh`. Claude Code on Windows uses Git Bash. | open |
| R-005 | operational | A consumer repo keeps its old `.gitignore` and gets no log rule. | high | low | Setup keeps an existing file by design. The reply-prefix hook still adds the rule to `.git/info/exclude`. | accepted |

## Assumptions Logged as Risks

| ID | Assumption | Impact if Wrong | Status |
|----|-----------|----------------|--------|
| A-001 | Claude Code runs hook commands through a POSIX shell. | The guards need a Node wrapper. | open |
| A-002 | The Codex PreToolUse model takes a second Bash group. | The step files a backlog entry and carries on. | open |
