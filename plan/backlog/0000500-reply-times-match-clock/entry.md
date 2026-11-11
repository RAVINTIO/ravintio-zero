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

the reply hook compares the time in the prefix with the clock and flags a gap of more than 2 minutes. It also flags a status outside the allowed list. The step instructions say to read the time with `date +%H:%M` for every reply.

## Why Deferred

Found at the step 27 driver stop of initiative 0000360. The human asked for it as its own step at the end of the chart.
