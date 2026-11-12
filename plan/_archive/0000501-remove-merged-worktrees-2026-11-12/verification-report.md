# Verification Report - 0000501-remove-merged-worktrees

The agent ran the real driver `src/ravintio-zero/scripts/initiative-run.mjs` against fixture repos with a stub `claude` and a stub merge queue. Each case marks step 1 merged in the chart, adds its worktree, then starts the driver.

| Criterion | Method | Outcome | Observation |
|-----------|--------|---------|-------------|
| REQ-001 AC-1: clean merged worktree goes | CLI run with a clean worktree whose branch sits on origin | verified | Exit 0. The step 1 worktree is gone. No `Kept:` line. Step 2 merged. |
| REQ-001 AC-2: unmerged worktree stays | CLI run where step 2 blocks | verified | Exit 1. The step 2 worktree remains and the output has no `Kept: step 2`. |
| REQ-001 AC-3: no worktree, no output | CLI run with no step 1 worktree | verified | Exit 0 and no `Kept:` line. |
| REQ-002 AC-1: uncommitted file keeps the worktree | CLI run with an untracked `notes.txt` | verified | The file remains. The output holds `Kept: step 1 worktree holds uncommitted files: notes.txt`. |
| REQ-002 AC-2: git failure keeps the worktree | CLI run with the worktree `.git` file pointed at a missing folder | verified | The worktree remains. The output holds `worktree could not be inspected`. |
| REQ-002 AC-3: the run goes on | The same runs, reading the exit code and the chart on origin | verified | Exit 0 and step 2 merged. |
| REQ-003 AC-1: unpushed commit keeps the worktree | CLI run with a local commit that origin lacks | verified | The worktree remains. The output holds `head is not on origin/feat/0000051-s1`. |
| REQ-003 AC-2: branch gone from origin | CLI run with a branch that was never pushed | verified | The worktree is gone and there is no `Kept:` line. |
| REQ-003 AC-3: live session keeps the worktree | CLI run with a `running` file that holds a live pid | verified | The worktree remains. The output holds `a session still runs`. |
| REQ-004 AC-1: driver header | Read the first 170 lines of the driver | verified | They name the merged-step sweep and `I-C Run: Kept:`. |
| REQ-004 AC-2: standards | Read "Concurrent steps" in `roadmap-standards.md` | verified | Item 7 names the sweep, the three conditions, and the `Kept:` line. |

Test file: `src/ravintio-zero/tests/test-0000501-req-001-004-sweep.sh` (31 passed, 0 failed).
