# Security Report - Driver favours the critical path

**Skill:** [validate-and-accept](../skills/ravintio-validate-and-accept/SKILL.md)
**Feature:** 0000491-driver-favours-critical-path
**Version:** 0.101.0

> It is advisory - the review makes no code changes. All findings require human review before action.

## Summary

**Overall Risk Assessment:** low
**Components Reviewed:** ravintio-zero
**Review Scope:** code review

## Findings

| ID | Severity | Category | Component | Description | Recommendation | Status |
|----|----------|----------|-----------|-------------|----------------|--------|
| S-001 | low | injection | ravintio-zero | `chainLengths` in `src/ravintio-zero/scripts/initiative-chart.mjs` reads parsed step numbers and lane names. It builds no `RegExp`, shell string, or path from them. | None. | mitigated |
| S-002 | low | availability | ravintio-zero | A cycle in the `After` lists could loop the count. The `walking` set ends the recursion at the repeated step, and a suite case plants a cycle. | None. | mitigated |
| S-003 | informational | availability | ravintio-zero | The recursion depth equals the longest chain, at most the number of steps. A chart of 60 steps ranks in under 1 ms. | None. | accepted |

## Dependency Audit

| Package | Current Version | Known CVEs | Severity | Action Required |
|---------|----------------|------------|----------|----------------|
| none added | not applicable | none | low | accept-risk |

## Threat Model

The change reorders a list that the driver already reads. It reads no new input, writes no file, and widens no guard.

## Risk register cross-reference

- R-001 (a cycle in `After` lists): mitigated. The `walking` set stops the count.
- R-002 (rank counts steps, not time): open by design. The scope leaves duration weights out.
- R-003 (`readySteps` is a public export): mitigated. The signature and return type stay the same, and the existing chart suites pass.
