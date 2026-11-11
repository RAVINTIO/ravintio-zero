# Security Report - Steps apply the chart's Decisions rows

**Skill:** [validate-and-accept](../skills/ravintio-validate-and-accept/SKILL.md)
**Feature:** 0000487-steps-apply-decision-rows
**Version:** 0.95.0

> It is advisory - the review makes no code changes. All findings require human review before action.

## Summary

**Overall Risk Assessment:** low
**Components Reviewed:** ravintio-zero
**Review Scope:** code review

## Findings

| ID | Severity | Category | Component | Description | Recommendation | Status |
|----|----------|----------|-----------|-------------|----------------|--------|
| S-001 | low | injection | ravintio-zero | `src/ravintio-zero/scripts/build-log-check.mjs` matches a fork against log lines with `startsWith`. It builds no `RegExp` from chart text, so a fork with metacharacters cannot change the match. | None. | mitigated |
| S-002 | low | resource | ravintio-zero | `expandSteps` in `src/ravintio-zero/scripts/decision-rows.mjs` expands a range such as `1-99999999` in a chart cell. | None. The code refuses any range of 1000 steps or more. | mitigated |
| S-003 | low | path | ravintio-zero | `decision-rows.mjs list --chart {path}` reads the path it is given. The check derives its chart path from the build log path and fixed names, and the command only reads and prints rows. | None. The module writes no file and runs no chart text. | mitigated |
| S-004 | informational | config | ravintio-zero | Check 9 reads `plan/current-initiative/initiative.md` through a symlink if one exists. The read is local and read-only. | None. | accepted |

## Dependency Audit

| Package | Current Version | Known CVEs | Severity | Action Required |
|---------|----------------|------------|----------|----------------|
| none added | not applicable | none | low | accept-risk |

## Threat Model

The module and the check read chart and log text as data. No shell string, path, or pattern comes from that text. Both run on the maintainers' own branches.

## Risk register cross-reference

- R-001 (colon or pipe in a fork): mitigated. A test covers a colon in a fork.
- R-002 (a line without applying the row): open by design. The check requires a line only.
- R-003 (old chart row): mitigated. The check reads the current step only.
