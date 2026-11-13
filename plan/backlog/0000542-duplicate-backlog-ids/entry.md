---
title: "Backlog Entry: 0000542 - Two open entries share one backlog id"
summary: "Two open entries use id 0000476, and no check flags a duplicate id."
status: "open"
priority: "medium"
theme: "initiative"
---
# Backlog Entry: 0000542 - Two open entries share one backlog id

**Source feature:** 0000360-backlog-sweep
**Source phase:** I-E Delivery
**Deferral source:** retrospective `plan/retrospectives/0000360-backlog-sweep-initiative-2026-11-13.md`
**Date filed:** 2026-11-13

---

## Problem

Two open entries share id 0000476:

- `plan/backlog/0000476-ack-write-mid-suite-fails-run`, filed by step 23
- `plan/backlog/0000476-plan-only-push-short-ci`, filed by step 30

Steps 23 and 30 ran side by side on 2026-11-10 and reserved the same id. Step 44 (0000485) added renumbering at merge, after both had merged. Steps 60 and 61 also took the same id on 2026-11-13, and the coordinator renumbered one by hand in PR #200. No check reports a duplicate id, so the pair stayed in the backlog for three days.

## Suggested Action

- Renumber `0000476-plan-only-push-short-ci` to a fresh id and update its links.
- Make `backlog-index.mjs` exit 1 when two entry folders share an id. CI then fails on the next duplicate.
- Add a test with two folders that share an id.

## Why Deferred

Found by the initiative retrospective at I-E Delivery, after the last step merged.
