---
title: "Acceptance Evidence - 0000318-titled-coordinator-prs"
summary: "Checks, security, and execution evidence for the step."
---
# Acceptance Evidence - 0000318-titled-coordinator-prs

## Checks

- Full suite: 239 feature suites passed, 0 failed. Regression: 19 of 19.
- Self-corrections: 1. The first full run failed two suites. `test-0000043-req-003` needed the words "one commit" in the I-B Activate text, and `test-0000189-req-007` flagged old names in `discovery.md`. I fixed the text and kept both tests.

## Security

- No critical or high finding. Overall risk: low. See `plan/current/security-report.md`.
- `merge-guard.mjs` is unchanged. A new test pins what it allows and blocks.

## Execution evidence

- The guard exited 0 for a squash into `initiative/…` and 2 for a squash into `main`, `--merge`, `--rebase`, `--admin`, a substitution, a variable, and a base of `initiativex`.
- `git diff` of `merge-guard.mjs` against the initiative branch is empty.
- The CI run on this PR is `unverified (docs only)`.

## Findings filed

- Entry 0000332: `reserve-id.mjs --commit` commits on the current branch.
