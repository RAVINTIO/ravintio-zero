# Security Report - 0000581-delivery-cleans-up-driver-state

**Skill:** [validate-and-accept](../skills/ravintio-validate-and-accept/SKILL.md)
**Feature:** 0000581-delivery-cleans-up-driver-state
**Version:** 0.151.0

> It is advisory. The review makes no code changes.

## Summary

**Overall Risk Assessment:** low
**Components Reviewed:** ravintio-zero
**Review Scope:** code review

## Findings

| ID | Severity | Category | Component | Description | Recommendation | Status |
|----|----------|----------|-----------|-------------|----------------|--------|
| S-001 | low | config | ravintio-zero | `scripts/initiative-cleanup.mjs` runs `git worktree remove --force` on each folder under `plan/.initiative-worktrees/`. A coordinator who runs it before the PR merges loses uncommitted work in a worktree. | The rule `rm-delivery-cleanup` says to run it after the human merges the PR, and the lock check blocks it while a driver runs. | accepted |
| S-002 | informational | injection | ravintio-zero | The `--id` value names an archive folder. `initiative-cleanup.mjs:parseArgs` accepts only letters, digits, dashes, and inner dots, and caps it at 100 characters. A test sends `../escape`. | None. | mitigated |
| S-003 | informational | config | ravintio-zero | The script refuses a symlink at `plan/`, each driver folder, and the archive base. A test covers `plan/.initiative-logs`. | None. | mitigated |

## Dependency Audit

| Package | Current Version | Known CVEs | Severity | Action Required |
|---------|----------------|------------|----------|----------------|
| none | none | none | low | none |

## Threat Model

| Threat | Attack Vector | Affected Component | Likelihood | Impact | Existing Mitigation | Gap |
|--------|--------------|-------------------|------------|--------|--------------------|----|
| Removal of a path outside the repo | Hostile `--id` or a symlinked folder | initiative-cleanup.mjs | low | medium | Id pattern and symlink refusal | none |
| Early run removes live worktrees | Coordinator runs the script while a driver runs | initiative-cleanup.mjs | low | medium | Lock check, delivery order | A stale lock after a crash blocks the run until a human removes it |

Risk register R-001 to R-004: The lock check mitigates R-001, and the symlink refusal mitigates R-003. R-002 holds at 118 lines. R-004 holds because the script has no removal in a shared temp folder, and the scan pattern finds none.

## Recommendations

1. None. No critical or high finding.
