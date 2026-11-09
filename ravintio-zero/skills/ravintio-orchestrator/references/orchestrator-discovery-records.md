---
title: "Orchestrator reference: Discovery records"
summary: "The Discovery Audit Trail and the Skill Map."
status: "active"
version: "1.0.0"
---
# Orchestrator reference: Discovery records

> Moved verbatim from `SKILL.md`. Read this file before you act on the topic. The Pack Index in `SKILL.md` lists the trigger.

### Discovery Audit Trail

For every coaching question asked and answered, immediately append to the build log under the P0 block:

```
P0 exchange ({topic}): Q: {question} / A: {human answer, summarised}
```

One entry per exchange, never batched, so an interrupted session still holds everything that occurred.

### Commit grouping

<!-- rule: records-group-by-topic --> Coaching records group into one commit per topic. The Q&A audit trail lines and the Scope Lock lines of one topic, such as scope or acceptance criteria, share a commit. A topic commits when it closes or when the session pauses.

<!-- rule: records-commit-at-once --> A requirement, an ADR, and `design.md` still commit at once. Any record commits at once when the session may end. An interruption then loses at most one topic.

### Skill Map

After you draft the design and before you present it, write a `## Skill Map` section in `design.md` with one row per requirement. Each row maps the requirement to the best-fit skill in `ravintio-zero/skills/` with a one-line rationale. Re-evaluate the map at each phase gate.
