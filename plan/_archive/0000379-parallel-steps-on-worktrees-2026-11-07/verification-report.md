# Verification report - 0000379-parallel-steps-on-worktrees

Method: ran each new suite against real git repositories, a bare `origin`, and a stub `claude` and merge queue. Ran `parseChart` and `readySteps` against the live chart.

| Criterion | Method | Outcome | Evidence |
|-----------|--------|---------|----------|
| REQ-001 AC-1 to AC-3 | `test-0000379-req-001-chart-columns.sh` and `node` on the live chart | verified | 18 passed. Live chart reports concurrency 3, 21 steps, step 3 ready. |
| REQ-002 AC-1 to AC-3 | scheduler suite with overlap markers | verified | 57 passed. Two stub sessions overlapped. Lane and `After` order held. The cap held. |
| REQ-003 AC-1 to AC-3 | scheduler suite | verified | cwd, branch, env, copied `.claude` and `CLAUDE.md`, worktree removed after merge, log kept. |
| REQ-004 AC-1 to AC-3 | queue hand-off and position suites | verified | 21 and 8 passed. Queue ran once per PR in ready order. Position names the lowest unmerged step. |
| REQ-005 AC-1 to AC-3 | scheduler suite | verified | A block stopped new starts and the report named each state. A restart file stopped starts. |
| REQ-006 AC-1 | `test-0000379-req-006-watcher.sh` | verified | 14 passed. |
| REQ-006 AC-2, REQ-007 AC-1 and AC-2 | text suites | verified | 9 passed for REQ-007. |
| Real `gh` and GitHub merge | none | not-verifiable | The suites use stub `gh` and a stub queue. Step 3 merges through the real queue at ship. |
