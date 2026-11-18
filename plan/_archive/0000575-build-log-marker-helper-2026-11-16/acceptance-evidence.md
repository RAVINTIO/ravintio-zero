## Acceptance evidence

- Checks: the clean-clone suite shows 472 feature suites passed and 3 failed, plus 19 regression suites passed. The 3 failures also fail on the base commit (`baseline-failures.mjs check` exit 0).
- Self-correction cycles: 0.
- OS gap: local macos, CI ubuntu, windows.
- Security: 0 critical, 0 high. Overall risk is low (`plan/current/security-report.md`).
- Execution: every criterion is `verified`. None is `not-verifiable`. See `plan/current/verification-report.md`.
- Search evidence: no run found a missing program.
- Docs edit pass: skipped as a subagent step. The changed docs are `docs/decisions-index.md` and ADR 0348, and `prose-check.mjs check` exits 0 on them.
- Archetype gates: none installed, exit 0.
