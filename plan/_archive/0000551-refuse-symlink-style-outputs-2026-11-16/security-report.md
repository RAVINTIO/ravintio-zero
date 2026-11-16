# Security Report - Refuse a symlink at the writing style output paths

**Skill:** [validate-and-accept](../skills/ravintio-validate-and-accept/SKILL.md)
**Feature:** 0000551-refuse-symlink-style-outputs
**Version:** 0.137.0

> It is advisory. The review makes no code changes.

## Summary

**Overall Risk Assessment:** low
**Components Reviewed:** ravintio-zero
**Review Scope:** code review

## Findings

| ID | Severity | Category | Component | Description | Recommendation | Status |
|----|----------|----------|-----------|-------------|----------------|--------|
| S-001 | low | config | ravintio-zero | `write_boot_file` in `setup.sh` writes `AGENTS.md` through a link. The writing block no longer reaches the target, but the boot content does. | Refuse a link in the boot file write. File a backlog entry. | open |
| S-002 | informational | config | ravintio-zero | The link check and the write are two steps, so a link planted between them wins. Setup runs in the repo owner's own tree. | Accept. | accepted |

## Dependency Audit

| Package | Current Version | Known CVEs | Severity | Action Required |
|---------|----------------|------------|----------|----------------|
| none added | n/a | none | low | none |

## Threat Model

| Threat | Attack Vector | Affected Component | Likelihood | Impact | Existing Mitigation | Gap |
|--------|--------------|-------------------|------------|--------|--------------------|----|
| Link redirects a style write | A link at the style file, its folder, or `AGENTS.md` | ravintio-zero | low | medium | Link check in `setup.sh` and `setup.ps1` | The boot file write (S-001) |

## Recommendations

1. Refuse a link at the boot file write.
