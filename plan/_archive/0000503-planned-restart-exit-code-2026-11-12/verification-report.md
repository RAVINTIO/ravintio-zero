---
title: "Verification Report - 0000503-planned-restart-exit-code"
summary: "Each acceptance criterion, run against the driver, with the exit code observed."
---
# Verification Report - 0000503-planned-restart-exit-code

The agent ran the driver in throwaway git repos with a stub `claude` and a stub merge queue. It read the exit code and the stop line for each case.

| Criterion | Method | Outcome | Observation |
|-----------|--------|---------|-------------|
| REQ-001 AC-1 serial `Restart:` | CLI run | verified | Exit 75, line unchanged |
| REQ-001 AC-2 concurrent `Restart:` | CLI run | verified | Exit 75, line unchanged |
| REQ-001 AC-3 `Restart: Setup:` | CLI run, serial and concurrent | verified | Exit 75 in both |
| REQ-002 AC-1 bare `Setup:` | CLI run, serial and concurrent | verified | Exit 1 in both |
| REQ-002 AC-2 blocked step | CLI run | verified | Exit 1 |
| REQ-002 AC-3 failure after restart hit | CLI run | verified | Exit 1, restart line printed first |
| REQ-002 AC-4 clean run | CLI run, serial and concurrent | verified | Exit 0 |
| REQ-003 AC-1 to AC-3 docs | File inspection and `sync-installed.mjs --check` | verified | Standards, skill, driver header, and ADR name the code. Trees match. |

Suite: `test-0000503-req-001-003-restart-exit.sh` passes 23 of 23 in both pack trees.
