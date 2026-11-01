# Changelog (0000319-initiative-history-checks, 1 Nov 2026)

**Feature:** Initiative history checks
**Version:** 0.45.0
**PR:**

## What changed

- `check-initiative-history.mjs` lists the first-parent commits of an initiative branch and fails on an untitled one. It has no exception list.
- `check-main-merge.mjs` fails a one-parent commit that came from an initiative PR.
- Both workflow copies add the `initiative-history` and `main-merge-check` jobs, run on a push to `initiative/**`, and limit `release-tag` to `main` and `master`.
- I-E Delivery runs the history script, lists failing commits in the PR body, and asks for a merge commit in the title and body.
- `ravintio-zero/docs/main-ruleset.md` names the ruleset that allows only the merge commit method on `main`.
- Four new suites cover the scripts, the jobs, the delivery text, and the doc. The release-tag suite pins the new trigger.

## Why

A direct commit on an initiative branch skips CI and breaks the titled history. A squash of an initiative PR into `main` loses that history. Backlog entries 0000275, 0000277, and 0000278 asked for the checks.

## Deviations

`README.md` gained a row for `ravintio-zero/docs/` because the self-description check requires it.

## Validation results

- The full suite passes and the consistency and self-description checks are clean.
- Execution checks of both scripts passed: titled, empty, untitled, and missing-ref cases for the history script, and squash and ordinary commits for the main check.
- The security review found no critical or high findings.
- Two criteria rest on documentation alone: the delivery step and the ruleset doc. The two new CI jobs run for the first time on this PR.

## Skipped phases

None
