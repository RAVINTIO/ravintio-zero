---
title: "Domain Glossary - Scan new pack files for the wording allowlist"
summary: "Definitions of domain terms used within this feature."
status: "active"
version: "0.1.0"
---
# Domain Glossary - Scan new pack files for the wording allowlist

**Skill:** [plan](../skills/ravintio-plan/SKILL.md)
**Feature:** 0000569-scan-new-pack-files-for-wording-allowlist
**Version:** 0.131.0

## Terms

| Term | Definition | Aliases | Used In |
|------|-----------|---------|---------|
| Test impact scan | The plan step that greps the tests for each cause a run triggers. | scan | ravintio-zero |
| Cause | One named reason a run may break an existing test. | none | ravintio-zero |
| Wording allowlist | The list in `test-0000042-req-010` of lines that may hold a banned word. | allowlist | ravintio-zero |
| Pack content | A content file under `ravintio-zero/`, such as a standard, a template, or a skill. | none | ravintio-zero |
