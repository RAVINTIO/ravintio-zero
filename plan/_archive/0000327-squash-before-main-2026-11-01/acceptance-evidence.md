# Acceptance evidence - 0000327-squash-before-main

- Checks: consistency check clean, full suite passes (259 feature and 19 regression suites).
- Self-correction cycles: 2. The first full suite found a release-tag test that rejected the new job, fixed in its own commit. The security review led to a dash-prefix guard, a required-check note, and a no-plain-`--force` line.
- Security: no critical or high findings. Six medium findings are accepted or mitigated and tracked as R-006 to R-009. Overall risk low. See `plan/current/security-report.md`.
- Execution: 9 criteria verified by running the script and reading the changed files. 1 is `not-verifiable`. 0 are `unverified (docs only)`.
- CI criterion: the `squash-before-main` job runs only on a PR into `main`. This step's PR targets an initiative branch, so the job first runs on the initiative PR or the next chore PR.
- Flags for the human: `CLAUDE.md` and `ravintio-overrides/instructions/custom-001-local-git-only.md` still say "Work on a feat/ branch". The human should mark `squash-before-main` as a required check in the `main` ruleset.
- Missing programs: none reported.
