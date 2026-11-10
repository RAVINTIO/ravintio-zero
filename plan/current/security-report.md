# Security Report - Merge ready PRs after a stop

**Skill:** [validate-and-accept](../../ravintio-zero/skills/ravintio-validate-and-accept/SKILL.md)
**Feature:** 0000446-drain-ready-prs-after-a-stop
**Version:** 0.91.0

> It is advisory. The review makes no code changes.

## Summary

**Overall Risk Assessment:** low
**Components Reviewed:** ravintio-zero
**Review Scope:** code review

## Findings

| ID | Severity | Category | Component | Description | Recommendation | Status |
|----|----------|----------|-----------|-------------|----------------|--------|
| S-001 | low | config | ravintio-zero | `schedule()` in `initiative-run.mjs` now calls the merge queue for each ready step after a failure. The call uses the same validated step number and PR number as before. No new input reaches a shell or a path. | None. | accepted |
| S-002 | informational | data-exposure | ravintio-zero | The extra failure line holds the queue's last output line, cut to `MAX_LINE`. The path was already in use for the first failure. | None. | accepted |

## Dependency Audit

| Package | Current Version | Known CVEs | Severity | Action Required |
|---------|----------------|------------|----------|----------------|
| none added | n/a | none | n/a | none |

## Threat Model

| Threat | Attack Vector | Affected Component | Likelihood | Impact | Existing Mitigation | Gap |
|--------|--------------|-------------------|------------|--------|--------------------|----|
| A drained PR merges without its prerequisites | A ready step that depends on an unmerged step | ravintio-zero | low | medium | The scheduler starts a step only after its `After` steps merge. The merge queue also checks CI and the PR title. | none |
| No guard widens | `merge-guard` and the other hooks | ravintio-zero | none | none | No hook changed. | none |

## Recommendations

1. None. No critical or high finding exists.
