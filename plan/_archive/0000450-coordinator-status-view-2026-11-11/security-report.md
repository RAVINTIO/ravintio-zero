# Security Report - 0000450-coordinator-status-view

**Skill:** [validate-and-accept](../skills/ravintio-validate-and-accept/SKILL.md)
**Feature:** 0000450-coordinator-status-view
**Version:** set by the merge queue at merge

> It is advisory - the review makes no code changes. All findings require human review before action.

## Summary

**Overall Risk Assessment:** low
**Components Reviewed:** ravintio-zero
**Review Scope:** code review

## Findings

| ID | Severity | Category | Component | Description | Recommendation | Status |
|----|----------|----------|-----------|-------------|----------------|--------|
| S-001 | low | injection | ravintio-zero | `scripts/initiative-status.mjs` printed stop text from build logs and step logs with control characters intact. A hostile line could move the cursor or colour the terminal. | Replace control characters with a space before printing. | mitigated |
| S-002 | informational | config | ravintio-zero | `scripts/initiative-run.mjs` writes the queue stop line to the step log. The reason is the last line of queue output, cut to 500 characters. | Readers treat the line as data. The watcher and the script both remove control characters. | accepted |
| S-003 | informational | config | ravintio-zero | `scripts/initiative-watch.mjs` and `scripts/initiative-status.mjs` read step logs and build logs by path. | Both refuse a symlink at each plan path, and a suite covers the status script. | mitigated |

## Dependency Audit

| Package | Current Version | Known CVEs | Severity | Action Required |
|---------|----------------|------------|----------|----------------|
| none added | not applicable | none | not applicable | none |

## Threat Model

| Threat | Attack Vector | Affected Component | Likelihood | Impact | Existing Mitigation | Gap |
|--------|--------------|-------------------|------------|--------|--------------------|----|
| Terminal escape in a stop line | A log or queue output line holds control characters | ravintio-zero | low | low | Control characters are removed before printing | none |
| Symlinked plan path | A symlink redirects a read | ravintio-zero | low | low | Symlink refusal at plan paths | none |

The status script writes no file, runs no process, and builds no shell string. The new guard widening: none.

## Recommendations

1. None open.
