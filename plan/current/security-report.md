# Security report - 0000327-squash-before-main

**Feature:** 0000327-squash-before-main
**Version:** 0.48.0

## Summary

**Overall risk assessment:** low
**Components reviewed:** `ravintio-zero/scripts/check-pr-into-main.mjs`, the `squash-before-main` job in `.github/workflows/ravintio.yml` and `ravintio-zero/hooks/ravintio.yml`, the ship skill section `## PRs into main`, `ravintio-zero/standards/roadmap-standards.md`, `ravintio-zero/docs/main-ruleset.md`, and the new tests
**Review scope:** code review and hostile-input runs

A reviewer subagent ran the script against throwaway repositories in temporary folders outside this repo. It found no injection, traversal, or credential path. It found no critical or high finding. The job runs on `pull_request` with a read-only token, a pinned checkout, no persisted credentials, and the head ref only in `env`.

## Findings

| ID | Severity | Category | Component | Description | Recommendation | Status |
|----|----------|----------|-----------|-------------|----------------|--------|
| S-001 | medium | policy bypass by name | `check-pr-into-main.mjs:30-33` | Any head ref that starts `initiative/` passes before a git call. The name is the only gate. | The human limits who creates `initiative/**` and reviews every PR into `main`. | accepted (R-006) |
| S-002 | medium | policy bypass by edit | `.github/workflows/ravintio.yml:146-159` | A PR runs the script from its own checkout and can edit it. This is inherent to `pull_request`. | The human merge gate and a required check. | accepted (R-006) |
| S-003 | medium | wrong ref counted | `check-pr-into-main.mjs:35-44` | `--head-ref` and `--head` are independent. A fork PR could count a same-named base-repo branch. A missing ref exits 2. | Count `base.sha..head.sha` in a later change. | accepted (R-007) |
| S-004 | low | argument injection | `check-pr-into-main.mjs:39-43` | A `--base` or `--head` value that starts with a dash reached `git rev-list` as an option. | The script now exits 2 on such a value, and two tests cover it. | fixed |
| S-005 | medium | advisory check | `ravintio-zero/docs/main-ruleset.md` | The docs did not ask for `squash-before-main` as a required check. | The doc now asks the human to require it. The human applies it. | mitigated (R-008) |
| S-006 | medium | branch steering | `orchestrator-p0-start-actions.md:10` | Step 2 offers `hotfix/{feature-id}` for every run outside an initiative. | Chart decision for step 10. Flagged for the human. | accepted (R-009) |
| S-007 | low | force-push wording | `ravintio-ship/SKILL.md` (`## PRs into main`) | The text limited `--force-with-lease` but did not forbid plain `--force`. | The section now says "Never use plain `--force`". | fixed |
| S-008 | low | prefix match | `check-pr-into-main.mjs:35` | `chore/../x` passes the prefix. The commit count still has to equal 1. | None needed. | accepted |
| S-009 | low | duplicate flags | `check-pr-into-main.mjs:17-24` | A repeated flag overrides the earlier one. CI arguments are fixed. | None needed. | accepted |

## Risk register cross-check

R-001 to R-005 hold. The review added R-006 to R-009.
