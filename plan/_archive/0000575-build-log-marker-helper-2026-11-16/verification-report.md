# Verification report - 0000575-build-log-marker-helper

Method: the agent ran `build-log-mark.mjs` against a scratch build log in a temporary folder and removed the folder after.

| Criterion | Method | Outcome | Evidence |
|-----------|--------|---------|----------|
| REQ-001 AC-1 RED and GREEN lines | CLI run with kind `RED` | verified | Exit 0. The log ended with `- RED: exec check ({time})`. |
| REQ-001 AC-2 Done line | CLI run with kind `Done` and flags | verified | The suite `test-0000575-req-001` checks the full form. A run with `--tier` missing exited 2. |
| REQ-001 AC-3 Refusals | CLI run with a missing flag and a symlinked log | verified | Both exited 2 with one stderr line. |
| REQ-002 AC-1 Skill names the script | Suite `test-0000575-req-002` reads the rule | verified | 3 checks passed. |
| REQ-002 AC-2 Standards name the script | Same suite | verified | 3 checks passed. |
| Marker lines in this log | The agent wrote the U1 and U2 `GREEN:` and `Done:` lines with the script | verified | `build-log-check.mjs` runs at ship. |
