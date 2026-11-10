---
title: "Domain Glossary - Merge ready PRs after a stop"
summary: "Definitions of domain terms used within this feature."
status: "active"
version: "0.1.0"
---
# Domain Glossary - Merge ready PRs after a stop

**Skill:** [plan](../../ravintio-zero/skills/ravintio-plan/SKILL.md)
**Feature:** 0000446-drain-ready-prs-after-a-stop
**Version:** 0.91.0

## Terms

| Term | Definition | Aliases | Used In |
|------|-----------|---------|---------|
| Ready step | A step whose PR has green CI and whose control folder holds a `ready` file. | ready PR | ravintio-zero |
| Drain | Queue each ready step once, even after the queue failed on another step. | none | ravintio-zero |
| Queue failure | A non-zero exit of `merge-queue.mjs run` for one PR. | none | ravintio-zero |
| Stop | The driver state that blocks new step starts. A `Blocked:` line or a failure sets it. | none | ravintio-zero |
