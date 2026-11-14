# Changelog (0000548-ack-write-mid-suite-fails-run, 14 Nov 2026)

**Feature:** Strict-mode ack write mid-suite fails the suite run
**Version:** set by the merge queue at merge
**PR:** pending

## What changed

- Both test runners write the git-ignored marker `plan/.suite-running` with their pid and remove it on exit.
- The strict-mode hook `check-orchestrator-presence.mjs` stays quiet for a step session while the marker names a live process.
- The tree check still fails when a suite changes `plan/.orchestrator-ack`. It exempts nothing.
- New suite `test-0000548-req-001-suite-marker.sh`. ADR-0344 records the decision.
