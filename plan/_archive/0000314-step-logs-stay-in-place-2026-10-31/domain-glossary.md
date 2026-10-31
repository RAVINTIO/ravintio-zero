---
title: "Domain Glossary - step logs stay in place"
summary: "Terms used by the step log fix."
status: "active"
version: "0.41.1"
---
# Domain Glossary - step logs stay in place

**Skill:** [plan](../skills/ravintio-plan/SKILL.md)
**Feature:** 0000314-step-logs-stay-in-place
**Version:** 0.41.1

## Terms

| Term | Definition | Aliases | Used In |
|------|-----------|---------|---------|
| Step log | The git-ignored file `plan/.initiative-logs/step-{n}.log` that holds a step session's output. | log | ravintio-zero |
| Driver file | A file or folder the driver owns: `plan/.initiative-logs/`, `plan/.initiative-runner.lock`, `plan/.initiative-queue/`. | none | ravintio-zero |
| Phase guard | The grep in `test-0000042-req-006` that fails on a phase cite above P4. | stale cite guard | ravintio-zero |
