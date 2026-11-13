---
title: "Domain Glossary - Step sessions receive the clock"
summary: "Definitions of domain terms used within this feature."
status: "active"
version: "0.112.0"
---
# Domain Glossary - Step sessions receive the clock

**Skill:** [plan](../../ravintio-zero/skills/ravintio-plan/SKILL.md)
**Feature:** 0000534-step-sessions-receive-clock
**Version:** 0.112.0

## Terms

| Term | Definition | Aliases | Used In |
|------|-----------|---------|---------|
| Clock hook | The `PostToolUse` hook `clock-context.mjs` that returns `Local time: hh:mm` after every tool call | clock-context | ravintio-zero |
| Hook event | A `system` event in the stream-json log with subtype `hook_started` or `hook_response` | none | ravintio-zero |
| Clock output | A `PostToolUse` hook response whose output holds `Local time: hh:mm` | none | ravintio-zero |
| Step log | The file `plan/.initiative-logs/step-{n}.log` that holds the stream-json events of one step session | none | ravintio-zero |
| Clock check | The script `step-clock-check.mjs` that fails a log with tool calls and no clock output | none | ravintio-zero |
