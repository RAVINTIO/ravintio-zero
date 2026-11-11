# Acceptance evidence - 0000497-keep-worktree-entries

## Checks

- The new suite `test-0000497-req-001-002-keep-entries.sh` passes: 21 passed, 0 failed.
- The full suite shows 443 feature suites passed and 1 failed, with 19 regression suites passed. The failed suite, `test-0000450-req-004-report-format.sh`, also fails on the base commit.
- `baseline-failures.mjs check` reports `inherited: test-0000450-req-004-report-format.sh` and no new suite. The baseline in a clean clone held three inherited suites. Two of them pass in the working tree.
- The agent ran 0 self-correction cycles.
- `consistency-check.mjs` reports clean. `prose-check.mjs` reports ok for 3 changed docs.

## Security

- 0 critical or high findings. Overall risk is low (see `plan/current/security-report.md`).

## Execution evidence

- 7 criteria verified by running the driver and reading the changed text (see `plan/current/verification-report.md`). 0 are not-verifiable.
- Driver change: `src/ravintio-zero/scripts/initiative-run.mjs:949`.

## Docs edit pass

- Changed docs: `docs/decisions-index.md`, `docs/adr/0325-driver-keeps-worktrees-with-untracked-entries.md`, `src/ravintio-zero/standards/roadmap-standards.md`.
- Cycles: 0. Final `prose-check.mjs` exit code: 0.

## Note for the coordinator

The step changes `initiative-run.mjs` and a skill, so the merge triggers `Restart:` and `Setup:` stops. The agent refreshed the installed copy `ravintio-zero/`.
