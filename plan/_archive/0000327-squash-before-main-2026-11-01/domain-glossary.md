---
title: "Domain Glossary - Squash before main"
summary: "Definitions of domain terms used within this feature."
status: "active"
version: "0.1.0"
---
# Domain Glossary - Squash before main

**Skill:** [plan](../skills/ravintio-plan/SKILL.md)
**Feature:** 0000327-squash-before-main
**Version:** 0.48.0

## Terms

| Term | Definition | Aliases | Used In |
|------|-----------|---------|---------|
| Chore branch | A `chore/*` branch that carries a small non-feature change into `main`. | none | ravintio-zero |
| Hotfix branch | A `hotfix/*` branch that carries an urgent fix into `main`. | none | ravintio-zero |
| Single-commit head | A branch that holds exactly one commit on top of `origin/main`. | none | ravintio-zero |
| Replacement PR | A new PR from a new branch cut from `origin/main`. The agent raises it for a `hotfix/*` branch that holds several commits, then closes the old PR with a link. | none | ravintio-zero |
| Force-with-lease | `git push --force-with-lease`. It overwrites a remote branch only if the remote still matches what the agent last fetched. | none | ravintio-zero |
