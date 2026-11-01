---
title: "Main ruleset"
summary: "The GitHub ruleset on main that allows only the merge commit method."
status: "active"
version: "0.45.0"
---
# Main ruleset

The `main` branch accepts only the merge commit method. A squash merge into `main` drops the step tags from reachable history.

## Ruleset

Create a GitHub ruleset that targets `main`. In its pull request rule, set the allowed merge methods to **Merge** only.

| Branch | Allowed merge methods |
|--------|-----------------------|
| `main` | merge commit |
| `initiative/**` | squash stays allowed |

Coordinator and feature PRs land on `initiative/**` branches by squash. Do not apply the merge commit rule to those branches.

## Branches that may target main

Only `initiative/*`, `chore/*`, and `hotfix/*` branches may target `main`. A `feat/*` branch never targets `main` and lands on an initiative branch instead. The CI job `squash-before-main` fails any other PR into `main`. It also fails a `chore/*` or `hotfix/*` PR with more than one commit. The agent never merges a PR into `main`.

## Who applies it

The human applies the ruleset in the repository settings under **Rules**. The agent never changes repository settings.
