---
title: "Domain Glossary - CI avoids extra runs on a plan-only push"
summary: "Terms of the concurrency change."
status: "active"
version: "0.139.0"
---
# Domain Glossary - CI avoids extra runs on a plan-only push

**Skill:** [plan](../../ravintio-zero/skills/ravintio-plan/SKILL.md)
**Feature:** 0000558-plan-only-push-short-ci
**Version:** 0.139.0

## Terms

| Term | Definition | Aliases | Used In |
|------|-----------|---------|---------|
| Plan-only push | A push whose changed files all sit under `plan/`, plus the sentinels. | closing push | ravintio-zero |
| Superseded run | A workflow run for a head that a newer push has replaced. | older run | ravintio-zero |
| Concurrency group | The key that GitHub uses to hold one active run at a time. | group | ravintio-zero |
