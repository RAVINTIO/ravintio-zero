# Security Report - Driver prints a stop summary

**Skill:** [validate-and-accept](../../ravintio-zero/skills/ravintio-validate-and-accept/SKILL.md)
**Feature:** 0000511-driver-stop-summary
**Version:** 0.111.0

> It is advisory - the review makes no code changes.

## Summary

**Overall Risk Assessment:** low
**Components Reviewed:** ravintio-zero
**Review Scope:** code review

## Findings

| ID | Severity | Category | Component | Description | Recommendation | Status |
|----|----------|----------|-----------|-------------|----------------|--------|
| S-001 | low | data-exposure | ravintio-zero | `printSummary` in `src/ravintio-zero/scripts/initiative-run.mjs` repeats lines that `out()` already printed. It adds no new data, and it names no environment value. | None | mitigated |
| S-002 | low | config | ravintio-zero | The recorder matches fixed line prefixes with anchored regular expressions. Each fix line is cut to `MAX_LINE`, and the fix list stops at 10. | None | mitigated |
| S-003 | low | config | ravintio-zero | `printSummary` runs inside a `try` block and runs once. A write failure cannot hide a stop or change an exit code. | None | accepted |

## Dependency Audit

| Package | Current Version | Known CVEs | Severity | Action Required |
|---------|----------------|------------|----------|----------------|
| none added | n/a | none | low | none |

## Threat Model

| Threat | Attack Vector | Affected Component | Likelihood | Impact | Existing Mitigation | Gap |
|--------|--------------|-------------------|------------|--------|--------------------|----|
| The summary leaks a value that the driver never printed | A fix line holds data from outside | ravintio-zero | low | low | The recorder keeps only lines that the driver printed, and those lines passed the earlier line limit. | none |
| The summary hides a stop | `printSummary` throws before the stop line | ravintio-zero | low | medium | The call sits in a `try` block, and the stop line prints after it. | none |

## Recommendations

1. None. The step adds no critical or high finding.
