---
title: "Risk Register - Standards archetypes"
summary: "Technical, operational, and security risks with their mitigations."
status: "draft"
version: "0.1.0"
---
# Risk Register - Standards archetypes

**Skill:** [plan](../../ravintio-zero/skills/ravintio-plan/SKILL.md) (updated by any agent that identifies a new risk)
**Feature:** 0000391-standards-archetypes
**Version:** 0.1.0
**Overall Risk Level:** high

## Risks

| ID | Category | Description | Likelihood | Impact | Mitigation | Status |
|----|----------|------------|------------|--------|-----------|--------|
| R-001 | security | An override or archetype relaxes a rule that a hook enforces, so the guard stops guarding. | medium | high | `protected.json` lists each enforced path. The resolver returns the pack copy for it. A test plants a relaxing override. The chart says to stop if the resolver cannot do this. | open |
| R-002 | technical | `setup.sh` and `setup.ps1` drift apart in the dispatch. | medium | medium | Both only dispatch to `archetype.mjs`. A parity test compares the output of `archetype list` from both. | open |
| R-003 | technical | A `use` run fails half way and leaves a partial install. | low | high | The command runs all checks before it writes. It writes the record last. A rerun repairs the rest. | open |
| R-004 | technical | A symlink or `..` path in an archetype or override reaches a file outside the repo. | low | high | The resolver and the command refuse a path outside the repo and any symlink. Tests cover both. | open |
| R-005 | operational | New edits to `ravintio-zero/skills/ravintio-validate-and-accept/SKILL.md` push skill text over the 1720-line cap. | medium | medium | The pointer text stays under 10 lines. The plan records 54 lines of headroom. The orchestrator `SKILL.md` stays untouched. | open |
| R-006 | compliance | A new archetype file breaks the prose check or the brand guard. | medium | medium | U5 runs `prose-check.mjs` over the catalogue. A test installs each archetype and runs the check. | open |

## Assumptions Logged as Risks

| ID | Assumption | Impact if Wrong | Status |
|----|-----------|----------------|--------|
| A-001 | The prose check tests no spelling. | The US archetype fails its own check. | open |
| A-002 | Overrides sit in `ravintio-overrides/standards/` and `ravintio-overrides/templates/`. | The resolver reads the wrong folder. | open |
