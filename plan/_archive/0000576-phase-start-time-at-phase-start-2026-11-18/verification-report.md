# Verification report - 0000576

Started no service. Ran each check as a CLI from the step worktree.

| Criterion | Method | Outcome | Evidence |
|-----------|--------|---------|----------|
| REQ-001 AC-1 | Ran `bash ravintio-zero/tests/test-0000576-req-001-start-time-check.sh` | verified | Exit 0. The late fixture prints a `P1: Start` finding that names the first artifact commit. |
| REQ-001 AC-2 | Same script, on-time fixture | verified | Exit 0. No check 10 finding. |
| REQ-001 AC-3 | Same script, fixture with no artifact commit | verified | Exit 0. No check 10 finding. |
| REQ-002 | Ran `bash ravintio-zero/tests/test-0000576-req-002-reference-wiring.sh` | verified | Exit 0. |
| Check 10 on this feature | Ran `node ravintio-zero/scripts/build-log-check.mjs` on the real log | verified | The output holds no check 10 finding for P1 or P2. |
