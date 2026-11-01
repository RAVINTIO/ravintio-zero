---
title: "Backlog Entry: 0000308 - tests check rule anchors instead of skill wording"
summary: "A discovered-but-out-of-scope item deferred for pickup at a future discovery run."
status: "open"
priority: "medium"
theme: "unsorted"
---
# Backlog Entry: 0000308 - tests check rule anchors instead of skill wording

**Source feature:** none (human request)
**Source phase:** none (human request)
**Deferral source:** human request
**Date filed:** 2026-10-31

---

## Problem

Tests read skill text sentence by sentence, so moving or rewording a rule breaks them:

- 0000244 broke 29 feature suites and 3 regression suites.
- 0000243 broke 10 tests and 2 regression copies.
- 0000205 broke 8 suites, and 0000245 broke 4.

Each retrospective records the breakage as rework. Entry 0000302 rewrites the pack's prose and would break many more. Entry 0000261 adds one helper to locate orchestrator text, but tests would still pin whole sentences.

## Suggested Action

- Give each rule in a skill, standard, or template a stable anchor, such as `<!-- rule: hl-8 -->`.
- Add a test helper that returns a rule's text by anchor, from whichever file holds it.
- Make tests check that the anchor exists and that its text holds the key terms, not the whole sentence.
- Convert existing suites that pin whole sentences. Build on the helper from entry 0000261.
- Land this before entry 0000302.

## Wanted outcome

Rewording or moving a rule breaks no test, as long as the rule keeps its anchor and key terms. Tests check these conditions:

- Moving an anchored rule to a reference file leaves its tests green.
- Rewording a rule that keeps its key terms leaves its tests green.
- Deleting a rule's anchor fails its test and names the anchor.

## Why Deferred

The human asked for it on 2026-10-31, from the rework lines in the retrospectives of 0000205 to 0000247. No run is active.
