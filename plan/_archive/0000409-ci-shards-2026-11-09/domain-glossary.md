---
title: "Domain Glossary - sharded CI suites"
summary: "Definitions of domain terms used within this feature."
status: "active"
version: "0.1.0"
---
# Domain Glossary - sharded CI suites

**Skill:** [plan](../skills/ravintio-plan/SKILL.md)
**Feature:** 0000409-ci-shards
**Version:** 0.69.0

## Terms

| Term | Definition | Aliases | Used In |
|------|-----------|---------|---------|
| Shard | One of n parts of the suite list. A runner runs one shard when `RAVINTIO_SHARD` is set. | none | ravintio-zero |
| Summary job | A CI job that runs no tests. It passes only when every shard of its suite job passed, and it carries the required check name. | none | repo workflow |
