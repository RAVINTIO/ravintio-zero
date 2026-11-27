# Security report - 0000580-log-non-tdd-units

| Finding | Location | Severity | Mitigation |
|---------|----------|----------|------------|
| `--class` text reaches a build log line | `ravintio-zero/scripts/build-log-mark.mjs:41-44` | Low | The script now refuses a comma, a parenthesis, or a line break in any of `--class`, `--tier`, and `--effort`, so a value cannot add a line or a field. |
| The script writes to a path from `--log` | `build-log-mark.mjs` log handling | Low | Unchanged. It refuses a symlinked log and writes no other path. |
| Regex built from a fixed word | `build-log-check.mjs` check 7 | Low | The change reads `fields[0]` as plain text and builds no pattern from input. |
| Credentials, network, dependencies | the four changed scripts | none | The step adds no library, no network call, and no secret. |

Overall risk: Low. The code mitigates risks R-001 to R-003 in the risk register. The pin test passes, the trees match, and no archived log uses class `docs`.

Top actions before production: none.
