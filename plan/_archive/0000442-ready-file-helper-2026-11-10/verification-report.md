---
title: "Verification Report - 0000442-ready-file-helper"
summary: "Execution evidence for each acceptance criterion."
---
# Verification Report - 0000442-ready-file-helper

I ran the helper directly in a temporary control folder. The two new suites drive the helper and the driver against a stub `gh` and a stub `claude`.

| Criterion | Method | Outcome | Evidence |
|-----------|--------|---------|----------|
| REQ-001 AC-1 | CLI: `initiative-ready.mjs --pr 163` with `RAVINTIO_INITIATIVE_CONTROL` set | verified | Exit 0. Output `I-D Advance: Ready: PR #163`. File held `163`. Mode 600. |
| REQ-001 AC-2 | CLI: `--pr 4x`, symlinked folder, symlinked file, no variable (suite) | verified | Exit 1 each time. Nothing written. The refusal never echoed the value. |
| REQ-001 AC-3 | CLI: `--check` on a missing, empty, timestamp, and valid file | verified | Exit 1 for the first three. Exit 0 and `ready holds PR #163` for the last. |
| REQ-002 AC-1, AC-2 | Driver run with an empty file and with a timestamp, stub `gh` lists one PR | verified | Exit 0. The queue ran for PR 77. The recovery line printed. No new session started. |
| REQ-002 AC-3 | Driver run with a stub `gh` that lists none, two, a non-numeric value, junk, or fails | verified | Exit 1 each time with the invalid ready file line. The queue never ran. Nothing in the output ran as a command. |
| REQ-002 (valid file) | Driver run with a valid file | verified | `gh` never ran. |
| REQ-003 AC-1 | Read the ship skill and the roadmap standards | unverified (docs only) | Both name the helper. No run observes documentation. |

Result: 32 and 31 checks passed, 0 failed. The real `gh pr list` output shape is `unverified (docs only)`. It rests on assumption A-001.
