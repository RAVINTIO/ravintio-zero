---
title: "Backlog Entry: 0000301 - add a prose linter with a ratchet"
summary: "A discovered-but-out-of-scope item deferred for pickup at a future discovery run."
status: "open"
priority: "medium"
theme: "unsorted"
---
# Backlog Entry: 0000301 - add a prose linter with a ratchet

**Source feature:** none (human request)
**Source phase:** none (human request)
**Deferral source:** human request
**Date filed:** 2026-10-31

---

## Problem

Only the em dash has a check (`em-dash-guard.mjs`). Nothing tests sentence length, banned words, semicolons, or passive voice.

A scan on 2026-10-31 of 95 Markdown files in the pack's skills, standards, templates, and `docs/` found about 3,500 sentences. Of those, 75 run over 25 words, 43 hold semicolons, 6 use banned words, and about 120 look passive.

## Suggested Action

- Add a Node script with no dependencies that checks Markdown and commit messages against `writing-standards.md` (entry 0000300):
  - sentences over 25 words
  - words on the standard's blocklist
  - semicolons and em dashes
  - likely passive voice, as "is", "are", "was", or "were" before a past participle
- Skip code blocks, inline code, tables, and quoted output.
- Run it on `docs/`, `plan/`, and the pack in pre-commit and CI, and on commit messages in `commit-msg`.
- Record current breaches as a baseline per file. Block new breaches, and let the baseline only shrink.

## Wanted outcome

New prose can't add breaches, and the count of old ones only falls. Tests check these conditions:

- A new 26-word sentence in `docs/` fails the check and names the file and line.
- A sentence inside a code block passes.
- An existing baselined breach passes until someone fixes it.
- A change that raises a file's baseline fails.

## Why Deferred

The human asked for it on 2026-10-31, from a review of Zero's writing quality. No run is active.
