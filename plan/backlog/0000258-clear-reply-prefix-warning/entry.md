---
title: "Backlog Entry: 0000258 - make the reply prefix warning clear in the human's session"
summary: "A human-requested change, filed for pickup at a future discovery run."
status: "open"
priority: "medium"
theme: "unsorted"
---
# Backlog Entry: 0000258 - make the reply prefix warning clear in the human's session

**Source feature:** none (human request)
**Source phase:** none (human request)
**Deferral source:** human request
**Date filed:** 2026-10-28

---

## Problem

During initiative 0000238, the human saw this warning twice in their own session and found it confusing:

```
Stop says: [RAVINTIO] Reply is missing a valid prefix. Start every reply in an active run with one of: ... The miss is logged to plan/.prefix-misses.log.
```

The warning comes from `.claude/hooks/enforcement/check-reply-prefix.mjs`. It caused confusion in four ways:

- **"Stop says" reads as a stopped run.** Claude Code labels Stop hook output this way. During an initiative, the human expects "stop" to mean a driver or step stop.
- **It names no reply.** The human can't tell which reply missed the prefix.
- **"Active run" is unclear.** The hook runs when `plan/.orchestrator-active` exists. A step session writes that file in the shared working tree, so the hook also checks the coordinator session's replies. It can't tell the two sessions apart.
- **It looks like the agent posted it.** The human asked why the agent shared the message. Claude Code shows it, and the agent can't hide it.

## Suggested Action

Discuss the solution with the human before any design. Options to put to them:

- Reword the warning so it names the hook as "Reply prefix check", quotes the first words of the flagged reply, and says which session it checked.
- Skip the check, or use a softer form, in the coordinator session while a step runs. For example, check `RAVINTIO_INITIATIVE_STEP` or the active skill.
- Send the warning only to the agent, for example through hook context. The human would then see only the miss log.
- Leave the hook as it is and explain the label in `getting-started.md`.

## Wanted outcome

The human agrees a solution at pickup, and the human no longer finds the warning confusing. Whatever the chosen solution, a test checks this condition:

- The warning, if the human still sees it, names the flagged reply and the session it checked, and it doesn't read as a stopped run.

P0 must not turn this entry into a design without the human present. An initiative step can't pick it up unless chart records the human's chosen solution first.

## Why Deferred

The human asked for it while initiative 0000238 step 4 was in P2. They asked for the solution to be discussed with them, so no step can take it on its own.
