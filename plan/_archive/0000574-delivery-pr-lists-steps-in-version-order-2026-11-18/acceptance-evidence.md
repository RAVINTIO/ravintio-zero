# Acceptance evidence - 0000574

## Checks

- Impacted suites pass. `test-0000574-req-001-rule-6-order.sh` passes 4 of 4. `test-0000574-req-002-003-printed-table.sh` passes 8 of 8. The reshape suites 0000353 and 0000378 pass.
- `sync-installed.mjs --check` exits 0.

## Full suite

The clean-clone run of the final commit passed 482 feature suites and failed 3. The regression suite passed 19 of 19. The three failures are the inherited `test-0000037-req-004-remove-old-folder.sh`, `test-0000318-req-004-merge-guard-pinned.sh`, and `test-0000450-req-004-report-format.sh`. `baseline-failures.mjs check` reports each as inherited and none as new. The base run also failed `test-0000189-req-007-old-name-guard.sh`, which passed on the final commit.

## Security

Two informational findings, S-001 and S-002, accepted. See `plan/current/security-report.md`.

## Execution

All criteria verified by CLI or file checks. See `plan/current/verification-report.md`.

## Docs edit pass

One changed doc sentence in `docs/architecture-overview.md`. The prose check passed on commit.

## RED and GREEN for U3 and U4

U3 is a sync unit and U4 is a docs unit. Neither has its own executable check. The build log records their markers per the chart row for 0000410.
