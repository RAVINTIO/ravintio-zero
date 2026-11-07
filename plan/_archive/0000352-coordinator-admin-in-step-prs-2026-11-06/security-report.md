# Security Report - Coordinator admin in step PRs

**Skill:** [validate-and-accept](../../ravintio-zero/skills/ravintio-validate-and-accept/SKILL.md)
**Feature:** 0000352-coordinator-admin-in-step-prs
**Version:** 0.50.0

> It is advisory - no code changes are made. All findings require human review before action.

## Summary

**Overall Risk Assessment:** low
**Components Reviewed:** ravintio-zero
**Review Scope:** code review

## Findings

| ID | Severity | Category | Component | Description | Recommendation | Status |
|----|----------|----------|-----------|-------------|----------------|--------|
| S-001 | informational | injection | ravintio-zero | `ravintio-zero/scripts/reserve-id.mjs` `currentBranch()` runs `git rev-parse --abbrev-ref HEAD` through `execFileSync` with an argument array. The `cwd` comes from the `--file` path. No shell string is built. | None. | mitigated |
| S-002 | informational | config | ravintio-zero | The refusal tightens a script. No guard changes, so `merge-guard` and the other fail-closed hooks keep their rules. | None. | mitigated |
| S-003 | low | config | ravintio-zero | The step writes a queue item's content to the `**Destination:**` path in `roadmap-standards.md` (I-C Run). A destination outside the repo or over a protected file is possible if the coordinator writes one. | The coordinator is the human's own session and the step stages by explicit path. The hook `gate-write` still blocks protected paths. The PR diff shows every destination. | accepted |
| S-004 | informational | injection | ravintio-zero | No incomplete escaping found in the script change. It builds no shell string, glob, or pattern from input. | None. | mitigated |

## Dependency Audit

| Package | Current Version | Known CVEs | Severity | Action Required |
|---------|----------------|------------|----------|----------------|
| none | none | none | low | none |

## Threat Model

| Threat | Attack Vector | Affected Component | Likelihood | Impact | Existing Mitigation | Gap |
|--------|--------------|-------------------|------------|--------|--------------------|----|
| A queue item steers a step to write a protected file | A crafted `**Destination:**` line | ravintio-zero | low | medium | `gate-write` blocks protected paths, and the PR diff goes through review | none |

## Recommendations

1. No action before release.

## Risk register cross-check

- R-001 open. The rule and the PR diff cover it.
- R-002 mitigated. The three callers name the route.
- R-003 mitigated. A failed lookup returns an empty name and the old behaviour holds.
- R-004 accepted. The step commits the destination, so the PR shows the result.
- R-005 mitigated. The full suite passes with the updated wording.
