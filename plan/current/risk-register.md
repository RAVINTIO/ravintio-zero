---
title: "Risk Register - Steps run to the end"
summary: "Technical and operational risks with their mitigations."
status: "active"
version: "0.1.0"
---
# Risk Register - Steps run to the end

**Skill:** [plan](../../ravintio-zero/skills/ravintio-plan/SKILL.md)
**Feature:** 0000354-steps-run-to-the-end
**Version:** 0.52.0
**Overall Risk Level:** low

## Risks

| ID | Category | Description | Likelihood | Impact | Mitigation | Status |
|----|----------|------------|------------|--------|-----------|--------|
| R-001 | technical | A resumed session repeats finished work. | low | low | The continue prompt tells it to read the build log first. The cap ends a loop at two resumes. | open |
| R-002 | security | A session id from the stream carries option text or shell syntax. | low | medium | The driver checks the id against a pattern and passes it as one array argument. | open |
| R-003 | technical | The setup compare treats a hand-edited record as different. | low | low | Setup rewrites the record, as it did before. | accepted |
| R-004 | operational | The watcher names the wrong step when an old step log has the highest number. | low | low | The watcher takes the newest step log by modified time and ignores attempt logs. | open |
| R-005 | operational | A step with `Step CI fixes: allowed` pushes a fix that widens scope. | low | medium | The rule limits the fix to the step's own scope. P3 reviews the PR. | open |

## Assumptions Logged as Risks

| ID | Assumption | Impact if Wrong | Status |
|----|-----------|----------------|--------|
| A-001 | Stream events carry `session_id`. | The driver cannot resume. It prints `Blocked:` and exits 1. | open |
| A-002 | `claude -p --resume {session} "{prompt}"` continues the session. | The resume exits 0 unmerged and the cap ends it with `Blocked:`. | open |
