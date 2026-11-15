---
title: "Risk Register - Test impact scan lists the mirrored pack tree"
summary: "Technical risks with their mitigations."
status: "active"
version: "0.1.0"
---
# Risk Register - Test impact scan lists the mirrored pack tree

**Skill:** [plan](../skills/ravintio-plan/SKILL.md)
**Feature:** 0000562-test-impact-scan-lists-the-mirrored-pack-tree
**Version:** 0.115.0
**Overall Risk Level:** low

## Risks

| ID | Category | Description | Likelihood | Impact | Mitigation | Status |
|----|----------|------------|------------|--------|-----------|--------|
| R-001 | technical | Three suites read the scan from `SKILL.md` and fail when the causes move. | high | low | Update their pins to read the reference file, and log a `Rework:` line. | open |
| R-002 | technical | The two pack trees drift apart. | medium | medium | Run `sync-installed.mjs` and its `--check` flag before commit. | open |

## Assumptions Logged as Risks

| ID | Assumption | Impact if Wrong | Status |
|----|-----------|----------------|--------|
| A-001 | `sync-installed.mjs` copies a new reference file to `ravintio-zero/`. | The parity check fails. | open |
