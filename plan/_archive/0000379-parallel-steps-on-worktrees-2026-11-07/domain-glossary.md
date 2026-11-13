---
title: "Domain Glossary - Parallel steps on worktrees"
summary: "Definitions of domain terms used within this feature."
status: "active"
version: "0.1.0"
---
# Domain Glossary - Parallel steps on worktrees

**Skill:** [plan](../skills/ravintio-plan/SKILL.md)
**Feature:** 0000379-parallel-steps-on-worktrees
**Version:** 0.59.0

## Terms

| Term | Definition | Aliases | Used In |
|------|-----------|---------|---------|
| Lane | A label on a chart row. Steps in one lane run in chart order. | none | ravintio-zero |
| After | The steps that must merge before a step starts. | dependency | ravintio-zero |
| Concurrency | The most steps the driver runs at once. | none | ravintio-zero |
| Worktree | A separate checkout of the repo that the driver creates for one step. | step worktree | ravintio-zero |
| Control area | The folder `plan/.initiative-control/step-{n}/` that holds a step's `ready` file. | none | ravintio-zero |
| Ready | A step whose PR is raised and green and waits for the queue. | none | ravintio-zero |
| Merge queue | The script that merges one ready PR at a time. | queue | ravintio-zero |
