---
title: "Design - 0000394-github-security-and-ci-lint"
summary: "Security files, pinned actions, a workflow lint job, and a local brand guard for the pack repo."
---
# Design - 0000394-github-security-and-ci-lint

## Feature
- Problem: The public pack repo leaves free GitHub security features unused, never lints its workflows, and finds brand-name slips only in CI.
- Adoption mode: standard-iterative
- Feature ID: 0000394-github-security-and-ci-lint
- Discovery: see `plan/current/discovery.md`

## Product Layer
- User stories:
  - US-001: As a maintainer, I find the security and community files in the repo, so that reporters and contributors have a route.
  - US-002: As a maintainer, I have every action pinned by SHA with dependency review and Scorecard workflows, so that a moved tag cannot change CI.
  - US-003: As a maintainer, I have CI lint the workflows with `actionlint` and `zizmor`, so that a risky workflow change fails the PR.
  - US-004: As a pack contributor, I have `pre-push` run the brand guard with CI's allowlist, so that the old name fails before CI.
  - US-005: As the repo admin, I get one settings checklist and a `gh api` check, so that no setting stays off unseen.
- Acceptance criteria confirmed: 6
- Constraints: admin settings need a human, `actionlint` and `zizmor` are absent locally, Bash 3.2
- Integrations: GitHub Actions, `gh api`

## Architecture Layer
- Latency target: the local brand guard finishes in under 5 seconds on a push of under 100 files
- Availability target: deferred - recorded in scope
- Scalability target: deferred - recorded in scope
- Security: no auth and no data. The workflows keep least-privilege `permissions`. Third-party actions are pinned by SHA.
- Data privacy: no regulated data
- Observability: standard defaults
- Cost boundary: free GitHub features only

## Engineering Layer
- Stack: Bash, Node.js, GitHub Actions, build target local
- Components: `ravintio-zero` - hooks, scripts, tests, and `.github/`
- Data ownership: none
- Deployment: none
- API versioning: not applicable

## Component Paths
- `ravintio-zero/`
- `.github/`

## Scope
- In: community and security files, SHA pins, dependency review and Scorecard workflows, the lint job, the shared brand guard allowlist and `pre-push` check, the settings checklist
- Out: the agent's GitHub account, ruleset edits, Discussions
- Deferred: artifact attestations, because `release-tag` publishes no artifact

## Assumptions
- Action SHAs resolve through `gh api` - impact if wrong: the step stops with the failing action named.
- `product.yml` `id` is `ravintio-zero` only in the pack source - impact if wrong: the guard runs in a consumer repo and flags its files.

## Risks
- `zizmor` or `actionlint` flags an existing workflow in CI only (medium likelihood, medium impact). Mitigation: fix the likely findings first and allow `CI` fix commits under `**Step CI fixes:** allowed`.
- The shared allowlist drifts from the test (low, medium). Mitigation: the test reads the file and keeps its stale-entry check.

## Dependencies
- Upstream: step 4 rule anchors
- Downstream: step 19 reads the touched pack prose
- Approved dependencies: `actions/dependency-review-action`, `ossf/scorecard-action`, `actions/attest-build-provenance` (library, deferred), Dependabot, GitHub secret scanning and push protection, private vulnerability reporting (service), `actionlint`, `zizmor` (library). Copied from the step 18 rows of `initiative.md`.

## Active Skills
None

## Skill Map
| Requirement | Best-fit Skill | Rationale |
|-------------|----------------|-----------|
| REQ-001 - community and security files | ravintio-implement | Files with a presence suite |
| REQ-002 - pinned actions and supply-chain workflows | ravintio-implement | Workflow edits with a pin suite |
| REQ-003 - workflow lint job | ravintio-implement | CI job with a suite |
| REQ-004 - brand guard before push | ravintio-implement | Hook change with a shared allowlist |
| REQ-005 - settings checklist | ravintio-implement | Human stop and `gh api` check |

## Repo Instructions
Local git only, prefer subagent decomposition, push and raise the PR at ship, standing setup refresh approval (`ravintio-overrides/instructions/`).

## Confirmation
Human confirmed this design before proceeding: yes (draft-accepted (initiative)) // Date and Time confirmed: 08 Nov 2026 @ 01:10 AM UTC
