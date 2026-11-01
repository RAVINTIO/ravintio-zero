---
title: "Backlog Entry: 0000254 - evaluate skill changes and model needs with Langfuse"
summary: "A human-requested change, filed for pickup at a future discovery run."
status: "open"
priority: "medium"
theme: "unsorted"
---
# Backlog Entry: 0000254 - evaluate skill changes and model needs with Langfuse

**Source feature:** none (human request)
**Source phase:** none (human request)
**Deferral source:** human request
**Date filed:** 2026-10-27

---

## Problem

The repo has no way to measure whether a change to a skill in `ravintio-zero/skills/` makes the agent better or worse. Reviews and the text checks in `ravintio-zero/tests/` confirm that a rule is present. They don't show how the agent behaves with it.

The repo also has no evidence for which model each skill needs. The model tier table in `ravintio-zero/standards/agent-dispatch-standards.md` assigns tiers by judgement. No run has compared a cheaper model against the assigned one on the same task.

The human asked for Langfuse in this repo to trace skill runs, score them, and compare results across skill versions and models.

## Suggested Action

- Add Langfuse tracing to a runner that drives skills against fixed briefs. Entry 0000174 describes that runner and its briefs.
- Tag each trace with the skill name, the skill's git commit, and the model.
- Score each run with a fixed rubric, such as acceptance criteria met, tool calls, tokens, and cost.
- Use Langfuse datasets and experiments to compare two skill versions, or two models, on the same briefs.
- Run Langfuse self-hosted with Docker Compose on the maintainer's machine. The human chose this over Langfuse Cloud on 2026-10-27. Langfuse v3 runs several containers, including Postgres, ClickHouse, Redis, and MinIO, so pickup approves each image as a dependency.
- Read the Langfuse keys from the environment in the runner only. Keep them out of the repo and out of agent context.

## Wanted outcome

A maintainer can run one command that scores a skill change and a model choice on the same fixed briefs. Tests or a recorded run check these conditions:

- A run of the fixed briefs produces one Langfuse trace per brief, tagged with the skill name, the skill's commit, and the model.
- A comparison of two skill commits on the same briefs reports each rubric score for both commits side by side.
- A comparison of two models on one skill reports each rubric score and the cost per brief for both models.
- No Langfuse key appears in any tracked file, log, or step log.

## Why Deferred

The human asked for it during the initiative 0000238 chart on 2026-10-27. It needs two approvals that no step has: the self-hosted Langfuse images as new dependencies, and paid model calls for each run. It depends on, or absorbs, entry 0000174.
