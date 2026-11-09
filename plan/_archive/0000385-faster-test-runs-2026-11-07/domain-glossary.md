---
title: "Domain Glossary - Faster test runs"
summary: "Terms used by the affected-test, baseline, and clean-clone change."
status: "active"
version: "0.1.0"
---
# Domain Glossary - Faster test runs

**Skill:** [plan](../../ravintio-zero/skills/ravintio-plan/SKILL.md)
**Feature:** 0000385-faster-test-runs
**Version:** 0.61.0

## Terms

| Term | Definition | Aliases | Used In |
|------|-----------|---------|---------|
| Affected tests | The new test plus the tests that cover the files a unit changes. | cycle tests | ravintio-zero |
| Baseline failures | The suites that fail on the base commit, recorded at P0 in `plan/current/baseline-failures.md`. | inherited failures | ravintio-zero |
| Clean clone | A temporary clone of `HEAD` that holds only committed files. P3 runs the suite there. | none | ravintio-zero |
| Full suite run | One run of every suite, once before P2 completes and once at P3. | none | ravintio-zero |
