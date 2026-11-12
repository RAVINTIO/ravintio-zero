---
title: "Domain Glossary - Driver removes merged step worktrees"
summary: "Definitions of domain terms used within this feature."
status: "active"
version: "0.107.0"
---
# Domain Glossary - Driver removes merged step worktrees

**Skill:** [plan](../../ravintio-zero/skills/ravintio-plan/SKILL.md)
**Feature:** 0000501-remove-merged-worktrees
**Version:** 0.107.0

## Terms

| Term | Definition | Aliases | Used In |
|------|-----------|---------|---------|
| Driver | The script `initiative-run.mjs` that starts step sessions and runs the merge queue | runner | ravintio-zero |
| Step worktree | The folder `plan/.initiative-worktrees/step-{n}` where one step session runs | worktree | ravintio-zero |
| Merged step | A chart row with status `merged` | none | ravintio-zero |
| Sweep | The pass at driver start that removes the safe worktrees of merged steps | none | ravintio-zero |
| Safe worktree | A worktree with no live session, no uncommitted file, and a head on its origin branch or an origin branch that no longer exists | none | ravintio-zero |
| Kept line | The line `I-C Run: Kept:` that names a worktree the sweep left in place and why | none | ravintio-zero |
