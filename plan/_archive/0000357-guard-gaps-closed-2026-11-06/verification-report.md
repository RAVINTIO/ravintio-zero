# Verification report - 0000357-guard-gaps-closed

Started nothing. The hooks run inside Claude Code and Codex. `setup.sh` ran in scratch projects, `setup.ps1` ran under `pwsh`, and `sh` ran each wired command with `CLAUDE_PROJECT_DIR` set.

| Criterion | Method | Outcome | Observation |
|-----------|--------|---------|-------------|
| With `guard-run.mjs` removed, each guard hook command exits 2 | CLI: `sh -c` on the eight wired commands, `test-0000357-req-001-fail-closed-launcher.sh` | verified | All eight exit 2. The merge guard command still exits 0 for an allowed call and 2 for a blocked one. |
| Advisory commands keep their form | Test: same suite | verified | The four advisory commands have no suffix. |
| `setup.ps1` writes the same suffix | CLI: `pwsh` ran the PowerShell hook suites, and a text test read `setup.ps1` | verified | `test-0000036`, `test-0000039`, `test-0000040`, `test-0000316`, and `test-0000207` pass under `pwsh`. |
| Each widened form is blocked | CLI: `block-forced-add.mjs` with 20 payloads, plus `/tmp/probe357.sh` | verified | `git stage -f`, a subshell, `$(...)`, a backtick, a brace group, three variable forms, and `git${IFS}add` exit 2. A plain add, a plain stage, and a commit message with `$` exit 0. |
| Existing forms stay blocked | Test: `test-0000317-req-002-block-forced-add.sh` | verified | 39 assertions pass. |
| Setup wires `block-forced-add` into Codex, in both setup scripts | CLI: `setup.sh codex` in a scratch project, and `pwsh` for `setup.ps1` | verified | One group for each guard. The wired forced-add command exits 2 for a forced stage. A rerun keeps one group each and a user group. |
| The report and the standard name the guard as active | Test: `test-0000357-req-003-forced-add-in-codex.sh` | verified | The setup report lists it under active hooks. `hook-enforcement.md` does too. |
| `ravintio-zero/.gitignore` and `.gitignore` hold the log rule | CLI: `git check-ignore` in a fresh repo with an empty exclude file | verified | Both files make `git check-ignore` print the path. |
| Every hook runs after a setup rerun | Human check at the `Setup:` stop | not-verifiable | The chart row for step 6 asks for a check after the setup rerun. The coordinator runs it. |
| Full suite and checks | CLI: `run-tests.sh`, `consistency-check.mjs` | see acceptance evidence | |
