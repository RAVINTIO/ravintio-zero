# Changelog (0000327-squash-before-main, 1 Nov 2026)

**Feature:** Squash before main
**Version:** 0.48.0
**PR:** #98

## What changed

- `ravintio-zero/scripts/check-pr-into-main.mjs` checks a PR into `main`. It passes an `initiative/*` PR, passes a `chore/*` or `hotfix/*` PR with one commit, and fails everything else. A `--base` or `--head` value that starts with a dash exits 2.
- CI runs the check in a job named `squash-before-main` on every PR into `main`, in `.github/workflows/ravintio.yml` and in the pack copy `ravintio-zero/hooks/ravintio.yml`.
- The ship skill gains `## PRs into main`. A `chore/*` branch is squashed in place and pushed with `git push --force-with-lease`. A `hotfix/*` branch gets a replacement PR and no force-push. The agent waits for green CI before it asks for the merge. The text forbids plain `--force`.
- `roadmap-standards.md` and `docs/main-ruleset.md` name `initiative/*`, `chore/*`, and `hotfix/*` as the only branches that may target `main`. The ruleset doc asks the human to require `squash-before-main`.
- Discovery Start Actions step 2 offers `git checkout -b hotfix/{feature-id}` in place of `feat/`.
- Backlog entry 0000326 is pulled in and deleted. Four new suites cover the five requirements.

## Why

`main` takes merge commits only, so a chore branch with several commits added each commit to the history of `main`. PR #73 showed it. Backlog entry 0000326 asked for one titled commit per chore or hotfix, and a check that catches a PR that breaks the rule.

## Deviations

- `CLAUDE.md` and `ravintio-overrides/instructions/custom-001-local-git-only.md` still say "Work on a feat/ branch". The human owns both files, and no setup source writes that sentence. The chart row for a generated `CLAUDE.md` found nothing to change.
- The step 2 change broke `test-0000151-req-011-orchestrator-references-split.sh` against its frozen fixture. The test gained one rule for the `feat/` to `hotfix/` change. The fixture is unchanged.
- `test-0000169-req-006-release-tag-ci-and-ship-flow.sh` now lets the new pull-request job carry its own `if` condition.
- The security review led to three fixes in the same run: a dash-prefix guard, the required-check note, and the no-plain-`--force` line.

## Validation results

- The full suite passes: 259 feature suites and 19 regression suites. The consistency check is clean.
- Execution checks of the script on six branches verified 9 criteria. 1 is `not-verifiable`: the CI job runs only on a PR into `main`, and this step's PR targets an initiative branch.
- No critical or high security finding. See the archived `security-report.md`.

## Skipped phases

None
