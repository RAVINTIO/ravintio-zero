---
title: "ADR 285: Unit class, tier, and effort table"
summary: "A table in the dispatch standards, not a new skill, gives each unit a class, a model tier, and an effort level, and content units may run inline."
status: "proposed"
version: "0.1.0"
component: "ravintio-zero"
feature: "0000386-unit-dispatch"
---
# ADR-0285 - Unit class, tier, and effort table

**Status:** proposed
**Component:** ravintio-zero

## Context

The tier table in `agent-dispatch-standards.md` assigns a tier by task type, and each skill sets one model. Nothing looks at the unit before dispatch, and nothing sets effort. The `ravintio-docs` run 0000024 ran three TDD tracks on one tier, though one track was mostly code. Runs 0000005 and 0000009 there, and runs 0000207 and 0000241 here, ran content units inline and logged a departure each time. Backlog entries 0000330 and 0000366 ask for a fix.

## Decision

Four unit classes (`content`, `code`, `test`, `config`) and three signals set a score from 0 to 3. A lookup table in `agent-dispatch-standards.md` maps class and score to a tier and an effort. The tier replaces the skill's `recommended_model` for that dispatch. The `Done:` line records `{class}, {tier}, {effort}`. A `content` unit that applies agreed text or changes one file runs inline and logs tier `inline` and effort `none`. It writes a `RED:` marker before a `GREEN:` marker, and `build-log-check.mjs` checks both. `workflow-metrics.mjs` reports units and rework by class and tier.

## Alternatives Considered

| Alternative | Pros | Cons | Why Rejected |
|-------------|------|------|-------------|
| A classifier skill that runs before each dispatch | Can weigh more signals | Adds a model call to every dispatch and a skill to load | A table gives the same answer with no call, and the chart chose a table |
| Let the human override a tier at the design gate | Handles odd units | An initiative step has no human at the gate | Later runs tune the table from the metrics |
| Keep one tier per skill | No change | Prose and code units share a tier | It is the gap the entry describes |

## Affected Components

| Component | Impact |
|-----------|--------|
| ravintio-zero | Standards, skill, template, and three scripts change |

## Consequences

**Positive:**
- Small content units skip three subagent calls and log no departure.
- Rework by class and tier gives evidence to tune the table.

**Negative:**
- The first table values are a guess until runs supply evidence.
- Every reader of the `Done:` line must accept the longer form.
