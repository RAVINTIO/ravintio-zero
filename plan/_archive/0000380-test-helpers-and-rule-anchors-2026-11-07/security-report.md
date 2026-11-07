# Security Report - Test helpers and rule anchors

**Skill:** [validate-and-accept](../../ravintio-zero/skills/ravintio-validate-and-accept/SKILL.md)
**Feature:** 0000380-test-helpers-and-rule-anchors
**Version:** 0.60.0

## Summary

**Overall Risk Assessment:** low
**Components Reviewed:** ravintio-zero
**Review Scope:** code review

## Findings

| ID | Severity | Category | Component | Description | Recommendation | Status |
|----|----------|----------|-----------|-------------|----------------|--------|
| S-001 | low | injection | ravintio-zero | `rule_text` in `tests/helpers/assert.sh` puts its id argument into a grep and awk pattern. A caller that passes regex characters changes the match. | Only test code calls it with literal ids, and the anchor suite rejects ids outside `[a-z0-9-]`. Accepted. | accepted |
| S-002 | low | config | ravintio-zero | `with_timeout` in `tests/helpers/timeout.sh` creates a temporary flag path under `TMPDIR` and removes it. | `mktemp` gives a unique name and the helper removes it on both exits. Accepted. | accepted |

## Dependency Audit

| Package | Current Version | Known CVEs | Severity | Action Required |
|---------|----------------|------------|----------|----------------|
| none added | none | none | low | none |

## Threat Model

| Threat | Attack Vector | Affected Component | Likelihood | Impact | Existing Mitigation | Gap |
|--------|--------------|-------------------|------------|--------|--------------------|----|
| Credential in a committed file | Anchor or doc text | ravintio-zero | low | low | The credential scan found none in the diff | none |

## Recommendations

1. None. The helpers read pack files and run caller commands, and they handle no untrusted input.
