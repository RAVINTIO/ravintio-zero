# Security Report - Driver removes merged step worktrees

**Skill:** [validate-and-accept](../../ravintio-zero/skills/ravintio-validate-and-accept/SKILL.md)
**Feature:** 0000501-remove-merged-worktrees
**Version:** 0.107.0

> It is advisory - the review makes no code changes.

## Summary

**Overall Risk Assessment:** low
**Components Reviewed:** ravintio-zero
**Review Scope:** code review

## Findings

| ID | Severity | Category | Component | Description | Recommendation | Status |
|----|----------|----------|-----------|-------------|----------------|--------|
| S-001 | low | config | ravintio-zero | `unsafeWorktree` and `sweepMergedWorktrees` in `src/ravintio-zero/scripts/initiative-run.mjs` run `git` through `spawnSync` with fixed arguments. The feature id passes the `FEATURE` pattern check before it reaches the branch name. No input reaches a shell. | None | mitigated |
| S-002 | low | config | ravintio-zero | `sweepMergedWorktrees` resolves the worktree path with `areaPath`, which refuses a symlink. A refusal becomes a `Kept:` line. | None | mitigated |
| S-003 | low | config | ravintio-zero | The sweep removes a worktree only after a clean `git status`, a head on origin, and no live pid. Every git failure keeps the worktree, so the check fails safe. | None | accepted |

## Dependency Audit

| Package | Current Version | Known CVEs | Severity | Action Required |
|---------|----------------|------------|----------|----------------|
| none added | n/a | none | low | none |

## Threat Model

| Threat | Attack Vector | Affected Component | Likelihood | Impact | Existing Mitigation | Gap |
|--------|--------------|-------------------|------------|--------|--------------------|----|
| The sweep deletes work | A merged step's worktree holds uncommitted or unpushed work | ravintio-zero | low | medium | The sweep keeps any worktree with uncommitted files, a head off origin, a live pid, or a git error. | none |

## Recommendations

1. None. The step adds no critical or high finding.
