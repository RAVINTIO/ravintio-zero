---
title: "Acceptance Evidence - 0000316-hooks-fail-closed"
summary: "Checks, security, and execution evidence for the step."
---
# Acceptance Evidence - 0000316-hooks-fail-closed

## Checks

- Full suite with `RAVINTIO_INITIATIVE_STEP=1` set: 234 feature suites passed, 0 failed. Regression: 19 of 19. The runner reported no changed tracked or untracked file.
- Self-corrections: 3. Run 1 failed 5 feature suites and 4 regression suites that checked the old relative command form. I updated them to the launcher form with the same checks. Run 3 failed `test-0000035-p5-security-fixes` on an unescaped `${CLAUDE_PROJECT_DIR}` in the test.

## Security

- No critical or high finding. Overall risk: low. One medium finding: a missing launcher still exits 1. See `plan/current/security-report.md`.

## Execution evidence

- Setup in a scratch project wrote `env` with `CLAUDE_BASH_MAINTAIN_PROJECT_WORKING_DIR` set to `1` and the launcher commands.
- A squash merge with `--admin`, run through the launcher from a subfolder, exited 2 with the `merge-guard` message.
- With `merge-guard.mjs` deleted, the wired command exited 2 and named the script.
- `${CLAUDE_PROJECT_DIR}` substitution by a live Claude Code session is `unverified (docs only)`. The setup rerun check after this step covers it.
