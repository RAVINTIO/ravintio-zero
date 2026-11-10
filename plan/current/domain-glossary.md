---
title: "Domain Glossary - steps read their queue items"
summary: "Definitions of domain terms used within this feature."
status: "active"
version: "0.1.0"
---
# Domain Glossary - steps read their queue items

**Skill:** [plan](../skills/ravintio-plan/SKILL.md)
**Feature:** 0000444-step-reads-its-queue-items
**Version:** 0.87.0

## Terms

| Term | Definition | Aliases | Used In |
|------|-----------|---------|---------|
| Queue item | A folder in `plan/.initiative-queue/` whose `item.md` holds a `**Step:**` line and a `**Destination:**` line | item | ravintio-zero |
| Named item | A queue item whose `**Step:**` line holds the step number | none | ravintio-zero |
| Item report | A build log line `Queue item {name}: {reason}` that records why the step did not commit the item | none | ravintio-zero |
