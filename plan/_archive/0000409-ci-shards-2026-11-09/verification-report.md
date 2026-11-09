# Verification report - 0000409-ci-shards

**Method.** I ran the two new suites and the three updated CI-shape suites. I ran the full suite in a clean clone of the branch, in 4 local shards, and compared it with the baseline on the base commit. I ran CI on PR #144 twice and read the job times with `gh run view`.

| Criterion | Method | Outcome | Evidence |
|-----------|--------|---------|----------|
| REQ-001 AC-1 shards are disjoint and complete | `test-0000409-req-001` | verified | Shards 1 and 2 of 2 run each of five suites exactly once. Shard 2 of 3 runs suites 2 and 5, one of them a regression suite |
| REQ-001 AC-2 unset runs everything | `test-0000409-req-001` | verified | All five suites run |
| REQ-001 AC-3 a malformed value stops the run | `test-0000409-req-001`, a local `pwsh` run with `4/3` | verified | `3/2`, `0/2`, `x`, `1/0`, and `1/2/3` exit 2 and run nothing. `run-tests.ps1` prints the same message and exits 2 |
| REQ-002 AC-1 shard jobs | `test-0000409-req-002`, CI run on `e3786225` | verified | 4 bash shards and 4 Windows shards ran in parallel, each passing |
| REQ-002 AC-2 summary jobs keep the names | `test-0000409-req-002`, `gh pr checks 144` | verified | Checks named `bash-suites` and `windows-powershell (powershell)` reported and passed |
| REQ-002 AC-3 CI time | `gh run view` on `e3786225` | verified | The slowest shard took 4.5 minutes, and the whole run took 4 minutes 40 seconds. The first run, with 3 Windows shards, took 7m23s on one shard, so the Windows matrix grew to 4 |

**Not verifiable.** None.

**Test run.** 364 suites ran in a clean clone in 4 shards. 362 passed. `test-0000037-req-004` and `test-0000318-req-004` failed, and both fail the same way on the base commit, as `baseline-failures.md` records. Every shard reported its own count, and the counts add up to the full suite list.
