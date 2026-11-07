---
title: "Discovery - 0000383-test-impact-scan"
summary: "Raw discovery-pass findings: what the orchestrator knew before coaching began."
---
# Discovery - 0000383-test-impact-scan

## Header (all modes)

| Field | Value |
|-------|-------|
| Adoption mode detected | `standard-iterative` |
| Detection signal | `plan/_archive/` holds prior features and `product.yml` holds a version |
| Git pre-flight | `feat/0000383-test-impact-scan`, cut by the driver from `initiative/0000360-backlog-sweep` |
| Skills inbox | empty |

## Mode Findings

### Standard Iterative

- Current version (`product.yml`): `0.60.0`
- Prior features (`plan/_archive/`): steps 1 to 4 of this initiative, merged as v0.57.0 to v0.60.0
- Constraining ADRs: none read for this step
- Component / data-ownership map: one component, `ravintio-zero`, no data store
- Repo instructions (`ravintio-overrides/instructions/`): local git only, prefer subagent decomposition, push and raise the PR at ship, standing setup refresh approval
- Plan skill: `ravintio-zero/skills/ravintio-plan/SKILL.md`, 178 lines. Skill text totals 1608 lines against a cap of 1720.
- Existing scan test: `test-0000246-req-001-test-impact-scan.sh` caps the scan at 15 non-blank lines.
- Skill text is `ravintio-zero/skills/`. `.claude/skills/` is the git-ignored installed copy.
