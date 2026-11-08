# Security Report - Writing standard

**Skill:** [validate-and-accept](../../ravintio-zero/skills/ravintio-validate-and-accept/SKILL.md)
**Feature:** 0000389-writing-standard
**Version:** 0.61.0

## Summary

**Overall Risk Assessment:** low
**Components Reviewed:** ravintio-zero
**Review Scope:** code review

## Findings

| ID | Severity | Category | Component | Description | Recommendation | Status |
|----|----------|----------|-----------|-------------|----------------|--------|
| S-001 | informational | injection | ravintio-zero | `setup.sh` and `setup.ps1` pass paths to node through environment variables and call `spawnSync` with no shell. No `eval`. | None | accepted |
| S-002 | low | config | ravintio-zero | Setup writes `.claude/output-styles/ravintio-writing.md` and `AGENTS.md` inside the project root. A symlink at either path would redirect the write. The existing boot file write has the same behaviour. | Refuse a symlink at both paths in a later step | open |
| S-003 | informational | data-exposure | ravintio-zero | The generated text holds no secrets and no environment values. | None | accepted |

## Dependency Audit

| Package | Current Version | Known CVEs | Severity | Action Required |
|---------|----------------|------------|----------|----------------|
| none | none | none | low | accept-risk |

## Threat Model

| Threat | Attack Vector | Affected Component | Likelihood | Impact | Existing Mitigation | Gap |
|--------|--------------|-------------------|------------|--------|--------------------|----|
| Redirected write | Symlink at the output path | ravintio-zero | low | low | Writes stay a developer's own repo | No symlink check on the two new paths |

## Recommendations

1. Add a symlink refusal for the two new output paths (S-002).
