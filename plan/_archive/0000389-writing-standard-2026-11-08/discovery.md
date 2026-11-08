---
title: "Discovery - 0000389-writing-standard"
summary: "Raw discovery-pass findings: what the orchestrator knew before coaching began."
---
# Discovery - 0000389-writing-standard

## Header (all modes)

| Field | Value |
|-------|-------|
| Adoption mode detected | `standard-iterative` |
| Detection signal | `plan/_archive/` holds prior runs and `docs/about.md` reads 0.60.0 |
| Git pre-flight | `feat/0000389-writing-standard`, cut by the driver from `initiative/0000360-backlog-sweep` (I-C Run) |
| Skills inbox | empty |

## Mode Findings

### Standard Iterative

- Current version (`docs/about.md`): `0.60.0`
- Prior features (`plan/_archive/`): latest is 0000380-test-helpers-and-rule-anchors (2026-11-07)
- Constraining ADRs (unless superseded): none read for this step
- Component / data-ownership map (`docs/`): one component, `ravintio-zero`, which owns every pack file

## Step inputs

- Backlog entry 0000300: ship a writing standard and install it for each tool
- Repo instructions: `ravintio-overrides/instructions/` holds four files, recorded in `design.md`
- Chart rows: Decisions rows for step 13 allow a `--no-writing-style` flag and a change to the `em-dash-guard.mjs` suggestion
- Bump: minor
- Past retrospectives: not read for this step
- Known conflicts: `formatting-standards.md` requires `DD MMM YYYY` dates and offers a semicolon in place of an em dash
