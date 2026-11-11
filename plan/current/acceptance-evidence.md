---
title: "Acceptance Evidence - 0000493-driver-starts-after-restart"
summary: "Results of the checks, the security review, and execution verification."
---
# Acceptance Evidence - 0000493-driver-starts-after-restart

## Checks

- New suite `test-0000493-req-001-003-handoff.sh`: 42 of 42 pass. It passed 26 of 42 before the change.
- New suite `test-0000493-req-004-handoff-text.sh`: 10 of 10 pass.
- Related driver suites pass: `test-0000379-req-002-003-005-scheduler.sh` (57), `test-0000379-req-004-queue-handoff.sh` (21), `test-0000446-req-001` (15), `test-0000448-req-002` (29), `test-0000450-req-003` (7), `test-0000491-req-001` (10), and `test-0000250-req-002` (21).
- Full suite in a clean clone: 439 feature suites passed and 3 failed. Regression suite: 19 passed.
- All 3 failures come from the baseline (`baseline-failures.md`): `test-0000037-req-004`, `test-0000318-req-004`, and `test-0000450-req-004`. `baseline-failures.mjs check` exits 0.
- `consistency-check.mjs`: clean. `archetype-gates.mjs`: no gates installed.
- Self-corrections: 1. The tree comparison in the text suite used a path that fails from `ravintio-zero/tests/`.

## Security

No critical or high findings. Overall risk: low. See `plan/current/security-report.md`.

## Execution

The handoff suite runs the real driver with real processes, a stub `claude`, and a stub merge queue. It verified every acceptance criterion except the spawn-failure path, which is `not-verifiable` because the fixture cannot make `spawn` fail. That path shares the keep-the-stop code with the fast-forward failure, which the suite verified. See `plan/current/verification-report.md`.

## Docs edit pass

Changed docs: `docs/architecture-overview.md`, `docs/decisions-index.md`, the ADR, and the changelog. One cycle, run by a fresh-context subagent. It made one edit. `prose-check.mjs` exits 0.
