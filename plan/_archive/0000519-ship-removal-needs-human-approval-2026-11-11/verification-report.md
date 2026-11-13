---
title: "Verification Report - 0000519-ship-removal-needs-human-approval"
summary: "What ran, and what it showed, for each acceptance criterion."
---
# Verification Report - 0000519-ship-removal-needs-human-approval

Method: ran `git rm -r -q plan/current` in a scratch repo at `/tmp/s58` after copying the folder, and read the skill text. The two new suites run the same text checks. No service started. The scratch run cannot show how the Claude Code safety check treats the command. The coordinator ran `git rm -rq plan/current` on step 57 without a refusal.

| Criterion | Method | Outcome | Observation |
|-----------|--------|---------|-------------|
| REQ-001 AC-1 Step 4 names the git command | Text suite and grep | verified | Step 4 item 4 holds `git rm -r -q plan/current` after the copy |
| REQ-001 AC-2 no plain rm -r | Text suite | verified | No `rm -r` of `plan/current` remains outside `git rm -r` |
| REQ-001 AC-3 installed copy | Text suite and `sync-installed.mjs --check` | verified | The installed ship skill equals the source |
| Command works | Ran it in the scratch repo | verified | Exit 0, the folder is gone, the archive copy stays |
| REQ-002 AC-1 rule orders docs and suite | Text suite | verified | The rule says to write docs before the suite starts and to change no file until it ends |
| REQ-002 AC-2 no docs-while-suite text | Text suite | verified | No `while you write docs` or `while the full test suite runs` remains |
| REQ-002 AC-3 caps | Text suite | verified | All skills total 1,683 lines of 1,720 |
