---
title: "Domain Glossary - Test impact scan misses suites that scan live files"
summary: "Definitions of domain terms used within this feature."
status: "active"
version: "0.1.0"
---
# Domain Glossary - Test impact scan misses suites that scan live files

**Skill:** [plan](../skills/ravintio-plan/SKILL.md)
**Feature:** 0000566-test-impact-for-history-moves
**Version:** 0.124.0

## Terms

| Term | Definition | Aliases | Used In |
|------|-----------|---------|---------|
| Test impact scan | The plan step that greps the tests for each cause a run triggers. | scan | ravintio-zero |
| Cause | One named reason a run may break an existing test. | none | ravintio-zero |
| History exclusion | A test line that skips `plan/_archive/` because the folder holds history, not live text. | none | ravintio-zero |
