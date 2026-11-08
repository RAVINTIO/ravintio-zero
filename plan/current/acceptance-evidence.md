---
title: "Acceptance evidence - 0000394-github-security-and-ci-lint"
summary: "Checks, security findings, and execution evidence for the step PR."
---
# Acceptance evidence - 0000394-github-security-and-ci-lint

## Checks

- Full suite on a clean tree: 305 feature suites and 19 regression suites passed.
- `actionlint` 1.7.12 on `.github/workflows/`: exit 0.
- `zizmor` 1.32.0 with `--no-online-audits`: no findings, one ignore with a reason.
- Self-corrections: 2 (the write guard path format, and three sibling tests that scan the allowlist file).

## Security findings

No critical or high findings. The step fixed one template injection and four floating action tags. See `plan/current/security-report.md`.

## Execution evidence

- `node ravintio-zero/scripts/github-settings.mjs list` printed six items.
- `node ravintio-zero/scripts/github-settings.mjs check` exited 1. It reported `dependabot-security-updates` and `private-vulnerability-reporting` on, and `secret-scanning`, `push-protection`, `topics`, and `workflow-lint-required` off.
- A scratch repo push with the old name exited 1 and printed `docs/note.md:2`. A clean push exited 0.
- Not verifiable before the PR: the `workflow-lint` job in CI, and the `workflow-lint-required` setting, which needs the job on `main`.

## Search evidence

`actionlint` and `zizmor` were absent from `PATH`. The step installed them under `/tmp` and ran them from there.
