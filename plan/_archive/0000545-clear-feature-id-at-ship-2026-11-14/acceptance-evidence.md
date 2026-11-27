---
title: "Acceptance evidence - 0000545-clear-feature-id-at-ship"
summary: "Check results, security findings, and execution evidence for REQ-001 to REQ-003."
status: "active"
version: "0.1.0"
---
# Acceptance evidence - 0000545-clear-feature-id-at-ship

## Checks

- Full suite in a clean clone: 451 feature suites passed, 3 failed. The regression suite passed 19 of 19.
- The 3 failures are `test-0000037-req-004-remove-old-folder.sh`, `test-0000318-req-004-merge-guard-pinned.sh`, and `test-0000450-req-004-report-format.sh`.
- None of the 3 touches a file this change edits. The first two pass from the working tree. The third passes from `src/ravintio-zero/tests/`.
- Cause: the clean clone has no `core.hooksPath`, no `origin/initiative/0000312` branch, and a different folder depth. These are environment gaps.
- Self-correction cycles: 0.
- `prose-check.mjs` on the two changed standards and skill files: exit 0.

## Security

No critical or high findings. See `plan/current/security-report.md`.

## Execution

The agent verified REQ-001, REQ-002, and REQ-003 by execution. See `plan/current/verification-report.md`.

## Docs edit pass

Skipped. The change edits no file under `docs/` for user-facing prose beyond an ADR and two index lines. `prose-check.mjs` exits 0.
