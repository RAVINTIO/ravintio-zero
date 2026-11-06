---
title: "Risk Register - CodeQL and branch cleanup in CI"
summary: "Technical, operational, and security risks with their mitigations."
status: "active"
version: "0.1.0"
---
# Risk Register - CodeQL and branch cleanup in CI

**Skill:** [plan](../skills/ravintio-plan/SKILL.md)
**Feature:** 0000355-codeql-and-branch-cleanup
**Version:** 0.53.0
**Overall Risk Level:** medium

## Risks

| ID | Category | Description | Likelihood | Impact | Mitigation | Status |
|----|----------|------------|------------|--------|-----------|--------|
| R-001 | security | The cleanup job holds a write token and deletes the wrong branch. | low | high | Skip fork heads, refuse `main` and `master`, validate the branch name, pass it through `env`, and test the job text. | open |
| R-002 | security | A head ref name injects shell text into the job. | low | high | Read the ref from `env`, never from an inline expression, and check it against an allowed pattern. | open |
| R-003 | operational | CodeQL default setup stays on and the advanced workflow conflicts with it. | medium | medium | The step stops for the human before it merges. | open |
| R-004 | technical | Adding `closed` to the pull request trigger runs an unguarded job. | medium | medium | Guard every pull request job and test that each job carries the guard or the marker. | open |
| R-005 | operational | A consumer repo keeps its old `ravintio.yml` and gets no cleanup job. | high | low | Setup keeps an existing file by design. Record it as out of scope. | accepted |

## Assumptions Logged as Risks

| ID | Assumption | Impact if Wrong | Status |
|----|-----------|----------------|--------|
| A-001 | Every existing pull request job can skip `closed` through its `if` condition. | The cleanup moves to a separate workflow file that setup installs. | open |
| A-002 | The workflow token can delete a head ref in the same repo. | The cleanup job fails and the branches stay. | open |
