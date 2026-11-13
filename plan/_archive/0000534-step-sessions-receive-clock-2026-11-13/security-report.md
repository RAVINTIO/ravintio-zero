# Security Report - Step sessions receive the clock

**Skill:** [validate-and-accept](../../ravintio-zero/skills/ravintio-validate-and-accept/SKILL.md)
**Feature:** 0000534-step-sessions-receive-clock
**Version:** 0.112.0

> It is advisory - the review makes no code changes.

## Summary

**Overall Risk Assessment:** low
**Components Reviewed:** ravintio-zero
**Review Scope:** code review

## Findings

| ID | Severity | Category | Component | Description | Recommendation | Status |
|----|----------|----------|-----------|-------------|----------------|--------|
| S-001 | low | data-exposure | ravintio-zero | With `--include-hook-events`, the step log also holds hook output. The log is in `plan/.initiative-logs/`, mode 700 for the folder and 600 for the file, and the guard hooks print no secret. | None | accepted |
| S-002 | low | injection | ravintio-zero | `step-clock-check.mjs` reads the path in its one argument and parses each line with `JSON.parse` inside a `try` block. It runs no shell and prints the path and two counts, never log text. | None | mitigated |

## Dependency Audit

| Package | Current Version | Known CVEs | Severity | Action Required |
|---------|----------------|------------|----------|----------------|
| none added | n/a | none | low | none |

## Threat Model

| Threat | Attack Vector | Affected Component | Likelihood | Impact | Existing Mitigation | Gap |
|--------|--------------|-------------------|------------|--------|--------------------|----|
| A hook prints a secret that now lands in the step log | A future hook echoes an environment value | ravintio-zero | low | low | The log keeps mode 600 and stays in an ignored folder. | none |
| The check prints log text | A crafted log line is echoed | ravintio-zero | low | low | The script prints only the path and counts. A test pins this. | none |

## Recommendations

1. None. The step adds no critical or high finding.
