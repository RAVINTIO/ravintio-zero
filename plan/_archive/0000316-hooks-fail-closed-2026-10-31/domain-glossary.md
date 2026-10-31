---
title: "Domain Glossary - hooks fail closed"
summary: "Terms used by the hook wiring work."
status: "active"
version: "0.42.0"
---
# Domain Glossary - hooks fail closed

**Skill:** [plan](../skills/ravintio-plan/SKILL.md)
**Feature:** 0000316-hooks-fail-closed
**Version:** 0.42.0

## Terms

| Term | Definition | Aliases | Used In |
|------|-----------|---------|---------|
| Guard | A hook that blocks a tool call with exit 2: `gate-write`, `ratchet-check`, `em-dash-guard`, and `merge-guard`. | fail-closed hook | ravintio-zero |
| Advisory hook | A hook that never blocks: `auto-trigger-orchestrator`, `check-orchestrator-presence`, `check-design`, and `check-reply-prefix`. | none | ravintio-zero |
| Launcher | `guard-run.mjs`. It runs one hook script, resolves it beside itself, and turns a missing or crashing guard into exit 2. | none | ravintio-zero |
