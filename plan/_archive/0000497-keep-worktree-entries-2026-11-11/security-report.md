# Security Report - Driver keeps uncommitted entries from a worktree

**Skill:** [validate-and-accept](../../ravintio-zero/skills/ravintio-validate-and-accept/SKILL.md)
**Feature:** 0000497-keep-worktree-entries
**Version:** 0.106.0

> It is advisory - the review makes no code changes.

## Summary

**Overall Risk Assessment:** low
**Components Reviewed:** ravintio-zero
**Review Scope:** code review

## Findings

| ID | Severity | Category | Component | Description | Recommendation | Status |
|----|----------|----------|-----------|-------------|----------------|--------|
| S-001 | low | config | ravintio-zero | `keepUntrackedEntries` in `src/ravintio-zero/scripts/initiative-run.mjs:949` runs `git ls-files` through `spawnSync` with fixed arguments. No input reaches a shell, and the step number is an integer. | None | mitigated |
| S-002 | low | config | ravintio-zero | File names from the listing go into one stop line. The driver cuts the line to 500 characters, and the list holds at most five names. | None | mitigated |
| S-003 | low | config | ravintio-zero | The check deletes nothing and moves nothing. A failed listing keeps the worktree, so the check fails safe. | None | accepted |

## Dependency Audit

| Package | Current Version | Known CVEs | Severity | Action Required |
|---------|----------------|------------|----------|----------------|
| none added | n/a | none | low | none |

## Threat Model

| Threat | Attack Vector | Affected Component | Likelihood | Impact | Existing Mitigation | Gap |
|--------|--------------|-------------------|------------|--------|--------------------|----|
| A step loses a filed entry | The step leaves the entry untracked and the queue removes the worktree | ravintio-zero | low | medium | The listing stops the queue. Ship tells the step to commit each entry. | none |

## Recommendations

1. None. The step adds no critical or high finding.
