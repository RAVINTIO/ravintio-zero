---
title: "Backlog Entry: 0000522 - Replies name actors by role"
summary: "Agent replies use 'I' for the agent and 'you' for the human."
status: "open"
priority: "high"
theme: "initiative"
---
# Backlog Entry: 0000522 - Replies name actors by role

**Source feature:** 0000521-replies-name-actors-by-role
**Source phase:** I-C Run
**Deferral source:** human request, 2026-11-11
**Date filed:** 2026-11-11

---

## Problem

Agent replies use "I" for the agent and "you" for the human. On 2026-11-11 the human found this subjective and confusing in coordinator reports. A reply often names a step session, the coordinator, the driver, and the human. "I" and "you" leave the reader to work out which actor each sentence means.

Evidence: the human's request in the coordinator session, 2026-11-11.

## Suggested Action

Replies, reports, and `Blocked:` lines name each actor by role. They use "the human" for a person and "the agent" for a model running a task. A narrower role, such as "the coordinator" or "step 45", also works. Update the reply conventions in `CLAUDE.md`, the orchestrator skill, and `ravintio-zero/standards/roadmap-standards.md`. The reply writing hook flags "I" and "you" in a reply. The initiative skill heading `Decisions for you` becomes `Decisions for the human`.

## Why Deferred

Found during I-C Run of initiative 0000360. The human asked for it as step 59.
