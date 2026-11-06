# Verification report - 0000352-coordinator-admin-in-step-prs

Started nothing. The script and the suites run from a shell.

| Criterion | Method | Outcome | Observation |
|-----------|--------|---------|-------------|
| `reserve-id.mjs --commit` on `initiative/*` exits non-zero, commits nothing, names `feat/` | CLI: a scratch repo on `initiative/0000999-demo`, then `reserve-id.mjs --commit` | verified | Exit 1. The message names `feat/`. The counter file still held `0000100` and the repo kept one commit. |
| A run without `--commit` still reserves on `initiative/*` | CLI: same repo, `reserve-id.mjs` | verified | Exit 0, printed `0000100`. |
| `--commit` on a `feat/` branch still commits the counter file alone | CLI: `test-0000352-req-001-reserve-id-refusal.sh` | verified | 12 assertions pass, including the commit subject. |
| Every coordinator squash command names `--delete-branch` | Text check: `test-0000352-req-002-004-standards-rules.sh` | verified | The Coordinator PRs section and the initiative skill hold `gh pr merge --squash --delete-branch {n}`. No command line in the skills or standards omits the flag. |
| Standards state the item contract, both routes, and the step rule | Same suite | verified | 16 assertions pass. |
| Skills state the queue rule and the `feat/` route, and stay under their caps | `test-0000352-req-003-005-skill-rules.sh` | verified | 16 assertions pass. The initiative skill holds 118 lines. |
| Consistency check | CLI: `consistency-check.mjs` | verified | Prints `clean`. |
