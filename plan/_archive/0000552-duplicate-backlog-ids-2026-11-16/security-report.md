# Security Report - Two open entries share one backlog id

**Skill:** [validate-and-accept](../skills/ravintio-validate-and-accept/SKILL.md)
**Feature:** 0000552-duplicate-backlog-ids
**Version:** 0.139.0

> It is advisory - the review makes no code changes. All findings require human review before action.

## Summary

**Overall Risk Assessment:** low
**Components Reviewed:** ravintio-zero
**Review Scope:** code review

## Findings

| ID | Severity | Category | Component | Description | Recommendation | Status |
|----|----------|----------|-----------|-------------|----------------|--------|
| S-001 | informational | injection | ravintio-zero | `src/ravintio-zero/scripts/backlog-index.mjs` prints folder names in the `check: duplicate backlog id` line. A folder name matches `^\d{7}-(.+)$`, and the script writes it to stderr only. It runs no command and writes no file in check mode. | None. | accepted |

## Dependency Audit

No dependency changed.

## Threat Model

The change adds one in-memory grouping and one stderr line to a script that already reads folder names. It adds no network call, credential, or file write.

## Recommendations

1. None.
