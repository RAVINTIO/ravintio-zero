# Security report - 0000388-replies-and-questions

**Overall risk rating:** Low

| Finding | Location | Severity | Mitigation |
|---------|----------|----------|------------|
| The warning quotes the first 40 characters of a reply into a hook message | `ravintio-zero/hooks/enforcement/check-reply-prefix.mjs` | Low | Output is JSON-encoded text for the human. Nothing executes it. |
| The skip reads `plan/.initiative-runner.lock` under `cwd` | `ravintio-zero/hooks/enforcement/check-reply-prefix.mjs` | Low | The check only tests the file exists. A planted lock silences a warning and weakens no guard. |
| The hook reads `RAVINTIO_INITIATIVE_STEP` | `ravintio-zero/hooks/enforcement/check-reply-prefix.mjs` | Low | The variable picks a message form. It grants nothing. |

No credential handling, path built from user input, new dependency, or fail-closed hook change. No critical or high finding. Risk register entries R-001 and R-002 stay mitigated by the tests named there.
