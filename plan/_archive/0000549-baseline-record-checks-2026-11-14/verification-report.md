# Verification report - 0000549-baseline-record-checks

The agent ran `node ravintio-zero/scripts/baseline-failures.mjs` against fixture files in a temporary folder, with `--file` pointing into that folder. The agent started no service.

| Criterion | Method | Outcome | Evidence |
|-----------|--------|---------|----------|
| REQ-001 AC-1 | CLI run of `record` on output with no totals line | verified | Exit code 2. One stderr line names the missing `Feature suites:` line. The baseline file does not exist. |
| REQ-001 AC-2 | CLI run of `record` on output with a totals line and no failed suites | verified | Exit code 0. The file lists `None.`. |
| REQ-002 AC-1 | CLI run of `check` with no baseline file | verified | Exit code 1. Stderr holds `no baseline recorded`. Stdout is empty. |
| REQ-002 AC-2 | `record`, then `check` on output that fails the same suite | verified | Exit code 0. Stdout holds `inherited: test-a.sh`. |

A first attempt at REQ-002 AC-2 used a baseline file the agent wrote by hand in the wrong format. It printed `new:`. The agent then built the file with `record` and the criterion passed.
