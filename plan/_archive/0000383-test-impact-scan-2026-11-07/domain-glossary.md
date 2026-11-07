---
title: "Domain Glossary - Test impact scan"
summary: "Terms used by the scan change."
status: "active"
version: "0.1.0"
---
# Domain Glossary - Test impact scan

**Skill:** [plan](../../ravintio-zero/skills/ravintio-plan/SKILL.md)
**Feature:** 0000383-test-impact-scan
**Version:** 0.61.0

## Terms

| Term | Definition | Aliases | Used In |
|------|-----------|---------|---------|
| Test impact scan | The plan step that greps test folders for each cause and lists matches under `## Test impact`. | scan | ravintio-zero |
| Cause | A kind of edit that can break a test the edit does not name. | none | ravintio-zero |
| Fixture pin | A line held in a file under `ravintio-zero/tests/fixtures/` that a test compares with a pack file. | pinned line | ravintio-zero |
| Non-suite file | A file under `ravintio-zero/tests/` that is not a `test-*.sh` suite, such as a helper. | none | ravintio-zero |
