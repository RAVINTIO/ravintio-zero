---
title: "Discovery - 0000466-version-files-completeness-check"
summary: "Raw discovery-pass findings: what the orchestrator knew before coaching began."
---
# Discovery - 0000466-version-files-completeness-check

## Header (all modes)

| Field | Value |
|-------|-------|
| Adoption mode detected | `standard-iterative` |
| Detection signal | `plan/_archive/` beside source in `src/` and `ravintio-zero/` |
| Git pre-flight | `feat/0000466-version-files-completeness-check`, cut by the driver from the initiative branch. Initiative step, so no human confirmation. |
| Skills inbox | empty |
| Track | `light` |

## Mode Findings

### Standard Iterative

- Current version (`product.yml`, `docs/about.md`): `0.87.0`. Step 37 applies `minor` at merge. The merge queue writes the version.
- Prior features (`plan/_archive/`): 0000420 added optional entries to `version-files.txt`. 0000378 added `version-files.mjs`.
- Constraining ADRs: none for this change.
- Component map: one component, `ravintio-zero`, with a source copy at `src/ravintio-zero/`.
- Version-carrying files at 0.87.0: `docs/about.md`, `product.yml`, `ravintio-zero/component.yml`, `src/ravintio-zero/component.yml`. The list names all four today.
- Backlog entry 0000433: no test ties `ravintio-zero/version-files.txt` to the real version-carrying files.
- Pending migration 0009 (ADRs in `docs/adr`): interactive, needs a human answer. Left pending.
- Repo instructions: `ravintio-overrides/instructions/` holds five files (git permissions, subagent decomposition, ship push, setup refresh).
