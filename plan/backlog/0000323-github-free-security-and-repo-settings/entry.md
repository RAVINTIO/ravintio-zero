---
title: "Backlog Entry: 0000323 - turn on the free GitHub security and repo features"
summary: "A discovered-but-out-of-scope item deferred for pickup at a future discovery run."
status: "open"
priority: "medium"
theme: "unsorted"
---
# Backlog Entry: 0000323 - turn on the free GitHub security and repo features

**Source feature:** none (human request)
**Source phase:** none (human request)
**Deferral source:** human request
**Date filed:** 2026-10-31

---

## Problem

`RAVINTIO/ravintio-zero` is a public repo owned by an organisation. GitHub gives public repos a set of security and workflow features at no cost. Most of them are off. The state on 2026-10-31 was as follows.

| Feature | State |
|---------|-------|
| Secret scanning | off |
| Secret scanning push protection | off |
| Dependabot alerts | on |
| Dependabot security updates | off |
| Dependabot version updates (`.github/dependabot.yml`) | absent |
| Code scanning (CodeQL default setup) | not configured |
| Private vulnerability reporting | off |
| `SECURITY.md` | absent |
| Branch protection or ruleset on `main` | done (see the ruleset section) |
| Delete head branches after a PR lands | off |
| Repo topics | none |
| `CONTRIBUTING.md`, `CODE_OF_CONDUCT.md`, issue and PR templates | absent |
| `CODEOWNERS` | absent |

`.github/workflows/ravintio.yml` pins `actions/checkout` by SHA in three jobs. Two jobs (lines 18 and 53) still use the `@v4` tag.

## Ruleset on `main`

The human added the ruleset `Protect Main Branch` (id `26272513`) on 2026-10-31. It is active on the default branch only, so the agent's squash into `initiative/*` still works. It holds these settings:

| Setting | Value |
|---------|-------|
| Bypass | Organization admin, for pull requests only |
| Restrict deletions | on |
| Block force pushes | on |
| Require a pull request | on, merge commits only |
| Required approvals | `1` |
| Require conversation resolution | on |
| Required status checks | `bash-suites`, `windows-powershell (powershell)`, `windows-powershell (pwsh)`, `validate-branch`, `self-description-check` |

The bypass covers PRs only, so no account can push to `main` directly. If the human needs a force push to `main`, they set the ruleset to **Disabled**, push, then set it back to **Active**.

Required approvals stays at `1` by the human's decision. The agent moves to its own GitHub account with fewer permissions. The human then approves the agent's PRs as a second person, and the status checks stay binding. A PR the human authors still needs the admin bypass, which also skips the checks.

## Suggested Action

Split the work into settings changes and committed files. A human applies the settings because they need admin rights.

Security settings:

- Turn on secret scanning and push protection.
- Turn on Dependabot security updates.
- Turn on CodeQL default setup for JavaScript and GitHub Actions. Copilot Autofix for code scanning alerts is free on public repos.
- Turn on private vulnerability reporting. Security advisories and CVE requests then work from the **Security** tab.

Repo settings:

- Create a GitHub account for the agent with the **Write** role on this repo. Point the agent's `gh` and `git` credentials at it.
- After CodeQL runs, add **Require code scanning results** to the ruleset.
- Turn on **Automatically delete head branches**.
- Add topics, and consider turning on Discussions.

Committed files:

- `SECURITY.md` with the reporting route.
- `.github/dependabot.yml` for the `github-actions` ecosystem, and `npm` if the pack gains a lockfile.
- Pin the two `actions/checkout@v4` uses by SHA.
- A dependency review workflow (`actions/dependency-review-action`) and the OpenSSF Scorecard workflow (`ossf/scorecard-action`). Both are free on public repos.
- Artifact attestations (`actions/attest-build-provenance`) for the `release-tag` job, if it publishes an artifact.
- `CONTRIBUTING.md`, `CODE_OF_CONDUCT.md`, issue templates, a PR template, `CODEOWNERS`, and `.github/release.yml` for generated release notes.

## Why Deferred

The human filed it on request. Each settings change needs repo admin rights.
