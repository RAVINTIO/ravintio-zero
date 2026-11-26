# Changelog (0000572-tests-share-a-repo-root-helper, 26 Nov 2026)

**Feature:** Tests share a repo-root helper for both pack trees
**Version:** set by the merge queue at merge
**PR:** pending

## What changed

`helpers/assert.sh` has three new functions: `repo_root`, `pack_tree_src`, and `pack_tree_installed`. They return the repo top and the two pack trees from `src/ravintio-zero/tests/` and from `ravintio-zero/tests/`. The testing standards name them and state that a new suite runs from both trees before it counts as green. The step-clock and handoff-text suites now call `repo_root`. Two new suites check the helpers, the standard, and the tree match.

## Why

Each suite worked out the repo root from its own path. A suite with the wrong depth passed from `src/` and failed in the installed copy. Two suites hit this in clean-clone runs. This step folds in backlog entries 0000528 and 0000539.

## Deviations

None.

## Validation results

The full suite passes apart from the 3 inherited baseline failures. Both new suites pass from both trees.

## Skipped phases

None
