# Security Report - Add-step writes the full feature id

**Skill:** [validate-and-accept](../skills/ravintio-validate-and-accept/SKILL.md)
**Feature:** 0000438-add-step-writes-full-feature-id
**Version:** 0.77.2

> It is advisory. The review makes no code changes.

## Summary

**Overall Risk Assessment:** low
**Components Reviewed:** ravintio-zero
**Review Scope:** code review

## Findings

| ID | Severity | Category | Component | Description | Recommendation | Status |
|----|----------|----------|-----------|-------------|----------------|--------|
| S-001 | informational | injection | ravintio-zero | `src/ravintio-zero/scripts/initiative-add-step.mjs:112` joins the reserved id and `--slug`. The slug passes the kebab-case check at line 42 and the joined id passes `FEATURE_ID` at line 113, so no pipe or newline reaches the chart row. | None. | mitigated |
| S-002 | informational | path | ravintio-zero | The slug builds the backlog folder name at line 120. The kebab-case check blocks `/` and `..`. | None. | mitigated |

## Dependency Audit

| Package | Current Version | Known CVEs | Severity | Action Required |
|---------|----------------|------------|----------|----------------|
| none added | n/a | none | n/a | none |

## Threat Model

| Threat | Attack Vector | Affected Component | Likelihood | Impact | Existing Mitigation | Gap |
|--------|--------------|-------------------|------------|--------|--------------------|----|
| A crafted slug corrupts the chart table | `--slug` with a pipe or newline | ravintio-zero | low | low | Kebab-case check and the `FEATURE_ID` check | none |

## Recommendations

1. None. The review found 0 critical and 0 high findings.
