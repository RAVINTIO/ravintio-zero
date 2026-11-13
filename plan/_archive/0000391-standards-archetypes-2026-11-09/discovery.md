---
title: "Discovery - 0000391-standards-archetypes"
summary: "Raw discovery-pass findings: what the orchestrator knew before coaching began."
---
# Discovery - 0000391-standards-archetypes

## Header (all modes)

| Field | Value |
|-------|-------|
| Adoption mode detected | `standard-iterative` |
| Detection signal | `plan/_archive/` holds prior runs and the pack source has a `docs/about.md` |
| Git pre-flight | `feat/0000391-standards-archetypes`, cut by the initiative driver in worktree step-15 |
| Skills inbox | empty |
| Track | `full` |

## Mode Findings

### Standard Iterative

- Current version (`product.yml`): `0.73.0`. Step bump is minor. The merge queue sets the released version.
- Prior features: see `plan/_archive/`. Step 14 (0000390) added prose checks. Step 13 (0000389) added the writing standard and output style.
- Constraining ADRs: `docs/adr/`.
- Component map: one component, `ravintio-zero`.
- Repo instructions: four files in `ravintio-overrides/instructions/`.
- Override areas today: `instructions`, `capability-skills`, `library-standards`. Only `library-standards` is override-first.
- Backlog entry for this step: 0000305.
- Queue item `ci-gate-step-15` applies.
- Chart row for dependencies: Kind `library`. The strict-testing archetype names Pact, Stryker or PIT, and Playwright MCP. The pack installs none.
- Chart decision: the resolver ignores any override of a rule a hook enforces, and a test proves it. Otherwise stop.
