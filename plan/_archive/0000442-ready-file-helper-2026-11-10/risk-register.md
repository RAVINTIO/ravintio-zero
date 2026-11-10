---
title: "Risk Register - ready file helper"
summary: "Technical and security risks with their mitigations."
status: "active"
version: "0.1.0"
---
# Risk Register - ready file helper

**Skill:** [plan](../../ravintio-zero/skills/ravintio-plan/SKILL.md)
**Feature:** 0000442-ready-file-helper
**Version:** 0.81.0
**Overall Risk Level:** low

## Risks

| ID | Category | Description | Likelihood | Impact | Mitigation | Status |
|----|----------|------------|------------|--------|-----------|--------|
| R-001 | technical | Recovery picks a wrong PR for the step. | low | medium | The lookup accepts one open PR with the exact head `feat/{feature-id}` and no other. | open |
| R-002 | security | The helper or the driver follows a symlink and writes outside the control folder. | low | high | Both refuse a symlink at the folder and at the file. | open |
| R-003 | technical | A step ignores the helper and writes the file by hand. | medium | low | Driver recovery covers an empty or invalid file. | open |

## Assumptions Logged as Risks

| ID | Assumption | Impact if Wrong | Status |
|----|-----------|----------------|--------|
| A-001 | `gh` is on the driver PATH and holds a sign-in. | Recovery fails and the driver stops as it does today. | open |
| A-002 | The driver cuts the step branch as `feat/{feature-id}`. | The lookup finds no PR and the driver stops as it does today. | open |
