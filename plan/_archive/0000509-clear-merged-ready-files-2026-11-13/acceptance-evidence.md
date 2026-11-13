# Acceptance evidence - 0000509-clear-merged-ready-files

## Checks

- The new suite `test-0000509-req-001-003-clear-ready.sh` passes: 23 passed, 0 failed.
- The clean-clone run shows 446 feature suites and 19 regression suites passed, with 3 failed. All 3 are on the baseline list.
- `baseline-failures.mjs check` reports 3 `inherited:` suites and no `new:` suite.
- The agent ran 0 self-correction cycles in P3.
- `consistency-check.mjs` reports clean. `prose-check.mjs` exits 0 for the changed docs. `archetype-gates.mjs` reports no gates installed.

## Security

- 0 critical or high findings. Overall risk is low (see `plan/current/security-report.md`).

## Execution evidence

- 9 criteria verified by running the driver and reading the changed text (see `plan/current/verification-report.md`). 0 are not-verifiable.
- Driver change: `src/ravintio-zero/scripts/initiative-run.mjs:1045`.

## Docs edit pass

- Changed docs: `docs/adr/0340-driver-clears-merged-ready-files.md`, `docs/decisions-index.md`, `plan/changelog/0000509-clear-merged-ready-files-2026-11-13.md`, `src/ravintio-zero/standards/roadmap-standards.md`.
- Cycles: 1. A fresh-context reviewer rewrote one Context sentence. Final `prose-check.mjs` exit code: 0.

## Note for the coordinator

The step changes `initiative-run.mjs`, so the merge triggers a `Restart:` stop. The agent refreshed the installed copy `ravintio-zero/`. The new driver then clears the leftover `ready` files of merged steps at its first start.
