---
title: "Security report - 0000394-github-security-and-ci-lint"
summary: "Security findings for the workflow, hook, and script changes."
---
# Security report - 0000394-github-security-and-ci-lint

**Overall risk rating:** low

| Finding | Location | Severity | Mitigation |
|---------|----------|----------|------------|
| Script installer downloaded at CI time | `.github/workflows/ravintio.yml` `workflow-lint` job, `download-actionlint.bash` | Low | The URL pins a commit SHA and the tool version. The script runs with `permissions: contents: read` and no token. |
| `zizmor` from PyPI at a pinned version | `.github/workflows/ravintio.yml` `workflow-lint` job | Low | The version is pinned. The job holds no secret. |
| Persisted checkout credentials in `release-tag` | `.github/workflows/ravintio.yml` `release-tag` job | Low | Not changed. The job needs the token for `git push`, and `zizmor: ignore[artipacked]` records the reason. |
| Template injection through `github.base_ref` | `.github/workflows/ravintio.yml` `validate-branch` job | Medium before the step | Fixed. The value now passes through the `BASE_REF` env variable. |
| Floating action tags | `.github/workflows/codeql.yml`, `.github/workflows/ravintio.yml`, `ravintio-zero/hooks/ravintio.yml` | Medium before the step | Fixed. All are pinned by SHA, and a suite fails on a new floating tag. |
| Scorecard job holds `id-token: write` and `security-events: write` | `.github/workflows/scorecard.yml` | Low | Required by the action. The job runs on push and schedule only, never on PR code. |
| Brand guard reads file content from the push | `ravintio-zero/scripts/brand-guard.sh` | Low | It runs `grep` on paths from `git diff` with quoted arguments and `--`. It executes no file content. |
| `gh api` reads | `ravintio-zero/scripts/github-settings.mjs` | Low | It uses `execFileSync` with an argument array, and `--repo` goes in as one argument. |

Credentials: none found in the new files. Risk register: R-001 to R-004 stay open until CI runs. No critical or high finding.
