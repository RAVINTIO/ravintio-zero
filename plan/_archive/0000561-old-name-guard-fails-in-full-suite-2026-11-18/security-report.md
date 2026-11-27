# Security Report - Old-name guard fails in the full suite

**Skill:** [validate-and-accept](../skills/ravintio-validate-and-accept/SKILL.md)
**Feature:** 0000561-old-name-guard-fails-in-full-suite
**Version:** 0.144.0

> It is advisory - the review makes no code changes. All findings require human review before action.

## Summary

**Overall Risk Assessment:** low
**Components Reviewed:** ravintio-zero
**Review Scope:** code review

## Findings

| ID | Severity | Category | Component | Description | Recommendation | Status |
|----|----------|----------|-----------|-------------|----------------|--------|
| S-001 | informational | config | ravintio-zero | `src/ravintio-zero/tests/test-0000189-req-007-old-name-guard.sh` builds a shim `grep` in a `mktemp -d` folder. The trap removes the folder on exit. The shim runs only inside the guard call. | None. | false-positive |

## Dependency Audit

| Package | Current Version | Known CVEs | Severity | Action Required |
|---------|----------------|------------|----------|----------------|
| none | none | none | low | none |

## Threat Model

| Threat | Attack Vector | Affected Component | Likelihood | Impact | Existing Mitigation | Gap |
|--------|--------------|-------------------|------------|--------|--------------------|----|
| A path with a newline or glob in a hit | A tracked file name | ravintio-zero | low | low | The match uses string equality and `case` on a quoted variable | none |

## Recommendations

1. None. The change touches one test file and adds no input path, credential, or dependency.
