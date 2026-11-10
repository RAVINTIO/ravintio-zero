# Security Report - ready file helper

**Skill:** [validate-and-accept](../../ravintio-zero/skills/ravintio-validate-and-accept/SKILL.md)
**Feature:** 0000442-ready-file-helper
**Version:** 0.81.0

> It is advisory. The review makes no code changes.

## Summary

**Overall Risk Assessment:** low
**Components Reviewed:** ravintio-zero
**Review Scope:** code review

## Findings

| ID | Severity | Category | Component | Description | Recommendation | Status |
|----|----------|----------|-----------|-------------|----------------|--------|
| S-001 | low | injection | ravintio-zero | `recoverPr` in `initiative-run.mjs:870` passes the branch to `gh` as one argument and checks the feature id against `FEATURE` first. No shell runs. | None | mitigated |
| S-002 | low | injection | ravintio-zero | The `gh` answer is JSON. The driver accepts one number that matches `PR` and ignores all other text. | None | mitigated |
| S-003 | low | config | ravintio-zero | `RAVINTIO_GH_BIN` picks the program the driver runs. Only the person who starts the driver sets it, and `human-settings-check.mjs` already reads the same variable. | None | accepted |
| S-004 | low | path-traversal | ravintio-zero | `initiative-ready.mjs:34` and `readControl` refuse a symlink at the control folder and at the file. The helper writes a temporary file and renames it inside the folder. | None | mitigated |

## Dependency Audit

| Package | Current Version | Known CVEs | Severity | Action Required |
|---------|----------------|------------|----------|----------------|
| none added | not applicable | none | low | none |

## Threat Model

| Threat | Attack Vector | Affected Component | Likelihood | Impact | Existing Mitigation | Gap |
|--------|--------------|-------------------|------------|--------|--------------------|----|
| Recovery picks a wrong PR | Another open PR with the same head | ravintio-zero | low | medium | One open PR with the exact head, else stop | none |
| Write outside the control folder | Symlink at the folder or file | ravintio-zero | low | high | Both refuse a symlink | none |

## Recommendations

1. None. The code above mitigates risk register items R-001 to R-003.
