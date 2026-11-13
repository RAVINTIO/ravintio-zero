# Verification Report - 0000511-driver-stop-summary

The agent ran the real driver `src/ravintio-zero/scripts/initiative-run.mjs` against fixture repos with a stub `claude` and a stub merge queue. Each case starts the driver and reads its output and exit code.

| Criterion | Method | Outcome | Observation |
|-----------|--------|---------|-------------|
| REQ-001 AC-1: the block names a merge | CLI run of a two-step chart | verified | Exit 0. The output holds `Summary: merged this run: 1, 2`. |
| REQ-001 AC-2: the block names a fix | CLI run with a `ready` file for a merged step 1 | verified | The output holds `Summary: driver fixes: 1` and `Summary: fix: I-C Run: Cleared: step 1 ready file of a merged step`. It lists step 2 only as merged. |
| REQ-001 AC-3: nothing to list | CLI run where step 1 blocks | verified | The output holds `merged this run: none`. A clean run holds `driver fixes: 0` and no `fix:` line. |
| REQ-002 AC-1: clean end | CLI run that merges every step | verified | The action line reads `run initiative delivery from the initiative skill`, because delivery is pending. The final line is the `I-E Delivery: Pending:` line. |
| REQ-002 AC-2: blocked step | CLI run where step 1 blocks | verified | Exit 1. The action line reads `read the stop line and the step log, then start a new driver`. The final line holds `Blocked:`. |
| REQ-002 AC-3: planned restart | CLI run where the queue reports a changed driver file | verified | Exit 75. The action line reads `start a new driver`. The final line is the `Restart:` line. |
| REQ-002: setup stop | CLI run where the queue reports changed setup files | verified | Exit 1. The action line names the setup command. |
| REQ-003 AC-1: driver header | Read the driver header | verified | It names the `I-C Run: Summary:` lines. |
| REQ-003 AC-2: standards | Read "Concurrent steps" in `roadmap-standards.md` | verified | Item 9 names the three line kinds and the action rules. |
| REQ-003 AC-3: ADR | Read `docs/adr/0341-driver-stop-summary.md` | verified | It names the lines. |

Test file: `src/ravintio-zero/tests/test-0000511-req-001-003-stop-summary.sh` (23 passed, 0 failed).
