---
title: "Postmortem: 2026-11-26 - Anchor edits broke cap and copy consumers"
summary: "A blameless record of why anchor edits broke byte caps, installed boot files, and a ratchet count, and the actions that close the gap."
status: "open"
---
# Postmortem: 2026-11-26 - Anchor edits broke cap and copy consumers

> Path: `plan/postmortems/2026-11-26-anchor-edits-broke-cap-and-copy-consumers.md`. Written by `ravintio-postmortem`.
> Blameless: a cause names a gap in a process, check, standard, or tool. Never name a person or an agent.
> Copy no credential from a log. Name the file and the line instead.

**Trigger:** P2 self-correction
**Feature:** 0000579-convert-remaining-suites-to-rule-anchors
**Date:** 2026-11-26

## Summary

The step added about 400 rule anchors. They pushed the orchestrator `SKILL.md` past its byte cap. They also leaked into the boot templates that setup copies into installs. A ratchet suite then failed on an assertion count. No defect reached the PR.

## Timeline

| Time | Event | Evidence |
|------|-------|----------|
| 2026-11-26T08:19:52Z | P1 ends. The test impact scan lists the cap suites and says anchors add no lines. It lists no byte measure. | `plan/current/execution-plan.md` |
| 2026-11-26T08:24:00Z | Batch agents report the orchestrator `SKILL.md` at 9,098 to 9,357 bytes against a 9,000 cap. | agent reports for batches `other-b` and `ship` |
| 2026-11-26T08:32:00Z | The step removes the anchors from the two boot templates. Four suites move back to plain checks. | commit "anchor rules and move suites to assert_rule" |
| 2026-11-26T08:33:00Z | Five cap suites measure the text without anchors. | commit "measure byte caps without anchors" |
| 2026-11-26T09:09:00Z | The full run fails `test-0000017-req-001`, `test-0000036-req-001-003`, and a PowerShell cap suite. | `/tmp` full-suite output, summary lines |
| 2026-11-26T09:10:00Z | The step reverts one converted suite, lists the ledger file, and fixes the PowerShell cap. | commit "fix the ratchet, runner, and cap suites" |

First missed chance to catch it: P1 Plan. The test impact scan has no cause for an edit that adds comment bytes to a measured file.

## 5 whys

1. Anchor edits broke three groups of suites after P1 had planned the work.
2. The plan said anchors add no lines. It did not ask what measures bytes, what setup copies, or what a ratchet counts.
3. The scan lists the line cap and the size cap. It has no cause for an edit that changes bytes but not lines.
4. The scan lists causes by edit shape that earlier steps broke. No earlier step added comments to many files.
5. The scan has no check that follows a file to its consumers, such as the setup copy and the ratchet.

**Gap:** The plan scan has no `Anchor edit` cause that lists byte caps, setup copies, and ratchet counts.

## Actions

| Type | Action | Status | Owner | Lives in | Verified by | Ref |
|------|--------|--------|-------|----------|-------------|-----|
| corrective | Measure caps without anchors, keep boot templates plain, keep the promoted suite, list the ledger | done | step 35 | `src/ravintio-zero/tests/` | The full suite passes apart from the inherited suites | this branch |
| preventive | Add an `Anchor edit` cause to the plan scan | filed | pipeline | `skills/ravintio-plan/references/test-impact-causes.md` | A test checks that the plan skill names the cause | 0000606 |
| detective | none, because the batch agents and the full run caught each break in P2 | none | none | none | none | none |
