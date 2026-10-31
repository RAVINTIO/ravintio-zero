---
title: "Verification Report - 0000317-block-forced-adds"
summary: "Each acceptance criterion, run against the hook and a scratch project."
---
# Verification Report - 0000317-block-forced-adds

I ran the hook with real payloads, ran setup twice in a scratch project, and ran the check command in this repo.

| Criterion | Method | Outcome | Evidence |
|-----------|--------|---------|----------|
| The hook blocks `git add -f plan` and `git add --force plan` | Piped a Bash payload into `block-forced-add.mjs` | verified | Both exit 2 with the rule message. |
| The hook blocks `git add -fA plan` and `git -C plan add -f x` | Same | verified | Both exit 2. |
| The hook allows `git add plan/current` | Same | verified | Exit 0. |
| `.gitignore` lists the three driver paths | `git check-ignore` in a scratch repo with an empty `.git/info/exclude` | verified | Each path ignored, in `test-0000317-req-001-003-004-rules-ignores-checks.sh`. |
| The CI check fails a branch with a committed ignored file | Force-added an ignored file in a scratch repo and ran `git ls-files -ci --exclude-standard` | verified | The command listed the file. A clean tree listed nothing. This repo lists nothing. |
| `setup.ps1` wires the same hook | Ran the `pwsh` suites that read the entry list | verified | 14, 37, 35, and 155 passed. |
| The GitHub Actions step runs in CI | Docs only. The workflow YAML parses, but no run observed it | unverified (docs only) | The first CI run on this PR covers it. |
| A live Claude Code session runs the new hook | Docs only | unverified (docs only) | The setup rerun check after this step runs every hook. |
