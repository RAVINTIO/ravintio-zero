---
title: "Backlog Entry: 0000535 - Step sessions receive the clock"
summary: "Step 51 (0000499) added the `clock-context.mjs` hook, which returns `Local time: hh:mm` after every tool call."
status: "open"
priority: "high"
theme: "initiative"
---
# Backlog Entry: 0000535 - Step sessions receive the clock

**Source feature:** 0000529-step-sessions-receive-clock
**Source phase:** I-C Run
**Deferral source:** human request, 2026-11-12
**Date filed:** 2026-11-12

---

## Problem

Step 51 (0000499) added the `clock-context.mjs` hook, which returns `Local time: hh:mm` after every tool call. On 2026-11-11 at 21:12 step 48 still wrote the reply time "20:12", which was its session start time. Run by hand, the hook returned the correct time. The step log holds no "Local time:" line, so nothing shows that a `claude -p` step session receives the hook output or reads it.

Evidence: `plan/.initiative-logs/step-48.log`, 21:12 on 2026-11-11.

## Suggested Action

Prove the clock reaches a step session, then fix whichever link fails. Run a short `claude -p` session with the hook installed and check that the model sees the time. If headless sessions drop `PostToolUse` context, deliver the time another way, such as the driver's prompt and a `UserPromptSubmit` hook. Add a test that fails when a step session can't report the current time. Record the result in the step's ADR.

## Why Deferred

Found during I-C Run of initiative 0000360, after step 51 merged. The human asked for it as step 60.
