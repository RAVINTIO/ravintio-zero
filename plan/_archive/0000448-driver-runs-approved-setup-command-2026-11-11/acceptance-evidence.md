# Acceptance evidence - 0000448-driver-runs-approved-setup-command

## Checks

- Full suite in a clean clone, in 4 shards: 409 feature suites passed and 2 failed. Regression suites: 19 passed, 0 failed.
- Both failures also fail on the base. `plan/current/baseline-failures.md` lists them: `plan/current/baseline-failures.md`: `test-0000037-req-004-remove-old-folder.sh` and `test-0000318-req-004-merge-guard-pinned.sh`.
- The three new suites pass: 16 of 16, 29 of 29, and 7 of 7 checks.
- `prose-check.mjs` exits 0 on the changed docs. `archetype-gates.mjs` found no gates installed.
- Self-correction cycles: 0.
- OS gap: local macos, CI ubuntu, windows.

## Security

No critical or high findings. There are two medium findings.

- A command that a chart names. A strict form and no shell mitigate it.
- A `setup.sh` from the merged ref that runs before a human reads it. The 2026-11-10 decision row accepts it.

See `plan/current/security-report.md`.

## Execution evidence

The driver ran as a real `node` process in throwaway repos. It ran in the serial and the concurrent path. The helper ran against the real chart and returned the approved command. Every criterion is `verified`. The real `setup.sh` never ran, so that part is `not-verifiable` here. See `plan/current/verification-report.md`.

## Docs edit pass

Changed docs: `docs/architecture-overview.md`, `docs/decisions-index.md`, ADR 0310, and the changelog. One cycle, run inline. `prose-check.mjs` exit code 0.
