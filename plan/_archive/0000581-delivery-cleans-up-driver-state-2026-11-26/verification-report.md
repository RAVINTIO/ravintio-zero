# Verification Report - 0000581-delivery-cleans-up-driver-state

**Started:** `initiative-cleanup.mjs` against scratch git repos in `$TMPDIR`, with real worktrees, real driver folders, and `initiative-status.mjs`. Nothing reached the network.

| Criterion | Method | Outcome | Evidence |
|-----------|--------|---------|----------|
| REQ-001 AC-1 lock blocks | Ran the script with `plan/.initiative-runner.lock` present | verified | Exit 1, `Blocked:` line, both folders still in `plan/` |
| REQ-001 AC-2 bad id | Ran with no `--id` and with `../escape` | verified | Exit 1 each time, nothing moved |
| REQ-002 AC-1 both folders move | Ran the script and listed `.git/ravintio-archive/{id}/` | verified | Logs and control files in the archive, `plan/` holds neither |
| REQ-002 AC-2 existing target | Ran with an archive folder of the same name | verified | `{id}-2` holds the new folders, the old folder is unchanged |
| REQ-002 AC-3 symlink | Ran with `plan/.initiative-logs` as a symlink | verified | Exit 1, `refused a symlinked path`, control folder stays |
| REQ-003 AC-1 worktrees go | Ran with two real worktrees | verified | Both folders gone, `git worktree list` shows one entry |
| REQ-003 AC-2 queue stays | Ran with two queue items | verified | Both items remain, one `Kept: queue item` line each |
| REQ-003 AC-3 failed removal | Ran with a folder git does not know | verified | `Kept:` line, exit 0, archive still made |
| REQ-004 AC-1 status reads zero | Ran the cleanup, wrote a pending chart, ran `initiative-status.mjs` | verified | `merged 0, ready 0, running 0, pending 2 of 2` |
| REQ-005 AC-1 standard names the cleanup | Read rule `rm-delivery-cleanup` through `assert_rule` | verified | Rule names the script, the lock, the archive folder, and the queue |
| REQ-005 AC-2 skill names the cleanup | Read rule `rm-ini-delivery` and counted lines | verified | Skill names the script and holds 118 lines |

A manual run in a separate scratch repo repeated the happy path and the lock refusal. It moved both folders, removed the worktree, named the queue item, and exited 0. With the lock present it exited 1.
