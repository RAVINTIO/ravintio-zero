# Security Report - Driver keeps starting steps after a Restart

**Skill:** [validate-and-accept](../skills/ravintio-validate-and-accept/SKILL.md)
**Feature:** 0000493-driver-starts-after-restart
**Version:** 0.105.0

> It is advisory. The review makes no code changes.

## Summary

**Overall Risk Assessment:** low
**Components Reviewed:** ravintio-zero
**Review Scope:** code review of `initiative-run.mjs` (handoff, adoption, `stopped` file) and a threat model

## Findings

| ID | Severity | Category | Component | Description | Recommendation | Status |
|----|----------|----------|-----------|-------------|----------------|--------|
| S-001 | informational | injection | ravintio-zero | `spawnSuccessor` in `scripts/initiative-run.mjs` starts `process.execPath` with a fixed argument list. The root comes from `--root` and the pid from `process.pid`. No shell runs. | None. | mitigated |
| S-002 | low | injection | ravintio-zero | `parseArgs` accepts `--handoff` only with 1 to 10 digits. Any other value stops the driver with `Blocked:`. | None. | mitigated |
| S-003 | low | data-exposure | ravintio-zero | `readStopped` reads the `stopped` file as data. It keeps the first line, cuts it to 500 characters, refuses a symlink, and passes it to no shell. A test feeds 2,000 characters. | None. | mitigated |
| S-004 | low | config | ravintio-zero | Adoption trusts the pid in `running` only when it equals the `--handoff` pid and that pid lives. A reused pid could hold a step in `running` until the poll sees `ready`, a `stopped` file, or a dead pid. | Accept. The coordinator can stop the driver. | accepted |
| S-005 | low | config | ravintio-zero | The detached successor inherits the full environment, as every step session already does. No new variable passes to it. | None. | accepted |
| S-006 | informational | config | ravintio-zero | The successor refuses to run unless the lock file holds its own pid. A process that runs `--handoff` by hand stops after 5 seconds. | None. | mitigated |

## Dependency Audit

| Package | Current Version | Known CVEs | Severity | Action Required |
|---------|----------------|------------|----------|----------------|
| none added | not applicable | none | low | none |

## Threat Model

| Threat | Attack Vector | Affected Component | Likelihood | Impact | Existing Mitigation | Gap |
|--------|--------------|-------------------|------------|--------|--------------------|----|
| A second driver starts a duplicate session | A bad pid check in the successor | ravintio-zero | low | high | Pid equality and liveness check. A test counts session starts. | none |
| A forged `stopped` file stops the initiative | A local user writes into the control folder | ravintio-zero | low | low | The folder has mode 700. The file only stops new starts. | A local user with write access can already edit the chart. |
| Two drivers queue one PR | The old driver queues after the handoff | ravintio-zero | low | high | `handedOff` disables the queue and clears `readyOrder`. A test counts queue runs. | none |

## Recommendations

1. None before release. Review S-004 if a pid reuse ever stalls a handoff.
