---
title: "Discovery - 0000378-merge-time-versioning"
summary: "Raw discovery-pass findings: what the orchestrator knew before coaching began."
---
# Discovery - 0000378-merge-time-versioning

## Header (all modes)

| Field | Value |
|-------|-------|
| Adoption mode detected | `standard-iterative` |
| Detection signal | `plan/_archive/` holds prior features and `docs/about.md` holds version 0.57.0 |
| Git pre-flight | `feat/0000378-merge-time-versioning`, cut from `initiative/0000360-backlog-sweep` (I-C Run) |
| Skills inbox | `ravintio-zero/skills-inbox/` holds only `capability-skills/`, no `SKILL.md` to process |

## Mode Findings

### Standard Iterative

- Current version (`docs/about.md`): `0.57.0`. Step 2 applies a minor bump to `0.58.0`.
- Prior features (`plan/_archive/`): latest is `0000377-driver-stops-and-headroom` (2026-11-07).
- Constraining ADRs: none read for this step.
- Component map: one component, `ravintio-zero`. `product.yml` policy is `max-component-version`.
- Repo instructions (`ravintio-overrides/instructions/`): custom-001 (local git), custom-002 (subagent decomposition), custom-004 (ship push and PR), custom-006 (setup refresh approval).
- Backlog entries for this step: 0000374, 0000376, 0000372, 0000368.
- Migrations: 0004 and 0005 stay pending because their `Applies when` conditions are false in the pack source.
- Initiative decisions for this step: steps 1 and 2 keep today's P4 bump. The PR title check (0000372) runs in the merge queue before each merge. The merge queue checks every version file after a bump and stops on a difference (0000368).
