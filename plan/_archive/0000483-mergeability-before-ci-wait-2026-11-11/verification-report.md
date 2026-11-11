---
title: "Verification Report - 0000483-mergeability-before-ci-wait"
summary: "What ran, and what it showed, for each acceptance criterion."
---
# Verification Report - 0000483-mergeability-before-ci-wait

Method: ran `merge-queue.mjs run` against a bare remote, a clone, and a stub `gh` that reports mergeability from a file and lists no checks on request. Read the standards and the ship skill. No service started.

| Criterion | Method | Outcome | Observation |
|-----------|--------|---------|-------------|
| REQ-001 AC-1 conflicting PR | Ran the queue with `CONFLICTING` and no checks, with `MQ_NOCHECKS_MS` at 60000 | verified | Exit 1 within a second. The error read `PR #11 conflicts with its base branch, so GitHub runs no checks.` The stub saw no merge call |
| REQ-001 AC-2 no checks appear | Ran the queue with `MERGEABLE`, no checks, and `MQ_NOCHECKS_MS` at 300 | verified | Exit 1. The error read `no CI checks appeared on PR #11 within 0.3s` |
| REQ-001 AC-3 normal wait | Ran the queue with `MERGEABLE` and checks that pass after two polls | verified | Exit 0 and `merged PR #11` in the output |
| REQ-002 AC-1 standards text | Read I-D Advance and ran the suite | verified | The `gh pr view {n} --json mergeable` read comes before the first `gh pr checks {n}` poll. The conflict stop line is present |
| REQ-002 AC-2 ship skill text | Read the initiative step paragraph | verified | It names the read and the merge of the initiative branch |
