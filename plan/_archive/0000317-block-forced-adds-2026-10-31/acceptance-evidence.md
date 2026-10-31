---
title: "Acceptance Evidence - 0000317-block-forced-adds"
summary: "Checks, security, and execution evidence for the step."
---
# Acceptance Evidence - 0000317-block-forced-adds

## Checks

- Full suite with `RAVINTIO_INITIATIVE_STEP=1` set: 236 feature suites passed, 0 failed. Regression: 19 of 19.
- Self-corrections: 2. Run 1 failed 12 assertions across 7 suites that count the hook entries. Run 2 failed `test-0000036-req-004-setup-ps1-install` on the shared expected-entry list. I updated each count and list, and kept every check.

## Security

- No critical or high finding. Overall risk: low. One medium finding: a forced add through an alias or substitution passes the hook and falls to the CI check. See `plan/current/security-report.md`.

## Execution evidence

- The hook exited 2 on `git add -f plan`, `--force`, `-fA`, and `git -C plan add -f x`, and 0 on `git add plan/current`.
- `git ls-files -ci --exclude-standard` lists nothing in this repo and lists a force-added file in a scratch repo.
- The CI step and a live session running the hook are `unverified (docs only)`. The first CI run and the setup rerun check cover them.
