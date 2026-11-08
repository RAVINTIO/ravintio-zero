# Changelog (0000394-github-security-and-ci-lint, 08 Nov 2026)

**Feature:** GitHub security and CI lint
**Version:** set by the merge queue at merge
**PR:** pending

## What changed

- Community and security files: `SECURITY.md`, Dependabot config, issue and PR templates, and `CODEOWNERS` (0000323).
- Every action in `.github/workflows/` pins to a commit SHA. New dependency review and Scorecard workflows run in CI.
- A `workflow-lint` CI job runs `actionlint` and `zizmor` on the workflows (0000325).
- The `pre-push` hook runs the brand guard with CI's shared allowlist file (0000324).
- `node ravintio-zero/scripts/github-settings.mjs` lists and checks the admin-only GitHub settings.
- One template injection in a workflow is fixed.

## Why

The pack repo is public but used few free GitHub security features, and nothing linted its workflows.

## Deviations

- `design.md` listed two paths on one line, so the write guard read one. The step put one path on each line.
- Release-tag attestations stay deferred, as the brief says.
- Tests that read the pulled-in entry 0000323, and three tests that scan the allowlist file, changed to match the shared allowlist.

## Validation results

- Full Bash suite: 305 feature suites and 19 regression suites passed.
- `actionlint` and `zizmor` report no findings.
- Settings check: all on except `workflow-lint-required`, which needs `workflow-lint` to run on `main` first.
- Security review: no critical or high findings.

## Skipped phases

None
