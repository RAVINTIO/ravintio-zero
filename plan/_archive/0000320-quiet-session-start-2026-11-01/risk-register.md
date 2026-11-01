---
title: "Risk Register - Quiet session start"
summary: "Technical, operational, and security risks with their mitigations."
status: "active"
version: "0.1.0"
---
# Risk Register - Quiet session start

**Skill:** [plan](../skills/ravintio-plan/SKILL.md)
**Feature:** 0000320-quiet-session-start
**Version:** 0.46.0
**Overall Risk Level:** low

## Risks

| ID | Category | Description | Likelihood | Impact | Mitigation | Status |
|----|----------|------------|------------|--------|-----------|--------|
| R-001 | technical | A `Detect:` item misreads a path and reports a migration that does not apply | low | low | The migrator skips it and records `not applicable` | open |
| R-002 | operational | Once-per-session hides the reminder after compaction in the same session | medium | low | The entry accepts it. A new session id restores the instruction | accepted |
| R-003 | security | A crafted ledger or migration file injects text into hook output | low | medium | The script prints only ids that match `^\d{4}$` and never repo text | open |
| R-004 | operational | In this repo each release bumps the pack version, so `not applicable` rows go stale and the finding returns once per release | high | low | Each return is one recorded skip. Consumer repos update less often | accepted |

## Assumptions Logged as Risks

| ID | Assumption | Impact if Wrong | Status |
|----|-----------|----------------|--------|
| A-001 | The host passes `session_id` to `UserPromptSubmit` and `last_assistant_message` to Stop | The hooks fall back to today's behaviour or exit silently | open |
