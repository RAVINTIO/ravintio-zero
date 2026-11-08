# Security Report - Ship postmortems

**Skill:** [validate-and-accept](../../ravintio-zero/skills/ravintio-validate-and-accept/SKILL.md)
**Feature:** 0000392-ship-postmortems
**Version:** 0.60.0

## Summary

**Overall Risk Assessment:** low
**Components Reviewed:** ravintio-zero
**Review Scope:** code review

## Findings

| ID | Severity | Category | Component | Description | Recommendation | Status |
|----|----------|----------|-----------|-------------|----------------|--------|
| S-001 | low | path traversal | ravintio-zero | `build-log-check.mjs` reads the record path from a `Postmortem:` line. A log could name a file outside `plan/postmortems/`. | The check only reads the file and prints findings, never its content. The log is a repo file the run wrote. Accepted. | accepted |
| S-002 | low | injection | ravintio-zero | `merge-queue.mjs` prints check names from `gh` in its stop message. | The names print as text and reach no command. Every `gh` and `git` call keeps an argument array. Accepted. | accepted |

## Dependency Audit

| Package | Current Version | Known CVEs | Severity | Action Required |
|---------|----------------|------------|----------|----------------|
| none added | none | none | low | none |

## Threat Model

| Threat | Attack Vector | Affected Component | Likelihood | Impact | Existing Mitigation | Gap |
|--------|--------------|-------------------|------------|--------|--------------------|----|
| Credential in a committed file | Postmortem or doc text | ravintio-zero | low | low | The credential scan found none in the diff | none |
