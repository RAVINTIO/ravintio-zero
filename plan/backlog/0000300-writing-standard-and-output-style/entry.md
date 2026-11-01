---
title: "Backlog Entry: 0000300 - ship a writing standard and install it for each tool"
summary: "A discovered-but-out-of-scope item deferred for pickup at a future discovery run."
status: "open"
priority: "medium"
theme: "unsorted"
---
# Backlog Entry: 0000300 - ship a writing standard and install it for each tool

**Source feature:** none (human request)
**Source phase:** none (human request)
**Deferral source:** human request
**Date filed:** 2026-10-31

---

## Problem

The pack has no writing standard. The human's British English variant of the Google developer documentation style lives only in their personal Claude settings. A developer who installs Zero gets `formatting-standards.md`, which covers British spelling, brevity, and the em dash ban.

That standard also conflicts with the Google variant in two places:

- It requires `DD MMM YYYY` dates in body text and forbids ISO dates (`formatting-standards.md:11`). The variant asks for `2026-10-31` or "October 31, 2026".
- It offers the semicolon as a replacement for the em dash (`formatting-standards.md:78`). The variant bans semicolons.

## Suggested Action

- Add `ravintio-zero/standards/writing-standards.md`, based on the British English variant of the Google developer documentation style.
- Settle the date and semicolon conflicts in `formatting-standards.md`.
- For Claude Code, have setup write `.claude/output-styles/ravintio-writing.md` and set `outputStyle` in `.claude/settings.json`.
- For Codex, have setup add a short writing section to `AGENTS.md` that points to the standard (`setup/codex.sh:12`).
- Generate both outputs from the standard, so they can't drift apart.
- If `outputStyle` already names another style, leave it and say so. Add a flag such as `--no-writing-style` to skip the install.
- Name the standard in every subagent and step-session brief, because output styles reach only the main session.
- At pickup, confirm in the Claude Code docs that project-level output styles work and that `outputStyle` is a project setting.

## Wanted outcome

Every developer who installs Zero gets the same writing standard in both tools. Tests check these conditions:

- After a Claude Code install, `.claude/output-styles/ravintio-writing.md` exists and `outputStyle` names it.
- After a Codex install, `AGENTS.md` holds the writing section.
- Setup leaves an existing `outputStyle` value in place.
- `formatting-standards.md` and `writing-standards.md` agree on dates and semicolons.

## Why Deferred

The human asked for it on 2026-10-31, from a review of Zero's writing quality. No run is active.
