# Changelog (0000393-session-integrity-and-guards, 09 Nov 2026)

**Feature:** Session integrity and guards
**Version:** set by the merge queue at merge
**PR:** pending

## What changed

- `gate-write` reads Bash redirects, `tee`, and `sed -i`, and applies its path checks to each target. Setup wires it on the Bash matcher (0000271).
- `block-forced-add` skips the value after `--git-dir`, `--work-tree`, `--namespace`, and three more git options. It blocks a git add or stage command that holds a brace group (0000367).
- `resume-detect.mjs` compares the pack version with `plan/state/pack-version.md`, never with `docs/about.md`. The policy and the `about.md` template say the file holds the product version only (0000272).
- `check-entry-wording.mjs` runs in the filing skill and flags lines that the pack wording tests reject (0000260).

## Why

Heredoc writes skipped the design gate, two forced-add forms passed the guard, every consumer repo showed a false pack version finding, and a bad backlog entry stopped a step at P2.

## Deviations

- The forced-add brace check blocks only when the git subcommand is add or stage, and ignores `${`. This keeps commit messages that name `$VAR` working.
- A missing pack record raises no finding. This keeps the pack source repo quiet.
- Several tests that pin the hook entry list or count moved by one for the new Bash entry. No assertion was weakened.
- `test-0000151-req-011` gained a rewrite step for the changed check 2 line.

## Validation results

- Full Bash suite: 328 feature suites and 19 regression suites passed.
- PowerShell suites were edited by hand and not run here. The Windows CI job runs them.

## Skipped phases

None
