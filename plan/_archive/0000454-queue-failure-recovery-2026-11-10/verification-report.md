# Verification report - 0000454-queue-failure-recovery

**Method.** I ran the new suite before and after the change. The suite drives the real `merge-queue.mjs` and real `git` against a bare remote and a queue worktree, with a fake `gh`. I then ran the nine other suites that name `merge-queue.mjs`, and the full suite in a clean clone.

| Criterion | Method | Outcome | Evidence |
|-----------|--------|---------|----------|
| REQ-001 AC-1 stale version commit | `test-0000454-req-001`, moved-base world | verified | The rerun exits 0, prints `reverted set version 0.58.0: the base moved to 0.59.0`, tags v0.59.0, and the chart row holds 0.59.0 |
| REQ-001 AC-2 unchanged base | `test-0000454-req-001`, same-base world | verified | The PR branch history holds the same number of commits at merge as before the rerun. The rerun tags v0.58.0 |
| REQ-001 AC-3 no force-push | `test-0000454-req-001` | verified | The head the failed run left stays in the PR branch history at merge time |
| REQ-002 AC-1 failed run | `test-0000454-req-001` | verified | `git symbolic-ref` fails in the queue worktree after the failed run, and `git worktree add` of the step branch succeeds |
| REQ-002 AC-2 successful run | `test-0000454-req-001` | verified | The queue worktree has no branch after the merge and after the rerun |
| REQ-003 AC-1 to AC-3 | `test-0000454-req-001` | verified | The suite covers the failure, the base change, the restart check, and the unchanged-base rerun |

**Not verifiable.** A live failed run against GitHub. The next failed queue run shows it.

**Test run.** 381 feature suites passed and 2 failed in a clean clone. `test-0000037-req-004` and `test-0000318-req-004` match `baseline-failures.md`. The new suite failed 9 of 18 checks before the change and passes 18 of 18 after it.
