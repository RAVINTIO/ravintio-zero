# Security Report - Give each step session a private temp folder

**Skill:** [validate-and-accept](../skills/ravintio-validate-and-accept/SKILL.md)
**Feature:** 0000583-step-temp-cleanup-after-merge
**Version:** 0.146.0

> It is advisory - the review makes no code changes. All findings require human review before action.

## Summary

**Overall Risk Assessment:** low
**Components Reviewed:** ravintio-zero
**Review Scope:** code review

## Findings

| ID | Severity | Category | Component | Description | Recommendation | Status |
|----|----------|----------|-----------|-------------|----------------|--------|
| S-001 | low | config | ravintio-zero | `sandboxSettings` in `scripts/initiative-run.mjs` assumes Claude Code honours `sandbox.enabled` and `sandbox.filesystem.allowWrite`. A changed key leaves the session unsandboxed. | Run one real step and check that a write to the shared `/tmp` fails. | open |
| S-002 | low | config | ravintio-zero | `RAVINTIO_TEMP_PATH_LIMIT` in `scripts/initiative-run.mjs` replaces the socket path check. A wrong value only skips a check and widens no access. | None. | accepted |
| S-003 | informational | data-exposure | ravintio-zero | `removeMergedWorktree` runs `git worktree remove --force` on `plan/.initiative-worktrees/step-{n}`. The path comes from `areaPath`, which refuses a symlink and a path outside the area. The queue already removed the worktree before the merge. | None. | mitigated |
| S-004 | informational | injection | ravintio-zero | The `--settings` JSON comes from `JSON.stringify` and the child gets it as one argument, with no shell. | None. | mitigated |

## Dependency Audit

| Package | Current Version | Known CVEs | Severity | Action Required |
|---------|----------------|------------|----------|----------------|
| none added | n/a | none | low | none |

## Threat Model

| Threat | Attack Vector | Affected Component | Likelihood | Impact | Existing Mitigation | Gap |
|--------|--------------|-------------------|------------|--------|--------------------|----|
| A script deletes another project's files | Name-based removal in a shared temp folder | ravintio-zero | low | high | The driver has no such removal, and `test-0000583-req-003` scans the pack scripts and plants files outside the repo | The scan matches patterns, not every possible removal |
| A step session writes outside its worktree | `--permission-mode auto` checks only the top-level command | ravintio-zero | medium | high | Sandbox with `allowWrite` limited to three folders | S-001 |

## Recommendations

1. Confirm the sandbox blocks a write to the shared `/tmp` in the first real step after merge (S-001).
