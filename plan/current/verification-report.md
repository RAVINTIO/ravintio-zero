# Verification report - 0000560

Started: no service. Each criterion ran as a CLI check from the worktree root.

| Criterion | Method | Outcome | Evidence |
|-----------|--------|---------|----------|
| REQ-001 AC-1 a done row stays quiet | New suite `test-0000560-req-001-ledger-rows-with-detect.sh` | verified | Exit 0, 4 passed, 0 failed. |
| REQ-001 AC-2 a not applicable row with a true Detect line reports | Same suite | verified | Both the current and the older pack version print the pending line. |
| REQ-001 AC-3 a not applicable row with a false Detect line stays quiet | Same suite | verified | The current version prints no pending line. |
| NFR-001 parity | `sync-installed.mjs --check` | verified | Exit 0. The suite also passes from `ravintio-zero/tests/`. |

RED came from a mutant copy of `resume-detect.mjs` that skips every ledger row. The suite failed 2 of 4 checks against it and passed 4 of 4 against the real script. `resume-detect.mjs` run in this worktree prints no pending line.
