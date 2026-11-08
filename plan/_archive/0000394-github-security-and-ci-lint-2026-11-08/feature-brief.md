---
title: "Feature Brief - GitHub security and CI lint"
summary: "The business case, scope, and product requirements for the feature."
status: "approved"
version: "0.1.0"
---
# Feature Brief - GitHub security and CI lint

**Feature ID:** 0000394-github-security-and-ci-lint

## Business Goal

The pack repo is public but uses few of the free GitHub security and repo features, and nothing lints its workflows. This step adds the committed security files, a workflow lint job, and a local brand guard. One checklist hands the admin-only settings to the human. Pulled in from backlog entries 0000323, 0000324, and 0000325.

## Features

| Feature | User Stories | Priority | Wave |
|---------|-------------|----------|------|
| Security and community files | As a maintainer, I find `SECURITY.md`, Dependabot config, templates, and `CODEOWNERS` in the repo, so that reporters and contributors have a route. | must-have | 1 |
| Pinned actions and supply-chain workflows | As a maintainer, I have every action pinned by SHA plus dependency review and Scorecard workflows, so that a tag move cannot change CI. | must-have | 1 |
| Workflow lint job | As a maintainer, I have CI run `actionlint` and `zizmor` on the workflows, so that a new unpinned action or risky pattern fails the PR. | must-have | 1 |
| Brand guard before push | As a pack contributor, I have `pre-push` run the brand guard with CI's allowlist, so that the old product name fails locally. | must-have | 1 |
| Settings checklist | As the repo admin, I get one checklist of settings to turn on and a check that they read on, so that nothing stays off unseen. | must-have | 1 |

## Waves

One wave. All features ship together.

## Target Architecture

### Components

| Component | Type | New or Existing | Responsibility |
|-----------|------|-----------------|---------------|
| ravintio-zero | component-pack | existing | Hooks, scripts, tests, and the repo's own CI files |

### Data Ownership

None. The pack holds no data store.

### Integration Points

| From | To | Method | Contract |
|------|-----|--------|----------|
| CI | GitHub Actions marketplace | `uses:` by SHA | Pinned actions only |
| Step session | GitHub API | `gh api` | Read settings after the human stop |

## Stack

| Concern | Decision |
|---------|----------|
| Language | Bash, Node.js |
| Testing | Bash suites under `ravintio-zero/tests/` |
| CI | GitHub Actions |
| Build target | local |

## Scope Boundaries

### In Scope
- `SECURITY.md`, `.github/dependabot.yml`, `CONTRIBUTING.md`, `CODE_OF_CONDUCT.md`, issue and PR templates, `CODEOWNERS`, `.github/release.yml`
- Pin every `actions/checkout@v4` and `github/codeql-action@v3` use by SHA
- Dependency review and Scorecard workflows
- A workflow lint job with `actionlint` and `zizmor`
- A shared brand guard allowlist read by `pre-push` and by `test-0000160-req-006`
- A human stop with a settings checklist, then a `gh api` check

### Out of Scope
- The agent's own GitHub account and the `Protect Main Branch` ruleset change
- Discussions and a required code scanning rule
- A required-check change to the ruleset (the checklist lists it for the human)

### Deferred
- Artifact attestations (`actions/attest-build-provenance`): `release-tag` publishes no artifact, so nothing exists to attest. Blocked until the job publishes one.

## Non-Functional Requirements

| NFR | Target | Measurement |
|-----|--------|-------------|
| Local brand guard time | under 5 seconds on a push that changes under 100 files | timed in the suite |
| Security | No workflow uses a floating tag for an action | suite greps `.github/workflows/` and `ravintio-zero/hooks/ravintio.yml` |

## Constraints and Assumptions

### Constraints
- Admin settings need repo admin rights. A step session cannot set them.
- `actionlint` and `zizmor` are not installed locally, so CI checks the lint job.

### Assumptions
- Action SHAs resolve through `gh api` at implementation time.

## Scenario Paths

**Happy path:** A contributor opens a PR. CI lints the workflows and passes. A push with the old name fails `pre-push` with file and line.

> A clean change passes every check and the settings read on.

**First-run path:** The first CI run of the lint job finds existing issues.

> Fix or record each existing finding before the job lands, so it starts green.

**Error / sad path:** A new workflow uses `actions/checkout@v4`.

> The pin suite and `zizmor` both fail the PR.

**Cross-session continuity:** The step stops for the human mid-run.

> The checklist and the stop line sit in the build log. The resumed session checks the settings with `gh api`.

## Acceptance Criteria

- [ ] The repo holds the security and community files named in scope.
- [ ] No workflow, and no workflow template, uses an action by floating tag.
- [ ] The lint job runs `actionlint` and `zizmor` on `.github/workflows/` and fails on any finding.
- [ ] A push of a file with the old product name exits non-zero and prints the file and line. A clean push passes.
- [ ] `pre-push` and `test-0000160-req-006` read one allowlist file.
- [ ] The step prints the settings checklist and, after the human acts, `gh api` reports each setting on.
