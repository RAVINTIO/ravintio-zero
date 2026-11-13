---
title: "Risk Register - Merge queue test gaps"
summary: "Technical risks with their mitigations."
status: "active"
version: "0.1.0"
---
# Risk Register - Merge queue test gaps

**Skill:** [plan](../skills/ravintio-plan/SKILL.md)
**Feature:** 0000464-merge-queue-test-gaps
**Version:** 0.84.0
**Overall Risk Level:** low

## Risks

| ID | Category | Description | Likelihood | Impact | Mitigation | Status |
|----|----------|------------|------------|--------|-----------|--------|
| R-001 | technical | No fixture input makes the post-set check fail without a test seam | medium | low | Use a version file that reads back different after the set, such as a second `version:` line. If that fails, stub `version-files.mjs` through the list path | open |
| R-002 | technical | The dash check changes an error path that other tests pin | low | low | The test impact scan lists the queue suites. The full suite runs on a clean tree | open |
| R-003 | security | A ref name that starts with a dash reaches `git` as an option | low | low | REQ-003 refuses it before any `git` call | open |

## Assumptions Logged as Risks

| ID | Assumption | Impact if Wrong | Status |
|----|-----------|----------------|--------|
| A-001 | The fake `gh` of test 0000456 extends to both fixtures | The step writes a new shim | open |
