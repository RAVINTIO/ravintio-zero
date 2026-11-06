# Security Report - Reshape at delivery

**Skill:** [validate-and-accept](../../ravintio-zero/skills/ravintio-validate-and-accept/SKILL.md)
**Feature:** 0000353-reshape-at-delivery
**Version:** 0.51.0

> It is advisory - no code changes are made. All findings require human review before action.

## Summary

**Overall Risk Assessment:** low
**Components Reviewed:** ravintio-zero
**Review Scope:** code review of `ravintio-zero/scripts/reshape-initiative.mjs`

## Findings

| ID | Severity | Category | Component | Description | Recommendation | Status |
|----|----------|----------|-----------|-------------|----------------|--------|
| S-001 | informational | injection | ravintio-zero | `reshape-initiative.mjs` runs git through `execFileSync` and `spawnSync` with argument arrays. It builds no shell string. | None. | mitigated |
| S-002 | informational | injection | ravintio-zero | Every caller value is checked before use: `--branch` and `--remote` against `BRANCH_RE` (starts with a letter or digit), `--assign` hashes against a hex pattern, step numbers as digits, and chart versions against `TAG_RE`. A branch name that starts with a dash is rejected, so no value reaches git as an option. | None. | mitigated |
| S-003 | informational | injection | ravintio-zero | No incomplete escaping found. The script builds no regular expression, glob, or pattern from the chart or the caller. Chart titles go to git as the `-m` argument value only. | None. | mitigated |
| S-004 | low | data integrity | ravintio-zero | Moving a local tag deletes it before it creates the new one. A failure between the two steps would lose the tag. | The script now restores the old tag object with `git update-ref` and exits 1 if the create fails. | mitigated |
| S-005 | low | data integrity | ravintio-zero | With `--push`, the remote tag is deleted before the new tag is pushed. A failed push leaves the tag absent on the remote. | The script pushes the branch first, then stops on the first failure and prints the exact tag to push by hand. The local tag exists, so recovery is one command. | accepted |
| S-006 | informational | config | ravintio-zero | No guard changes. The script uses a delete refspec for remote tags and no force option. The ship skill change removes an allowance and widens nothing. `merge-guard` and the other fail-closed hooks keep their rules. | None. | mitigated |

## Dependency Audit

| Package | Current Version | Known CVEs | Severity | Action Required |
|---------|----------------|------------|----------|----------------|
| none | none | none | low | none |

## Threat Model

| Threat | Attack Vector | Affected Component | Likelihood | Impact | Existing Mitigation | Gap |
|--------|--------------|-------------------|------------|--------|--------------------|----|
| A crafted branch or hash steers git to run an option | A value that starts with a dash or holds shell text | ravintio-zero | low | medium | Name patterns and argument arrays | none |
| A crafted chart title injects a git message | A newline or option text in a `Title` cell | ravintio-zero | low | low | The title is one table cell and passes as a `-m` value | none |

## Recommendations

1. No action before release.

## Risk register cross-check

- R-001 open. The script stops and names the commit.
- R-002 accepted. The delivery rules state the trade-off.
- R-003 mitigated. See S-002.
- R-004 accepted. See S-005.
- R-005 mitigated. The script checks the git version before it starts.
