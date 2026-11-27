# Acceptance evidence - 0000570

## Checks

- Ten related suites pass, including `test-0000570-req-001-sibling-copy-line.sh` with 5 of 5 checks.
- `sync-installed.mjs --check` exits 0.
- `archetype-gates.mjs` reports no gates installed.
- Self-correction cycles: 0.

## Full suite

The clean-clone run passed 469 feature suites and failed 3. The regression suite passed 19 of 19. The three failures are the inherited `test-0000037-req-004-remove-old-folder.sh`, `test-0000318-req-004-merge-guard-pinned.sh`, and `test-0000450-req-004-report-format.sh`. `baseline-failures.mjs check` exits 0 and lists no `new:` suite.

## Security

One informational finding, S-001, accepted. See `plan/current/security-report.md`.

## Execution

All criteria verified by CLI or file checks. See `plan/current/verification-report.md`.

## Docs edit pass

Two changed docs: `docs/architecture-overview.md` and the changelog record. A fresh-context subagent reviewed the added text. The build log records the result.

## RED and GREEN for U3 and U4

U3 is a sync unit and U4 is a docs unit. Neither has an executable check. The build log records their markers per the chart row for 0000410.
