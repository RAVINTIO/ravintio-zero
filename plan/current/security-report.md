# Security Report - driver setup stop

**Skill:** [validate-and-accept](../skills/ravintio-validate-and-accept/SKILL.md)
**Feature:** 0000313-driver-setup-stop
**Version:** 0.41.0

> It is advisory - no code changes are made. All findings require human review before action.

## Summary

**Overall Risk Assessment:** low
**Components Reviewed:** ravintio-zero
**Review Scope:** code review

## Findings

| ID | Severity | Category | Component | Description | Recommendation | Status |
|----|----------|----------|-----------|-------------|----------------|--------|
| S-001 | low | injection | ravintio-zero | `ravintio-zero/scripts/initiative-run.mjs` prints file names from `git diff --name-only` in the stop line. A name with control characters could reach the terminal. | Git quotes such names in octal by default (`core.quotePath`), and the line is not parsed as input. No change. | accepted |
| S-002 | low | config | ravintio-zero | The initiative skill reruns a setup command. A wrong command would run shell code. | The skill runs only the exact command a `Confirmation:` row names, and stops otherwise. The text sits in `ravintio-zero/skills/ravintio-initiative/SKILL.md`. No guard changes. | mitigated |

## Dependency Audit

| Package | Current Version | Known CVEs | Severity | Action Required |
|---------|----------------|------------|----------|----------------|
| none added | n/a | none | low | none |

## Threat Model

| Threat | Attack Vector | Affected Component | Likelihood | Impact | Existing Mitigation | Gap |
|--------|--------------|-------------------|------------|--------|--------------------|----|
| Setup runs an unapproved command | A tampered initiative table | ravintio-zero | low | medium | The exact-command rule and the human chart approval | none |
| The check leaves stale copies in place | Unreadable git skips the check | ravintio-zero | low | low | The same skip exists for the restart stop | accepted |

## Recommendations

1. None. No critical or high finding is open.
2. The credential scan of the changed files found no secret.
