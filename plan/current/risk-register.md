---
title: "Risk Register - Check every hook after setup"
summary: "Technical, operational, and security risks with their mitigations."
status: "draft"
version: "0.1.0"
---
# Risk Register - Check every hook after setup

**Skill:** [plan](../skills/ravintio-plan/SKILL.md)
**Feature:** 0000507-hook-check-after-setup
**Version:** 0.110.0
**Overall Risk Level:** low

## Risks

| ID | Category | Description | Likelihood | Impact | Mitigation | Status |
|----|----------|------------|------------|--------|-----------|--------|
| R-001 | technical | A sample input makes a hook write to the repo | low | medium | Run each hook in a temporary working directory and test that the repo stays unchanged | open |
| R-002 | operational | A false failure stops the driver after a good setup | medium | high | Pin the pass codes 0 and 2 in the test and print the hook, event, and exit code | open |
| R-003 | security | The script runs a command from `.claude/settings.json` that someone edited | low | high | Run only commands already in the file, which the human trusts at setup | open |
| R-004 | technical | A new hook has no sample, so the check skips it | medium | medium | Fail the check for a hook event or matcher with no sample | open |

## Assumptions Logged as Risks

| ID | Assumption | Impact if Wrong | Status |
|----|-----------|----------------|--------|
| A-001 | Every hook command accepts JSON on stdin | The check reports a false failure for that hook | open |
| A-002 | The driver can find `hook-check.mjs` in the root after setup | The driver stops with a missing-script error | open |
