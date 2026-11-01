---
title: "Verification Report - 0000318-titled-coordinator-prs"
summary: "Each acceptance criterion, checked by running the tests and the guard."
---
# Verification Report - 0000318-titled-coordinator-prs

I ran the three step tests, ran the guard against a stub `gh`, and diffed the hook against the initiative branch.

| Criterion | Method | Outcome | Evidence |
|-----------|--------|---------|----------|
| REQ-001 AC-1: the standards state the rule | `test-0000318-req-001-002-coordinator-prs.sh` | verified | `roadmap-standards.md:338`. 18 passed. |
| REQ-001 AC-2: the old wording is gone | Same test, plus a grep of the standards and the skill | verified | No text tells the coordinator to commit on the initiative branch. |
| REQ-002 AC-1: the section names title, suite, CI, squash | Same test | verified | `roadmap-standards.md:336-348`. |
| REQ-002 AC-2: the carve-out names coordinator PRs | Same test | verified | `roadmap-standards.md:332`. `test-0000043-req-010` still passes, 45 of 45. |
| REQ-002 AC-3: the skill points to the section | Same test | verified | `ravintio-initiative/SKILL.md:94`. |
| REQ-003 AC-1: ship sets the PR number before the squash | `test-0000318-req-003-pr-number-before-squash.sh` | verified | `ravintio-ship/SKILL.md:191`. 3 passed. |
| REQ-003 AC-2: I-D Advance agrees | `test-0000318-req-001-002-coordinator-prs.sh` | verified | `roadmap-standards.md:366` precedes the squash at `:380`. |
| REQ-004 AC-1: a coordinator squash passes | `test-0000318-req-004-merge-guard-pinned.sh` with a stub `gh` | verified | Exit 0 for `gh pr merge 12 --squash --delete-branch` into `initiative/…`. |
| REQ-004 AC-2: blocked forms stay blocked | Same test | verified | Seven forms exit 2 with a `[RAVINTIO]` message. 16 passed. |
| REQ-004 AC-3: the hook is unchanged | `git diff` of `merge-guard.mjs` against the initiative branch | verified | Empty diff. |
| CI runs the new tests on the PR | Docs only. No CI run has observed it | unverified (docs only) | The first CI run on the step PR covers it. |
