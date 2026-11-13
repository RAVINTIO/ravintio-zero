# Security Report - Pending migrations reach the human early

**Skill:** [validate-and-accept](../skills/ravintio-validate-and-accept/SKILL.md)
**Feature:** 0000536-pending-migrations-reach-the-human-early
**Version:** 0.113.0

> It is advisory. The review makes no code changes.

## Summary

**Overall Risk Assessment:** low
**Components Reviewed:** ravintio-zero
**Review Scope:** code review

The change edits Markdown skills, one standard, and one Bash test. It adds no script, hook, dependency, or network call.

## Findings

| ID | Severity | Category | Component | Description | Recommendation | Status |
|----|----------|----------|-----------|-------------|----------------|--------|
| S-001 | low | config | ravintio-zero | `ravintio-zero/standards/roadmap-standards.md:318` lets a `Migration:` row with the answer `all` run a migration with no per-finding review. The human approves the row at chart time. | None. The chart confirmation covers the row, and the migrator still skips code identifiers and fenced blocks. | accepted |
| S-002 | informational | config | ravintio-zero | No guard or hook widens. `merge-guard`, `gate-write`, and `ratchet-check` are unchanged. | None. | mitigated |

## Dependency Audit

| Package | Current Version | Known CVEs | Severity | Action Required |
|---------|----------------|------------|----------|----------------|
| none added | none | none | low | none |

## Threat Model

| Threat | Attack Vector | Affected Component | Likelihood | Impact | Existing Mitigation | Gap |
|--------|--------------|-------------------|------------|--------|--------------------|----|
| A step runs an unreviewed migration | A `Migration:` row with `all` that the human never saw | ravintio-zero | low | medium | Chart lists each migration and takes the human's answer | None |

## Recommendations

1. None. The risk register items R-001 to R-003 stay open and low.
