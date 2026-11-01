---
title: "Backlog Entry: 0000283 - one update command and a doctor check"
summary: "A discovered-but-out-of-scope item deferred for pickup at a future discovery run."
status: "open"
priority: "medium"
theme: "unsorted"
---
# Backlog Entry: 0000283 - one update command and a doctor check

**Source feature:** none (human request)
**Source phase:** none (human request)
**Deferral source:** human request
**Date filed:** 2026-10-31

---

## Problem

Consumer repos install and update Zero in ways the pack doesn't support or check:

- In `rapid-prototypes`, Zero 0.30.1 was copied in on 2026-10-27 (`06e9dea`), but setup never ran. `CLAUDE.md` still holds the rules from before the rename, and `.claude/skills/` still holds 21 old skills.
- In `ravintio/docs`, two update scripts disagree. `refresh-ravintio-zero-dir.ps1` copies from `../zero` and hard-codes `--strict-orchestrator`. An untracked `update-ravintio-zero.local-only.sh` copies from another folder.
- Setup doesn't create `plan/current/`. A run in `ravintio/docs` had to add `mkdir -p plan/current` (`0000009` build-log line 50).
- Leftover state from the old pack needed manual cleanup, such as a stale `plan/.run-mode` holding `continuous` (`0000005` build-log line 42).
- Under the old pack, 5 of 6 hooks weren't executable, and re-running setup brought the fault back (`rapid-prototypes` run 0000008, build-log lines 289 to 293).

## Suggested Action

- Ship one supported update path, such as `setup.sh update {source}`. It copies the pack from a release or a local folder, then reruns setup with the flags in `plan/state/{tool}.md`.
- Add a `doctor` check, such as `setup.sh doctor`, that reports:
  - whether setup has run, and whether `CLAUDE.md` is Zero's
  - whether every hook is executable and wired in `.claude/settings.json`
  - whether `.claude/skills/` matches the pack
  - whether the installed flags match `plan/state/{tool}.md`
  - leftover files from an older pack
- Make setup create `plan/current/` and the other folders the pipeline expects.
- Have session start run the cheap parts of `doctor` and report a failure once.

## Wanted outcome

A developer can update Zero with one command and confirm that the install is healthy. Tests check these conditions:

- `doctor` fails on a repo where the pack is copied in but setup never ran.
- `doctor` fails on a non-executable hook and names it.
- The update command keeps the flags from `plan/state/{tool}.md`.
- Setup creates `plan/current/`.

## Why Deferred

The human asked for it on 2026-10-31, from a review of consumer repos. No run is active.
