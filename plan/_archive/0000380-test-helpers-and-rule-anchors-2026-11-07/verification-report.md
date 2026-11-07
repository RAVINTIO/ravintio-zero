# Verification report - 0000380-test-helpers-and-rule-anchors

Started: no service. Each check ran a Bash command in the worktree or in a temporary copy of `ravintio-zero/`.

| Criterion | Method | Outcome | Evidence |
|-----------|--------|---------|----------|
| Moving a section fails no test | Moved the whole Phase Invocation reference into a new file in a copy, then ran `test-0000151-req-009` and `test-0000023-req-001` | verified | 11 passed, 0 failed. 8 passed, 0 failed. |
| A heading in neither place fails | Ran `orch_section` on a missing heading in `test-0000380-req-001` | verified | Exit 1 and a marker naming the heading |
| Moving an anchored rule keeps tests green | `test-0000380-req-002` moves a fixture rule between files | verified | 21 passed, 0 failed |
| Rewording with key terms passes | Reworded a Phase Invocation rule in the copy, then ran the anchor suite. The fixture reword case also runs. | verified | 21 passed, 0 failed |
| Deleting an anchor fails and names it | Deleted `resume-run-mode` in the copy, then ran `test-0000042-req-003` | verified | Three failures show `RULE ANCHOR NOT FOUND: resume-run-mode` |
| `with_timeout` stops a slow command and passes a fast one | `test-0000380-req-003` on the perl path and the Bash watchdog path | verified | Exit 124 within 5 seconds, exit 3 passed through, 15 passed, 0 failed |
| Windows (Git Bash) portability | No Windows runner available locally | not-verifiable | CI runs the Windows jobs |
