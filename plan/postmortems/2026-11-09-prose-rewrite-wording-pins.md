---
title: "Postmortem: 2026-11-09 - prose rewrite broke wording pins"
summary: "A blameless record of why a prose rewrite failed seven tests that pinned old wording."
status: "closed"
---
# Postmortem: 2026-11-09 - prose rewrite broke wording pins

> Path: `plan/postmortems/2026-11-09-prose-rewrite-wording-pins.md`. Written by `ravintio-postmortem`.
> Blameless: a cause names a gap in a process, check, standard, or tool. Never name a person or an agent.
> Copy no credential from a log. Name the file and the line instead.

**Trigger:** P2 self-correction
**Feature:** 0000395-pack-prose-to-the-standard
**Date:** 2026-11-09

## Summary

The step rewrote prose in about 370 files. Seven tests and two fixtures grepped the old wording, and they failed until the step moved each pin to the new wording.

## Timeline

| Time | Event | Evidence |
|------|-------|----------|
| P2 batch 2 | Unit agents reported pins in the orchestrator files | `plan/current/build-log.md`, the U11 hand-back |
| P2 | The orchestrator pins forced a second pass over 19 breaches | `plan/current/build-log.md`, line "Done: U11 part 2" |
| P2 | The full suite listed five new failing suites | `ravintio-zero/tests/test-0000032-req-004-refresh-setup-reads-record-first.sh` and four more |
| P2 | The step updated each pin | commit "0000395: Update test pins for rewritten wording" |

First missed chance to catch it: the P1 test impact scan could have listed the pins, but it has no cause for a prose rewrite.

## 5 whys

1. Seven tests failed after the rewrite.
2. They grepped sentences that the rewrite changed.
3. The plan did not list those tests before P2.
4. The test impact scan names causes such as skill count and size cap, and none for a prose rewrite.
5. Nothing in the plan skill asks for a grep of the tests against changed sentences.

**Gap:** The plan skill's test impact scan has no cause for a prose rewrite.

## Actions

| Type | Action | Status | Owner | Lives in | Verified by | Ref |
|------|--------|--------|-------|----------|-------------|-----|
| corrective | Move each pin to the rewritten wording | done | step 19 | `ravintio-zero/tests/` | the full suite | commit "0000395: Update test pins for rewritten wording" |
| preventive | Add a prose rewrite cause to the test impact scan | filed | pack maintainer | `ravintio-zero/skills/ravintio-plan/SKILL.md` | a plan test | 0000418 |
| detective | none, because the full suite at P3 already fails on a pin | none | none | none | none | none |
