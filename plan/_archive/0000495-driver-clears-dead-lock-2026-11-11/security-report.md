# Security Report - Driver clears a dead lock

**Skill:** [validate-and-accept](../../ravintio-zero/skills/ravintio-validate-and-accept/SKILL.md)
**Feature:** 0000495-driver-clears-dead-lock
**Version:** 0.106.0

> It is advisory - the review makes no code changes.

## Summary

**Overall Risk Assessment:** low
**Components Reviewed:** ravintio-zero
**Review Scope:** code review

## Findings

| ID | Severity | Category | Component | Description | Recommendation | Status |
|----|----------|----------|-----------|-------------|----------------|--------|
| S-001 | low | config | ravintio-zero | `deadLockPid` in `src/ravintio-zero/scripts/initiative-run.mjs:659` reads the lock only after `isLink` is false and only accepts `^[1-9][0-9]{0,9}\n?$`. A planted lock cannot make the driver signal an arbitrary pid, because `process.kill(pid, 0)` sends no signal. | None | mitigated |
| S-002 | low | config | ravintio-zero | A reused pid reads as alive, so the driver refuses. This fails safe. | None | accepted |
| S-003 | low | config | ravintio-zero | Two drivers race for one dead lock in `takeLock` at line 674. The second `wx` write fails with `EEXIST` and the loser refuses. | None | mitigated |

## Dependency Audit

| Package | Current Version | Known CVEs | Severity | Action Required |
|---------|----------------|------------|----------|----------------|
| none added | n/a | none | low | none |

## Threat Model

| Threat | Attack Vector | Affected Component | Likelihood | Impact | Existing Mitigation | Gap |
|--------|--------------|-------------------|------------|--------|--------------------|----|
| Driver takes a live driver's lock | Lock names a pid that the check misreads as dead | ravintio-zero | low | medium | `alive` counts `EPERM` as alive. Text that is not one pid refuses. `wx` decides races. | none |

## Recommendations

1. None. The step adds no critical or high finding.
