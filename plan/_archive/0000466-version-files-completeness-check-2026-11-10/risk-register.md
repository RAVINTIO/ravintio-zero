---
title: "Risk Register - Version files completeness check"
summary: "Technical risks with their mitigations."
status: "active"
version: "0.1.0"
---
# Risk Register - Version files completeness check

**Skill:** [plan](../skills/ravintio-plan/SKILL.md)
**Feature:** 0000466-version-files-completeness-check
**Version:** 0.88.0
**Overall Risk Level:** low

## Risks

| ID | Category | Description | Likelihood | Impact | Mitigation | Status |
|----|----------|------------|------------|--------|-----------|--------|
| R-001 | technical | The scan flags a file whose `version:` line matches the product version by chance | low | low | The scan skips `plan/`, `docs/adr/`, and `tests/fixtures/`. A flagged file goes on the list or gets a different version | open |
| R-002 | technical | The test runs in both `src/ravintio-zero/` and `ravintio-zero/`, so a fixed root path breaks one copy | medium | medium | The test asks git for the repo root and reads the list beside itself | open |
| R-003 | operational | A fixture repo needs a git identity | low | low | The fixture runs `git add` and `git ls-files` only, and makes no commit | open |

## Assumptions Logged as Risks

| ID | Assumption | Impact if Wrong | Status |
|----|-----------|----------------|--------|
| A-001 | Git is on the path in every test environment | The test cannot list tracked files | open |
