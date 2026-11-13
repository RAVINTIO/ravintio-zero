---
title: "Verification Report - 0000505-coordinator-branch-regenerate"
summary: "Execution evidence for each acceptance criterion."
status: "active"
version: "0.1.0"
---
# Verification Report - 0000505-coordinator-branch-regenerate

I ran the suite in temporary git repos. Each repo holds a coordinator branch `feat` and a base branch `main`.

| Criterion | Method | Outcome | Observation |
|-----------|--------|---------|-------------|
| AC-1 Stale index after a clean merge | `bash src/ravintio-zero/tests/test-0000505-req-001-coordinator-merge.sh` | verified | Exit 0. The command printed `regenerated: plan/backlog/index.md`. The regeneration commit used the initiative id. A second run added no commit. |
| AC-2 Conflict on shared files | Same suite | verified | The command printed `resolved:` for the index and the counter. The counter took the higher value `0000012`. The head was a merge commit and the tree was clean. |
| AC-3 Conflict on any other file | Same suite | verified | Exit 1. The message named `README.md`. The head was unchanged and the tree was clean. |
| Dirty tree, missing id, unknown ref | Same suite | verified | Each case exited 1 and added no commit. |

## Coverage

| Requirement | Tests |
|-------------|-------|
| REQ-001 | `test-0000505-req-001-coordinator-merge.sh` (24 checks) |
