---
title: "Backlog Entry: 0000371 - orchestrator skill byte headroom"
summary: "A discovered-but-out-of-scope item deferred for pickup at a future discovery run."
status: "open"
priority: "low"
theme: "unsorted"
---
# Backlog Entry: 0000371 - orchestrator skill byte headroom

**Source feature:** 0000359-safe-parallel-commits
**Source phase:** P1
**Deferral source:** discovered mid-flight
**Date filed:** 2026-11-07
**Source retrospective:** `plan/retrospectives/0000359-safe-parallel-commits-2026-11-07.md`

---

## Problem

`ravintio-zero/skills/ravintio-orchestrator/SKILL.md` holds 8882 bytes under a 9000 byte cap (`test-0000151-req-011-orchestrator-references-split.sh`, `test-0000247-req-001-stage-by-path.sh`). Step 8 had 221 bytes to work with and wrote a one-line rule. The next rule that needs orchestrator text has 118 bytes.

## Suggested Action

Move one section of the skill, such as Context Hygiene, into a reference file under `skills/ravintio-orchestrator/references/`. Leave a Pack Index row that points to it. Update the cap tests that read the moved text.

## Why Deferred

The step's rule fit inside the cap. Moving a section changes the Pack Index and several suites, which is outside the scope of step 8.
