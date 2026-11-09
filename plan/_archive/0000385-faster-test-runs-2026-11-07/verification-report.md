# Verification report - 0000385-faster-test-runs

Started: no service. Each check ran a Bash or Node command in the worktree.

| Criterion | Method | Outcome | Evidence |
|-----------|--------|---------|----------|
| The implement skill names the affected-tests rule and the single full run | Ran `test-0000385-req-001` against the skill rules | verified | 8 passed, 0 failed |
| Each cycle appends a `Tests run:` line | Read the build-log template and this run's build log | verified | The template holds both forms and the log holds three lines |
| P3 reruns failed suites, then runs the full suite once | Ran `test-0000385-req-001` against the validate skill rules | verified | `p3-rerun-failed` and `p3-full-suite` hold their terms |
| Matching failures pass and list as inherited, a new failure stops | Ran `baseline-failures.mjs check` on this run's clean-clone output, and `test-0000385-req-002` | verified | Exit 0 and `inherited: test-0000037-req-004-remove-old-folder.sh`. 15 passed, 0 failed. |
| The script runs the suite in a clone, and an untracked file fails | Ran `clean-clone-test.mjs` on this repo and `test-0000385-req-003` | verified | 304 feature and 19 regression suites ran in the clone. 11 passed, 0 failed. |
| The OS gap is named and the clone is removed | Same runs | verified | `OS gap: local macos, CI ubuntu, windows`. No `ravintio-clean-clone-*` folder remains. |
| Clone cost under 30 seconds | Timed `clean-clone-test.mjs -- true` | verified | 2 seconds |
