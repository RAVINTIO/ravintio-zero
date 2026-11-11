---
title: "Acceptance Evidence - 0000521-replies-name-actors-by-role"
summary: "Results of the checks, the security review, and execution verification."
---
# Acceptance Evidence - 0000521-replies-name-actors-by-role

## Checks

- New suite `test-0000521-req-001-003-actor-names.sh`: 13 of 13 pass. It passed 1 of 13 before the text change.
- New suite `test-0000521-req-002-actor-pronoun-hook.sh`: 7 of 7 pass. It passed 4 of 7 before the hook change.
- Related suites 0000200, 0000151, 0000247, 0000390, 0000028, and 0000450 req-004 text checks pass.
- Full suite in a clean clone: 436 feature suites passed and 3 failed, all inherited (`baseline-failures.md`). Regression suite: 19 passed.
- An earlier sharded run on the working tree showed 438 passed and 1 failed. The failure is the inherited 0000450 suite, which reads the repo root from `src/ravintio-zero/` only.
- `sync-installed.mjs --check`: exit 0. `consistency-check.mjs`: clean. `archetype-gates.mjs`: no gates installed.
- The orchestrator skill holds 8,937 of 9,000 bytes. All skills total 1,685 of 1,720 lines.
- Self-corrections: 0. The frozen-line and boot cap suites failed on the first text edit, before the unit reached GREEN. The agent reworked the edit inside the same attempt.

## Security

No critical or high findings. See `plan/current/security-report.md`.

## Execution

The agent fed three replies to the hook in a scratch project. The run reply with "I" and "you" got a note that names `actor-pronoun` for both words. The run reply that names roles and the plain chat reply got no note. The hook exited 0 each time. The agent verified all eight criteria. None are not-verifiable. See `plan/current/verification-report.md`.

## Docs edit pass

Changed docs: `docs/architecture-overview.md`, `docs/decisions-index.md`, and the changelog. One cycle, run by a fresh-context subagent. It split a sentence that had an unclear referent and tightened wording. `prose-check.mjs` exits 0.
