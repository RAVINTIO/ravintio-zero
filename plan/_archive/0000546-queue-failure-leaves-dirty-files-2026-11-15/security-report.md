# Security Report - 0000546-queue-failure-leaves-dirty-files

**Skill:** [validate-and-accept](../skills/ravintio-validate-and-accept/SKILL.md)
**Feature:** 0000546-queue-failure-leaves-dirty-files
**Version:** 0.1.0

> It is advisory. The review makes no code changes.

## Summary

**Overall Risk Assessment:** low
**Components Reviewed:** ravintio-zero
**Review Scope:** code review

The change adds `restoreWrittenFiles` to `merge-queue.mjs`, one ADR, two doc edits, and one shell test. It adds no dependency and no credential handling.

## Findings

| ID | Severity | Category | Component | Description | Recommendation | Status |
|----|----------|----------|-----------|-------------|----------------|--------|
| S-001 | informational | injection | ravintio-zero | `restoreWrittenFiles` passes paths to `git` through `execFileSync` with an argument array and a `--` separator. The paths come from the chart path and `version-files.txt`, so no shell parses them. | None. | false-positive |
| S-002 | informational | data exposure | ravintio-zero | `git restore` discards written changes. It names each path, runs only after the clean-tree check passed, and never uses `reset --hard` or `clean`. | None. | false-positive |

## Dependency Audit

| Package | Current Version | Known CVEs | Severity | Action Required |
|---------|----------------|------------|----------|----------------|
| none added | n/a | none | n/a | none |

## Threat Model

| Threat | Attack Vector | Affected Component | Likelihood | Impact | Existing Mitigation | Gap |
|--------|--------------|-------------------|------------|--------|--------------------|----|
| The restore discards an unrelated change | A tracked change in the queue worktree | ravintio-zero | low | low | The clean-tree check at the start of `run`, and named paths | none |

## Recommendations

1. None. The code mitigates R-001 and R-002 in the risk register.
