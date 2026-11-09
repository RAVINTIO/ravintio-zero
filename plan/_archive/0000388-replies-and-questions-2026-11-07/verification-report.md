# Verification report - 0000388-replies-and-questions

Started a scratch project folder with `plan/.orchestrator-active` and fed each hook a Stop or prompt payload. Removed the folder afterwards.

| Criterion | Method | Outcome | Evidence |
|-----------|--------|---------|----------|
| `check-design` injects `hh:mm` | Hook run with a bare payload | verified | Output holds `Local time: 22:30`, exit 0 |
| Prefix hook accepts a time before `I-C Run:` and `P0 Discovery:` | Hook run with each reply | verified | No output, exit 0, no miss line |
| Reply with neither prefix nor time logs a miss | Hook run | verified | Warning printed, one log line |
| Reply with a time and no prefix logs a miss | Hook run | verified | Warning printed, one log line |
| Warning names the check, quotes the reply, names the session | Hook run in both sessions | verified | Text holds "Reply prefix check", the quoted start, and "this session" or "step session" |
| Coordinator skip while the driver lock is held | Hook run with the step marker unset and the lock present | verified | No output, no new log line |
| Step session still checked while the lock is held | Hook run with the marker set | verified | Warning printed |
| Driver and watcher lines start with `hh:mm` | Read of `out` in both scripts, and the driver's own output line `22:30 I-C Run: Blocked: ...` | verified | `initiative-run.mjs:203`, `initiative-watch.mjs:116` |
| Agreement and question rules | Anchor tests read the rule text | verified | Tests 0000388-req-003 and req-004 pass |
| Docs name the time | Anchor test on boot templates, skills, roadmap standards | verified | Test 0000388-req-005 passes |
