---
title: "Backlog Entry: 0000479 - parallel steps reserve the same ADR number"
summary: "Two steps that run at once reserve the same ADR number from their own branches, and the second to merge must renumber by hand."
status: "open"
priority: "medium"
theme: "queue"
---
# Backlog Entry: 0000479 - parallel steps reserve the same ADR number

**Source feature:** 0000462-tests-without-git-identity

**Source phase:** P4

**Deferral source:** discovered mid-flight

**Date filed:** 2026-11-10

---

## Problem

Step 35 reserved ADR 0301 from `docs/adr/.next-id` on its own branch. Steps 32 and 33 had already reserved 0301 and 0302 from their branches. The merge of the initiative branch into step 35 conflicted on the counter, the decisions index, and the ADR number. The step renumbered its ADR to 0303 by hand. The merge queue resolves the counter and the index rows, but it does not detect two ADR files with one number.

Retrospective: `plan/retrospectives/0000462-tests-without-git-identity-2026-11-10.md`.

## Suggested Action

- The merge queue renumbers an ADR file whose number another merged step already uses, and updates its index row and references.

## Wanted outcome

- Two steps that reserve the same ADR number merge with no hand edit, and each ADR keeps one unique number.
