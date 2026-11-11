---
title: "Domain Glossary - Check mergeability before a CI wait"
summary: "Definitions of domain terms used within this feature."
status: "active"
version: "0.1.0"
---
# Domain Glossary - Check mergeability before a CI wait

**Skill:** [plan](../skills/ravintio-plan/SKILL.md)
**Feature:** 0000483-mergeability-before-ci-wait
**Version:** 0.91.0

## Terms

| Term | Definition | Aliases | Used In |
|------|-----------|---------|---------|
| Mergeability | The `mergeable` value of a PR from `gh pr view --json mergeable`: `MERGEABLE`, `CONFLICTING`, or `UNKNOWN` | merge state | ravintio-zero |
| Conflicting PR | A PR that conflicts with its base branch. GitHub starts no pull request workflows for it | none | ravintio-zero |
| No-checks timeout | The time the queue waits for a first check to appear, set with `MQ_NOCHECKS_MS` | none | ravintio-zero |
