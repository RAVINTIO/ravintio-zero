---
title: "Verification report - 0000394-github-security-and-ci-lint"
summary: "What the step ran and observed for each acceptance criterion."
---
# Verification report - 0000394-github-security-and-ci-lint

The step started nothing long-lived. It ran each script and linter from the worktree, with `actionlint` 1.7.12 and `zizmor` 1.32.0 installed under `/tmp`.

| Requirement | Criterion | Method | Outcome | Observation |
|-------------|-----------|--------|---------|-------------|
| REQ-001 | AC-1 files present | `test-0000394-req-001-community-files.sh` | verified | 13 passed, 0 failed |
| REQ-001 | AC-2 Dependabot covers workflows | same suite | verified | `package-ecosystem: "github-actions"` found |
| REQ-002 | AC-1 no floating tag | `test-0000394-req-002-pinned-actions.sh` | verified | every `uses:` line ends in a 40-character SHA |
| REQ-002 | AC-2 new workflows exist | same suite | verified | both parse, guard or marker present |
| REQ-003 | AC-1 job runs both tools | same suite | verified | `workflow-lint` runs `actionlint` and `zizmor` |
| REQ-003 | AC-2 workflows pass the linters | `actionlint .github/workflows/*.yml` and `zizmor --no-online-audits .github/workflows` | verified | exit 0 and "No findings to report" |
| REQ-003 | The job passes in CI | CI run on the step PR | not-verifiable | Runs after the PR opens. The chart marks it `CI`. |
| REQ-004 | AC-1 old name fails | scratch repo, `pre-push` | verified | exit 1, output `docs/note.md:2` |
| REQ-004 | AC-2 clean push passes | scratch repo, `pre-push` | verified | exit 0 |
| REQ-004 | AC-3 one allowlist | source checks in the suite | verified | hook, script, and CI test name `brand-guard-allowlist.txt` |
| REQ-004 | NFR-001 under 5 seconds | 100-file push in the suite | verified | under 5 seconds |
| REQ-005 | AC-1 checklist lists every item | `github-settings.mjs list` | verified | six items printed |
| REQ-005 | AC-2 check reports state | stub `gh` suite, then the real `check` | verified | stub: 12 passed. Real: exit 1, four items off |
| REQ-005 | Each setting reads on through `gh api` | real `github-settings.mjs check` | failed until the human acts | `on`: dependabot-security-updates, private-vulnerability-reporting. `off`: secret-scanning, push-protection, topics, workflow-lint-required |

Full suite: 305 feature suites and 19 regression suites passed on a clean tree.
