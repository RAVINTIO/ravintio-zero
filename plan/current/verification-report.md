# Verification Report - 0000509-clear-merged-ready-files

The agent ran the real driver `src/ravintio-zero/scripts/initiative-run.mjs` against fixture repos with a stub `claude` and a stub merge queue. Each case marks step 1 merged in the chart, adds a control folder, then starts the driver.

| Criterion | Method | Outcome | Observation |
|-----------|--------|---------|-------------|
| REQ-001 AC-1: merged ready file goes | CLI run with a `ready` file in the control folder of step 1 | verified | Exit 0. The file is gone. The output holds `Cleared: step 1 ready file of a merged step` and no `Kept:` line. Step 2 merged. |
| REQ-001 AC-2: unmerged ready file stays | CLI run with a `ready` file for step 2 | verified | The output has no `Cleared: step 2`. |
| REQ-001 AC-3: no file, no output | CLI run with no control folder for step 1 | verified | Exit 0 and no `Cleared:` or `Kept: step 1` line. |
| REQ-001: other files stay | CLI run with a `stopped` file beside `ready` | verified | The `stopped` file remains. |
| REQ-002 AC-1: live session keeps the file | CLI run with a `running` file that holds a live pid | verified | The `ready` file remains. The output holds `Kept: step 1 a session still runs`. |
| REQ-002 AC-2: symlinked control path | CLI run with `step-1` as a symlink to an outside folder | verified | The file behind the link remains. The output holds a `Kept: step 1` line. The run goes on. |
| REQ-002 AC-3: dead pid | CLI run with a `running` file that holds a finished pid | verified | The file is gone and the output holds the `Cleared:` line. |
| REQ-003 AC-1: driver header | Read the first 175 lines of the driver | verified | They name the clearing and `I-C Run: Cleared:`. |
| REQ-003 AC-2: standards | Read "Concurrent steps" in `roadmap-standards.md` | verified | Item 8 names the clearing, the live-session keep rule, and both lines. |

Test file: `src/ravintio-zero/tests/test-0000509-req-001-003-clear-ready.sh` (23 passed, 0 failed).
