---
title: "Domain Glossary - Delivery cleans up driver state"
summary: "Definitions of domain terms used within this feature."
status: "active"
version: "0.1.0"
---
# Domain Glossary - Delivery cleans up driver state

**Skill:** [plan](../skills/ravintio-plan/SKILL.md)
**Feature:** 0000581-delivery-cleans-up-driver-state
**Version:** 0.151.0

## Terms

| Term | Definition | Aliases | Used In |
|------|-----------|---------|---------|
| Driver state | The folders `plan/.initiative-control/`, `plan/.initiative-logs/`, and `plan/.initiative-worktrees/`, which the driver writes while it runs. | none | ravintio-zero |
| Cleanup | The step of I-E Delivery that archives the driver state and removes the worktrees. | none | ravintio-zero |
| Lock | The file `plan/.initiative-runner.lock`, which exists while a driver runs. | runner lock | ravintio-zero |
| Archive folder | `.git/ravintio-archive/{id}-{slug}/`, which holds the moved logs and control files as stop evidence. | none | ravintio-zero |
| Queue | The folder `plan/.initiative-queue/`, which holds coordinator items for steps. | none | ravintio-zero |
