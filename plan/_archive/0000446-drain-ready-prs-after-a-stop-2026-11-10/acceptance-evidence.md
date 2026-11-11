# Acceptance evidence - 0000446-drain-ready-prs-after-a-stop

## Checks

- Full suite in the working tree: 408 feature suites and 19 regression suites passed, 0 failed.
- Full suite in a clean clone of `HEAD`: 406 feature suites passed and 2 failed. Both failures come from the base commit: `test-0000037-req-004-remove-old-folder.sh` and `test-0000318-req-004-merge-guard-pinned.sh`. `baseline-failures.mjs check` reported no new failure.
- Archetype gates: none installed.
- Self-corrections: 0.
- OS gap: local macos, CI ubuntu, windows.

## Security

- No critical or high finding. Two findings are low or informational and accepted. See `plan/current/security-report.md`.

## Execution evidence

- All 5 criteria verified by running the driver against a real git repo with stub `claude` and stub queue. None is `not-verifiable`. See `plan/current/verification-report.md`.

## Docs edit pass

- Changed docs: `docs/architecture-overview.md`, `docs/decisions-index.md`, and the changelog.
- Cycles: 1, inline. `prose-check.mjs check --files` on the three files exits 0.
