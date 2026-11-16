---
title: "Risk Register - CI avoids extra runs on a plan-only push"
summary: "Risks of the concurrency block."
status: "active"
version: "0.139.0"
---
# Risk Register - CI avoids extra runs on a plan-only push

**Skill:** [plan](../../ravintio-zero/skills/ravintio-plan/SKILL.md)
**Feature:** 0000558-plan-only-push-short-ci
**Version:** 0.139.0
**Overall Risk Level:** low

## Risks

| ID | Category | Description | Likelihood | Impact | Mitigation | Status |
|----|----------|------------|------------|--------|-----------|--------|
| R-001 | operational | A closed event cancels the validation run of the same pull request. | low | medium | The group key holds a flag for the closed action. | open |
| R-002 | operational | A push to main cancels the release tag job of an earlier push. | medium | high | `cancel-in-progress` is false for a push event. | open |

## Assumptions Logged as Risks

| ID | Assumption | Impact if Wrong | Status |
|----|-----------|----------------|--------|
| A-001 | A new run cancels the older run of its group. | Older runs keep running and the change has no effect. | open |
| A-002 | A cancelled run leaves no required check red. | The pull request shows a red check until the newer run ends. | open |
