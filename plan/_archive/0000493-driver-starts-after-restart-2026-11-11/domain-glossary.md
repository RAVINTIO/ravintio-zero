---
title: "Domain Glossary - Driver keeps starting steps after a Restart"
summary: "Definitions of domain terms used within this feature."
status: "active"
version: "0.1.0"
---
# Domain Glossary - Driver keeps starting steps after a Restart

**Skill:** [plan](../../ravintio-zero/skills/ravintio-plan/SKILL.md)
**Feature:** 0000493-driver-starts-after-restart
**Version:** 0.105.0

> The ubiquitous language for this feature.

## Terms

| Term | Definition | Aliases | Used In |
|------|-----------|---------|---------|
| Handoff | The act where the old driver starts a successor and gives it new starts and the queue. | takeover | ravintio-zero |
| Old driver | The driver process that ran the merge that triggered the handoff. It supervises its own running sessions until they end. | outgoing driver | ravintio-zero |
| Successor | The driver process that the old driver starts with `--handoff`. It holds the lock and runs new code. | new driver | ravintio-zero |
| Adopted step | A step whose session the old driver still runs and the successor tracks through the control folder. | handed-over step | ravintio-zero |
| Restart-only hit | A merge that changed a watched driver, watcher, or skill file and changed no setup file. | none | ravintio-zero |
| `stopped` file | A file in the step control folder that holds the stop line of a step that blocked or failed after a handoff. | none | ravintio-zero |
| Lock holder | The process whose pid the lock file holds. Only the lock holder runs the queue. | none | ravintio-zero |
