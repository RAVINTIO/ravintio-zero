---
title: "Risk Register - sharded CI suites"
summary: "Technical risks with their mitigations."
status: "active"
version: "0.1.0"
---
# Risk Register - sharded CI suites

**Skill:** [plan](../skills/ravintio-plan/SKILL.md)
**Feature:** 0000409-ci-shards
**Version:** 0.69.0
**Overall Risk Level:** low

## Risks

| ID | Category | Description | Likelihood | Impact | Mitigation | Status |
|----|----------|------------|------------|--------|-----------|--------|
| R-001 | technical | Shards are uneven, so one shard sets the wall clock | medium | low | Round-robin by sorted name spreads the long setup suites. The matrix size can grow. | open |
| R-002 | technical | A fault that shows only under pwsh on Windows goes unseen | low | medium | pwsh still runs every `.ps1` suite on Linux, and Windows PowerShell 5.1 still runs on Windows | open |
| R-003 | operational | The ruleset still requires `windows-powershell (pwsh)` | high | medium | The coordinator removes it after merge, as the human approved | open |
| R-004 | security | A summary job passes when a shard was skipped or cancelled | low | high | The summary job fails unless the shard result is `success` | open |

## Assumptions Logged as Risks

| ID | Assumption | Impact if Wrong | Status |
|----|-----------|----------------|--------|
| A-001 | GitHub names a summary job's check after its `name:` | The ruleset waits on a missing check | open |
