# Security Report - Baseline record checks

**Skill:** [validate-and-accept](../../ravintio-zero/skills/ravintio-validate-and-accept/SKILL.md)
**Feature:** 0000549-baseline-record-checks
**Version:** 0.115.0

> The review is advisory. It makes no code changes.

## Summary

**Overall risk assessment:** low
**Components reviewed:** ravintio-zero
**Review scope:** code review

## Findings

| ID | Severity | Category | Component | Description | Recommendation | Status |
|----|----------|----------|-----------|-------------|----------------|--------|
| S-001 | informational | injection | ravintio-zero | `ravintio-zero/scripts/baseline-failures.mjs` reads suite names from runner output and writes them to the baseline file. The change adds a regex test for the totals line and does not alter that path. | None. | accepted |
| S-002 | informational | config | ravintio-zero | `--file` takes any path. The caller is a local agent or CI job, and the change adds no new path handling. | None. | accepted |
| S-003 | informational | data-exposure | ravintio-zero | The new stderr lines name the baseline path and the missing totals line. They print no runner output. | None. | accepted |

## Dependency audit

The change adds no dependency. The script imports only `node:fs` and `node:path`.

## Threat model

| Threat | Attack vector | Affected component | Likelihood | Impact | Existing mitigation | Gap |
|--------|--------------|--------------------|------------|--------|---------------------|-----|
| Partial runner output records an empty baseline | A run stops early and `record` accepts the output | ravintio-zero | medium | medium | REQ-001 refuses output with no `Feature suites:` line | none |
| A missing baseline passes as empty | `check` treats a missing file as no failures | ravintio-zero | medium | medium | REQ-002 exits 1 with `no baseline recorded` | none |

## Risk register cross-check

R-001 and R-002 are reliability risks, not security risks. Both stay open as the register records them. No critical or high finding is open.

## Recommendations

1. None before production.
