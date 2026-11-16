# Security report - 0000575-build-log-marker-helper

| Finding | Location | Severity | Mitigation |
|---------|----------|----------|------------|
| `--log` takes any path and the script appends to it | `ravintio-zero/scripts/build-log-mark.mjs:61` | Low | The script runs only on a local call by the session. It refuses a symlink and a missing file, so it creates no file. |
| The unit text goes into the log unchanged | `build-log-mark.mjs:41` | Low | The script refuses a line break in the unit and in the Done fields, so one call writes one line. |
| New dependency | none | none | The script imports only `node:fs`. |
| Credentials, network, shell calls | none | none | The script holds none. |

Overall risk: low.

Risk register: A test runs `build-log-check.mjs` on a log the script wrote, which mitigates R-001. The affected suites pass, which mitigates R-002.

Top actions before production: none.
