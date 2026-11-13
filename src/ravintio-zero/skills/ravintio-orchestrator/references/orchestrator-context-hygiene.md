---
title: "Orchestrator reference: Context hygiene"
summary: "When to clear context and when to offer compaction."
status: "active"
version: "1.0.0"
---
# Orchestrator reference: Context hygiene

> Moved verbatim from `SKILL.md`. Read this file before you clear context at discovery start or after ship. The Pack Index in `SKILL.md` lists the trigger.

## Context Hygiene

Clear context at two bookends: discovery start (fresh runs only) and after ship completes. Issue `/clear` or the host tool's equivalent. If the tool has none, ask the human to clear manually and confirm before continuing. Mid-run, if context accumulates material that no longer serves the active phase, offer compaction. Advisory only: never block on it.
