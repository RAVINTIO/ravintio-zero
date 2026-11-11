---
title: "Verification Report - 0000493-driver-starts-after-restart"
summary: "What ran, and what it showed, for each acceptance criterion."
---
# Verification Report - 0000493-driver-starts-after-restart

Method: `test-0000493-req-001-003-handoff.sh` runs the real driver script with real processes. Each case builds a git repo with a bare origin, a stub `claude`, and a stub merge queue. The old driver spawns a real successor, and both write to one output file. The text suite reads the standards and the skill. No service started.

| Criterion | Method | Outcome | Observation |
|-----------|--------|---------|-------------|
| REQ-001 AC-1 Restart-only merge hands off | Three steps, step 1 changes `initiative-run.mjs`, step 2 runs | verified | The output holds the handoff line. Step 3 started while step 2 ran. The old driver exited 0 |
| REQ-001 AC-2 Setup hit keeps the stop | Queue stub changes a skills file, and again with both files | verified | `Setup:` and `Restart: Setup:` stops, exit 1, step 2 never started |
| REQ-001 AC-3 failed handoff keeps the stop | A local file blocks the fast-forward | verified | The existing `Restart:` stop, exit 1, no handoff line |
| REQ-002 AC-1 no duplicate session | Count `claude` starts per step | verified | One start for step 2 and one for step 3 |
| REQ-002 AC-2 ready step queued once | Count queue runs per PR | verified | One queue run per step, all three merged on origin |
| REQ-002 AC-3 dead supervisor | `--handoff` with a dead pid and a `running` file | verified | One new session, step 1 merged, exit 0 |
| REQ-003 AC-1 old driver records the stop | Step 2 blocks after the handoff | verified | The `stopped` file holds the stop line, old driver exit 1 |
| REQ-003 AC-2 successor stops new starts | Step 4 waits behind the block. Also a 2,000-character `stopped` file | verified | Step 4 never started. No output line passed 700 characters |
| REQ-003 AC-3 stale file ignored | A fresh driver with an old `stopped` file | verified | The driver exited 0 and merged step 1 |
| REQ-004 AC-1 to AC-3 text | Text suite | verified | 10 of 10 checks pass, including identical trees |
| Error path: spawn failure | Not run | not-verifiable | The test fixture cannot make `spawn` fail. The code returns false and the caller keeps the stop, the same path as the fast-forward case |
| NFR-001 start delay | Suite runs to completion with 10 second stub waits | verified | Step 3 started before the 10 second wait on step 2 expired |
