---
title: "Design - 0000355-codeql-and-branch-cleanup"
summary: "Confirmed design: CodeQL on PRs into initiative branches, a CI branch cleanup job, a workflow marker for the shape test, and incomplete escaping in the P3 checklist."
status: "confirmed"
---
# Design - 0000355-codeql-and-branch-cleanup

## Feature
- Problem: CodeQL scans only PRs into `main`, so a finding on a step PR shows up late. Merged head branches pile up on `origin`. A new workflow job fails `test-0000169-req-006` after P2. The P3 checklist misses incomplete escaping.
- Adoption mode: standard-iterative (signal: `plan/_archive/` and `docs/about.md`)
- Feature ID: 0000355-codeql-and-branch-cleanup
- Discovery: see `plan/current/discovery.md` (raw discovery findings. Do not embed them here. This document records confirmed decisions only)

## Product Layer
- User stories:
  - US-001: As a maintainer, I get a CodeQL scan on each PR into `main` or `initiative/**`, so that a finding appears on the step PR.
  - US-002: As a reviewer, I see incomplete escaping named in the P3 security checklist, so that a missed backslash is a finding.
  - US-003: As a pack maintainer, I add a CI job with a marker comment and edit no test, so that a new job does not fail the suite.
  - US-004: As a developer, I find a merged PR's head branch deleted by CI, so that I change no repo setting.
  - US-005: As a maintainer, I read entry 0000323 as true, so that it matches the repo.
- Acceptance criteria confirmed: 5
- Constraints: widens no guard. The cleanup job holds `contents: write` and no other job gains it. Every existing job skips the `closed` event. Prose follows the writing standard.
- Integrations: GitHub Actions and the GitHub API, through the workflow token

## Architecture Layer
- Latency target: deferred - recorded in scope (no runtime target)
- Availability target: deferred - recorded in scope
- Scalability target: deferred - recorded in scope
- Security: no auth strategy of its own. The workflow token authorises the cleanup job with `contents: write` on that job only. The job skips a head branch from a fork and never deletes `main` or `master`. It validates the branch name before it uses it. Data classification: none.
- Data privacy: no regulated data
- Observability: standard defaults. The job logs the branch it deletes or that it is already gone.
- Cost boundary: not constrained

## Engineering Layer
- Stack: YAML workflows, Bash tests, Markdown skills, Bash and PowerShell setup. Build target: ci-only.
- Components: `ravintio-zero` (hooks template, plan and validate skills, tests, setup if a separate workflow file is needed)
- Data ownership: none
- Deployment: files in the pack. The step triggers a `Setup:` stop afterwards because it changes skills and workflows.
- API versioning: not applicable

## Scope
- In: `.github/workflows/codeql.yml`, a `cleanup-branch` job in both copies of `ravintio.yml`, a marker comment read by `test-0000169-req-006`, the workflow cause in the plan skill's test impact scan, incomplete escaping in the P3 checklist, the edit to entry 0000323.
- Out: turning off default setup in repo settings, other items in entry 0000323, hook changes.
- Deferred: nothing deferred. If a human must turn default setup off before the merge, the step stops for the human.

## Assumptions
- Every existing job can skip `closed` through its `if` guard - impact if wrong: the cleanup moves to a separate workflow file that setup installs.
- The chart row for the separate-file fallback lets setup change - impact if wrong: the step stops.

## Risks
- A write-scoped job deletes the wrong branch. Likelihood low, impact high. Mitigation: skip forks, protect `main` and `master`, test the job text.
- A workflow-shape test breaks on the new job. Likelihood medium, impact low. Mitigation: the marker comment.
- Default CodeQL setup conflicts with the advanced workflow. Likelihood medium, impact medium. Mitigation: the step stops for the human before it merges.

## Dependencies
- Upstream: none
- Downstream: none
- Approved dependencies: none (initiative.md `## Dependencies`, steps 1-8: none)

## Active Skills
None

## Skill Map
| Requirement | Best-fit Skill | Rationale |
|-------------|----------------|-----------|
| REQ-001 - codeql workflow | ravintio-implement | Workflow file with a text test |
| REQ-002 - p3 escaping | ravintio-implement | One checklist line with a test |
| REQ-003 - workflow marker | ravintio-implement | Test and plan skill edit |
| REQ-004 - branch cleanup | ravintio-implement | Workflow job with a security review |
| REQ-005 - entry 0000323 | ravintio-implement | Documentation edit |

## Repo Instructions
- custom-001 local git only, custom-002 prefer subagent decomposition, custom-004 ship push and raise PR, custom-006 standing setup refresh approval. Files live in `ravintio-overrides/instructions/`.

## Confirmation
Human confirmed this design before proceeding: draft-accepted (initiative) // Date and Time confirmed: 06 Nov 2026 @ 02:40 AM UTC
