# Verification Report - 0000495-driver-clears-dead-lock

The agent ran the real driver `src/ravintio-zero/scripts/initiative-run.mjs` against fixture repos with a stub `claude`. Each case sets a lock file, then starts the driver.

| Criterion | Method | Outcome | Observation |
|-----------|--------|---------|-------------|
| REQ-001 AC-1: dead pid, driver takes the lock | CLI run with a lock that holds an exited pid | verified | Exit 0. Output names the pid. The step ran once. |
| REQ-001 AC-2: driver frees the lock at exit | Inspect the lock path after the run | verified | The file is gone. |
| REQ-002 AC-1: live pid, driver refuses | CLI run with the test process pid in the lock | verified | Non-zero exit. Existing refusal line. No step ran. The lock is unchanged. |
| REQ-002 AC-2: unreadable lock, driver refuses | CLI runs with `other-driver`, `12abc`, `0`, an empty file, `123 456`, and a symlink | verified | Each run refused and left the lock unchanged. The symlink remained. |
| REQ-003 AC-1: both texts state the rule | Read the driver header and `roadmap-standards.md` | verified | Both hold the words "no longer runs". |

Test file: `src/ravintio-zero/tests/test-0000495-req-001-002-dead-lock.sh` (34 passed, 0 failed).
