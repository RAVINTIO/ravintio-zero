# Verification report - 0000392-ship-postmortems

Started: no service. Each check ran a Bash command in the worktree.

| Criterion | Method | Outcome | Evidence |
|-----------|--------|---------|----------|
| Ship fails on a `Resolved:` line with no `Postmortem:` line | `test-0000392-req-001-ship-postmortem-check.sh` runs `build-log-check.mjs` on fixture logs | verified | 11 passed, 0 failed. Exit 1 and the finding names the missing line. |
| The record check fails on a missing CAPA row | `test-0000392-req-002-capa-record-check.sh` | verified | 10 passed, 0 failed. Exit 1 and `no preventive row`. |
| A `none, because` row passes | Same suite, with a bare `none` as the contrast | verified | The `none, because` record exits 0 and the bare `none` record exits 1. |
| The queue waits for pending checks after its push, then merges | `test-0000392-req-003-queue-waits-for-ci.sh` with a stub `gh` | verified | 8 passed, 0 failed. |
| The queue stops with the check name when a check fails after its push | Same suite | verified | Exit 1, `unit-tests` in the message, no `pr merge` call. |
| P4 raises a PR title that passes `merge-queue.mjs title` | `test-0000392-req-004-pr-title-form.sh` | verified | 13 passed, 0 failed. |
| Real `gh` returns the `--json name,bucket` shape | No pull request with checks exists in the worktree | not-verifiable | The first queue run in CI exercises it. |
| This run's own build log passes the new check | `build-log-check.mjs` at ship Step 3 | verified at ship | See the build log. |
