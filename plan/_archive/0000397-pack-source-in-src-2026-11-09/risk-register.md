---
title: "Risk Register - Pack source in src"
summary: "Technical, operational, and security risks with their mitigations."
status: "active"
version: "0.1.0"
---
# Risk Register - Pack source in src

**Skill:** [plan](../../ravintio-zero/skills/ravintio-plan/SKILL.md)
**Feature:** 0000397-pack-source-in-src
**Version:** 0.76.0
**Overall Risk Level:** medium

## Risks

| ID | Category | Description | Likelihood | Impact | Mitigation | Status |
|----|----------|------------|------------|--------|-----------|--------|
| R-001 | security | A guard covers `ravintio-zero/` and misses `src/ravintio-zero/`, so a write to the source passes. | medium | high | One test per guard on both paths. The plan lists each guard from a grep. | open |
| R-002 | technical | The move commit gains an edit, so `git log --follow` loses history. | low | high | Check `git diff -M --numstat` shows 0 added and 0 removed lines. | open |
| R-003 | technical | A test pins the old path. About 148 test files hold a literal `ravintio-zero/` path. | high | medium | Tests use `$ZERO_DIR` and the git top level. The full suite runs on a clean tree. | open |
| R-004 | operational | The installed copy lags the source, so hooks run old rules. | medium | medium | `sync-installed.mjs --check` runs in CI and in the suite. | open |
| R-005 | technical | The Windows suite fails on a longer path. | medium | medium | CI runs the Windows tests on the final tree. | open |

## Assumptions Logged as Risks

| ID | Assumption | Impact if Wrong | Status |
|----|-----------|----------------|--------|
| A-001 | One test file passes from either folder. | The suite needs two variants and parity breaks. | open |
| A-002 | Setup copies the pack from the installed folder. | Consumer paths change. | open |
