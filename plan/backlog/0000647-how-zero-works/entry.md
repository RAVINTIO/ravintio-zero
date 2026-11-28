---
title: "Backlog Entry: 0000647 - How Zero works process reference"
summary: "docs/how-zero-works.md lists, as numbered steps, how a feature run and an initiative work now. A test keeps it to as-is facts."
status: "open"
priority: "high"
theme: "documentation"
---
# Backlog Entry: 0000647 - How Zero works process reference

**Source feature:** 0000646-how-zero-works

**Source phase:** I-A Chart

**Deferral source:** human request on 2026-11-28, chart of initiative 0000613

**Date filed:** 2026-11-28

---

## Problem

No doc tells a person, step by step, how Zero works. The flow lives across the orchestrator skill, the phase skills, and `roadmap-standards.md`. `docs/architecture-overview.md` describes components, not the flow a person follows.

## Wanted outcome

`docs/how-zero-works.md` is a Diátaxis reference doc, governed by its manifest from entry 0000645.

- The doc holds two numbered lists and nothing else:
  1. A feature run, from brief to merged PR, P0 to P4.
  2. An initiative, from chart to delivery, I-A to I-E.
- Each step is one sentence that names the actor and what the step produces.
- The doc states only what Zero does now. It holds no history, no plans, no advice, and no reasons.
- The manifest sets a hard limit on steps and words.
- The manifest's `update_when` names the orchestrator skill, the phase skills, the initiative skill, and `roadmap-standards.md`. A run that changes one of them updates the doc in the same PR.

## Tests

- The doc names each phase, P0 to P4, and each stage, I-A to I-E.
- The doc has only the two headings that its manifest lists.
- The doc holds no date, version, feature id, backlog id, ADR id, or `Last updated:` line.
- The doc holds none of these words: "previously", "now", "new", "no longer", "changed", "since", "will".
- `docs-check.mjs` passes on the doc.

## Why Deferred

The human asked for it on 2026-11-28 during I-A Chart of initiative 0000613. It joins that initiative as step 32, after step 31 builds the doc manifests.
