---
title: "Backlog Entry: 0000329 - Coach dependency approval for advisory fixes"
summary: "A discovered-but-out-of-scope item deferred for pickup at a future discovery run."
status: "open"
---
# Backlog Entry: 0000329 - Coach dependency approval for advisory fixes

**Source feature:** none (human request)
**Source phase:** none (human request)
**Deferral source:** human request
**Date filed:** 2026-10-31

---

## Problem

Copied from the `ravintio-docs` repo, entry 0000011, found in its run 0000009 during P2.

In that run, the `Approved dependencies` field allowed only patch and minor updates "within current majors". That bound came from a P0 audit snapshot. The story's goal was 0 advisories. When a new advisory needed a major bump, the bound and the goal conflicted, and P2 stopped. The postmortem is `plan/postmortems/2026-10-31-advisory-after-discovery.md` in the `ravintio-docs` repo.

## Suggested Action

Add a discovery coaching question for advisory-fix stories. It asks whether a major bump of an existing dependency is pre-approved when it is the only fix, and records the answer in `Approved dependencies`.

## Why Deferred

The human asked to move it from the `ravintio-docs` backlog, where a pack change is out of scope.
