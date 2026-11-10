# Changelog (0000452-ci-wait-before-archive, 10 Nov 2026)

**Feature:** Ship waits for CI before it archives
**Version:** set by the merge queue at merge
**PR:** pending

## What changed

- An initiative step now raises its PR and waits for CI before it archives. Ship Steps 4, 5, and 8 run after green CI, as one closing push.
- The step waits for the checks on the closing push. It writes `ready` only when `gh pr checks` exits 0 for that head.
- ADR-0298 records the order.
- Two new suites, `test-0000452-req-001-archive-after-ci.sh` and `test-0000452-req-002-ready-needs-green.sh`.
- Two pinned tests, `test-0000043-req-005` and `test-0000151-req-002`, now expect the new order.
- The step pulls in entry 0000412 and deletes it.

## Why

Ship archived `plan/current/` before CI ran. `gate-write` then blocked code edits, so a step could not fix its own failing check. Step 6 of initiative 0000360 blocked three times on PR #136.

## Deviations

- Ship writes the build report after the PR exists. The step adds the `## Workflow governance` section to the PR body with `gh pr edit`.
- A normal run outside an initiative keeps its order.

## Validation results

- Full suite on the working tree: 384 feature suites and 19 regression suites passed.
- Clean clone: two inherited failures, both in the baseline.
- Security review: no findings.

## Skipped phases

None.
