# Verification report - 0000546-queue-failure-leaves-dirty-files

Target type: CLI script. The agent ran `merge-queue.mjs run` against a bare remote, a queue worktree, and a pre-commit hook that rejects the set-version commit.

| Criterion | Method | Outcome | Evidence |
|-----------|--------|---------|----------|
| AC-1 Rejected commit | Ran `bash ravintio-zero/tests/test-0000546-req-001-restore-written-files.sh` | verified | Exit 1 from `run`. `git status --porcelain --untracked-files=no` printed nothing. The output held a `restored:` line that names `plan/current-initiative/initiative.md`. |
| AC-2 Other files stay | Same run | verified | `untracked.txt` still held `keep me`. |
| AC-3 Rerun starts clean | Same run, then the hook flag removed and `run` invoked again | verified | Exit 0 and `merged PR #11 as v0.58.0`. The output held no `working tree is not clean`. |
| NFR-001 Copies match | `diff` of both `merge-queue.mjs` copies | verified | No difference. |
