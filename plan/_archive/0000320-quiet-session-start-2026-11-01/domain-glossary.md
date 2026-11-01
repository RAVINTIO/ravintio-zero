---
title: "Domain Glossary - Quiet session start"
summary: "Definitions of domain terms used within this feature."
status: "active"
version: "0.1.0"
---
# Domain Glossary - Quiet session start

**Skill:** [plan](../skills/ravintio-plan/SKILL.md)
**Feature:** 0000320-quiet-session-start
**Version:** 0.46.0

## Terms

| Term | Definition | Aliases | Used In |
|------|-----------|---------|---------|
| Migration ledger | The file `plan/state/migrations.md`. It holds one row per migration with its result and pack version. | ledger | ravintio-zero |
| Loaded-session record | The ignored file `plan/.orchestrator-loaded`. It holds the last session id that got the load instruction. | session record | ravintio-zero |
| Detect line | A `**Detect:**` line in a migration file. It lists path checks that show when the migration applies. | none | ravintio-zero |
| Finding | One fixed line that `resume-detect.mjs` prints. | resume finding | ravintio-zero |
| Final reply | The assistant message that ends a turn and holds no `tool_use` block. | none | ravintio-zero |
