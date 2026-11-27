---
title: "Retrospective: 2026-11-26 - Repo-root helper for both pack trees"
summary: "A blameless review of step 28, which added repo-root helpers to the test assertion file."
status: "open"
---
# Retrospective: 2026-11-26 - Repo-root helper for both pack trees

**Mode:** run
**Subject:** 0000572-tests-share-a-repo-root-helper
**Date:** 2026-11-26

## Summary

The step added `repo_root`, `pack_tree_src`, and `pack_tree_installed` to `assert.sh`, a standards paragraph, and two suites. Two older suites now call the helper. The full run passed apart from the 3 inherited failures.

## What helped

- Both pack trees were identical at the base, so one sync copied every edit (plan/_archive/0000572-tests-share-a-repo-root-helper-2026-11-26/execution-plan.md, Concurrency plan).
- The postmortem of 2026-11-13 named the two suites to convert (plan/postmortems/2026-11-13-installed-copy-repo-root.md).

## What slowed the work

- The baseline run took about 25 minutes, and the P3 run about 24. Both exceed the 13 minutes that the start actions state (plan/_archive/0000572-tests-share-a-repo-root-helper-2026-11-26/build-log.md, P3 block).
- The `gate-write` hook rejected a command that wrote plan files after a `cd`. The agent reran it with paths from the repo root.

## Keep

- Walking up to `product.yml` needs no git repository, so the helper also works in scratch trees.

## Change

- Move the remaining suites that build a root from `../..` to `repo_root`.

## Actions

| Change | Owner | Lives in | Verified by | Filed as |
|--------|-------|----------|-------------|----------|
| Move the remaining suites to `repo_root` | the coordinator | `src/ravintio-zero/tests/` | a grep for `../..` root paths finds none | not filed |
