---
title: "Domain Glossary - Test impact scan covers size caps and frozen lines"
summary: "Definitions of domain terms used within this feature."
status: "active"
version: "0.1.0"
---
# Domain Glossary - Test impact scan covers size caps and frozen lines

**Skill:** [plan](../skills/ravintio-plan/SKILL.md)
**Feature:** 0000567-test-impact-size-caps-and-frozen-lines
**Version:** 0.125.0

## Terms

| Term | Definition | Aliases | Used In |
|------|-----------|---------|---------|
| Test impact scan | The plan step that greps the tests for each cause a run triggers. | scan | ravintio-zero |
| Cause | One named reason a run may break an existing test. | none | ravintio-zero |
| Size cap | A test that fails when a file grows past a byte limit. | cap | ravintio-zero |
| Frozen line | A base line of the orchestrator skill that a suite requires to stay in the skill or its references. | none | ravintio-zero |
| Boot template | The `templates/standard-boot.md` text that setup copies into a project boot file. | none | ravintio-zero |
