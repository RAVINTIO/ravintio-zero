# Acceptance evidence - 0000565

## Checks

- Nine suites named in the P2 block pass in the worktree, including `test-0000565-req-001-path-move-cause.sh` with 6 of 6 checks.
- `consistency-check.mjs` exits 0.
- `sync-installed.mjs --check` exits 0.
- Self-correction cycles: 0.

## Full suite

The full suite ran in a clean clone of `HEAD`: 458 feature suites passed and 3 failed. The regression suite passed 19 of 19. The 3 failures are the inherited `test-0000037-req-004-remove-old-folder.sh`, `test-0000318-req-004-merge-guard-pinned.sh`, and `test-0000450-req-004-report-format.sh`. `baseline-failures.mjs check` exits 0 and lists no `new:` suite.

## Security

One informational finding, S-001, accepted. See `plan/current/security-report.md`.

## Execution

All criteria verified by CLI or file checks. See `plan/current/verification-report.md`.

## Docs edit pass

One changed doc, `docs/architecture-overview.md`. `prose-check.mjs` exits 0. The agent skipped the subagent review and the build log records it.

## RED and GREEN for U3 and U4

U3 and U4 are a docs unit and a sync unit with no executable check. The build log records their markers under the chart row for 0000410.
