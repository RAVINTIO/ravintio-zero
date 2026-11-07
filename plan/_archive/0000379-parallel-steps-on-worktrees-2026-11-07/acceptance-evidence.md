# Acceptance evidence - 0000379-parallel-steps-on-worktrees

- Checks: full suite passes (299 feature suites, 19 regression suites). Consistency and self-description checks pass. Self-corrections: 2 (a size cap on `standard-boot.md`, a helper allowlist entry).
- Security: 0 critical or high findings. See `plan/current/security-report.md`.
- Execution: each acceptance criterion ran against real git repositories with stub `claude` and stub queue. See `plan/current/verification-report.md`.
- Not verifiable: a live GitHub merge. Step 3 runs through the real queue at ship.
- Deviation: `running` and `ready` live in the control area, not the committed chart (ADR-001).
