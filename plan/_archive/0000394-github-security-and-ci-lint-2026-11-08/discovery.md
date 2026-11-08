---
title: "Discovery - 0000394-github-security-and-ci-lint"
summary: "Raw discovery-pass findings: what the orchestrator knew before coaching began."
---
# Discovery - 0000394-github-security-and-ci-lint

## Header (all modes)

| Field | Value |
|-------|-------|
| Adoption mode detected | `standard-iterative` |
| Detection signal | `plan/_archive/` holds prior features and `docs/about.md` holds a version |
| Git pre-flight | `feat/0000394-github-security-and-ci-lint`, cut by the driver from `initiative/0000360-backlog-sweep` |
| Skills inbox | empty |

## Mode Findings

### Standard Iterative

- Current version (`product.yml`): `0.60.0`
- Prior features (`plan/_archive/`): steps 1 to 4 of this initiative, merged as v0.57.0 to v0.60.0
- Constraining ADRs: none read for this step
- Component / data-ownership map: one component, `ravintio-zero`, no data store
- Repo instructions (`ravintio-overrides/instructions/`): local git only, prefer subagent decomposition, push and raise the PR at ship, standing setup refresh approval
- Queue items for step 18: none
- Tools on this machine: `gh` is logged in. `actionlint`, `zizmor`, and `shellcheck` are not installed, so the workflow lint criterion belongs to CI.
- Workflow state: `.github/workflows/ravintio.yml` pins `actions/checkout` by SHA in five jobs and uses `@v4` in two. `.github/workflows/codeql.yml` uses `github/codeql-action@v3` tags.
