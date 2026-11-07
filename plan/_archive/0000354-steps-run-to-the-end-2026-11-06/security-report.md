# Security Report - Steps run to the end

**Skill:** [validate-and-accept](../../ravintio-zero/skills/ravintio-validate-and-accept/SKILL.md)
**Feature:** 0000354-steps-run-to-the-end
**Version:** 0.52.0

> It is advisory - no code changes are made. All findings require human review before action.

## Summary

**Overall Risk Assessment:** low
**Components Reviewed:** ravintio-zero
**Review Scope:** code review of `ravintio-zero/scripts/initiative-run.mjs`, `ravintio-zero/scripts/initiative-watch.mjs`, the `write_setup_config_override` function in `ravintio-zero/setup.sh`, and the matching `setup.ps1` block

## Findings

| ID | Severity | Category | Component | Description | Recommendation | Status |
|----|----------|----------|-----------|-------------|----------------|--------|
| S-001 | informational | injection | ravintio-zero | The driver passes the session id to `claude` as one element of an argument array through `spawn`. It builds no shell string (`initiative-run.mjs`, `runStep`). | None. | mitigated |
| S-002 | informational | injection | ravintio-zero | The driver checks the session id against `^[A-Za-z0-9_-]{8,128}$` before it uses it. An id that starts with a dash, holds a space, or holds shell text fails the check, so no option or command reaches `claude`. A test plants `--bad id; touch pwned` and confirms nothing runs. | None. | mitigated |
| S-003 | informational | incomplete escaping | ravintio-zero | `SESSION_FIELD` is a fixed regular expression that reads the stream text. No pattern is built from the stream, the chart, or the environment. The watcher's step-log name pattern `^step-([0-9]{1,4})\.log$` is also fixed. | None. | mitigated |
| S-004 | low | resource use | ravintio-zero | The driver keeps up to 4096 bytes of a split stream line between chunks, so a child cannot grow the buffer without limit. | None. | mitigated |
| S-005 | informational | data exposure | ravintio-zero | The driver never prints the session id or any log content. The resume line holds only the step number and the count. | None. | mitigated |
| S-006 | informational | path traversal | ravintio-zero | The watcher reads step-log names from `plan/.initiative-logs/` after `refuseLinks`, and joins only names that match the fixed pattern. | None. | mitigated |
| S-007 | informational | config | ravintio-zero | Setup writes a candidate file next to the record, compares it, and either removes it or moves it over the record. No path comes from outside input. No guard changes. `merge-guard` and the other fail-closed hooks keep their rules. | None. | mitigated |

## Dependency Audit

| Package | Current Version | Known CVEs | Severity | Action Required |
|---------|----------------|------------|----------|----------------|
| none | none | none | low | none |

## Threat Model

| Threat | Attack Vector | Affected Component | Likelihood | Impact | Existing Mitigation | Gap |
|--------|--------------|-------------------|------------|--------|--------------------|----|
| A crafted stream event steers `claude` to run an option | A `session_id` that holds dashes or shell text | ravintio-zero | low | medium | Pattern check and argument array | none |
| A resume loop burns turns | A step that always exits 0 unmerged | ravintio-zero | low | low | Cap of two resumes | none |

## Recommendations

1. No action before release.

## Risk register cross-check

- R-001 open. The continue prompt tells the session to read the build log first, and the cap ends a loop.
- R-002 mitigated. See S-001 and S-002.
- R-003 accepted. Setup rewrites a hand-edited record, as it did before.
- R-004 mitigated. The watcher ignores attempt logs and takes the newest log by modified time.
- R-005 open. The standards limit an `allowed` fix to the step's own scope, and P3 reviews the PR.
