---
title: "Verification Report - 0000440-driver-reads-reply-blocks"
summary: "Execution evidence for each acceptance criterion."
---
# Verification Report - 0000440-driver-reads-reply-blocks

The driver ran against a stub `claude` on PATH in a temporary fixture repo. The suite `ravintio-zero/tests/test-0000440-req-001-reply-block.sh` drives it. Each row below is an observed run.

| Criterion | Method | Outcome | Evidence |
|-----------|--------|---------|----------|
| REQ-001 AC-1 | CLI: run `initiative-run.mjs --root {fixture}` with a stub that prints a `result` event holding `13:41 I-D Advance: Blocked: CI failed` and writes no build log | verified | Exit 1. The stub ran once. Output held `I-C Run: Blocked: step 1 stopped.` and the block line. No `Resuming` line. Lock released. |
| REQ-001 AC-1 (data) | Same run, reply text holds `$(touch pwned)` | verified | The file `pwned` was not created. |
| REQ-001 AC-1 (sad path) | Stub prints a non-JSON line, a numeric `result`, and a `result` event with no text | verified | No `stopped.` line. The driver took its normal resume path. |
| REQ-001 AC-1 (resolved) | Reply holds a block then `Resolved:` | verified | Exit 0 after one resume. |
| REQ-001 AC-2 | CLI: build log holds `I-D Advance: Blocked: CI failed` | verified | Exit 1, one stub call, stop line repeats the block. |
| REQ-001 AC-3 | CLI: stub removes the build log, then the driver resumes | verified | The resume prompt omits `Read plan/current/build-log.md`, says there is no build log in the archive, and still names `Question:`. |

Result: 16 checks passed, 0 failed. No criterion is `not-verifiable`. Nothing ran the real `claude` program, so a real `result` event shape is `unverified (docs only)`. It rests on assumption A-001.
