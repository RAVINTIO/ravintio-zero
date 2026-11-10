---
title: "Acceptance Evidence - 0000464-merge-queue-test-gaps"
summary: "Results of the checks, the security review, and execution verification."
---
# Acceptance Evidence - 0000464-merge-queue-test-gaps

## Checks

- New suites: `test-0000464-req-001-002-queue-branches.sh` passes 15 of 15. `test-0000464-req-003-dash-guard.sh` passes 12 of 12. It failed 6 of 12 before the guard existed.
- The nine queue suites in the plan's test impact scan pass, and so does `test-0000164-req-008-no-process-substitution-loops.sh`.
- Full suite in a clean clone of `HEAD`: 395 passed, 2 failed, 19 regression suites passed. Both failures also fail on the base commit (`baseline-failures.md`). The baseline check exits 0.
- `sync-installed.mjs --check`: exit 0.
- `archetype-gates.mjs`: no gates installed.
- `prose-check.mjs` on the changed docs: exit 0.
- OS gap: local macos, CI ubuntu and windows. The new suites are Bash and run on macOS only here.
- Self-corrections: 0.

## Security

No critical or high findings. Two low findings, both mitigated. See `plan/current/security-report.md`.

## Execution

Each requirement ran against a fake `gh` and a bare remote. Breaking the rerun branch and then the post-set check made the new suite fail each time. See `plan/current/verification-report.md`. No criterion is not-verifiable.

## Docs edit pass

Changed docs: `docs/architecture-overview.md` and the changelog. The pass ran inline in 1 cycle. `prose-check.mjs` exits 0.

## Deviation

The mismatch fixture runs a copy of the queue beside a stub `version-files.mjs`. No real input makes the files differ after the set.
