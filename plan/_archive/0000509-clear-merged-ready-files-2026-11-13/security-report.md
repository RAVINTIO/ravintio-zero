# Security Report - Driver clears ready files of merged steps

**Skill:** [validate-and-accept](../../ravintio-zero/skills/ravintio-validate-and-accept/SKILL.md)
**Feature:** 0000509-clear-merged-ready-files
**Version:** 0.110.0

> It is advisory - the review makes no code changes.

## Summary

**Overall Risk Assessment:** low
**Components Reviewed:** ravintio-zero
**Review Scope:** code review

## Findings

| ID | Severity | Category | Component | Description | Recommendation | Status |
|----|----------|----------|-----------|-------------|----------------|--------|
| S-001 | low | path-traversal | ravintio-zero | `clearMergedReadyFiles` in `src/ravintio-zero/scripts/initiative-run.mjs:1045` resolves the control folder with `areaPath` and refuses a symlinked folder or a symlinked `ready` file. A refusal becomes a `Kept:` line. The step number passes the `POSITION` pattern in `recFor` before it reaches the path. | None | mitigated |
| S-002 | low | config | ravintio-zero | The pass removes one fixed file name with `rmSync` and runs no shell and no `git` command. | None | mitigated |
| S-003 | low | config | ravintio-zero | The pass removes a file only when no live pid sits in the `running` file. Every error keeps the file, so the check fails safe. | None | accepted |

## Dependency Audit

| Package | Current Version | Known CVEs | Severity | Action Required |
|---------|----------------|------------|----------|----------------|
| none added | n/a | none | low | none |

## Threat Model

| Threat | Attack Vector | Affected Component | Likelihood | Impact | Existing Mitigation | Gap |
|--------|--------------|-------------------|------------|--------|--------------------|----|
| The pass deletes a file outside the control folder | A symlink at `step-{n}` or at `ready` | ravintio-zero | low | medium | `areaPath` and the `isLink` check refuse a symlink, and a test pins the symlinked folder. | none |
| The pass removes the file of a running step | A merged step with a live session | ravintio-zero | low | low | The pass keeps the file while a live pid sits in `running`. | none |

## Recommendations

1. None. The step adds no critical or high finding.
