---
title: "Risk Register - Tests share a repo-root helper for both pack trees"
summary: "Technical risks with their mitigations."
status: "active"
version: "0.1.0"
---
# Risk Register - Tests share a repo-root helper for both pack trees

**Skill:** [plan](../skills/ravintio-plan/SKILL.md)
**Feature:** 0000572-tests-share-a-repo-root-helper
**Version:** 0.147.0
**Overall Risk Level:** low

## Risks

| ID | Category | Description | Likelihood | Impact | Mitigation | Status |
|----|----------|------------|------------|--------|-----------|--------|
| R-001 | technical | A syntax error in `assert.sh` fails every suite. | low | high | Run the new suite and the full suite before ship. | open |
| R-002 | technical | The two pack trees drift apart. | medium | medium | Run `sync-installed.mjs` and its `--check` flag before commit. | open |
| R-003 | technical | The new standards text trips a wording test. | low | low | Run `test-0000042-req-010` before commit. | open |

## Assumptions Logged as Risks

| ID | Assumption | Impact if Wrong | Status |
|----|-----------|----------------|--------|
| A-001 | `product.yml` sits at the repo root and nowhere between a suite and the root. | The helper returns a wrong folder. | open |
