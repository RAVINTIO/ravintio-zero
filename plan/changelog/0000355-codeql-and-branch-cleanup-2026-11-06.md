# Changelog (0000355-codeql-and-branch-cleanup, 06 Nov 2026)

**Feature:** CodeQL and branch cleanup in CI
**Version:** 0.53.0
**PR:** pending

## What changed

- `.github/workflows/codeql.yml` scans JavaScript and GitHub Actions on each PR into `main` or `initiative/**`.
- `ravintio.yml` and its pack template `ravintio-zero/hooks/ravintio.yml` hold a branch cleanup job. It runs on `pull_request` `closed`, deletes the head branch of a merged PR, and exits 0 if the branch is gone. It holds `contents: write` on that job only.
- Every other job in both workflow files skips the `closed` event.
- Each unguarded CI job carries a marker comment. `test-0000169-req-006` reads `helpers/unguarded-jobs.sh` and needs no edit when a job is added. The plan skill's test impact scan names the workflow cause.
- The P3 security checklist names incomplete escaping, such as a missed backslash.
- Entry 0000323 says CodeQL runs from the workflow and drops the branch deletion item.
- Backlog entries 0000346, 0000338, and 0000356 are pulled in and deleted.

## Why

A CodeQL alert such as `js/incomplete-sanitization` surfaced only on the initiative PR. Default setup cannot scan a PR into `initiative/**`. Each developer also had to turn on branch deletion in repo settings.

## Deviations

- `ravintio-zero/tests/helpers/assert.sh` accepts a trailing comment on the chart status line, because the chart template writes one.
- `test-0000169-req-006` reads `helpers/unguarded-jobs.sh` instead of a fixed job name list. `run-tests.sh` lists the helper.
- Workflow tests `test-0000319` and `test-0000327` expect two write scopes, not one.
- The step stopped once because CodeQL default setup was on. The human turned it off and the stop is resolved in the build log.

## Validation results

- The full suite passes: 276 feature suites and 19 regression suites. The consistency check, the backlog index check, and the self-description check pass.
- 10 criteria verified by execution. 0 failed. 2 not-verifiable without GitHub: CodeQL on a PR into `initiative/**`, and the head branch gone after the squash.
- Security review found no critical, high, or medium findings.

## Skipped phases

None.
