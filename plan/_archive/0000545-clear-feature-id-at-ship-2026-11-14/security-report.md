---
title: "Security report - 0000545-clear-feature-id-at-ship"
summary: "Security review of the feature id fix. No findings above low."
status: "active"
version: "0.1.0"
---
# Security report - 0000545-clear-feature-id-at-ship

**Skill:** [validate-and-accept](../../ravintio-zero/skills/ravintio-validate-and-accept/SKILL.md)
**Feature:** 0000545-clear-feature-id-at-ship
**Version:** 0.115.0

> The review is advisory. It makes no code changes.

## Summary

**Overall risk assessment:** low
**Components reviewed:** ravintio-zero pack scripts and skills
**Review scope:** code review

## Findings

| ID | Severity | Category | Component | Description | Recommendation | Status |
|----|----------|----------|-----------|-------------|----------------|--------|
| S-001 | low | injection | `ravintio-zero/scripts/shared-files.mjs` | `resolveFeatureId` passes a fixed path constant to `git` and `fs`. No user input reaches it. | None. | accepted |
| S-002 | informational | data-exposure | `plan/.feature-id` | The file holds a feature id only. The change removes it from the tracked tree. | None. | mitigated |

## Dependency audit

The change adds no dependency.

## Threat model

| Threat | Attack vector | Affected component | Likelihood | Impact | Existing mitigation | Gap |
|--------|---------------|--------------------|------------|--------|---------------------|-----|
| Path traversal in the resolver | Crafted conflict path | `shared-files.mjs` | low | low | The resolver matches the exact path `plan/.feature-id` | None |

## Risk register cross-reference

- R-001: mitigated. The pinned Step 8 text tests pass.
- R-002: mitigated. Resume detection handles a missing id file.

## Recommendations

1. None before release.
