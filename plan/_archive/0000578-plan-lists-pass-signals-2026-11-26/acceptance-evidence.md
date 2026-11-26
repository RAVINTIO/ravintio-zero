# Acceptance evidence - 0000578

## Checks

- `test-0000578-req-001-pass-signal-paths.sh` passes 9 of 9 checks. The skill-size suites 0000031, 0000206, 0000327, and 0000359 pass at 1700 lines against the cap of 1720.
- `sync-installed.mjs --check` exits 0.

## Full suite

The clean-clone run of the branch passed 484 feature suites and failed 3. The regression suite passed 19 of 19. `baseline-failures.mjs check` lists all three failures as `inherited:` and exits 0. The base run failed the same three suites.

## Security

One informational finding, S-001, accepted. See `plan/current/security-report.md`.

## Execution

All criteria verified by CLI or file checks. See `plan/current/verification-report.md`.

## Docs edit pass

One changed doc sentence in `docs/architecture-overview.md`. The prose check passed with exit 0.

## RED and GREEN for U1, U3, and U4

The U2 suite checks U1. U3 is a sync unit and U4 is a docs unit. Neither has its own executable check. The build log records their markers per the chart row for 0000410.
