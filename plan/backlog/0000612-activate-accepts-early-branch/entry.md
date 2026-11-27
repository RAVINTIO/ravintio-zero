---
title: "Backlog Entry: 0000612 - Activate accepts an initiative branch cut before the chart"
summary: "Let the human start an initiative branch first, chart on it, and activate it without a draft folder workaround."
status: "open"
priority: "medium"
theme: "initiative"
---
# Backlog Entry: 0000612 - Activate accepts an initiative branch cut before the chart

**Source feature:** none (human request)

**Source phase:** none (human request)

**Deferral source:** human request

**Date filed:** 2026-11-27

---

## Problem

The roadmap standards chart on `main`, and I-B Activate cuts `initiative/{id}-{slug}`. In claude-code-launcher on 2026-11-27, the human asked to start initiative 0000041 first and file its backlog entries in a chore PR off that branch. That flow worked. Activation then needs a workaround.

`scripts/initiative-activate.mjs` accepts an existing initiative branch on `origin` only if the branch holds the draft at `plan/roadmap/{id}-{slug}/initiative.md`. Otherwise it blocks with `{branch} already exists on origin and holds no draft to activate`. The chart must therefore land on the initiative branch as a draft through its own coordinator PR before activation can run. `roadmap-standards.md` doesn't describe this order.

## Suggested Action

Make an early initiative branch a supported start:

- Add a command or a flag that cuts and pushes an empty `initiative/{id}-{slug}` from `main`, and reserves the initiative id.
- Let I-A Chart run on that branch and write the chart. Let the backlog entries land through `chore/` PRs into it.
- Let `initiative-activate.mjs` take the chart from the draft path or from a path the human names, with no separate draft PR.
- Describe the flow in the I-A Chart and I-B Activate sections of `roadmap-standards.md`.

Observable condition: a test repo has an initiative branch cut before the chart, with one backlog chore PR merged into it. That branch activates with one coordinator PR and no `holds no draft` block.

## Why Deferred

It changes the pack's initiative scripts and standards. It needs its own run in RAVINTIO Zero.
