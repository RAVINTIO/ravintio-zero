---
title: "Domain Glossary - Backlog triage"
summary: "Definitions of domain terms used within this feature."
status: "active"
version: "0.1.0"
---
# Domain Glossary - Backlog triage

**Skill:** [plan](../skills/ravintio-plan/SKILL.md)
**Feature:** 0000321-backlog-triage
**Version:** 0.47.0

## Terms

| Term | Definition | Aliases | Used In |
|------|-----------|---------|---------|
| Backlog index | The generated file `plan/backlog/index.md`. It lists every entry grouped by theme and ordered by priority. | index | ravintio-zero |
| Priority | A frontmatter field on an entry. It holds `high`, `medium`, or `low`. | none | ravintio-zero |
| Theme | A frontmatter field on an entry. It holds a kebab-case group name. The default is `unsorted`. | none | ravintio-zero |
| Review age | The number of days after **Date filed** when an entry counts as stale. It is `backlogReviewDays` in `product.yml`, default 5. | staleness age | ravintio-zero |
| Staleness review | The `--review` mode of `backlog-index.mjs`. It lists entries older than the review age. | review | ravintio-zero |
