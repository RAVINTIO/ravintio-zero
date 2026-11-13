# Security Report - Steps use Question only for real questions

**Skill:** [validate-and-accept](../skills/ravintio-validate-and-accept/SKILL.md)
**Feature:** 0000489-question-only-for-questions
**Version:** 0.99.0

> It is advisory - the review makes no code changes. All findings require human review before action.

## Summary

**Overall Risk Assessment:** low
**Components Reviewed:** ravintio-zero
**Review Scope:** code review

## Findings

| ID | Severity | Category | Component | Description | Recommendation | Status |
|----|----------|----------|-----------|-------------|----------------|--------|
| S-001 | low | injection | ravintio-zero | `isFalseQuestion` in `src/ravintio-zero/hooks/enforcement/check-reply-prefix.mjs` compares reply text with `startsWith` and `includes`. It builds no `RegExp`, shell string, or path from the reply. | None. | mitigated |
| S-002 | low | data exposure | ravintio-zero | The hook appends the first 80 characters of a false `Question:` line to `plan/.prefix-misses.log`. The log is git-ignored through `.git/info/exclude`. The existing prefix check already logs the same snippet. | None. | accepted |
| S-003 | informational | availability | ravintio-zero | The new branch sits inside the existing `try` block. Any error exits 0, so the hook cannot block a turn. | None. | mitigated |

## Dependency Audit

| Package | Current Version | Known CVEs | Severity | Action Required |
|---------|----------------|------------|----------|----------------|
| none added | not applicable | none | low | accept-risk |

## Threat Model

The hook reads the final reply as data and writes one log line. The change widens no guard. It adds a warning and blocks nothing.

## Risk register cross-reference

- R-001 (a real question without a mark): open by design. The hook only warns.
- R-002 (a false question with a mark): open by design. The skill text is the main control.
- R-003 (SKILL.md size cap): mitigated. `SKILL.md` is 8,987 bytes against a cap of 9,000.
