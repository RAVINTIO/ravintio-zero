# Security report - 0000319-initiative-history-checks

**Feature:** 0000319-initiative-history-checks

## Summary

**Overall risk assessment:** low
**Components reviewed:** `ravintio-zero/scripts`, `.github/workflows/ravintio.yml`, `ravintio-zero/hooks/ravintio.yml`
**Review scope:** code review

## Findings

| ID | Severity | Category | Component | Description | Recommendation | Status |
|----|----------|----------|-----------|-------------|----------------|--------|
| S-001 | low | config | `.github/workflows/ravintio.yml` (`initiative-history`) | The job passes `github.head_ref` through an `env` variable, not inline, so a branch name cannot inject shell. | None. | mitigated |
| S-002 | low | config | `.github/workflows/ravintio.yml` (`release-tag`) | The push trigger now fires on `initiative/**`. The `if` limits `release-tag` to `main` and `master`, so it cannot tag an initiative push (R-001). | None. | mitigated |
| S-003 | low | injection | `ravintio-zero/scripts/check-initiative-history.mjs` | The script calls `git` with `execFileSync` and an argument array, so refs cannot inject shell. | None. | mitigated |
| S-004 | low | config | both new jobs | Both jobs set `contents: read` and `persist-credentials: false`, and pin checkout to a commit. | None. | mitigated |

## Dependency audit

No new dependencies. The scripts use Node built-ins only.

## Recommendations

1. Apply the merge-commit-only ruleset on `main` (see `ravintio-zero/docs/main-ruleset.md`). The human does this in repository settings.

## Risk register cross-check

- R-001: mitigated by the `release-tag` `if`.
- R-002: open by design. The ruleset is the first defence.
- R-003 and R-004: open by design. The step documents the response.

No critical or high findings.
