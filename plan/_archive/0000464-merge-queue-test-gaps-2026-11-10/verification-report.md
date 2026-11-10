---
title: "Verification Report - 0000464-merge-queue-test-gaps"
summary: "What ran, and what it showed, for each acceptance criterion."
---
# Verification Report - 0000464-merge-queue-test-gaps

Method: ran the new suites against a fake `gh` and a bare remote. Then broke each guarded branch of `merge-queue.mjs` in turn and ran the suite again. No service started.

| Criterion | Method | Outcome | Observation |
|-----------|--------|---------|-------------|
| REQ-001 AC-1 no new commit | Ran `run` twice on one PR. The fake `gh` refused the first merge | verified | The first run exited 1 after it pushed the set-version commit. The second run left the PR branch history unchanged and the branch held one set-version commit |
| REQ-001 AC-2 the second run merges | Read the second run's exit code, output, and the remote | verified | Exit 0, `merged PR #11 as v0.58.0`, and the remote holds tag `v0.58.0` |
| REQ-002 AC-1 run stops | Ran `run` from a copy of the queue beside a stub `version-files.mjs` that rewrites `product.yml` to `9.9.9` | verified | Exit 1. The output holds `version mismatch`, `product.yml`, and `9.9.9` |
| REQ-002 AC-2 no merge | Read the fake `gh` call log and the remote tags | verified | The log holds no merge call and the remote holds no `v0.58.0` tag |
| REQ-003 AC-1 dash head refused | Ran `run` with head `-fhead` and a logging `git` wrapper | verified | Exit 1 with `headRefName must not start with a dash: -fhead`. The wrapper log holds no `fetch` |
| REQ-003 AC-2 dash base refused | Ran `run` with base `--base` and the same wrapper | verified | Exit 1 with `baseRefName must not start with a dash: --base`. The log holds no `fetch` |
| REQ-003 AC-3 normal names pass | Ran `run` with ordinary names | verified | Exit 0 and the PR merged as `v0.58.0` |
| NFR-001 both branches run in the suite | Replaced the `done` test with `true`, then removed the post-set check | verified | Each break failed the matching checks of the new suite. Restoring the file gave 15 of 15 |
