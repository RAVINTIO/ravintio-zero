---
title: "Domain Glossary - block forced adds"
summary: "Terms used by the forced-add work."
status: "active"
version: "0.43.0"
---
# Domain Glossary - block forced adds

**Skill:** [plan](../skills/ravintio-plan/SKILL.md)
**Feature:** 0000317-block-forced-adds
**Version:** 0.43.0

## Terms

| Term | Definition | Aliases | Used In |
|------|-----------|---------|---------|
| Forced add | A `git add` with `-f` or `--force`. It stages a file that an ignore rule matches. | force add | ravintio-zero |
| Ignored file | A file that a `.gitignore` or `.git/info/exclude` rule matches. | none | ravintio-zero |
| Driver paths | `plan/.initiative-logs/`, `plan/.initiative-queue/`, and `plan/.initiative-runner.lock`. The initiative driver writes them. | none | ravintio-zero |
