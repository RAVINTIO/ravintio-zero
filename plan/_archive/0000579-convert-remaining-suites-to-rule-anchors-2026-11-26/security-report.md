# Security Report - Convert remaining suites to rule anchors

**Skill:** [validate-and-accept](../skills/ravintio-validate-and-accept/SKILL.md)
**Feature:** 0000579-convert-remaining-suites-to-rule-anchors
**Version:** 0.149.0

> It is advisory. The review makes no code changes.

## Summary

**Overall Risk Assessment:** low
**Components Reviewed:** ravintio-zero
**Review Scope:** code review

## Findings

| ID | Severity | Category | Component | Description | Recommendation | Status |
|----|----------|----------|-----------|-------------|----------------|--------|
| S-001 | low | injection | ravintio-zero | `src/ravintio-zero/tests/test-0000579-req-001-anchor-conversion-guard.sh` runs sampled suites from a temporary copy and reads only the ledger in the same folder. The ledger names no path, and the suite joins each name to a fixed folder. | None. The ledger is a tracked file. | accepted |
| S-002 | low | config | ravintio-zero | Anchors in `templates/backlog-entry.template.md` and `templates/adr.template.md` copy into new entries. They are HTML comments and carry no data. | None. | accepted |
| S-003 | informational | config | ravintio-zero | The boot templates `standard-boot.md` and `codex-boot.md` carry no anchors, so setup writes none into installed files. | None. | mitigated |

## Dependency Audit

No dependency changed.

## Threat Model

No new input, network call, or credential. The change adds comments to markdown and edits bash suites.

## Recommendations

1. None before release.
