---
title: "Domain Glossary - 0000555-initiative-pause-reaches-every-step"
summary: "Definitions of domain terms used within this feature."
status: "active"
version: "0.1.0"
---
# Domain Glossary - 0000555-initiative-pause-reaches-every-step

**Skill:** [plan](../skills/ravintio-plan/SKILL.md)
**Feature:** 0000555-initiative-pause-reaches-every-step
**Version:** 0.129.0

## Terms

| Term | Definition | Aliases | Used In |
|------|-----------|---------|---------|
| Pause request | The file `plan/.initiative-control/pause`. The driver reads it and starts no new step. | none | ravintio-zero |
| Step pause record | `plan/current/pause.md` in the worktree of a running step. | pause file | ravintio-zero |
| Initiative pause record | `plan/current-initiative/pause.md` in the root. | none | ravintio-zero |
| Phase end | A `Complete: P{n}` line that a step appends to its build log. | safe point | ravintio-zero |
