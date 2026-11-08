# Verification report - 0000389-writing-standard

Each check ran in a fresh temporary git repo with a copy of `ravintio-zero/`. Bash used `setup.sh`. PowerShell used `pwsh` from `/opt/homebrew/bin`.

| Criterion | Method | Outcome | Observation |
|-----------|--------|---------|-------------|
| req-001 AC-1 | `test-0000389-req-001-002-standard.sh` | verified | Both regions hold text |
| req-001 AC-2 | Same suite scans for U+2014 and semicolons | verified | 0 found |
| req-002 AC-1 | Same suite reads both date rules | verified | Both name the ISO and long forms |
| req-002 AC-2 | Same suite reads the guard and the standard | verified | No semicolon suggestion |
| req-003 AC-1 | `setup.sh claude-code` in a repo with no settings file | verified | Style file created, `outputStyle` is `ravintio-writing` |
| req-003 AC-2 | `setup.sh claude-code` with `outputStyle` set to `Concise` | verified | Output reads "outputStyle already set to Concise, left as is" and the value stays |
| req-003 AC-3 | Second run and a fresh generation | verified | The second codex run printed "unchanged". Suites compare tree checksums. |
| req-004 AC-1, AC-2 | `setup.sh codex` twice | verified | One `ravintio-writing:start` marker after two runs |
| req-005 AC-1 | `--no-writing-style` for both tools | verified | Skip line printed, no `.claude/output-styles`, no `outputStyle` key, no block in `AGENTS.md` |
| req-005 AC-2 | Refresh skill suite | verified | The skill accepts the flag |
| req-006 AC-1, AC-2 | `test-0000389-req-006-briefs.sh` with a stub `claude` | verified | The stub received `--append-system-prompt` and the unchanged prompt |
| NFR-003 parity | `setup.sh` and `setup.ps1` on two fresh repos | verified | `AGENTS.md` and the style file are identical |
| Session reads the style | Start a Claude Code session with the installed style | not-verifiable | Needs a restart of the interactive client. The Claude Code docs confirm the folder and the setting by name. |
