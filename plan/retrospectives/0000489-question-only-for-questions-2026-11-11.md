---
title: "Retrospective: 2026-11-11 - Question only for questions"
summary: "A blameless review of the Question wording run. The run files no change."
status: "closed"
---
# Retrospective: 2026-11-11 - Question only for questions

**Mode:** run
**Subject:** 0000489-question-only-for-questions
**Date:** 2026-11-11

## Summary

The run added a rule that `Question:` asks the human something. It also added a Stop hook warning for a `Question:` line with no question mark. A merge with the initiative branch moved the ADR from 0317 to 0318.

## What helped

- The backlog entry named the evidence, the wanted outcome, and the check, so P0 needed no questions (build log P0 block).
- `id-collisions.mjs` renumbered the ADR and fixed most references (build log P4 notes). Three mentions of the old number needed a manual fix.

## What slowed the work

- The full suite took about 30 minutes because other steps shared the machine (build log P2 notes).
- The `SKILL.md` byte cap left 48 bytes, so the rule text moved to `roadmap-standards.md`.

## Keep

- Put new rule text in a standard when `SKILL.md` is near its cap (build log P2 notes).

## Change

None. The run found no gap that needs a new change.

## Actions

None filed.
