# Acceptance evidence - 0000560

## Checks

- The new suite `test-0000560-req-001-ledger-rows-with-detect.sh` passes 4 of 4 checks in both pack trees. Against a mutant script that skips every ledger row, it failed 2 of 4.
- `sync-installed.mjs --check` exits 0.
- `prose-check.mjs check --files docs/architecture-overview.md` exits 0.

## Full suite

The local full run passed 481 feature suites and failed 1. The regression suite passed 19 of 19. The clean-clone run passed 479 feature suites and failed 3. `baseline-failures.mjs check` lists all three as inherited and exits 0.

## Security

One informational finding, S-001, accepted. See `plan/current/security-report.md`.

## Execution

All criteria verified by CLI checks. See `plan/current/verification-report.md`.

## Docs edit pass

One changed doc sentence in `docs/architecture-overview.md`. The prose check passed.

## Scope result

Entry 0000403 asked for a ledger skip and a step rule. 0000399 and 0000320 shipped the skip. 0000536 shipped the step rule. This step pins the `not applicable` rule that the chart keeps and removes the entry. The step changes no code in `resume-detect.mjs`.

## RED and GREEN for U2 and U3

U2 is a sync unit and U3 is a docs unit. Neither has its own executable check. The build log records their markers per the chart row for 0000410.
