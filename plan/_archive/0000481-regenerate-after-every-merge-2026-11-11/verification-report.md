---
title: "Verification Report - 0000481-regenerate-after-every-merge"
summary: "Execution evidence for each acceptance criterion."
status: "active"
version: "0.1.0"
---
# Verification Report - 0000481-regenerate-after-every-merge

I ran each suite in a temporary git repo. The queue suite runs `merge-queue.mjs run` against a bare remote with a fake `gh`.

| Criterion | Method | Outcome | Observation |
|-----------|--------|---------|-------------|
| AC-1 Stale index after a clean merge | `bash src/ravintio-zero/tests/test-0000481-req-001-queue-regenerates.sh` | verified | Exit 0. The queue printed `regenerated: plan/backlog/index.md`. The PR branch held the commit `0000402: Regenerate shared files`. The base index listed the step 2 entry. |
| AC-1 (module) | `bash src/ravintio-zero/tests/test-0000481-req-001-regenerate.sh` | verified | The index matched `backlog-index.mjs --check` after the module ran. One commit added. |
| AC-2 Nothing to change | Same suites | verified | A second module run returned `[]` and added no commit. A queue run with a current index printed no `regenerated:` line. |
| AC-3 Counters never fall | Module suite | verified | A counter lowered in the merge commit rose to the parent value `0000015` and the module reported the path. |
| Conflict path still works | `test-0000456-req-001-queue-resolves.sh`, `test-0000456-req-001-shared-files.sh` | verified | 11 and 15 checks passed. |

## Coverage

| Requirement | Tests |
|-------------|-------|
| REQ-001 | `test-0000481-req-001-regenerate.sh` (12 checks), `test-0000481-req-001-queue-regenerates.sh` (8 checks) |
