---
title: "Domain Glossary - isolated test state"
summary: "Terms used by the test isolation work."
status: "active"
version: "0.41.2"
---
# Domain Glossary - isolated test state

**Skill:** [plan](../skills/ravintio-plan/SKILL.md)
**Feature:** 0000315-isolated-test-state
**Version:** 0.41.2

## Terms

| Term | Definition | Aliases | Used In |
|------|-----------|---------|---------|
| Runner setting | A `RAVINTIO_*` variable the runner reads: `RAVINTIO_TEST_QUIET`, `RAVINTIO_REQUIRE_PWSH`, `RAVINTIO_PREFLIGHT_ONLY`, `RAVINTIO_PWSH`. Only `RAVINTIO_PWSH` and `RAVINTIO_TEST_QUIET` reach a suite. | none | ravintio-zero |
| Tree check | The runner step that compares tracked and untracked files before and after a run. | final check | ravintio-zero |
