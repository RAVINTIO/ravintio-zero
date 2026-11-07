# Security Report - Step titles and history shape

**Skill:** [validate-and-accept](../../ravintio-zero/skills/ravintio-validate-and-accept/SKILL.md)
**Feature:** 0000351-step-titles-and-history-shape
**Version:** 0.49.0

> It is advisory - no code changes are made. All findings require human review before action.

## Summary

**Overall Risk Assessment:** low
**Components Reviewed:** ravintio-zero
**Review Scope:** code review

## Findings

| ID | Severity | Category | Component | Description | Recommendation | Status |
|----|----------|----------|-----------|-------------|----------------|--------|
| S-001 | informational | injection | ravintio-zero | `ravintio-zero/scripts/check-initiative-history.mjs` runs git through `execFileSync` with an argument array. `--base`, `--head`, and `--root` reach git as arguments. A value that starts with a dash could act as a git option. | The CI caller passes `origin/$HEAD_REF` and the script verifies both refs with `rev-parse --verify` first, so an option value fails there. No change. | accepted |
| S-002 | informational | injection | ravintio-zero | The chart title text is compared as a string and builds no regular expression. | None. | mitigated |
| S-003 | low | data-exposure | ravintio-zero | The archived-chart lookup joins an id from `--head`. The id matches `\d{7}`, so it holds no path separators. `--chart` takes any path the caller gives. | None. The script only reads the file and prints no chart content except step titles. | accepted |
| S-004 | informational | config | ravintio-zero | No incomplete escaping found in the script. It builds no shell string, glob, or pattern from input. | None. | mitigated |

## Dependency Audit

| Package | Current Version | Known CVEs | Severity | Action Required |
|---------|----------------|------------|----------|----------------|
| none | none | none | low | none |

## Threat Model

| Threat | Attack Vector | Affected Component | Likelihood | Impact | Existing Mitigation | Gap |
|--------|--------------|-------------------|------------|--------|--------------------|----|
| Crafted chart title forges a pass | A title that matches a stray commit subject | ravintio-zero | low | low | A chart change goes through the same PR review as a commit | none |

## Recommendations

1. No action before release.

## Risk register cross-check

- R-001 accepted. The check runs only on a PR into `main`.
- R-002 mitigated. The script builds no regular expression.
- R-003 mitigated. The script names the paths it tried.
- R-004 mitigated. The 0000319 tests pass with chart fixtures.
