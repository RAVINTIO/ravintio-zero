# Verification report - 0000548

Started: `bash ravintio-zero/tests/test-0000548-req-001-suite-marker.sh` in the step worktree. The test drives the real hook and both runners in temporary repos.

| Criterion | Method | Outcome | Evidence |
|-----------|--------|---------|----------|
| AC-1 quiet hook during a suite run | Hook / gate: trigger the hook with a live marker | verified | Exit 0 with no banner, 14 of 14 checks pass |
| AC-2 strict banner otherwise | Hook / gate: trigger with no, dead, or malformed marker | verified | Banner emitted |
| AC-3 marker lifecycle and tree check | Side effects: inspect the marker and run the runner | verified | Marker removed on exit, tree check exits 1 on an ack change |
| `run-tests.ps1` marker | not-verifiable | not-verifiable | No PowerShell run here. The test checks the text only. CI runs the windows leg |
