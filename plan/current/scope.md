---
title: "Scope - Convert remaining suites to rule anchors"
summary: "Defines explicit boundaries of what is in scope and out of scope."
status: "active"
version: "0.1.0"
---
# Scope - Convert remaining suites to rule anchors

**Skill:** [plan](../skills/ravintio-plan/SKILL.md)
**Feature:** 0000579-convert-remaining-suites-to-rule-anchors
**Version:** 0.149.0

## In Scope

- A `<!-- rule: {id} -->` anchor on each rule that a prose-pinning suite checks, in skills, standards, and templates.
- A move of each such suite onto `assert_rule` or `rule_text` with key terms.
- A ledger, `tests/helpers/anchor-conversions.txt`, that lists each converted suite and each suite the step judged a structure check.
- One guard suite with a reword probe.

## Out of Scope

- The copies in `tests/regression/`, which the ratchet process owns.
- Suites that check structure: file lists, line caps, sync results, heading lists, frontmatter, and the wording allowlist.
- A change to the meaning of any rule.

## Deferred

- None.
