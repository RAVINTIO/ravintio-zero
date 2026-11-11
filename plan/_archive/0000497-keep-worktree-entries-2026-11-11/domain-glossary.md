---
title: "Domain Glossary - Driver keeps uncommitted entries from a worktree"
summary: "Definitions of domain terms used within this feature."
status: "active"
version: "0.106.0"
---
# Domain Glossary - Driver keeps uncommitted entries from a worktree

**Skill:** [plan](../../ravintio-zero/skills/ravintio-plan/SKILL.md)
**Feature:** 0000497-keep-worktree-entries
**Version:** 0.106.0

## Terms

| Term | Definition | Aliases | Used In |
|------|-----------|---------|---------|
| Driver | The script `initiative-run.mjs` that starts step sessions and runs the merge queue | runner | ravintio-zero |
| Step worktree | The folder `plan/.initiative-worktrees/step-{n}` where one step session runs | worktree | ravintio-zero |
| Untracked entry | A file under `plan/backlog/` in a step worktree that git does not track and does not ignore | uncommitted entry | ravintio-zero |
| Keep | The driver leaves the worktree in place and stops the queue for the step | refuse | ravintio-zero |
