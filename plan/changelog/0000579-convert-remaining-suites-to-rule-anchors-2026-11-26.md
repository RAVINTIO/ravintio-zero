# Changelog (0000579-convert-remaining-suites-to-rule-anchors, 26 Nov 2026)

**Feature:** Convert remaining suites to rule anchors
**Version:** set by the merge queue at merge
**PR:** pending

## What changed

Rules in the skills, standards, and templates now carry `<!-- rule: id -->` anchors. 160 suites read those rules through `assert_rule` or `rule_text` with key terms. 46 suites check structure or behaviour and keep their checks. A ledger lists both groups. A guard suite reads the ledger, then rewords the anchored rules in a copy of the pack and reruns a sample of the converted suites.

## Why

A reword of a rule broke every suite that pinned its sentence. Step 4 anchored the orchestrator only. This step covers the ship, plan, implement, validate, and initiative skills, plus the standards and templates (backlog entry 0000401).

## Deviations

- The boot templates carry no anchors, because setup copies them into installed files. Their suites keep plain checks.
- The byte caps on the orchestrator `SKILL.md` count its text without anchors.
- Two suites that compared a source file with its installed copy now drop anchor lines first.

## Validation results

See the build report.

## Skipped phases

None
