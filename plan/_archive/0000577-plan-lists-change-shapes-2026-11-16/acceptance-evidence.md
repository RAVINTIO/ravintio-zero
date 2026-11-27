# Acceptance evidence - 0000577

## Checks

- Impacted suites pass, including `test-0000577-req-001-diff-reader-cause.sh` with 9 of 9 checks. The cap suites 0000383, 0000567, 0000568, 0000569, 0000570, and 0000571 pass.
- `sync-installed.mjs --check` exits 0.

## Full suite

The local full run passed 475 feature suites and failed 2. The regression suite passed 19 of 19. One failure is the inherited `test-0000450-req-004-report-format.sh`. The other is `test-0000039-req-001-003-ps1-setup-hardening.ps1`, which ran while the clean-clone baseline ran beside it. Run alone with `pwsh`, it passes 37 of 37. `baseline-failures.mjs check` therefore exits 1 on the combined run and lists that suite as `new:`. The clean-clone baseline run failed the three inherited suites.

## Security

One informational finding, S-001, accepted. See `plan/current/security-report.md`.

## Execution

All criteria verified by CLI or file checks. See `plan/current/verification-report.md`.

## Docs edit pass

One changed doc sentence in `docs/architecture-overview.md`. The prose check passed on commit.

## RED and GREEN for U1, U3, and U4

The U2 suite checks U1. U3 is a sync unit and U4 is a docs unit. Neither has its own executable check. The build log records their markers per the chart row for 0000410.
