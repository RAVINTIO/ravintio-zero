# Security Report - 0000548-ack-write-mid-suite-fails-run

**Feature:** 0000548-ack-write-mid-suite-fails-run
**Version:** minor bump

## Summary

**Overall Risk Assessment:** low
**Components Reviewed:** ravintio-zero
**Review Scope:** code review

## Findings

| ID | Severity | Category | Component | Description | Recommendation | Status |
|----|----------|----------|-----------|-------------|----------------|--------|
| S-001 | low | auth | ravintio-zero | `check-orchestrator-presence.mjs:suiteRunning` silences the strict banner while `plan/.suite-running` names a live pid in a step session. A process that writes the marker with a live pid can skip the ack prompt. | The window needs `RAVINTIO_INITIATIVE_STEP=1`, a 1 to 10 digit pid, and a live process. The ack still gates a non-step session. The chart pre-approved the cut-back. Accept. | accepted |
| S-002 | low | injection | ravintio-zero | `run-tests.sh` and `run-tests.ps1` write the pid to a fixed path. Both refuse a symlinked `plan/` or marker and leave a live marker of another runner alone. | None. | mitigated |
| S-003 | informational | config | ravintio-zero | The tree check does not exempt `plan/.orchestrator-ack`. The test covers this (AC-5). | None. | mitigated |

## Dependency Audit

No dependency added.

## Threat Model

| Threat | Attack Vector | Affected Component | Likelihood | Impact | Existing Mitigation | Gap |
|--------|--------------|-------------------|------------|--------|--------------------|----|
| Skipped ack prompt | A forged marker with a live pid | ravintio-zero | low | low | Step-session env check, digit pattern, liveness check | A recycled pid keeps the hook quiet until the process exits |
| Marker left after a crash | Runner killed mid-run | ravintio-zero | low | low | The hook checks the pid, so a dead pid counts as no marker | None |

## Recommendations

1. Accept S-001. No critical or high finding is open.
