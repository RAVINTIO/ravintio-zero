# Verification report - 0000548

Started: `bash ravintio-zero/tests/test-0000548-req-001-suite-marker.sh` in the step worktree. The test drives the real hook and both runners in temporary repos.

| Criterion | Method | Outcome | Evidence |
|-----------|--------|---------|----------|
| AC-1 quiet hook during a suite run | Hook / gate: trigger the hook with a live marker | verified | Test AC-1: no banner for a step session with a live marker. 14 of 14 checks pass |
| AC-2 strict banner otherwise | Hook / gate: trigger with no, dead, or malformed marker | verified | Test AC-2: banner for a non-step session, a dead pid, non-pid text, and no marker |
| AC-3 marker lifecycle and tree check | Side effects: inspect the marker and run the runner | verified | Test AC-3 to AC-5: marker live during the run and removed on exit, run exits 0 with an unchanged ack, tree check exits 1 when a suite changes the ack |
| `run-tests.ps1` marker | not-verifiable | not-verifiable | No PowerShell run here. The test checks the text only. CI runs the windows leg |
