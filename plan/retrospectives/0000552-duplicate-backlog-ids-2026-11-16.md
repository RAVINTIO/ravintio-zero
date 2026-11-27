---
title: "Retrospective: 2026-11-16 - Duplicate backlog id check"
summary: "A blameless review of step 8, which made the index check fail on a duplicate backlog id."
status: "open"
---
# Retrospective: 2026-11-16 - Duplicate backlog id check

**Mode:** run
**Subject:** 0000552-duplicate-backlog-ids
**Date:** 2026-11-16

## Summary

The step added a duplicate id check to `backlog-index.mjs --check` and one suite. The check stays out of the generate mode, because the merge queue builds the index before it renumbers. The clean-clone run failed only the three inherited suites.

## What helped

- Reading `merge-queue.mjs` at P0 showed that a check in the generate mode would stop the renumber (plan/_archive/0000552-duplicate-backlog-ids-2026-11-16/design.md, Risks).
- The queue helpers resolved the base merge and renumbered the ADR in two calls (docs/adr/0350-duplicate-id-check-in-check-mode.md).

## What slowed the work

- The agent waited about 22 minutes for the baseline suite before it could run the full suite (plan/_archive/0000552-duplicate-backlog-ids-2026-11-16/build-log.md, P2 block).
- The sentinel hook blocked the first write of the P0 artifacts, because the artifacts and the sentinel shared one command.
- `build-log-mark.mjs` wrote markers after the closing rule, so the agent moved them by hand.

## Keep

- Check the order of the merge queue calls before a script fails a mode that the queue also runs.

## Change

- Place a `build-log-mark.mjs` marker inside the open phase block.

## Actions

| Change | Owner | Lives in | Verified by | Filed as |
|--------|-------|----------|-------------|----------|
| Place markers inside the open phase block | the coordinator | `ravintio-zero/scripts/build-log-mark.mjs` | a test with a closed block above `## Summary` | not filed. Step 33 raised it. |
