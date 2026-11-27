---
title: "Domain Glossary - Plan lists every way a check can pass"
summary: "Definitions of domain terms used within this feature."
status: "active"
version: "0.1.0"
---
# Domain Glossary - Plan lists every way a check can pass

**Skill:** [plan](../skills/ravintio-plan/SKILL.md)
**Feature:** 0000578-plan-lists-pass-signals
**Version:** 0.145.0

## Terms

| Term | Definition | Aliases | Used In |
|------|-----------|---------|---------|
| Pass signal | The exit code or output that tells a check that the judged component passed. | | ravintio-zero |
| Launcher | A program between a check and the judged component, such as `guard-run.mjs`. | wrapper | ravintio-zero |
| Pass path | One way the judged component, or its launcher, produces the pass signal. | path | ravintio-zero |
