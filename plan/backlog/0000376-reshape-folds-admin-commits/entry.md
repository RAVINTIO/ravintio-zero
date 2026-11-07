---
title: "Backlog Entry: 0000376 - the reshape folds admin commits that a later step builds on"
summary: "The reshape stops for the human on a conflict that folding an admin commit into the next step would clear."
status: "open"
priority: "medium"
theme: "initiative"
---
# Backlog Entry: 0000376 - the reshape folds admin commits that a later step builds on

**Source feature:** 0000349-clean-initiative-history
**Source phase:** I-E Delivery
**Deferral source:** human request
**Date filed:** 2026-11-07

---

## Problem

At I-E Delivery of initiative 0000349, `reshape-initiative.mjs` conflicted twice:

- Step 1 edits the chart, which only the activation commits #109 and #110 create.
- Steps 7 and 8 built on the coordinator admin PRs #117 and #119, which changed `plan/backlog/.next-id` and the index.

Folding each admin commit into the step right after it cleared both. I-E Delivery step 3 in `roadmap-standards.md` says to stop for the human on any replay conflict. The coordinator stopped, and the human said a fold like this needs no approval. Any coordinator would stop the same way.

## Suggested Action

- When a replay conflicts, the reshape tries again with each admin commit that comes before the failing step folded into the next step, as `--assign` does today.
- It keeps a fold only if the replay is then clean, the final tree equals the old head, and the history check passes. It prints each fold.
- It stops for the human only when no such fold clears the conflict. It never drops or edits a hunk.
- Update I-E Delivery step 3 and the initiative skill to match, and name the folds in the delivery PR body.

## Wanted outcome

Delivery needs no human for a conflict that a fold clears. Tests check these conditions:

- A fixture branch where step 1 edits a file that the activation commit creates reshapes cleanly with no `--assign`. The output names the fold.
- A fixture branch with a conflict that no fold clears still exits 1 and names the commit.
- The final tree of every reshaped fixture equals its old head.

## Why Deferred

Found at I-E Delivery of initiative 0000349, after the human merged the delivery PR.
