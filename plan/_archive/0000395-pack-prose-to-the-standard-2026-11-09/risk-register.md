---
title: "Risk Register - Pack prose to the standard"
summary: "Technical and operational risks with their mitigations."
status: "active"
version: "0.1.0"
---
# Risk Register - Pack prose to the standard

**Skill:** [plan](../../ravintio-zero/skills/ravintio-plan/SKILL.md)
**Feature:** 0000395-pack-prose-to-the-standard
**Version:** 0.75.0
**Overall Risk Level:** medium

> Every entry is specific to this feature.

## Risks

| ID | Category | Description | Likelihood | Impact | Mitigation | Status |
|----|----------|------------|------------|--------|-----------|--------|
| R-001 | technical | A rewrite changes the meaning of a rule | medium | high | Reviewers read each diff against the original. The full suite runs after each batch. | open |
| R-002 | technical | A rewrite edits a line that a test or fixture pins | high | low | The step runs the suite after each batch and updates the pin with a Rework line. | open |
| R-003 | operational | Two agents edit one file | low | medium | Each unit owns the files in its slice list, and the slices share no file. | open |
| R-004 | technical | A rewrite alters a heading that a script parses | low | medium | Agents keep every heading. The suite catches a parse failure. | open |

## Assumptions Logged as Risks

| ID | Assumption | Impact if Wrong | Status |
|----|-----------|----------------|--------|
| A-001 | Every breach in scope sits outside code font, tables, and comments | A breach cannot be fixed by a prose edit | open |
