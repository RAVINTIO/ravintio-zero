# Verification Report - 0000583-step-temp-cleanup-after-merge

**Started:** the stub-claude scheduler fixture (`helpers/scheduler-fixture.sh`), a real git repo with a bare origin, and the driver `initiative-run.mjs`. Nothing reached the network.

| Criterion | Method | Outcome | Evidence |
|-----------|--------|---------|----------|
| REQ-001 AC-1 private folder | Ran the driver and read the stub environment | verified | `TMPDIR` and `GIT_CEILING_DIRECTORIES` equal `{worktree}/.t` |
| REQ-001 AC-2 sandbox | Read the `--settings` argument the stub received | verified | `enabled` is true, `allowWrite` holds the worktree, the git folder, and the control folder, and not `/tmp` |
| REQ-001 AC-2 Claude Code honours the keys | None possible without a live session | not-verifiable | Needs a real step session (S-001) |
| REQ-001 AC-3 removal after merge | Ran the driver to merge, then listed worktrees | verified | Worktree and `.t` folder gone, `git worktree list` omits them |
| REQ-001 AC-4 ignore rule | Read `.gitignore` | verified | Lists `.t/` |
| REQ-001 AC-5 socket limit | Ran the driver with the limit at 104 and a long path | verified | Exit non-zero, message names the cause, step 1 stays pending |
| REQ-002 AC-1, AC-2, AC-3 | Ran five suites and the helper, sent `TERM` | verified | No `ravintio_*` entry left |
| REQ-003 AC-1 planted files | Planted `step1*` and `step2*` files outside the repo, ran the driver to merge | verified | All four still exist |
| REQ-003 AC-2 script scan | Scanned `scripts/` and `hooks/` | verified | No removal in a shared temp folder |
| REQ-004 AC-1, AC-2 | Read the rule and the skill through `assert_rule` | verified | Rule names `$TMPDIR`, `/tmp`, `EXIT`. Skill names the rule |
