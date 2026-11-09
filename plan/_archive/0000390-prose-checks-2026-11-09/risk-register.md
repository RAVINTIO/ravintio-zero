---
title: "Risk Register - Prose checks"
summary: "Technical, operational, and security risks with their mitigations."
status: "active"
version: "0.1.0"
---
# Risk Register - Prose checks

**Skill:** [plan](../skills/ravintio-plan/SKILL.md) (updated by any agent that identifies a new risk)
**Feature:** 0000390-prose-checks
**Version:** 0.71.0
**Overall Risk Level:** low

> Every entry must be specific to this feature. Do not produce generic risks.

## Risks

| ID | Category | Description | Likelihood | Impact | Mitigation | Status |
|----|----------|------------|------------|--------|-----------|--------|
| R-001 | technical | The passive-voice heuristic flags a valid sentence and blocks a commit | high | low | The baseline absorbs old hits. A developer rewrites a new hit or uses `--no-verify` | accepted |
| R-002 | operational | Step 20 moves the pack source and the baseline keys no longer match | high | medium | The scope file defers it. The build report tells step 20 to rename the keys | open |
| R-003 | technical | `commit-msg` blocks a merge commit or a trailer line | low | medium | The message mode skips comment lines and trailers. A test covers a merge subject | open |
| R-004 | technical | `setup.sh` and `setup.ps1` register the Stop hook differently | medium | medium | The parity suites compare both registrations | open |
| R-005 | operational | A skill size cap fails on the edit pass text | medium | low | The edit pass text stays short and the test impact scan lists the cap tests | open |
| R-006 | security | A crafted Markdown file makes the sentence splitter run for a long time | low | low | The splitter uses no nested quantifiers and the script reads one file at a time | open |
| R-007 | technical | The hook reads a long reply and slows the Stop event | low | low | The hook caps the text it checks at 20000 characters and always exits 0 | open |

## Assumptions Logged as Risks

| ID | Assumption | Impact if Wrong | Status |
|----|-----------|----------------|--------|
| A-001 | The Stop payload carries `last_assistant_message` | The advisory hook stays silent. The hook falls back to the transcript | open |
| A-002 | `commit-msg` can run `node` on every developer machine | The prose check skips with a note and the other rules still run | open |
