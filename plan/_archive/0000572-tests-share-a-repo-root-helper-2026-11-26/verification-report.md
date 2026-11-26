---
title: "Verification Report - 0000572-tests-share-a-repo-root-helper"
summary: "Execution evidence for each acceptance criterion."
---
# Verification Report - 0000572-tests-share-a-repo-root-helper

Method: each suite ran from `src/ravintio-zero/tests/` and from `ravintio-zero/tests/` (2026-11-26T07:09:44Z).

| Criterion | Method | Outcome | Evidence |
|-----------|--------|---------|----------|
| REQ-001 AC-1 | Ran `test-0000572-req-001-repo-root-helpers.sh` from both trees | verified | 9 passed in each tree. `repo_root` printed one folder for both start points. |
| REQ-001 AC-2 | Same suite | verified | `pack_tree_src` and `pack_tree_installed` printed the two trees, also with no argument from a shell in `src/ravintio-zero/tests`. |
| REQ-001 AC-3 | Same suite | verified | Scratch folder with no `product.yml`: empty output, exit 1. |
| REQ-002 AC-1 | Ran `test-0000572-req-002-standard-and-adoption.sh` from both trees | verified | 14 passed in each tree. |
| REQ-002 AC-2 | Same suite, plus the step-clock and handoff-text suites | verified | 19 and 10 checks passed from both trees. |
| REQ-002 AC-3 | `sync-installed.mjs --check` | verified | Exit 0. |
