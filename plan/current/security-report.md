# Security Report - Smoother activation

**Skill:** [validate-and-accept](../../ravintio-zero/skills/ravintio-validate-and-accept/SKILL.md)
**Feature:** 0000399-smoother-activation
**Version:** set by the merge queue

> It is advisory. The review makes no code changes.

## Summary

**Overall Risk Assessment:** low
**Components Reviewed:** ravintio-zero
**Review Scope:** code review

## Findings

| ID | Severity | Category | Component | Description | Recommendation | Status |
|----|----------|----------|-----------|-------------|----------------|--------|
| S-001 | informational | config | ravintio-zero | `initiative-activate.mjs` runs `git` and `gh` through one wrapper. It rejects `--force`, `-f`, and `--force-*`. It merges only after it checks that the base branch starts with `initiative/`. | None | accepted |
| S-002 | informational | injection | ravintio-zero | All three new scripts pass arguments as arrays to `spawnSync` or `execFileSync`. None builds a shell string. | None | accepted |
| S-003 | informational | config | ravintio-zero | No guard gains an allowed form. The hooks only change which skill they name. | None | accepted |

## Dependency Audit

| Package | Current Version | Known CVEs | Severity | Action Required |
|---------|----------------|------------|----------|----------------|
| none added | n/a | none | n/a | none |

## Threat Model

| Threat | Attack Vector | Affected Component | Likelihood | Impact | Existing Mitigation | Gap |
|--------|--------------|-------------------|------------|--------|--------------------|----|
| A draft title or slug carries shell text | `--title` or a draft path | ravintio-zero | low | low | Argument arrays, no shell | none |
| The script merges into `main` | A crafted draft id | ravintio-zero | low | high | Base branch must start with `initiative/`, and `merge-guard` stays | none |

## Recommendations

1. None.
