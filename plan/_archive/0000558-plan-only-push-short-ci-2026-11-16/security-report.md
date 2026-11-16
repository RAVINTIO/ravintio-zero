---
title: "Security Report - 0000558-plan-only-push-short-ci"
summary: "Advisory review of the concurrency block."
---
# Security Report - 0000558-plan-only-push-short-ci

> It is advisory.

## Summary

**Overall Risk Assessment:** low
**Components Reviewed:** ravintio-zero
**Review Scope:** code review

## Findings

| Finding | Location | Severity | Mitigation |
|---------|----------|----------|------------|
| The group reads only the workflow name, the pull request number, the commit, and the event action. It reads no head ref or title text. | .github/workflows/ravintio.yml, top-level concurrency block | Low | Mitigated. A test pins the absence of head ref and title text. |
| A push run could cancel a release tag job. | .github/workflows/ravintio.yml, cancel-in-progress | Low | Mitigated. A push run keys on its commit and never cancels. |
| The change adds no permission, secret, or dependency. | .github/workflows/ravintio.yml | Low | Not applicable. |

## Risk register

The group key mitigates R-001, and the push rule mitigates R-002. The new suite checks both.

## Top actions before production

None.
