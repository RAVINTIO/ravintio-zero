---
title: "Backlog Entry: 0000328 - Refresh the dependency audit before implement"
summary: "A discovered-but-out-of-scope item deferred for pickup at a future discovery run."
status: "open"
priority: "medium"
theme: "unsorted"
---
# Backlog Entry: 0000328 - Refresh the dependency audit before implement

**Source feature:** none (human request)
**Source phase:** none (human request)
**Deferral source:** human request
**Date filed:** 2026-10-31

---

## Problem

Copied from the `ravintio-docs` repo, entry 0000010, found in its run 0000009 during P2.

Run 0000009 audited dependencies in P0 and planned the fix from that result. A new advisory (GHSA-238p-pmpm-9mq7 in `katex`) appeared before P2. Its fix needed a major bump outside the approved list, so P2 stopped. Nothing in P1 re-checks the audit. `ravintio-zero/skills/ravintio-plan/SKILL.md` has no audit step today. The postmortem is `plan/postmortems/2026-10-31-advisory-after-discovery.md` in the `ravintio-docs` repo.

## Suggested Action

Have `ravintio-plan` re-run the dependency audit when a requirement targets advisories or dependency versions. Any fix outside the approved list then surfaces at the plan gate, not mid-implement.

## Why Deferred

The human asked to move it from the `ravintio-docs` backlog, where a pack change is out of scope.
