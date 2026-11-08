---
title: "Domain Glossary - GitHub security and CI lint"
summary: "Terms used by the security and lint change."
status: "active"
version: "0.1.0"
---
# Domain Glossary - GitHub security and CI lint

**Skill:** [plan](../../ravintio-zero/skills/ravintio-plan/SKILL.md)
**Feature:** 0000394-github-security-and-ci-lint
**Version:** 0.61.0

## Terms

| Term | Definition | Aliases | Used In |
|------|-----------|---------|---------|
| Brand guard | A check that no tracked file uses the retired product name outside an allowlist. | none | ravintio-zero |
| Brand guard allowlist | The file `brand-guard-allowlist.txt` that lists excluded prefixes and allowed path and line pairs. | allowlist | ravintio-zero |
| SHA pin | A `uses:` reference to a 40-character commit SHA, with the release tag in a comment. | pin | ravintio-zero |
| Workflow lint | The `workflow-lint` job that runs `actionlint` and `zizmor`. | lint job | ravintio-zero |
| Settings checklist | The list of admin-only GitHub settings that a human turns on. | checklist | ravintio-zero |
