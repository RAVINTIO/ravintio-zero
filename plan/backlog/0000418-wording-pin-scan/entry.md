---
title: "Backlog Entry: 0000418 - scan for wording pins before a prose rewrite"
summary: "The plan phase has no scan for tests that grep rewritten sentences, so a prose rewrite finds pins only at P3."
status: "open"
priority: "medium"
theme: "unsorted"
---
# Backlog Entry: 0000418 - scan for wording pins before a prose rewrite

**Source feature:** 0000395-pack-prose-to-the-standard

**Source phase:** P3

**Deferral source:** discovered mid-flight

**Date filed:** 2026-11-09

---

## Problem

Step 19 rewrote prose in about 370 files. Seven tests and two fixtures grepped the old wording, and the full suite found them only at P3. The plan skill's test impact scan lists causes such as skill count and size cap. It has no cause for a prose rewrite.

## Suggested Action

Add a cause to the test impact scan in `ravintio-zero/skills/ravintio-plan/SKILL.md`. For a run that rewrites prose, grep `ravintio-zero/tests/` for each changed sentence, and list the matches in the execution plan. A script could print the matches for a slice list.

## Why Deferred

The change edits the plan skill, which is outside the scope of a prose rewrite.
