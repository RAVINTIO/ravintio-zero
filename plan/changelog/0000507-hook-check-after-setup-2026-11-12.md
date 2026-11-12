# Changelog (0000507-hook-check-after-setup, 12 Nov 2026)

**Feature:** Check every hook after setup
**Version:** set by the merge queue at merge
**PR:** set at P4

## What changed

- New script `hook-check.mjs` runs every hook in `.claude/settings.json` with `CLAUDE_PROJECT_DIR` set and one fixed sample for its event and matcher. Exit 0 and exit 2 pass. Any other result fails.
- The initiative driver runs the script after the approved setup command. A failure prints `I-D Advance: Blocked: hook check failed after setup:` and stops the driver.
- New docs: `src/ravintio-zero/docs/hook-check.md` and ADR-0339.
- Two new suites: `test-0000507-req-001-hook-check` and `test-0000507-req-003-driver-hook-check`.

## Deviations

- A pack with no `hook-check.mjs` skips the check and the driver prints a Setup line. This keeps the existing driver suites passing against older fixtures.

## Validation results

- The new suites pass: 25 and 15 checks. The driver suites 0000448, 0000313, and 0000250 still pass.
- The full suite result is in the verification report.

## Skipped phases

None.
