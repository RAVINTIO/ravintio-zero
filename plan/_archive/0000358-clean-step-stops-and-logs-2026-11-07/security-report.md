# Security Report - Clean step stops and logs

**Skill:** [validate-and-accept](../skills/ravintio-validate-and-accept/SKILL.md)
**Feature:** 0000358-clean-step-stops-and-logs
**Version:** 0.55.0

> It is advisory - no code changes are made. All findings require human review before action.

## Summary

**Overall Risk Assessment:** low
**Components Reviewed:** ravintio-zero
**Review Scope:** code review of `ravintio-zero/scripts/build-log-check.mjs`, `ravintio-zero/tests/run-tests.sh`, and `ravintio-zero/tests/run-tests.ps1`

## Findings

| ID | Severity | Category | Component | Description | Recommendation | Status |
|----|----------|----------|-----------|-------------|----------------|--------|
| S-001 | informational | injection | ravintio-zero | `build-log-check.mjs` runs `git blame` with `execFileSync` and an argument array. The file name follows `--` and the working directory comes from the path. No shell reads the path, and the output is parsed by regex only. | none | mitigated |
| S-002 | low | config | ravintio-zero | `git blame` output is capped at 64 MB. A larger log makes the call throw, and the check falls back to the clock. | none | accepted |
| S-003 | informational | data-exposure | ravintio-zero | The runners print suite file names only. They print no path outside the `tests/` folder and no file content. | none | mitigated |
| S-004 | informational | config | ravintio-zero | The check reads the committer time, which a rebase moves later. A moved time can only widen the allowed gap, so a rebase never causes a false failure. | none | accepted |

## Dependency Audit

No dependency added or changed.

## Threat Model

| Threat | Attack Vector | Affected Component | Likelihood | Impact | Existing Mitigation | Gap |
|--------|--------------|-------------------|------------|--------|--------------------|----|
| A guessed time reaches ship | A phase types a time | `build-log-check.mjs` | medium | low | The new future-time check | A past guessed time passes |

## Risk register cross-check

- R-001: mitigated. The suite run found each pinned string.
- R-002: mitigated. The orchestrator skill is 8779 bytes of 9000, and skill text is 1602 lines of 1720.
- R-003: mitigated as S-004.
- R-004: open until P4 reads the clock for each ship time.

## Recommendations

None.
