---
title: "Discovery - 0000395-pack-prose-to-the-standard"
summary: "Raw discovery-pass findings for step 19: the state of the pack's prose breaches."
---
# Discovery - 0000395-pack-prose-to-the-standard

> Raw findings only. Decisions belong in `design.md`.

## Header (all modes)

| Field | Value |
|-------|-------|
| Adoption mode detected | `standard-iterative` |
| Detection signal | `plan/_archive/` holds prior runs and the pack source sits beside it |
| Git pre-flight | `feat/0000395-pack-prose-to-the-standard`, cut from the initiative branch by the driver |
| Skills inbox | empty |
| Track | full |

## Mode Findings

### Standard Iterative

- Current version (`docs/about.md`): `0.74.0`
- Prior features (`plan/_archive/`): 0000390-prose-checks added the linter and the per-file baseline in `plan/state/prose-baseline.json`. 0000389-writing-standard added the standard. 0000391-standards-archetypes added archetypes.
- Constraining ADRs: ADR-0285, ADR-0288, and ADR-0289 define the prose rules, the baseline, and the scope.
- Component map: one component, `ravintio-zero`, with the pack source in `ravintio-zero/`.

## Prose breach findings

- The baseline holds 376 files and 2,312 breaches.
- Counts by rule: passive 952, sentence-length 593, em-dash 503, semicolon 265, blocklist 99.
- The linter skips inline code, fenced code, tables, front matter, and HTML comments.
- A banned word in code font passes. `writing-standards.md` lists the banned words in plain text, so it holds 36 blocklist breaches.
- About 100 files are ADRs under `docs/adr/`. They hold roughly half the breaches.
- The linter scope skips `plan/_archive/`, `ravintio-zero/tests/`, `CLAUDE.md`, and `AGENTS.md`.
- Tests under `ravintio-zero/tests/` pin some wording. The `<!-- rule: {id} -->` anchors from step 4 hold most pins.

## Repo instructions

None in `ravintio-overrides/instructions/` beyond the standing overrides.
