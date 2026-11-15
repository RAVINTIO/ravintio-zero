# Changelog (0000548-ack-write-mid-suite-fails-run, 14 Nov 2026)

**Feature:** Strict-mode ack write mid-suite fails the suite run
**Version:** set by the merge queue at merge
**PR:** 215

## What changed

- Both test runners write the git-ignored marker `plan/.suite-running` with their pid and remove it on exit.
- The strict-mode hook `check-orchestrator-presence.mjs` stays quiet for a step session while the marker names a live process.
- The tree check still fails when a suite changes `plan/.orchestrator-ack`. It exempts nothing.
- New suite `test-0000548-req-001-suite-marker.sh`. ADR-0344 records the decision.

## Why

The strict-mode hook asked a step session for an ack while its suite ran. The session then wrote `plan/.orchestrator-ack`, and the tree check failed the run. The chart barred an exemption for the ack file, so the fix removes the prompt instead.

## Deviations

None.

## Validation results

- Full suite: 452 feature suites and 19 regression suites passed. One suite failed.
- The failure is `test-0000450-req-004-report-format.sh`. It fails the same way on the merge base, so the run inherits it.
- Security review: no critical or high findings. One low finding, S-001, has the chart's pre-approval.
- Not verifiable: the `run-tests.ps1` marker. The test checks its text, and the windows CI leg runs it.

## Skipped phases

None.
