# Verification report - 0000411-queue-waits

**Method.** I ran the new suite against the old script and the new one. I ran the five queue suites the plan names, then the full suite in a clean clone in 4 shards, and compared it with the baseline.

| Criterion | Method | Outcome | Evidence |
|-----------|--------|---------|----------|
| REQ-001 AC-1 a slow GitHub | `test-0000411-req-001` | verified | With two stale-head and two `UNKNOWN` answers, the queue polls past them and merges. On the old script the same suite fails 7 of 9 checks |
| REQ-001 AC-2 no early merge | `test-0000411-req-001` | verified | The first `MERGEABLE` answer comes before the first merge call. A first "not mergeable" refusal gets exactly one retry |
| REQ-001 AC-3 the existing suites pass | 0000378, 0000392, 0000405, 0000043, and two 0000379 suites | verified | Each exits 0 |
| NFR-001 wait bound | `test-0000411-req-001` with `MQ_TIMEOUT_MS=300` | verified | A PR that never turns mergeable stops with `timed out waiting for PR #11: mergeable`, and the queue never merges it |

**Not verifiable.** The real GitHub race shows only on a live PR. The next queue run in initiative 0000360 shows it.

**Test run.** 375 suites, 372 passed. `test-0000037-req-004` and `test-0000318-req-004` match `baseline-failures.md`. `test-0000151-req-004-prune-retired-hooks.sh` exited 141 (SIGPIPE) under the parallel load and passes alone on the branch and the base.
