---
title: "Domain Glossary - Convert remaining suites to rule anchors"
summary: "Definitions of domain terms used within this feature."
status: "active"
version: "0.1.0"
---
# Domain Glossary - Convert remaining suites to rule anchors

**Skill:** [plan](../skills/ravintio-plan/SKILL.md)
**Feature:** 0000579-convert-remaining-suites-to-rule-anchors
**Version:** 0.149.0

## Terms

| Term | Definition | Aliases | Used In |
|------|-----------|---------|---------|
| Rule anchor | A `<!-- rule: {id} -->` comment at the start of a line that marks one rule. | anchor | ravintio-zero |
| Key term | A word or phrase that a rule must hold, passed to `assert_rule`. | | ravintio-zero |
| Prose pin | A suite check that matches a whole sentence, or a section it cuts out with `sed` or `awk`. | pin | ravintio-zero |
| Structure check | A suite check of a file list, a line cap, a sync result, a heading list, or frontmatter. | | ravintio-zero |
| Ledger | The file `tests/helpers/anchor-conversions.txt`, which lists each converted suite and each suite judged a structure check. | | ravintio-zero |
| Reword probe | A run in a copy of the pack that rewords each anchored rule and reruns a sample of suites. | probe | ravintio-zero |
