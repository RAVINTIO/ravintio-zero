---
title: "Backlog Entry: 0000366 - subagent task classifier skill"
summary: "A human-requested change, filed for pickup at a future discovery run."
status: "open"
priority: "medium"
theme: "agent-dispatch"
---
# Backlog Entry: 0000366 - subagent task classifier skill

**Source feature:** none (human request)
**Source phase:** none (human request)
**Deferral source:** human request
**Date filed:** 2026-11-07

---

## Problem

Each skill sets one model through its `recommended_model` field. The tier table in `ravintio-zero/standards/agent-dispatch-standards.md` assigns tiers by judgement. Nothing looks at the unit of work itself before dispatch, and nothing sets the effort level.

The `ravintio-docs` repo hit this gap in run 0000024-explainer-six-tools. Its build log records a departure: all three TDD tracks ran on `opus` instead of `haiku`. Two units were prose rewrites under strict style rules. The third was mostly code and could have run on `haiku`. The orchestrator chose one tier for all three because no rule told it to pick a tier for each unit. The source is `plan/_archive/0000024-explainer-six-tools-2026-11-06/build-log.md` in the `ravintio-docs` repo, at lines 91 and 92.

The human chose this skill over adding Langfuse to the pipeline now. Entry 0000254 covers Langfuse for offline evaluation and stays open.

## Suggested Action

Add a classifier skill that the dispatching phase runs before each subagent dispatch.

- It classifies the unit by task class, such as code change, prose rewrite, test writing, review, or mechanical edit.
- It scores signals such as files touched, rules that constrain the output, and the risk of rework.
- It returns the model tier and the effort level for that unit, from a table in the dispatch standards.
- It writes the class, tier, and effort to the build-log line for the unit, such as `Done: U1 REQ-001 (prose, opus, high)`.
- `workflow-metrics.mjs` reports rework by class and tier, so later runs can tune the table from evidence.

The classifier's tier replaces the skill's `recommended_model` for that dispatch. The rule that retries a unit on `sonnet` after two `haiku` failures stays. Pickup decides whether the human can override a tier at the design gate.

Entry 0000330 defines an inline TDD path for content units. Pickup checks how the classifier treats inline units.

## Why Deferred

The human asked for it from the `ravintio-docs` repo, where a pack change is out of scope. It needs its own design decision about the class list, the tier table, and how effort maps to each host tool.
