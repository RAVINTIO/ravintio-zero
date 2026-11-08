# Verification report - 0000405-queue-merge-subject

**Method.** I ran the new suite, which runs the real `merge-queue.mjs` against a local git remote with a blocking `commit-msg` hook. I ran the four queue suites the plan names, then the full suite. I listed the branch diff for hooks.

| Criterion | Method | Outcome | Evidence |
|-----------|--------|---------|----------|
| REQ-001 AC-1 the base merge has the short subject | `test-0000405-req-001` | verified | The merge commit on the step branch has the subject `0000401: Merge the initiative branch` |
| REQ-001 AC-2 a blocking hook passes | `test-0000405-req-001` | verified | The default subject in the test world is 148 characters. The queue exits 0, and the fake `gh` receives the squash call |
| REQ-001 AC-3 the existing suites pass | `test-0000378-req-002-003`, `test-0000043-req-005`, `test-0000379-req-004-position`, `test-0000379-req-004-queue-handoff` | verified | Each exits 0 |
| No hook change | `git diff --name-only` against the initiative branch | verified | The diff names no hook, `merge-guard`, `gate-write`, or `commit-standards.md` |

**Not verifiable.** None.

**Test run.** `run-tests.sh` ran 331 suites. Two failed, `test-0000042-req-006` and `test-0000043-req-009`. Both scan files under `plan/.initiative-worktrees/`, which the driver keeps for steps. Both pass in a clean clone of this branch. No change here causes them.
