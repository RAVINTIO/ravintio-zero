# Security report - 0000390-prose-checks

**Overall risk rating:** low

| Finding | Location | Severity | Mitigation |
|---------|----------|----------|------------|
| The sentence splitter reads untrusted Markdown | `ravintio-zero/hooks/enforcement/prose-rules.mjs` | Low | The regexes have no nested quantifiers. A 20000-character cap bounds the hook input. The script reads one file at a time. |
| `--root`, `--baseline`, and `--files` take paths from the command line | `ravintio-zero/scripts/prose-check.mjs` | Low | The script only reads those files. It writes one file, the baseline, and only through `update`. Callers are local hooks and CI. |
| `git show` runs with a ref from `--base` | `ravintio-zero/scripts/prose-check.mjs` | Low | The script passes arguments through `execFileSync` with no shell. A ref that starts with a dash would read as an option, and the CI workflow builds it as `origin/$BASE_REF`. |
| CI passes the base branch name into a script | `.github/workflows/ravintio.yml`, `ravintio-zero/hooks/ravintio.yml` | Low | The job passes `BASE_REF` through `env`, so a branch name cannot inject shell text. |
| The Stop hook echoes reply text | `ravintio-zero/hooks/enforcement/check-reply-writing.mjs` | Low | It quotes 40 characters, replaces control characters, and writes no log file. |
| The allowlist entry for baseline keys | `ravintio-zero/tests/brand-guard-allowlist.txt` | Low | The entry matches only ADR and changelog key lines in the baseline file. No guard hook changed. |

No credentials, network calls, or guard changes. Critical and high findings: none.

## Risk register cross-check

- R-001, R-003, R-004: open and tested.
- R-002: open for step 20.
- R-006, R-007: mitigated as listed.
