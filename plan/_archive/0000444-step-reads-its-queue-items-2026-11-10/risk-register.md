---
title: "Risk Register - steps read their queue items"
summary: "Technical, operational, and security risks with their mitigations."
status: "active"
version: "0.1.0"
---
# Risk Register - steps read their queue items

**Skill:** [plan](../skills/ravintio-plan/SKILL.md)
**Feature:** 0000444-step-reads-its-queue-items
**Version:** 0.87.0
**Overall Risk Level:** low

## Risks

| ID | Category | Description | Likelihood | Impact | Mitigation | Status |
|----|----------|------------|------------|--------|-----------|--------|
| R-001 | security | Item text reaches the start prompt and steers the session | low | medium | The driver prints only folder names that match `^[A-Za-z0-9._-]{1,80}$`. It never prints item content | open |
| R-002 | operational | The check fails a step whose item needs no commit | medium | low | A report line in the build log clears the item | open |
| R-003 | technical | A destination holds `{id}` and never matches a committed path | medium | low | The check turns `{id}` into seven digits before it matches | open |

## Assumptions Logged as Risks

| ID | Assumption | Impact if Wrong | Status |
|----|-----------|----------------|--------|
| A-001 | Every item holds `**Step:** {n}` and `**Destination:** {path}` in `item.md` | The helper skips the item and warns | open |
