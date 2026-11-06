# Security Report - CodeQL and branch cleanup in CI

**Skill:** [validate-and-accept](../skills/ravintio-validate-and-accept/SKILL.md)
**Feature:** 0000355-codeql-and-branch-cleanup
**Version:** 0.53.0

> It is advisory - no code changes are made. All findings require human review before action.

## Summary

**Overall Risk Assessment:** low
**Components Reviewed:** ravintio-zero
**Review Scope:** code review of `.github/workflows/codeql.yml`, the `cleanup-branch` job in `.github/workflows/ravintio.yml` and `ravintio-zero/hooks/ravintio.yml`, and the test helper `ravintio-zero/tests/helpers/unguarded-jobs.sh`

## Findings

| ID | Severity | Category | Component | Description | Recommendation | Status |
|----|----------|----------|-----------|-------------|----------------|--------|
| S-001 | low | config | ravintio-zero | `cleanup-branch` deletes any same-repo head branch except `main` and `master` once its PR merges. A long-lived branch such as `develop` or `release/*` merged into `main` is deleted. | Protect those branches with a ruleset that restricts deletion, as `Protect Main Branch` does for `main`. | open |
| S-002 | low | config | ravintio-zero | A `pull_request` workflow runs the PR's own copy of `ravintio.yml`. A same-repo PR author with write access could edit `cleanup-branch` to delete other branches. The author already has write access, and a ruleset blocks deletion of `main`. | Keep the ruleset that restricts deletion on `main`. Review workflow edits in PRs. | accepted |
| S-003 | low | dependency | ravintio-zero | `.github/workflows/codeql.yml` uses `github/codeql-action/init@v3` and `analyze@v3` by tag. The pack pins `actions/checkout` by commit SHA. | Pin both by SHA when Dependabot for `github-actions` lands (entry 0000323). | open |
| S-004 | informational | injection | ravintio-zero | `cleanup-branch` passes the head ref through `env`, never an inline expression. It rejects `..`, any character outside `A-Za-z0-9._/-`, a name over 200 characters, `main`, and `master` before the API call. Nine cases ran against a fake `gh`, and none deleted a protected or malformed name. | none | mitigated |
| S-005 | informational | auth | ravintio-zero | The only write scopes are `contents: write` on `cleanup-branch` and `release-tag`, and `security-events: write` on `analyze`. The top-level scope stays `contents: read`. The cleanup job has no checkout and runs no PR code. A fork head is skipped. | none | mitigated |

## Dependency Audit

| Package | Current Version | Known CVEs | Severity | Action Required |
|---------|----------------|------------|----------|----------------|
| github/codeql-action | v3 (tag) | none known | low | accept-risk, pin by SHA later (S-003) |

## Threat Model

| Threat | Attack Vector | Affected Component | Likelihood | Impact | Existing Mitigation | Gap |
|--------|--------------|-------------------|------------|--------|--------------------|----|
| Shell injection through the branch name | A branch named with shell text | `cleanup-branch` | low | high | `env` passing and the character check | none |
| Deleting a protected branch | A PR whose head is `main` | `cleanup-branch` | low | high | `main` and `master` refusal, and the ruleset | none |
| A changed job deletes other branches | A same-repo PR edits the workflow | `cleanup-branch` | low | medium | Write access is already required | Ruleset only covers `main` |

## Risk register cross-check

- R-001: mitigated by S-004 and S-005.
- R-002: mitigated by S-004.
- R-003: open. The step stops for the human if default setup is still on.
- R-004: mitigated. Every pull request job carries the closed guard or the marker, and the shape test checks it.
- R-005: accepted.

## Recommendations

1. Turn CodeQL default setup off in repo settings before the step merges.
2. Add a deletion restriction for long-lived branches (S-001).
3. Pin the CodeQL actions by SHA (S-003).
