---
title: "Verification Report - 0000397-pack-source-in-src"
summary: "Execution evidence for each acceptance criterion of the pack source move."
---
# Verification Report - 0000397-pack-source-in-src

Each row ran the command or hook and recorded what it printed.

| Criterion | Method | Outcome | Observation |
|-----------|--------|---------|-------------|
| REQ-001 AC-1: history follows | `git log --follow --oneline src/ravintio-zero/setup.sh` | verified | 66 commits. The oldest is `700ff352`, from before the move. |
| REQ-001 AC-2: pure rename | `git diff -M --numstat b419da39~1 b419da39` | verified | 681 rows, 0 with added or removed lines. |
| REQ-002 AC-1: byte parity | `node src/ravintio-zero/scripts/sync-installed.mjs --check` | verified | Exit 0 after the last refresh. |
| REQ-002 AC-2: check reports drift | Same command on a scratch repo with one changed file | verified | Exit 1, and it named `setup.sh`. |
| REQ-002: no symlink | `find ravintio-zero -type l` | verified | 0 results. |
| REQ-003 AC-1: suite passes from the source | `bash src/ravintio-zero/tests/run-tests.sh` in a clean clone under `/private/tmp` | verified | See the acceptance evidence for the counts. |
| REQ-003 AC-2: CI uses the source | Search `.github/workflows/ravintio.yml` for pack calls | verified | Every pack call uses `src/ravintio-zero/`. The only `ravintio-zero/tests` text is inside `src/ravintio-zero/tests`. |
| REQ-004 AC-1: route documented | Read `src/ravintio-zero/docs/layout.md` | verified | Names the source, the installed copy, and the refresh command. |
| REQ-004 AC-2: refresh works | Ran `sync-installed.mjs` after a docs edit | verified | Printed `synced 687 files`, then `--check` exited 0. |
| REQ-005 AC-1: same block | `test-0000397-req-005-guards-cover-both.sh` | verified | 44 assertions passed. |
| REQ-005 AC-2: no new allowance | Same test, allowlist comparison against `b419da39^` | verified | Only `(src/)?` mirrors differ. |
| Consumer installs keep their path | Scratch repo with a copy of `ravintio-zero/`, then `setup.sh claude-code` | verified | Exit 0, `.claude` and `ravintio-zero` present, no `src/ravintio-zero`. |
| Windows suite on the new depth | CI only | not-verifiable | Needs the first CI run on the PR. |
