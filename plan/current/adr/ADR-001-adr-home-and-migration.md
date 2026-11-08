---
title: "ADR 001: ADR home in docs/adr and migration 0009"
summary: "Every ADR lives in docs/adr under a four-digit repo-wide number. A script-backed migration moves and renumbers the archived ADRs."
status: "proposed"
version: "0.1.0"
---
# ADR-001 - ADR home in docs/adr and migration 0009

**Skill:** [plan](../skills/ravintio-plan/SKILL.md)
**Feature:** 0000384-plan-checks
**Component:** ravintio-zero
**Date:** 08 Nov 2026

## Context

Each feature writes ADRs to `plan/current/adr/` and ship archives them. The archive is the only home of the text. Feature 0000030 emptied the archive and lost the ADRs of features 0000001 to 0000029. Numbers restart at ADR-001 in every feature. The initiative chart answers three open questions: restore the lost ADRs, keep one repo-wide folder, and use four digits.

## Decision

- `docs/adr/{NNNN}-{slug}.md` holds every ADR. `docs/adr/.next-id` is the counter, reserved with `reserve-id.mjs --file`.
- Migration 0009 runs a Node script `migrate-adr-home.mjs` with `.sh` and `.ps1` wrappers, as migrations 0004 to 0008 do. The script runs in two phases: restore from git history, then move and renumber.
- The script numbers ADRs by feature id, then by per-feature ADR order. It records an old-to-new map at `docs/adr/.migration-map.json` and rewrites `Supersedes` and `Superseded by` references with the map.
- It skips a target that exists with the same content, so a rerun changes nothing.
- This run's own ADRs (`plan/current/adr/`) move through the same script at P2, and ship archives a link only.
- Oldest shell: Bash 3.2. The wrappers use no Bash 4 feature.

## Alternatives Considered

| Alternative | Pros | Cons | Why Rejected |
|-------------|------|------|-------------|
| Keep ADRs in the archive | No migration | ADRs stay lost to archive passes and numbers repeat | Fails the wanted outcome |
| One folder per component | Local ownership | Several counters, and the pack has one component | The chart chose one repo-wide folder |
| Shell-only migration | Matches older migrations | Hard to parse and rewrite references in Bash 3.2 | Node is already a pack dependency |

## Affected Components

| Component | Impact |
|-----------|--------|
| ravintio-zero | New `docs/adr/`, a new migration, and plan, ship, and ADR template edits |

## Consequences

**Positive:**
- A decision has one stable number and one file.
- Archive passes cannot lose an ADR.

**Negative:**
- The migration rewrites about 190 files and the diff is large.

**Risks:**
- A wrong rewrite breaks a supersession chain. The suite checks every reference.

## Related ADRs

- ADR-002 - related-to
- ADR-003 - related-to

## Supersedes

- None

## Superseded By

- None
