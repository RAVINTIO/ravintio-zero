# Acceptance evidence - 0000384-plan-checks

1. **Checks.** The full suite passed: 316 feature suites and 19 regression suites. `node --check` passed on three scripts and `bash -n` on one wrapper. Self-correction cycles: 3, all in test pins for history paths. Lint, typecheck, and build do not apply.
2. **Security.** No critical or high finding. Four low findings, all mitigated or accepted. See `plan/current/security-report.md`.
3. **Execution.** Each acceptance criterion ran. See `plan/current/verification-report.md`. 11 verified, 0 failed, 0 not verifiable. The Windows CI job runs after the PR opens.
4. **Search.** `pwsh` was found at `/opt/homebrew/bin/pwsh`. No program was missing.

## Deviations

- Ten suites and one regression copy now treat `docs/adr/` as history, as they treat `plan/_archive/`.
- `test-0000160-req-001-pack-identifiers.sh` carves out `plan/_archive/*/adr/` from its archive-unchanged check.
- Features 0000002, 0000013, and 0000029 have no ADRs in git history, so the migration restored none for them.
- The installed `.claude/skills/` copy stays stale until the driver `Setup:` stop.
