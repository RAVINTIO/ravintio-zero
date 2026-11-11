---
title: "Acceptance Evidence - 0000485-adr-number-collision"
summary: "Results of the checks, the security review, and execution verification."
---
# Acceptance Evidence - 0000485-adr-number-collision

## Checks

- New suite `test-0000485-req-001-id-collisions.sh`: 30 of 30 pass. It passed 0 of 27 before the module existed.
- New suite `test-0000485-req-002-queue-renumbers.sh`: 19 of 19 pass.
- Related queue suites 0000378, 0000456 (two), 0000464, 0000483 (two) pass, before and after the merge of the initiative branch.
- Full suite in a clean clone before the merge: 408 passed, 2 failed, both inherited (`baseline-failures.md`). Regression suite: 19 passed.
- `sync-installed.mjs --check`: exit 0. `consistency-check.mjs`: clean. `backlog-index.mjs --check`: exit 0.
- Self-corrections: 1. The first run of the module on the real merge missed a backlog entry that git read as a rename. A new test case failed first, and the fix passes it.

## Security

No critical or high findings. One low finding is open (S-002, a counter symlink). See `plan/current/security-report.md`.

## Execution

The two suites run the module and the real `merge-queue.mjs` on real git repos, and verify all six acceptance criteria. See `plan/current/verification-report.md`. None are not-verifiable. I also ran the module on the real merge of the initiative branch. It renumbered this step's ADR 0310 to 0312 and its backlog entry 0000513 to 0000515.

## Branch moved during the run

The initiative branch moved during P3 with the merges of steps 28 and 30. The merge conflicted on the counters, `decisions-index.md`, `architecture-overview.md`, `roadmap-standards.md`, and `plan/.feature-id`. I resolved each by hand and reran the related suites.

## Docs edit pass

Changed docs: `docs/architecture-overview.md`, `roadmap-standards.md`, ADR 0312, and the changelog. One cycle, run by a fresh-context subagent. It changed nothing, and `prose-check.mjs` exits 0.
