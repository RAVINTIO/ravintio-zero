# Acceptance evidence - 0000511-driver-stop-summary

## Checks

- The new suite `test-0000511-req-001-003-stop-summary.sh` passes: 23 passed, 0 failed.
- Five existing driver suites pinned the final line. The agent moved the summary before the final line, so all five pass again without a test change.
- The clean-clone run shows 447 feature suites and 19 regression suites passed, with 3 failed. All 3 are on the baseline list.
- `baseline-failures.mjs check` reports 3 `inherited:` suites and no `new:` suite.
- The agent ran 1 self-correction cycle in P2 (the summary position).
- `consistency-check.mjs` reports clean. `prose-check.mjs` exits 0 for the changed docs. `archetype-gates.mjs` reports no gates installed.

## Security

- 0 critical or high findings. Overall risk is low (see `plan/current/security-report.md`).

## Execution evidence

- 10 criteria verified by running the driver and reading the changed text (see `plan/current/verification-report.md`). 0 are not-verifiable.
- Driver change: `src/ravintio-zero/scripts/initiative-run.mjs:278`.

## Docs edit pass

- Changed docs: `docs/adr/0341-driver-stop-summary.md`, `docs/decisions-index.md`, `plan/changelog/0000511-driver-stop-summary-2026-11-13.md`, `src/ravintio-zero/standards/roadmap-standards.md`.
- Cycles: 1. A fresh-context reviewer split one long sentence and shortened one bullet. Final `prose-check.mjs` exit code: 0.

## Note for the coordinator

The step changes `initiative-run.mjs`, so the merge triggers a `Restart:` stop. The agent refreshed the installed copy `ravintio-zero/`. The new driver prints the summary block at its first stop.
