---
title: "Backlog Entry: 0000598 - Merge queue stops on every parallel step"
summary: "Parallel steps conflict on shared living docs and reuse the same ADR id, and the queue resolves neither."
status: "open"
priority: "high"
theme: "initiative"
---
# Backlog Entry: 0000598 - Merge queue stops on every parallel step

**Source feature:** none (human request)

**Source phase:** none (human request)

**Deferral source:** human request

**Date filed:** 2026-11-24

---

## Problem

In the consumer `claude-code-launcher` (pack 0.114.0), the merge queue stopped on each step that ran beside another. Steps 4, 10, and 10 again all stopped this way. The coordinator fixed each by hand.

Two causes repeat:

- Each step edits the same living docs. These include `docs/component-registry.md`, `docs/decisions-index.md`, `docs/dependency-graph.md`, `docs/architecture-overview.md`, and the `cli` docs. Each conflict is a `Last updated:` line or rows that both sides added.
- Each step reserves the next ADR id from `docs/adr/.next-id` on its own branch. Two parallel steps take the same id, so the ADR files and index rows clash.

A step that merges third can conflict twice, because the base moves after the first fix.

## Suggested Action

Give the merge queue a resolver for these two cases before it stops:

1. Take the PR's `Last updated:` line, and keep the rows and lines that both sides added.
2. On an ADR id clash, renumber the PR's ADRs from the base counter. Then update their links and the counter.

Run the gates after the resolve. Stop as now if any other hunk remains. A test can merge two fixture branches that add rows to the same table and take the same ADR id.

## Why Deferred

Found in a consumer repo during an initiative run. The fix belongs to the pack, not the consumer.
