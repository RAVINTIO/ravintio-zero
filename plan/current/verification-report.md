# Verification report - 0000359-safe-parallel-commits

Started nothing. The changes are skill text, one standard, and two Bash tests. Each check ran on the repo files.

| Criterion | Method | Outcome | Observation |
|-----------|--------|---------|-------------|
| The orchestrator skill names the git commands a step never runs while subagents run | CLI: `test-0000359-req-001-no-tree-git-under-subagents.sh` and `grep` on the skill | verified | The skill holds one line naming `git stash`, `git checkout -- {path}`, `git reset`, and `git clean` while any subagent runs. It holds 8882 bytes of 9000. |
| The implement skill names the scratch clone and the build log note | CLI: the same test and `grep` on the skill | verified | The `### Shared tree` section names the four commands, the scratch clone, and the build log note. Skill text holds 1614 lines of 1720. |
| The dispatch standard names the `-- {paths}` form and the amend ban | CLI: `test-0000359-req-002-own-path-commits.sh` and a read of `## Fast batches` | verified | The section holds the path-limited commit form and `Never run git commit --amend`. The stage-by-path and no-stash bullets remain. |
| Earlier suites that pin the dispatch standard | CLI: the full runner | verified | 286 feature suites and 19 regression suites pass. |
| Hooks and setup after the rerun | Human check at the `Setup:` stop | not-verifiable | The chart assigns the setup rerun to the coordinator, before I-E Delivery. |
