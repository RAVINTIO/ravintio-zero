---
title: "Postmortem: 2026-11-09 - archetype content used a banned word"
summary: "A blameless record of why a banned word in a new pack file reached the full suite, and the actions that close the gap."
status: "closed"
---
# Postmortem: 2026-11-09 - archetype content used a banned word

> Path: `plan/postmortems/2026-11-09-archetype-content-banned-word.md`. Written by `ravintio-postmortem`.

**Trigger:** P2 self-correction
**Feature:** 0000391-standards-archetypes
**Date:** 2026-11-09

## Summary

A sample file in the restricted-stack archetype used a word that `test-0000042-req-010-pack-wording-allowlist.sh` bans. The first full suite run failed on it. The fix took one commit.

## Timeline

| Time | Event | Evidence |
|------|-------|----------|
| 2026-11-09T18:23Z | The unit brief for U5 named two repo-wide tests to run | build-log P2 block |
| 2026-11-09T18:45Z | U5 committed with the banned word in `stack-allowlist.md` | commit 909ee6d1 |
| 2026-11-09T19:05Z | The full suite failed on the wording test | `Failed suites:` list of the first full run |
| 2026-11-09T19:08Z | The word was replaced | commit 828c3c61 |

First missed chance to catch it: the plan's test-impact scan, which has no cause for a new pack content file.

## 5 whys

1. The full suite failed on the wording test.
2. The unit never ran that test.
3. The unit brief listed only the tests from the scan and two familiar ones.
4. The scan lists no wording test for a run that adds pack content.
5. The plan skill has no scan cause for a new content file under `ravintio-zero/`.

**Gap:** The test-impact scan in the plan skill lacks a cause for new pack content.

## Actions

| Type | Action | Status | Owner | Lives in | Verified by | Ref |
|------|--------|--------|-------|----------|-------------|-----|
| corrective | Replace the banned word in the sample file | done | step 15 | `ravintio-zero/archetypes/constraint/restricted-stack/files/standards/stack-allowlist.md` | `test-0000042-req-010-pack-wording-allowlist.sh` | commit 828c3c61 |
| preventive | Add a scan cause for new pack content files | filed | pack maintainers | `ravintio-zero/skills/ravintio-plan/SKILL.md` | a test that reads the scan | 0000415 |
| detective | none, because the full suite already catches the breach before P3 closes | none | n/a | n/a | n/a | n/a |
