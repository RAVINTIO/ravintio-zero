---
title: "Domain Glossary - Driver clears a dead lock"
summary: "Definitions of domain terms used within this feature."
status: "active"
version: "0.106.0"
---
# Domain Glossary - Driver clears a dead lock

**Skill:** [plan](../../ravintio-zero/skills/ravintio-plan/SKILL.md)
**Feature:** 0000495-driver-clears-dead-lock
**Version:** 0.106.0

## Terms

| Term | Definition | Aliases | Used In |
|------|-----------|---------|---------|
| Driver | The script `initiative-run.mjs` that starts step sessions and runs the merge queue | runner | ravintio-zero |
| Lock | The file `plan/.initiative-runner.lock` that holds the pid of the driver | runner lock | ravintio-zero |
| Dead lock | A lock whose file holds a decimal pid for which no process runs | stale lock | ravintio-zero |
| Take over | The driver removes a dead lock and writes its own pid with `wx` | clear | ravintio-zero |
