# Security Report - Ship removal needs human approval

**Skill:** [validate-and-accept](../skills/ravintio-validate-and-accept/SKILL.md)
**Feature:** 0000519-ship-removal-needs-human-approval
**Version:** 0.101.0

> It is advisory - the review makes no code changes. All findings require human review before action.

## Summary

**Overall Risk Assessment:** low
**Components Reviewed:** ravintio-zero
**Review Scope:** code review

## Findings

| ID | Severity | Category | Component | Description | Recommendation | Status |
|----|----------|----------|-----------|-------------|----------------|--------|
| S-001 | low | data exposure | ravintio-zero | `git rm -r -q plan/current` in `src/ravintio-zero/skills/ravintio-ship/SKILL.md` removes tracked files only. A file lost before Step 4 stages everything has no archive copy. | Step 4 copies first and stages everything. No change. | mitigated |
| S-002 | informational | permissions | ravintio-zero | The change adds no allowlist entry and widens no guard. The safety check stays in force. | None. | mitigated |

## Dependency Audit

| Package | Current Version | Known CVEs | Severity | Action Required |
|---------|----------------|------------|----------|----------------|
| none added | not applicable | none | low | accept-risk |

## Threat Model

The change edits skill text and adds two text suites. The suites read files and build no path from input.

## Risk register cross-reference

- R-001 (untracked file blocks git rm): mitigated. Step 4 item 5 stages everything first.
- R-002 (a test pins the old wording): mitigated. The pins in 0000025 and 0000385 pass.
- R-003 (safety check refuses git rm elsewhere): open by design. The step prints Blocked with the exact error.
