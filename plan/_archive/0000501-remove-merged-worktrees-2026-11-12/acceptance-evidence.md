# Acceptance evidence - 0000501-remove-merged-worktrees

## Checks

- The new suite `test-0000501-req-001-004-sweep.sh` passes: 31 passed, 0 failed, in both `src/` and the installed copy.
- The clean-clone run shows 442 feature suites and 19 regression suites passed, with 3 failed. All 3 are on the baseline list.
- `baseline-failures.mjs check` reports 3 `inherited:` suites and no `new:` suite.
- The agent ran 1 self-correction cycle. The new suite failed once in the full run because its ADR path broke in the installed copy. The agent fixed the path.
- `consistency-check.mjs` reports clean. `prose-check.mjs` exits 0 for the changed docs. `archetype-gates.mjs` reports no gates installed.

## Security

- 0 critical or high findings. Overall risk is low (see `plan/current/security-report.md`).

## Execution evidence

- 11 criteria verified by running the driver and reading the changed text (see `plan/current/verification-report.md`). 0 are not-verifiable.
- Driver change: `src/ravintio-zero/scripts/initiative-run.mjs:974` and `:997`.

## Docs edit pass

- Changed docs: `docs/adr/0326-driver-sweeps-merged-worktrees.md`, `docs/decisions-index.md`, `src/ravintio-zero/standards/roadmap-standards.md`.
- Cycles: 1. A fresh-context reviewer rewrote one Context sentence. Final `prose-check.mjs` exit code: 0.

## Note for the coordinator

The step changes `initiative-run.mjs`, so the merge triggers a `Restart:` stop. The agent refreshed the installed copy `ravintio-zero/`. The new driver then sweeps the leftover worktree `step-12` at its first start.
