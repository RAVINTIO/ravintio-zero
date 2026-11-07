---
title: "Risk Register - Replies and questions"
summary: "Technical, operational, and security risks with their mitigations."
status: "draft"
version: "0.1.0"
---
# Risk Register - Replies and questions

**Skill:** [plan](../../ravintio-zero/skills/ravintio-plan/SKILL.md) (updated by any agent that identifies a new risk)
**Feature:** 0000388-replies-and-questions
**Version:** 0.1.0
**Overall Risk Level:** medium

> Every entry must be specific to this feature. Do not produce generic risks.

## Risks

| ID | Category | Description | Likelihood | Impact | Mitigation | Status |
|----|----------|------------|------------|--------|-----------|--------|
| R-001 | technical | About 30 tests grep `initiative-run.mjs` and `initiative-watch.mjs` output, and some match from line start. The time prefix breaks them. | high | low | Update each pin in U2 and log `Rework:` in the build log. | open |
| R-002 | technical | Prefix hook tests pin the old warning text or the old prefix handling. | high | low | Update the pins in U1 and log `Rework:`. | open |
| R-003 | technical | The orchestrator `SKILL.md` has 369 bytes of room under its 9000 byte cap. | medium | medium | Put rule text in `references/`. Edit `SKILL.md` only in U2 and only for the time mention. | open |
| R-004 | technical | `standard-boot.md` has 24 bytes of room under its 3600 byte boot cap. The time mention can break the cap. | high | medium | Cut words elsewhere in the section to pay for the time mention. Check with the cap test. | open |
| R-005 | technical | The initiative skill has 119 lines against a cap of fewer than 120. | high | medium | Edit lines in place. Put new rule text behind a pointer to a reference. | open |
| R-006 | security | The coordinator skip makes the prefix check weaker. A fail-closed hook must not widen. | low | low | The skip applies to the warn-only prefix hook alone. `merge-guard` and `gate-write` stay untouched. | accepted |
| R-007 | operational | A stale `plan/.initiative-runner.lock` keeps the coordinator check off after the driver ends. | medium | low | Only a warning goes missing and no turn blocks. The driver removes the lock on exit. | open |

## Assumptions Logged as Risks

Documented assumptions from the specification are logged here with likelihood: medium.

| ID | Assumption | Impact if Wrong | Status |
|----|-----------|----------------|--------|
| A-001 | A step session sets `RAVINTIO_INITIATIVE_STEP=1` and the coordinator does not. | The coordinator warning stays on. | open |
| A-002 | `plan/.initiative-runner.lock` marks that a step runs. | The skip misfires. | open |
