---
title: "Acceptance Evidence - 0000458-refuse-step-merge-outside-queue"
summary: "Results of the checks, the security review, and execution verification."
---
# Acceptance Evidence - 0000458-refuse-step-merge-outside-queue

## Checks

- New suite `test-0000458-req-001-refuse-step-merge.sh`: 19 of 19 pass. It failed 8 of 19 before the change.
- Suites that run the guard or pin the carve-out text pass: 0000043 (req-006, req-010), 0000189, 0000197, 0000245, 0000248, 0000252, 0000151 (req-011), and 0000380.
- Full suite in a clean clone: see the build log line `Tests run: full suite`.
- Self-corrections: 2. Five existing guard suites inherited the step session variable, and one suite pins the `Merge is human-only` line by fixture.

## Security

No critical or high findings. See `plan/current/security-report.md`.

## Execution

Running the guard verified all four acceptance criteria. See `plan/current/verification-report.md`.

## Docs edit pass

Changed docs: `docs/architecture-overview.md`, `hook-enforcement.md`, `roadmap-standards.md`, the ship skill, ADR 0301, and the changelog. `prose-check.mjs` runs at commit.
