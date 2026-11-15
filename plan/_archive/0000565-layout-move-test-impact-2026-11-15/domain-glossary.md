---
title: "Domain Glossary - Test impact scan for layout moves"
summary: "Definitions of domain terms used within this feature."
status: "active"
version: "0.1.0"
---
# Domain Glossary - Test impact scan for layout moves

**Skill:** [plan](../skills/ravintio-plan/SKILL.md)
**Feature:** 0000565-layout-move-test-impact
**Version:** 0.123.0

## Terms

| Term | Definition | Aliases | Used In |
|------|-----------|---------|---------|
| Test impact scan | The plan step that greps the tests for each cause a run triggers. | scan | ravintio-zero |
| Cause | One named reason a run may break an existing test. | none | ravintio-zero |
| Depth lookup | A test line that finds the repo root by climbing a fixed number of folders, such as `$ZERO_DIR/..`. | none | ravintio-zero |
| Path-keyed state | A state file that stores data under a file path, such as `plan/state/prose-baseline.json`. | none | ravintio-zero |
