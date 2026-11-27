---
title: "Retrospective: 2026-11-26 - Convert remaining suites to rule anchors"
summary: "A blameless review of step 35, which anchored rules and moved 160 suites onto assert_rule."
status: "open"
---
# Retrospective: 2026-11-26 - Convert remaining suites to rule anchors

**Mode:** run
**Subject:** 0000579-convert-remaining-suites-to-rule-anchors
**Date:** 2026-11-26

## Summary

The step anchored rules in the skills, standards, and templates and moved 160 suites onto `assert_rule`. 46 suites stayed as structure checks. Eight agents did the conversion in 49 minutes. The final full run passed apart from the three inherited suites.

## What helped

- One agent per target file family split a task of about 200 suites into reports of 7 to 34 suites each (plan/_archive/0000579-convert-remaining-suites-to-rule-anchors-2026-11-26/build-log.md, P2 block).
- A shared brief and a report format let the lead build the ledger from the reports without a second read of each suite (plan/_archive/0000579-convert-remaining-suites-to-rule-anchors-2026-11-26/conversion-roadmap-a.txt).
- Each agent ran its suites alone, so the first full run found only three failures.

## What slowed the work

- Anchors changed bytes in files that setup copies and that cap suites measure. Five suites, the boot templates, and a ratchet suite needed rework (plan/postmortems/2026-11-26-anchor-edits-broke-cap-and-copy-consumers.md).
- The two full runs took about 25 minutes each. The first one ended before a PowerShell cap suite showed its failure.

## Keep

- Split a wide conversion by target file family, and let each agent write one report file (build-log P2 block).

## Change

- Add an `Anchor edit` cause to the plan scan, so the plan lists byte caps, setup copies, and ratchet counts before the first anchor (plan/postmortems/2026-11-26-anchor-edits-broke-cap-and-copy-consumers.md).

## Actions

| Change | Owner | Lives in | Verified by | Filed as |
|--------|-------|----------|-------------|----------|
| Add an `Anchor edit` cause to the plan scan | pipeline | `skills/ravintio-plan/references/test-impact-causes.md` | A test checks that the plan skill names the cause | 0000606 |
