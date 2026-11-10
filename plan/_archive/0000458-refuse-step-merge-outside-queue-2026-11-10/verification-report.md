---
title: "Verification Report - 0000458-refuse-step-merge-outside-queue"
summary: "What ran, and what it showed, for each acceptance criterion."
---
# Verification Report - 0000458-refuse-step-merge-outside-queue

Method: ran `merge-guard.mjs` with a stub `gh` on PATH, and ran the queue suite with the variable set. No service started.

| Criterion | Method | Outcome | Observation |
|-----------|--------|---------|-------------|
| AC-1 refusal under the driver | Guard run with `RAVINTIO_INITIATIVE_QUEUE=1` on a plain squash, a chained merge, and an API merge path | verified | Exit 2 each time. The message names the merge queue. The stub `gh` log stays empty |
| AC-2 no change without the variable | Guard run with the variable unset, `0`, and empty | verified | Exit 0 for the squash into `initiative/x`. A squash into `main` still exits 2. `git status` and the queue script pass under the driver |
| AC-3 the queue still merges | Ran `test-0000454-req-001-queue-failure-recovery.sh` with the variable set, and read `merge-queue.mjs` | verified | 18 of 18 pass. `merge-queue.mjs` never reads the variable |
| AC-4 text | Read the carve-out rule and four documents | verified | Each names `RAVINTIO_INITIATIVE_QUEUE` and the merge queue |
