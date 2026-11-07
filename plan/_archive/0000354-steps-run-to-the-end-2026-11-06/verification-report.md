# Verification report - 0000354-steps-run-to-the-end

Started nothing. The scripts and the suites run from a shell. A stub `claude` on `PATH` stands in for the model.

| Criterion | Method | Outcome | Observation |
|-----------|--------|---------|-------------|
| A fake `claude` that exits 0 unmerged gets two resumes, then `Blocked:` | CLI: `initiative-run.mjs` against a two-step fixture, stub in `never` mode | verified | Exit 1. Three stub calls, two with `--resume sess-abc12345`. The output holds `Resuming ... resume 1 of 2`, `resume 2 of 2`, and `Blocked: step 1 exited without merging after 2 resumes`, then `Log: plan/.initiative-logs/step-1.log`. The lock is gone. |
| A resume lets a step merge | CLI: same fixture, stub in `once` mode | verified | Exit 0 at delivery. Four stub calls. Each step ran once and resumed once. The resume wrote to the same step log. |
| No resume without a valid id or after a failure | CLI: stub in `nosession`, `badid`, and `fail` modes | verified | Exit 1 each time with one stub call. The planted id `--bad id; touch pwned` created no file. |
| Running setup twice leaves a clean `git status` | CLI: `setup.sh claude-code --strict-orchestrator` twice in a scratch repo with the record committed | verified | The second run prints `= plan/state/claude-code.md (unchanged)`. `git status --porcelain -- plan/state` is empty. The ignored marker has a fresh `writtenAt`. A run without the flag rewrites the record. |
| `setup.ps1` holds the same compare | Source search, and a PowerShell parse of the file | verified | The parser reports 0 errors. The file holds the `(unchanged)` message. A run of PowerShell setup was not made. |
| With no `plan/current/build-log.md`, the watcher prints no stale line | CLI: `initiative-watch.mjs --once` on a scratch repo with a newer commit than the archived log | verified | One `I-C Run: waiting for the build log` line, no stale line. Three passes still give one waiting line. With a build log present, the stale line still prints. |
| The heartbeat names the running step | CLI: scratch repo at position 6 with `step-5.log` newest | verified | The heartbeat reads `step 5`. With no step log it reads `step 6`. The attempt log is ignored. |
| The three driver suites read their arguments from one helper | Test: `test-0000354-req-002-006-text-rules.sh` | verified | None of the four driver suites repeats `--permission-mode auto`. Each sources `helpers/driver-args.sh`. |
| The chart template holds the field, and the standards state the rule | Test: same suite | verified | The template holds `**Step CI fixes:**` with `allowed` and `stop`. The standards state both values and the default. |
| The orchestrator skill states the early-end rule | Test: same suite | verified | The skill holds the rule. `test-0000151-req-011` and `test-0000031-req-003` pass within their caps. |
| Real repo watcher run | CLI: `initiative-watch.mjs --root . --once` | verified | Heartbeat `step 4, phase P2`, lock held. No stale line. |
| Full suite and checks | CLI: `run-tests.sh`, `consistency-check.mjs`, `backlog-index.mjs --check`, `self-description-check.mjs` | verified | 271 feature suites and 19 regression suites pass. The three checks pass. |
