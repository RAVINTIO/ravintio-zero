---
title: "Acceptance Evidence - 0000519-ship-removal-needs-human-approval"
summary: "Results of the checks, the security review, and execution verification."
---
# Acceptance Evidence - 0000519-ship-removal-needs-human-approval

## Checks

- New suite `test-0000519-req-001-ship-removal-command.sh`: 4 of 4 pass. It passed 2 of 4 before the text change.
- New suite `test-0000519-req-002-p2-docs-timing.sh`: 7 of 7 pass. It passed 4 of 7 before the text change.
- Related suites 0000025, 0000385, 0000383, 0000206, and 0000391 pass.
- Full suite in a clean clone: 430 feature suites passed and 3 failed, all inherited (`baseline-failures.md`). Regression suite: 19 passed.
- An earlier full run on the working tree showed 431 passed and 2 failed. One failure also fails in the baseline. The other came from the new req-001 suite, which used a root path that fails for the installed copy. The suite now uses `git rev-parse --show-toplevel` and passes.
- `sync-installed.mjs --check`: exit 0. `consistency-check.mjs`: clean. `archetype-gates.mjs`: no gates installed.
- Self-corrections: 1.

## Security

No critical or high findings. See `plan/current/security-report.md`.

## Execution

I ran `git rm -r -q plan/current` in a scratch repo after copying the folder. It exited 0, removed the folder, and left the copy. I verified all seven acceptance criteria. None are not-verifiable. The scratch run cannot show how the Claude Code safety check treats the command. See `plan/current/verification-report.md`.

## Docs edit pass

Changed docs: `docs/architecture-overview.md`, `docs/decisions-index.md`, the ADR, and the changelog. One cycle, run by a fresh-context subagent. It split one sentence. `prose-check.mjs` exits 0.
