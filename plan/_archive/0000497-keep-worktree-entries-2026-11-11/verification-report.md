# Verification Report - 0000497-keep-worktree-entries

The agent ran the real driver `src/ravintio-zero/scripts/initiative-run.mjs` against fixture repos with a stub `claude` and a stub merge queue. Each case sets a stub mode, then starts the driver.

| Criterion | Method | Outcome | Observation |
|-----------|--------|---------|-------------|
| REQ-001 AC-1: untracked entry, worktree stays | CLI run with a step that leaves `plan/backlog/0000900-lost-entry/entry.md` untracked | verified | Exit 1. The worktree and the file remain. The queue never ran. The `ready` file stays. |
| REQ-001 AC-2: stop line names the file | Read the driver output of the same run | verified | The output holds `I-D Advance: Blocked: queue stopped on step 1` and the path of the file. |
| REQ-002 AC-1: no untracked entry, worktree goes | CLI run with a step that leaves no file | verified | Exit 0. The worktree is gone. Step 1 merged. |
| REQ-002 AC-2: other untracked files do not stop the queue | CLI run with a step that leaves `notes.txt` | verified | Exit 0. The worktree is gone. Step 1 merged. |
| REQ-002 AC-3: failed listing, worktree stays | CLI run with a step that points the worktree `.git` file at a missing folder | verified | Exit 1. The worktree remains. The output says `could not list untracked backlog entries`. |
| REQ-003 AC-1: ship rule | Read `ravintio-ship/SKILL.md` Step 4 | verified | It holds `git status --porcelain plan/backlog` and explicit-path staging. |
| REQ-003 AC-2: driver rule in the docs | Read the driver header and `roadmap-standards.md` | verified | Both hold the words `untracked backlog entries`. |

Test file: `src/ravintio-zero/tests/test-0000497-req-001-002-keep-entries.sh` (21 passed, 0 failed).
