# Verification report - 0000555-initiative-pause-reaches-every-step

Started nothing long-lived. The checks run shell suites. One suite runs the driver against stub steps and starts and stops real child processes.

| Criterion | Method | Outcome | Evidence |
|-----------|--------|---------|----------|
| REQ-001 AC-1 Step records | CLI: `bash ravintio-zero/tests/test-0000555-req-001-pause-records.sh` | verified | Exit 0. Both worktrees hold `pause.md` with phase P2 and P1. |
| REQ-001 AC-2 Initiative record | CLI: same suite | verified | Exit 0. The record holds the merged count, the remaining order, the open block, and the resume steps. |
| REQ-001 AC-3 Refusals | CLI: same suite | verified | Exit 1 for a second write and for a symlinked worktree. Nothing written through the link. |
| REQ-002 AC-1 No new starts | CLI: `bash ravintio-zero/tests/test-0000555-req-002-driver-pause.sh` | verified | Exit 0. With a request and two pending steps, no session starts. |
| REQ-002 AC-2 Phase boundary stop | CLI: same suite | verified | Two running stub sessions stop after a `Complete: P2` line. The driver exits 0, prints `Paused: 0 steps merged, 2 steps hold a pause record`, and releases the lock. |
| REQ-002 AC-3 Resume | CLI: same suite | verified | A second driver prints the resume line, removes both files, and merges steps 1 and 3. |
| REQ-003 AC-1 Finding | CLI: `bash ravintio-zero/tests/test-0000555-req-003-resume-finding.sh` | verified | The finding prints before `pause record present`. |
| REQ-003 AC-2 Rules | Side effect: grep of both trees | verified | The standards, the skill, and the reference hold the rules and the finding. |
| NFR-001 Skill length | CLI: four length suites | verified | The skill has 117 lines. |
| NFR-002 No symlink write | CLI: REQ-001 suite | verified | See REQ-001 AC-3. |
