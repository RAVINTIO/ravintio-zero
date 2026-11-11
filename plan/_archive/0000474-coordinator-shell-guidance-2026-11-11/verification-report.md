---
title: "Verification Report - 0000474-coordinator-shell-guidance"
summary: "Execution evidence for each acceptance criterion."
status: "active"
version: "0.1.0"
---
# Verification Report - 0000474-coordinator-shell-guidance

I ran the three suites against temporary folders and repos. I also ran both scripts by hand with a scratch spec file and an empty queue.

| Criterion | Method | Outcome | Observation |
|-----------|--------|---------|-------------|
| REQ-001 AC-1 The section exists | `bash src/ravintio-zero/tests/test-0000474-req-001-004-shell-section-and-guards.sh` | verified | The section names bash, the Write tool, the three snags, the three commands, and the guards. |
| REQ-001 AC-2 The skill points to it | Same suite | verified | The skill names `coord-shell-tasks`. Skill text totals 1,683 lines, under the 1,720 cap. |
| REQ-002 AC-1 Matching items go | `bash src/ravintio-zero/tests/test-0000474-req-002-queue-drain.sh` | verified | Two step 7 folders were drained with a `drained:` line each. The step 8 folder stayed. |
| REQ-002 AC-2 Unsafe entries stay | Same suite | verified | A symlinked folder produced a warning and its target stayed. |
| REQ-002 AC-3 Empty queue | Same suite, and `drain --step 41` in this worktree | verified | Exit 0 and `drained: none`. |
| REQ-003 AC-1 Literal replacement | `bash src/ravintio-zero/tests/test-0000474-req-003-bulk-edit.sh`, and a hand run replacing `X` with `$&` | verified | The file held `a$&b`. No text duplicated. |
| REQ-003 AC-2 Unsafe path | Same suite | verified | A `..` path, an absolute path, an empty `from`, and a symlink each exited 1. The first edit in the spec was not written. |
| REQ-003 AC-3 Dry run | Same suite | verified | The `edited:` line printed and the file stayed. |
| REQ-004 AC-1 Forced add forms stay blocked | Same suite as REQ-001 | verified | A compound forced add and a quoted `-f` exited 2. |
| REQ-004 AC-2 Merge forms stay blocked | Same suite as REQ-001 | verified | A variable merge and a compound merge into `main` exited 2. |
| REQ-004 AC-3 Hooks untouched | `git diff --stat` against the base | verified | No file under `hooks/enforcement/` appears in the diff. |

## Coverage

| Requirement | Tests |
|-------------|-------|
| REQ-001, REQ-004 | `test-0000474-req-001-004-shell-section-and-guards.sh` (16 checks) |
| REQ-002 | `test-0000474-req-002-queue-drain.sh` (10 checks) |
| REQ-003 | `test-0000474-req-003-bulk-edit.sh` (14 checks) |
