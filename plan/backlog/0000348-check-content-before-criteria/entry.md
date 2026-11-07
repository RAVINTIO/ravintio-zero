---
title: "Backlog Entry: 0000348 - Check that tested content exists before writing a criterion"
summary: "A discovered-but-out-of-scope item deferred for pickup at a future discovery run."
status: "open"
priority: "medium"
theme: "unsorted"
---
# Backlog Entry: 0000348 - Check that tested content exists before writing a criterion

**Source feature:** none (human request)
**Source phase:** none (human request)
**Deferral source:** human request
**Date filed:** 2026-11-01

---

## Problem

Copied from the `ravintio-docs` repo's retrospective `plan/retrospectives/0000016-site-regression-and-quality-2026-11-01.md`, run 0000016.

In run 0000016, a confirmed criterion said each Mermaid diagram renders as an SVG. No page held a diagram, so the criterion had nothing to test. P1 found this and stopped for the human. Discovery could have found it before the design gate.

## Suggested Action

In P0 coaching, before confirming a criterion that tests existing content or data, check that at least one instance exists. If none does, offer a reworded criterion at the design gate.

## Wanted outcome

Discovery confirms no criterion about content that does not exist. Tests check these conditions:

- The P0 coaching reference tells the agent to check that at least one instance exists before it confirms a criterion about existing content or data.
- If none exists, coaching offers a reworded criterion before the design gate.
- A fixture criterion about rendered Mermaid diagrams, in a repo with no diagram, gets the reworded offer.

## Why Deferred

It changes the pack. The `ravintio-docs` retrospective filed it here for the pack maintainer.
