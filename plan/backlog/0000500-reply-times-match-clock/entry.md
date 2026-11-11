---
title: "Backlog Entry: 0000500 - Reply times match the clock"
summary: "On 2026-11-11 step 27 printed reply times 10 to 13 minutes ahead of the clock."
status: "open"
priority: "high"
theme: "initiative"
---
# Backlog Entry: 0000500 - Reply times match the clock

**Source feature:** 0000499-reply-times-match-clock
**Source phase:** I-C Run
**Deferral source:** human request, 2026-11-11
**Date filed:** 2026-11-11

---

## Problem

On 2026-11-11 step 27 printed reply times 10 to 13 minutes ahead of the clock. It printed "00:27 P4 Ship" at 00:17 and "00:35 I-D Advance" at 00:22. It also used the status `Running:`, which is not in the allowed list. Wrong times and unknown statuses make the activity feed hard to trust.

Evidence: `plan/.initiative-logs/step-27.log`, 00:17 to 00:22 on 2026-11-11.

## Suggested Action

The reply hook compares the time in the prefix with the clock and flags a gap of more than 2 minutes. It also flags a status outside the allowed list. The step instructions say to read the time with `date +%H:%M` for every reply.

## Added on 2026-11-11

The root cause is that agents estimate times instead of reading the clock. Step 43 ran `date +%H:%M` once, at the start of its session, and wrote every later time from its own estimate. It stamped a 01:10 line as 01:53. The coordinator session did the same in some replies. A step session is one long turn. The reply-prefix hook runs only at the end of a turn, so it never sees the progress lines that drift.

The human's rule: every timestamp an agent writes comes from a real clock read at that moment. An estimate is never acceptable. A clock read costs almost nothing.

Suggested action, replacing the one above:

1. Add a `PostToolUse` hook that returns the current local time as `hh:mm` in `additionalContext` after every tool call. The agent then always holds a fresh time and never needs to estimate one.
2. The orchestrator skill, the initiative skill, and the roadmap standards require a fresh clock read for every timestamp. The source is the hook's latest value or `date +%H:%M`.
3. The reply-prefix hook flags a prefix time more than 2 minutes from the clock, and a status outside the allowed list.
4. The driver stamps each `activity:` line with its own clock, so the feed stays correct even when an agent's time is wrong.
5. A test checks that setup installs the hook and that its output holds the current time.

## Why Deferred

Found at the step 27 driver stop of initiative 0000360. The human asked for it as its own step at the end of the chart.
